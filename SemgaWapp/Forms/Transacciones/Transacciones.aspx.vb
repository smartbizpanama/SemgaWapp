Imports System.Web.Services
Imports System.Web.Script.Services
Imports System.Web.Script.Serialization
Imports SBSqlClient
Imports SBUtility
Imports System.Data
Imports System.Web.Security
Imports System.Text.RegularExpressions

Public Class Transacciones
	Inherits BasePage

	''' <summary>Cantidad máxima de transacciones por lote (parámetro CANT_TRANS_LOTE en sesión). Por defecto 10.</summary>
	Public ReadOnly Property CantTransLoteMax As Integer
		Get
			Dim val As Object = Session(VariablesSesion.CANT_TRANS_LOTE)
			If val Is Nothing OrElse String.IsNullOrWhiteSpace(val.ToString()) Then Return 10
			Dim n As Integer
			If Integer.TryParse(val.ToString().Trim(), n) AndAlso n > 0 Then Return n
			Return 10
		End Get
	End Property

	Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
		' Verificar sesión
		If Session(VariablesSesion.UsuarioId) Is Nothing Then
			Response.Redirect("~/Login.aspx")
			Return
		End If
		If ModGlobal.ValidarYRedirigirSiSinPermiso(HttpContext.Current) Then Return
	End Sub


	<WebMethod()>
	<ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
	Public Shared Function BuscarAsociados(busqueda As String) As Object
		Try
			ModGlobal.EscribirLog("BuscarAsociados iniciado. Búsqueda: " & busqueda)

			Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))

			' Detectar si es un número (ID) o texto
			Dim esNumero As Boolean = False
			Dim numeroAsociado As Integer = 0

			If Integer.TryParse(busqueda, numeroAsociado) Then
				esNumero = True
				ModGlobal.EscribirLog("Búsqueda por ID detectada: " & numeroAsociado)
			Else
				ModGlobal.EscribirLog("Búsqueda por texto detectada: " & busqueda)
			End If

			Dim sSql As String
			If esNumero Then
				sSql = "Exec spBuscarAsociadoPorID"
				ModGlobal.EscribirLog("Ejecutando SQL por ID: " & sSql)
				With objSql.Parametros
					.Add("@NumeroAsociado", numeroAsociado)
				End With
			Else
				sSql = "Exec spBuscarAsociados"
				ModGlobal.EscribirLog("Ejecutando SQL por texto: " & sSql)
				With objSql.Parametros
					.Add("@Busqueda", busqueda)
				End With
			End If

			ModGlobal.EscribirLog($"Ejecutando: {sSql} {objSql.getParamList()}")
			Dim dt As DataTable = objSql.GetDataTableSql(sSql)

			' Verificar si hubo error en la base de datos
			If objSql.MensajeError <> "" Then
				ModGlobal.EscribirLog("Error en BD al buscar asociados: " & objSql.MensajeError)
				Return New With {
					.Resultado = "ERROR",
					.Data = "",
					.Mensaje = "Error en la base de datos: " & objSql.MensajeError
				}
			Else
				ModGlobal.EscribirLog("Comando ejecutado correctamente - BuscarAsociados")
			End If

			ModGlobal.EscribirLog("Resultados encontrados: " & dt.Rows.Count & " registros")

			' Crear lista de objetos simples para evitar referencias circulares
			Dim asociados As New List(Of Object)

			If dt.Rows.Count > 0 Then
				For i As Integer = 0 To dt.Rows.Count - 1
					Dim row As DataRow = dt.Rows(i)

					' Log para verificar qué campos están disponibles
					ModGlobal.EscribirLog("Campos disponibles en la fila:")
					For Each col As DataColumn In dt.Columns
						ModGlobal.EscribirLog($"  - {col.ColumnName}: {row(col.ColumnName)}")
					Next

					' Procesar JsonAuxiliares en el servidor
					Dim rubrosUnicos As New List(Of Object)
					Dim auxiliaresPorRubro As New Dictionary(Of String, List(Of Object))
					Dim transaccionesPorRubro As New Dictionary(Of String, List(Of Object))

					If dt.Columns.Contains("JsonAuxiliares") AndAlso Not String.IsNullOrEmpty(row("JsonAuxiliares").ToString()) Then
						Try
							Dim jsonAuxiliaresValue As String = row("JsonAuxiliares").ToString()
							ModGlobal.EscribirLog($"JsonAuxiliares encontrado: {jsonAuxiliaresValue}")

							' Deserializar el JSON en el servidor
							Dim auxiliaresData As Object = New JavaScriptSerializer().Deserialize(Of Object)(jsonAuxiliaresValue)
							Dim auxiliaresArray As Object() = DirectCast(auxiliaresData, Object())

							' Procesar cada auxiliar
							For Each auxiliar As Object In auxiliaresArray
								Dim auxiliarDict As Dictionary(Of String, Object) = DirectCast(auxiliar, Dictionary(Of String, Object))
								Dim codigoRubro As String = auxiliarDict("CodigoRubro").ToString()
								Dim descripcionRubro As String = auxiliarDict("DescripcionRubro").ToString()

								' Agregar rubro único
								If Not rubrosUnicos.Any(Function(r) r.CodigoRubro = codigoRubro) Then
									rubrosUnicos.Add(New With {.CodigoRubro = codigoRubro, .DescripcionRubro = descripcionRubro})
								End If

								' Agregar auxiliar por rubro (agrupar cuentas por auxiliar)
								If Not auxiliaresPorRubro.ContainsKey(codigoRubro) Then
									auxiliaresPorRubro(codigoRubro) = New List(Of Object)
								End If

								Dim idTipoAuxiliar As String = auxiliarDict("IdTipoAuxiliar").ToString()
								Dim descripcionAuxiliar As String = auxiliarDict("DescripcionAuxiliar").ToString()
								Dim cuenta As String = auxiliarDict("Cuenta").ToString()
								Dim idAuxiliar As String = auxiliarDict("IdAuxiliar").ToString()

								' Buscar si ya existe este auxiliar (mismo IdTipoAuxiliar y DescripcionAuxiliar)
								Dim auxiliarExistente = auxiliaresPorRubro(codigoRubro).FirstOrDefault(Function(a) a.IdTipoAuxiliar = idTipoAuxiliar AndAlso a.DescripcionAuxiliar = descripcionAuxiliar)

								If auxiliarExistente Is Nothing Then
									' Crear nuevo auxiliar con lista de cuentas que incluyen IdAuxiliar
									auxiliaresPorRubro(codigoRubro).Add(New With {
										.IdTipoAuxiliar = idTipoAuxiliar,
										.DescripcionAuxiliar = descripcionAuxiliar,
										.Cuentas = New List(Of Object) From {New With {.IdAuxiliar = idAuxiliar, .Cuenta = cuenta}}
									})
								Else
									' Agregar cuenta al auxiliar existente si no existe ya
									Dim cuentasList As List(Of Object) = DirectCast(auxiliarExistente.Cuentas, List(Of Object))
									Dim cuentaExistente As Boolean = cuentasList.Any(Function(c) c.Cuenta = cuenta)
									If Not cuentaExistente Then
										cuentasList.Add(New With {.IdAuxiliar = idAuxiliar, .Cuenta = cuenta})
									End If
								End If

								' Procesar transacciones (evitar duplicados)
								If auxiliarDict.ContainsKey("Transacciones") Then
									Dim transaccionesArray As Object() = DirectCast(auxiliarDict("Transacciones"), Object())
									If Not transaccionesPorRubro.ContainsKey(codigoRubro) Then
										transaccionesPorRubro(codigoRubro) = New List(Of Object)
									End If
									For Each transaccion As Object In transaccionesArray
										Dim transaccionDict As Dictionary(Of String, Object) = DirectCast(transaccion, Dictionary(Of String, Object))
										Dim codigoTransaccion As String = transaccionDict("CodigoTransaccion").ToString()
										Dim descripcionTransaccion As String = transaccionDict("DescripcionTransaccion").ToString()

										' Verificar si ya existe esta transacción
										Dim yaExisteTransaccion As Boolean = transaccionesPorRubro(codigoRubro).Any(Function(t) t.CodigoTransaccion = codigoTransaccion AndAlso t.DescripcionTransaccion = descripcionTransaccion)

										If Not yaExisteTransaccion Then
											transaccionesPorRubro(codigoRubro).Add(New With {
												.CodigoTransaccion = codigoTransaccion,
												.DescripcionTransaccion = descripcionTransaccion
											})
										End If
									Next
								End If
							Next

							ModGlobal.EscribirLog($"Rubros procesados: {rubrosUnicos.Count}")
							ModGlobal.EscribirLog($"Auxiliares por rubro: {auxiliaresPorRubro.Count}")
							ModGlobal.EscribirLog($"Transacciones por rubro: {transaccionesPorRubro.Count}")

						Catch ex As Exception
							ModGlobal.EscribirLog($"Error al procesar JsonAuxiliares: {ex.Message}")
						End Try
					Else
						ModGlobal.EscribirLog("JsonAuxiliares NO encontrado o vacío")
					End If

					' Crear objeto asociado con datos procesados
					Dim asociado As New With {
						.NumeroAsociado = row("NumeroAsociado").ToString(),
						.NombreCompleto = row("NombreCompleto").ToString(),
						.NumeroIdentificacion = row("NumeroIdentificacion").ToString(),
						.TipoAsociado = row("TipoAsociado").ToString(),
						.CodTipoDoc = row("CodTipoDoc").ToString(),
						.CantAuxiliares = row("CantAuxiliares").ToString(),
						.Rubros = rubrosUnicos,
						.AuxiliaresPorRubro = auxiliaresPorRubro,
						.TransaccionesPorRubro = transaccionesPorRubro
					}

					' Log para verificar el objeto antes de serializar
					ModGlobal.EscribirLog($"Objeto asociado antes de serializar: Rubros = {asociado.Rubros.Count}, Auxiliares = {asociado.AuxiliaresPorRubro.Count}, Transacciones = {asociado.TransaccionesPorRubro.Count}")
					asociados.Add(asociado)


				Next
			End If

			Dim jsonData As String = New JavaScriptSerializer().Serialize(asociados)
			ModGlobal.EscribirLog("JSON generado (primeros 200 chars): " & jsonData.Substring(0, Math.Min(200, jsonData.Length)))

			' Log específico para verificar datos procesados en el JSON final
			If jsonData.Contains("Rubros") AndAlso jsonData.Contains("AuxiliaresPorRubro") AndAlso jsonData.Contains("TransaccionesPorRubro") Then
				ModGlobal.EscribirLog("Datos procesados (Rubros, AuxiliaresPorRubro, TransaccionesPorRubro) encontrados en JSON final")
			Else
				ModGlobal.EscribirLog("Datos procesados NO encontrados en JSON final")
			End If

			Return New With {
				.Resultado = "SUCCESS",
				.Data = jsonData,
				.Mensaje = ""
			}
		Catch ex As Exception
			ModGlobal.EscribirLog("Error en BuscarAsociados: " & ex.Message & " | StackTrace: " & ex.StackTrace)
			Return New With {
				.Resultado = "ERROR",
				.Data = "",
				.Mensaje = "Error al buscar asociados: " & ex.Message
			}
		End Try
	End Function


	<WebMethod()>
	<ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
	Public Shared Function ObtenerRubros() As Object
		Try
			ModGlobal.EscribirLog("ObtenerRubros iniciado")

			Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
			Dim sSql As String = "Exec spAuxiliares_ObtenerRubros"

			ModGlobal.EscribirLog($"Ejecutando: {sSql} {objSql.getParamList()}")
			Dim dt As DataTable = objSql.GetDataTableSql(sSql)

			' Verificar si hubo error en la base de datos
			If objSql.MensajeError <> "" Then
				ModGlobal.EscribirLog("Error en BD al obtener rubros: " & objSql.MensajeError)
				Return New With {
					.Resultado = "ERROR",
					.Data = "",
					.Mensaje = "Error en la base de datos: " & objSql.MensajeError
				}
			Else
				ModGlobal.EscribirLog("Comando ejecutado correctamente - ObtenerRubros")
			End If

			' Crear lista de objetos simples para evitar referencias circulares
			Dim rubros As New List(Of Object)

			For Each row As DataRow In dt.Rows
				Dim rubro As New With {
					.CodigoRubro = row("CodigoRubro").ToString(),
					.Descripcion = row("Descripcion").ToString()
				}
				rubros.Add(rubro)
			Next

			Return New With {
				.Resultado = "SUCCESS",
				.Data = New JavaScriptSerializer().Serialize(rubros),
				.Mensaje = ""
			}
		Catch ex As Exception
			ModGlobal.EscribirLog("Error en ObtenerRubros: " & ex.Message & " | StackTrace: " & ex.StackTrace)
			Return New With {
				.Resultado = "ERROR",
				.Data = "",
				.Mensaje = "Error al obtener rubros: " & ex.Message
			}
		End Try
	End Function

	<WebMethod()>
	<ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
	Public Shared Function ObtenerAuxiliaresAsociado(numeroAsociado As Integer) As Object
		Try
			ModGlobal.EscribirLog("ObtenerAuxiliaresAsociado iniciado. Número: " & numeroAsociado)

			Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
			Dim sSql As String = "Exec spAuxiliares_ObtenerAuxiliaresPorAsociado"

			With objSql.Parametros
				.Add("@NumeroAsociado", numeroAsociado)
			End With

			ModGlobal.EscribirLog($"Ejecutando: {sSql} {objSql.getParamList()}")
			Dim dt As DataTable = objSql.GetDataTableSql(sSql)

			' Verificar si hubo error en la base de datos
			If objSql.MensajeError <> "" Then
				ModGlobal.EscribirLog("Error en BD al obtener auxiliares: " & objSql.MensajeError)
				Return New With {
					.Resultado = "ERROR",
					.Data = "",
					.Mensaje = "Error en la base de datos: " & objSql.MensajeError
				}
			Else
				ModGlobal.EscribirLog("Comando ejecutado correctamente - ObtenerAuxiliaresAsociado")
			End If

			' Crear lista de objetos simples para evitar referencias circulares
			Dim auxiliares As New List(Of Object)

			For Each row As DataRow In dt.Rows
				Dim auxiliar As New With {
					.ID = row("ID").ToString(),
					.DescripcionRubro = row("DescripcionRubro").ToString(),
					.DescripcionTipoAuxiliar = row("DescripcionTipoAuxiliar").ToString()
				}
				auxiliares.Add(auxiliar)
			Next

			Return New With {
				.Resultado = "SUCCESS",
				.Data = New JavaScriptSerializer().Serialize(auxiliares),
				.Mensaje = ""
			}
		Catch ex As Exception
			ModGlobal.EscribirLog("Error en ObtenerAuxiliaresAsociado: " & ex.Message & " | StackTrace: " & ex.StackTrace)
			Return New With {
				.Resultado = "ERROR",
				.Data = "",
				.Mensaje = "Error al obtener auxiliares: " & ex.Message
			}
		End Try
	End Function

	<WebMethod()>
	<ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
	Public Shared Function ObtenerCodigosTransaccion(codigoRubro As String) As Object
		Try
			ModGlobal.EscribirLog("ObtenerCodigosTransaccion iniciado. Rubro: " & codigoRubro)

			Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
			Dim sSql As String = "Exec spTransacciones_ObtenerCodigosPorRubro"

			With objSql.Parametros
				.Add("@CodigoRubro", codigoRubro)
			End With

			ModGlobal.EscribirLog($"Ejecutando: {sSql} {objSql.getParamList()}")
			Dim dt As DataTable = objSql.GetDataTableSql(sSql)

			' Verificar si hubo error en la base de datos
			If objSql.MensajeError <> "" Then
				ModGlobal.EscribirLog("Error en BD al obtener códigos: " & objSql.MensajeError)
				Return New With {
					.Resultado = "ERROR",
					.Data = "",
					.Mensaje = "Error en la base de datos: " & objSql.MensajeError
				}
			Else
				ModGlobal.EscribirLog("Comando ejecutado correctamente - ObtenerCodigosTransaccion")
			End If

			' Crear lista de objetos simples para evitar referencias circulares
			Dim codigos As New List(Of Object)

			For Each row As DataRow In dt.Rows
				Dim codigo As New With {
					.CodigoTransaccion = row("CodigoTransaccion").ToString(),
					.Descripcion = row("Descripcion").ToString(),
					.DebCred = row("DebCred").ToString()
				}
				codigos.Add(codigo)
			Next

			Return New With {
				.Resultado = "SUCCESS",
				.Data = New JavaScriptSerializer().Serialize(codigos),
				.Mensaje = ""
			}
		Catch ex As Exception
			ModGlobal.EscribirLog("Error en ObtenerCodigosTransaccion: " & ex.Message & " | StackTrace: " & ex.StackTrace)
			Return New With {
				.Resultado = "ERROR",
				.Data = "",
				.Mensaje = "Error al obtener códigos de transacción: " & ex.Message
			}
		End Try
	End Function

	' GuardarMovimiento eliminado: el guardado se hace solo vía GuardarLote (spMovimientos_GuardarLote).
	' Ver DbScripts/spMovimientos_GuardarMovimiento_REFERENCIA.sql para la definición del SP (usado internamente por GuardarLote en BD).

	<WebMethod()>
	<ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
	Public Shared Function GuardarLote(numeroAsociado As Integer, jsonLote As String) As Object
		Try
			ModGlobal.EscribirLog("GuardarLote iniciado. NumeroAsociado: " & numeroAsociado)
			Dim usuarioId As Integer = Convert.ToInt32(HttpContext.Current.Session(VariablesSesion.UsuarioId))
			Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
			objSql.Parametros.Clear()
			objSql.Parametros.Add("@NumeroAsociado", numeroAsociado)
			objSql.Parametros.Add("@UsuarioID", usuarioId)
			objSql.Parametros.Add("@JsonLote", jsonLote)
			ModGlobal.EscribirLog("Ejecutando: Exec dbo.spMovimientos_GuardarLote " & objSql.getParamList())
			Dim dt As DataTable = objSql.GetDataTableSql("Exec dbo.spMovimientos_GuardarLote")
			If objSql.MensajeError <> "" Then
				ModGlobal.EscribirLog("BD ERROR: GuardarLote - " & objSql.MensajeError)
				Return New With { .Resultado = "ERROR", .Mensaje = "Error en la base de datos: " & objSql.MensajeError, .Detalles = New Object() {} }
			End If
			ModGlobal.EscribirLog("BD OK: GuardarLote")
			If dt Is Nothing OrElse dt.Rows.Count = 0 Then
				Return New With { .Resultado = "ERROR", .Mensaje = "El procedimiento no devolvió datos.", .Detalles = New Object() {} }
			End If
			Dim jsonStr As String = dt.Rows(0)(0).ToString()
			If String.IsNullOrWhiteSpace(jsonStr) Then
				Return New With { .Resultado = "ERROR", .Mensaje = "Respuesta vacía del procedimiento.", .Detalles = New Object() {} }
			End If
			Dim serializer As New JavaScriptSerializer()
			Dim obj As Object = serializer.Deserialize(Of Object)(jsonStr)
			Return obj
		Catch ex As Exception
			ModGlobal.EscribirLog("Error en GuardarLote: " & ex.Message & " | " & ex.StackTrace)
			Return New With { .Resultado = "ERROR", .Mensaje = "Error al guardar lote: " & ex.Message, .Detalles = New Object() {} }
		End Try
	End Function

	<WebMethod()>
	<ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
	Public Shared Function GenerarComprobanteLote(idTrans As Integer) As Object
		Try
			ModGlobal.EscribirLog("GenerarComprobanteLote iniciado. IDTrans: " & idTrans)
			Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
			objSql.Parametros.Clear()
			objSql.Parametros.Add("@IDTrans", idTrans)
			ModGlobal.EscribirLog("Ejecutando: Exec dbo.spMovimientos_ObtenerDatosComprobanteLote " & objSql.getParamList())
			Dim dt As DataTable = objSql.GetDataTableSql("Exec dbo.spMovimientos_ObtenerDatosComprobanteLote")
			If objSql.MensajeError <> "" Then
				ModGlobal.EscribirLog("BD ERROR: GenerarComprobanteLote - " & objSql.MensajeError)
				Return New With { .Resultado = "ERROR", .Mensaje = "Error al obtener datos del comprobante: " & objSql.MensajeError }
			End If
			ModGlobal.EscribirLog("BD OK: GenerarComprobanteLote")
			If dt Is Nothing OrElse dt.Rows.Count = 0 Then
				Return New With { .Resultado = "ERROR", .Mensaje = "No se encontraron datos para este lote." }
			End If
			Dim row0 As DataRow = dt.Rows(0)
			Dim idTransFormateado As String = Right("000000000000" & idTrans.ToString(), 12)
			' Fecha de hoy: el comprobante se imprime desde la misma ventana donde se creó el movimiento
			Dim fechaHora As String = DateTime.Now.ToString("dd/MM/yyyy HH:mm")
			Dim usuario As String = If(dt.Columns.Contains("UsuarioNombre"), row0("UsuarioNombre").ToString(), If(dt.Columns.Contains("Usuario"), row0("Usuario").ToString(), ""))
			Dim numeroAsociado As String = If(dt.Columns.Contains("NumeroAsociado"), row0("NumeroAsociado").ToString(), "")
			Dim nombreAsociado As String = If(dt.Columns.Contains("NombreAsociado"), row0("NombreAsociado").ToString(), "")
			Dim tipoIdentificacion As String = If(dt.Columns.Contains("TipoIdentificacion") AndAlso Not IsDBNull(row0("TipoIdentificacion")), row0("TipoIdentificacion").ToString(), "")
			Dim numeroIdentificacion As String = If(dt.Columns.Contains("NumeroIdentificacion") AndAlso Not IsDBNull(row0("NumeroIdentificacion")), row0("NumeroIdentificacion").ToString(), "")
			Dim sb As New System.Text.StringBuilder()
			Dim numeroLinea As Integer = 1
			Dim fmt As System.Globalization.CultureInfo = System.Globalization.CultureInfo.InvariantCulture
			For Each row As DataRow In dt.Rows
				Dim idRaw As String = If(dt.Columns.Contains("ID") AndAlso Not IsDBNull(row("ID")), row("ID").ToString().Trim(), "")
				Dim idVal As String = If(idRaw.Length > 5, idRaw.Substring(idRaw.Length - 5), idRaw.PadLeft(5, "0"c))
				Dim rubro As String = If(dt.Columns.Contains("DescripcionRubro"), row("DescripcionRubro").ToString(), "")
				Dim auxiliar As String = If(dt.Columns.Contains("DescripcionTipoAuxiliar"), row("DescripcionTipoAuxiliar").ToString(), "")
				Dim cuenta As String = If(dt.Columns.Contains("Cuenta"), row("Cuenta").ToString(), "")
				Dim tipoTrans As String = If(dt.Columns.Contains("DescripcionTransaccion"), row("DescripcionTransaccion").ToString(), "")
				Dim montoVal As Decimal = 0
				If dt.Columns.Contains("Monto") AndAlso Not IsDBNull(row("Monto")) Then montoVal = Convert.ToDecimal(row("Monto"))
				Dim montoStr As String = "$" & montoVal.ToString("###,###,##0.00", fmt)
				Dim saldoVal As Decimal = 0
				If dt.Columns.Contains("Saldo") AndAlso Not IsDBNull(row("Saldo")) Then saldoVal = Convert.ToDecimal(row("Saldo"))
				Dim saldoStr As String = "$" & saldoVal.ToString("###,###,##0.00", fmt)
				Dim obs As String = If(dt.Columns.Contains("Observaciones") AndAlso Not IsDBNull(row("Observaciones")), row("Observaciones").ToString(), "")
				obs = System.Net.WebUtility.HtmlEncode(obs)
				sb.Append("<tr><td class=""col-num"">").Append(numeroLinea).Append("</td><td class=""col-id"">").Append(System.Net.WebUtility.HtmlEncode(idVal)).Append("</td><td class=""col-rubro"">").Append(System.Net.WebUtility.HtmlEncode(rubro)).Append("</td><td>").Append(System.Net.WebUtility.HtmlEncode(auxiliar)).Append("</td><td class=""col-cuenta"">").Append(System.Net.WebUtility.HtmlEncode(cuenta)).Append("</td><td>").Append(System.Net.WebUtility.HtmlEncode(tipoTrans)).Append("</td><td class=""col-monto"">").Append(montoStr).Append("</td><td class=""col-saldo"">").Append(saldoStr).Append("</td><td class=""col-obs"">").Append(obs).Append("</td></tr>")
				numeroLinea += 1
			Next
			Dim tablaDetalle As String = sb.ToString()
			Dim templatePath As String = HttpContext.Current.Server.MapPath("~/Forms/Transacciones/comprobanteLote.html")
			Dim htmlTemplate As String = System.IO.File.ReadAllText(templatePath)
			htmlTemplate = htmlTemplate.Replace("@IDTransaccion", idTransFormateado)
			htmlTemplate = htmlTemplate.Replace("@FechaHora", fechaHora)
			htmlTemplate = htmlTemplate.Replace("@Usuario", System.Net.WebUtility.HtmlEncode(usuario))
			htmlTemplate = htmlTemplate.Replace("@NumeroAsociado", System.Net.WebUtility.HtmlEncode(numeroAsociado))
			htmlTemplate = htmlTemplate.Replace("@NombreAsociado", System.Net.WebUtility.HtmlEncode(nombreAsociado))
			htmlTemplate = htmlTemplate.Replace("@TipoIdentificacion", System.Net.WebUtility.HtmlEncode(tipoIdentificacion))
			htmlTemplate = htmlTemplate.Replace("@NumeroIdentificacion", System.Net.WebUtility.HtmlEncode(numeroIdentificacion))
			htmlTemplate = htmlTemplate.Replace("@TablaDetalle", tablaDetalle)
			ModGlobal.EscribirLog("GenerarComprobanteLote OK. IDTrans: " & idTrans)
			Return New With { .Resultado = "SUCCESS", .Html = htmlTemplate, .IDTransaccion = idTrans }
		Catch ex As Exception
			ModGlobal.EscribirLog("Error en GenerarComprobanteLote: " & ex.Message & " | " & ex.StackTrace)
			Return New With { .Resultado = "ERROR", .Mensaje = "Error al generar comprobante: " & ex.Message }
		End Try
	End Function

	<WebMethod()>
	<ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
	Public Shared Function GenerarComprobante(capitalMovimientoId As String, interesesMovimientoId As String) As Object
		Try
			ModGlobal.EscribirLog($"GenerarComprobante iniciado. CapitalMovimientoID: {capitalMovimientoId}, InteresesMovimientoID: {interesesMovimientoId}")

			Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))

			' Obtener datos del movimiento de capital (si existe)
			Dim dtCapital As DataTable = Nothing
			Dim rowCapital As DataRow = Nothing
			ModGlobal.EscribirLog($"Verificando capitalMovimientoId: '{capitalMovimientoId}' (IsNullOrEmpty: {String.IsNullOrEmpty(capitalMovimientoId)})")
			If Not String.IsNullOrEmpty(capitalMovimientoId) Then
				Dim sSqlCapital As String = "Exec spMovimientos_ObtenerDatosComprobante"
				With objSql.Parametros
					.Clear()
					.Add("@MovimientoID", Integer.Parse(capitalMovimientoId))
				End With
				dtCapital = objSql.GetDataTableSql(sSqlCapital)
				
				If objSql.MensajeError <> "" Then
					ModGlobal.EscribirLog("Error en BD al obtener datos del comprobante de capital: " & objSql.MensajeError)
				ElseIf dtCapital.Rows.Count > 0 Then
					rowCapital = dtCapital.Rows(0)
					ModGlobal.EscribirLog($"Datos de capital obtenidos correctamente. Monto: {rowCapital("Monto")}")
				Else
					ModGlobal.EscribirLog("No se encontraron datos para el movimiento de capital")
				End If
			Else
				ModGlobal.EscribirLog("capitalMovimientoId está vacío o nulo, no se buscará movimiento de capital")
			End If

			' Obtener datos del movimiento de intereses (si existe)
			Dim dtIntereses As DataTable = Nothing
			Dim rowIntereses As DataRow = Nothing
			ModGlobal.EscribirLog($"Verificando interesesMovimientoId: '{interesesMovimientoId}' (IsNullOrEmpty: {String.IsNullOrEmpty(interesesMovimientoId)})")
			If Not String.IsNullOrEmpty(interesesMovimientoId) Then
				Dim sSqlIntereses As String = "Exec spMovimientos_ObtenerDatosComprobante"
				With objSql.Parametros
					.Clear()
					.Add("@MovimientoID", Integer.Parse(interesesMovimientoId))
				End With
				dtIntereses = objSql.GetDataTableSql(sSqlIntereses)
				
				If objSql.MensajeError <> "" Then
					ModGlobal.EscribirLog("Error en BD al obtener datos del comprobante de intereses: " & objSql.MensajeError)
				ElseIf dtIntereses.Rows.Count > 0 Then
					rowIntereses = dtIntereses.Rows(0)
					ModGlobal.EscribirLog($"Datos de intereses obtenidos correctamente. Monto: {rowIntereses("Monto")}")
				Else
					ModGlobal.EscribirLog("No se encontraron datos para el movimiento de intereses")
				End If
			Else
				ModGlobal.EscribirLog("interesesMovimientoId está vacío o nulo, no se buscará movimiento de intereses")
			End If

			' Validar que al menos uno de los movimientos exista
			If rowCapital Is Nothing AndAlso rowIntereses Is Nothing Then
				ModGlobal.EscribirLog("No se encontró ningún movimiento")
				Return New With {
					.Resultado = "ERROR",
					.Mensaje = "No se encontró el movimiento"
				}
			End If

			' Usar el movimiento de capital como referencia principal, o intereses si no hay capital
			Dim rowPrincipal As DataRow = If(rowCapital IsNot Nothing, rowCapital, rowIntereses)
			Dim movimientoIdPrincipal As String = If(Not String.IsNullOrEmpty(capitalMovimientoId), capitalMovimientoId, interesesMovimientoId)

			' Formatear MovimientoID con ceros a la izquierda
			Dim movimientoIdFormateado As String = Right("000000000000" & movimientoIdPrincipal, 12)

			' Formatear fecha y hora
			Dim fechaHora As String = Convert.ToDateTime(rowPrincipal("FechaMovimiento")).ToString("dd/MM/yyyy HH:mm")

			' Formatear montos con formato de moneda (incluyendo símbolo $)
			Dim montoCapitalFormateado As String = ""
			Dim montoInteresesFormateado As String = ""
			Dim montoCapital As Decimal = 0
			Dim montoIntereses As Decimal = 0
			
			If rowCapital IsNot Nothing Then
				montoCapital = Convert.ToDecimal(rowCapital("Monto"))
				montoCapitalFormateado = montoCapital.ToString("$###,###,##0.00", System.Globalization.CultureInfo.InvariantCulture)
			End If
			
			If rowIntereses IsNot Nothing Then
				montoIntereses = Convert.ToDecimal(rowIntereses("Monto"))
				montoInteresesFormateado = montoIntereses.ToString("$###,###,##0.00", System.Globalization.CultureInfo.InvariantCulture)
			End If

			' Calcular total (capital + intereses)
			Dim montoTotal As Decimal = montoCapital + montoIntereses
			Dim montoTotalFormateado As String = montoTotal.ToString("$###,###,##0.00", System.Globalization.CultureInfo.InvariantCulture)

			' Leer el template HTML
			Dim templatePath As String = HttpContext.Current.Server.MapPath("~/Forms/Transacciones/ComprobanteTransaccion.html")
			Dim htmlTemplate As String = System.IO.File.ReadAllText(templatePath)

			' Reemplazar placeholders comunes
			htmlTemplate = htmlTemplate.Replace("@MovimientoID", movimientoIdFormateado)
			htmlTemplate = htmlTemplate.Replace("@FechaHora", fechaHora)
			htmlTemplate = htmlTemplate.Replace("@Usuario", rowPrincipal("UsuarioNombre").ToString())
			htmlTemplate = htmlTemplate.Replace("@NumeroAsociado", rowPrincipal("NumeroAsociado").ToString())
			htmlTemplate = htmlTemplate.Replace("@NombreAsociado", rowPrincipal("NombreAsociado").ToString())
			
			' Agregar identificación del asociado
			Dim tipoIdentificacion As String = ""
			Dim numeroIdentificacion As String = ""
			Dim dtPrincipal As DataTable = If(rowCapital IsNot Nothing, dtCapital, dtIntereses)
			If dtPrincipal IsNot Nothing AndAlso dtPrincipal.Columns.Contains("TipoIdentificacion") AndAlso Not IsDBNull(rowPrincipal("TipoIdentificacion")) Then
				tipoIdentificacion = rowPrincipal("TipoIdentificacion").ToString()
			End If
			If dtPrincipal IsNot Nothing AndAlso dtPrincipal.Columns.Contains("NumeroIdentificacion") AndAlso Not IsDBNull(rowPrincipal("NumeroIdentificacion")) Then
				numeroIdentificacion = rowPrincipal("NumeroIdentificacion").ToString()
			End If
			htmlTemplate = htmlTemplate.Replace("@TipoIdentificacion", tipoIdentificacion)
			htmlTemplate = htmlTemplate.Replace("@NumeroIdentificacion", numeroIdentificacion)
			
			htmlTemplate = htmlTemplate.Replace("@DescripcionAuxiliar", rowPrincipal("DescripcionTipoAuxiliar").ToString())
			htmlTemplate = htmlTemplate.Replace("@Cuenta", rowPrincipal("Cuenta").ToString())
			htmlTemplate = htmlTemplate.Replace("@Total", montoTotalFormateado)
			
			' Reemplazar descripción de transacción (usar la del capital si existe, sino la de intereses)
			Dim descripcionTransaccion As String = ""
			If rowCapital IsNot Nothing Then
				descripcionTransaccion = rowCapital("DescripcionTransaccion").ToString()
			ElseIf rowIntereses IsNot Nothing Then
				descripcionTransaccion = rowIntereses("DescripcionTransaccion").ToString()
			End If
			
			' Construir descripción de transacción + ' TOTAL '
			Dim descripcionTransaccionTotal As String = descripcionTransaccion & " TOTAL "
			htmlTemplate = htmlTemplate.Replace("@DescripcionTransaccionTotal", descripcionTransaccionTotal)
			htmlTemplate = htmlTemplate.Replace("@DescripcionTransaccion", descripcionTransaccion)
			
			' Construir sección de montos dinámicamente
			Dim nuevaSeccionMontos As String = ""
			
			ModGlobal.EscribirLog($"Construyendo sección de montos - Capital: '{montoCapitalFormateado}', Intereses: '{montoInteresesFormateado}'")
			
			If Not String.IsNullOrEmpty(montoCapitalFormateado) AndAlso Not String.IsNullOrEmpty(montoInteresesFormateado) Then
				' Ambos movimientos - mostrar lado a lado
				nuevaSeccionMontos = "            <div class=""monto-container"">" & vbCrLf &
					"                <div class=""monto-section capital"">" & vbCrLf &
					"                    <div class=""monto-label"">Capital</div>" & vbCrLf &
					"                    <div class=""monto-value"">" & montoCapitalFormateado & "</div>" & vbCrLf &
					"                </div>" & vbCrLf &
					"                <div class=""monto-section intereses"">" & vbCrLf &
					"                    <div class=""monto-label"">Intereses</div>" & vbCrLf &
					"                    <div class=""monto-value"">" & montoInteresesFormateado & "</div>" & vbCrLf &
					"                </div>" & vbCrLf &
					"            </div>"
				ModGlobal.EscribirLog("Sección de montos: Ambos (Capital e Intereses) - lado a lado")
			ElseIf Not String.IsNullOrEmpty(montoCapitalFormateado) Then
				' Solo capital - usar color azul
				nuevaSeccionMontos = "            <div class=""monto-section capital"">" & vbCrLf &
					"                <div class=""monto-label"">Capital</div>" & vbCrLf &
					"                <div class=""monto-value"">" & montoCapitalFormateado & "</div>" & vbCrLf &
					"            </div>"
				ModGlobal.EscribirLog("Sección de montos: Solo Capital")
			ElseIf Not String.IsNullOrEmpty(montoInteresesFormateado) Then
				' Solo intereses - usar color verde distintivo
				nuevaSeccionMontos = "            <div class=""monto-section intereses"">" & vbCrLf &
					"                <div class=""monto-label"">Intereses</div>" & vbCrLf &
					"                <div class=""monto-value"">" & montoInteresesFormateado & "</div>" & vbCrLf &
					"            </div>"
				ModGlobal.EscribirLog("Sección de montos: Solo Intereses")
			Else
				' Fallback: usar monto genérico si no hay ninguno
				nuevaSeccionMontos = "            <div class=""monto-section"">" & vbCrLf &
					"                <div class=""monto-label"">Monto</div>" & vbCrLf &
					"                <div class=""monto-value"">0.00</div>" & vbCrLf &
					"            </div>"
				ModGlobal.EscribirLog("Sección de montos: Fallback (Monto genérico)")
			End If
			
			' Reemplazar secciones de monto - usar un método más robusto con System.Text.RegularExpressions
			' Patrón regex para encontrar la sección de monto (más flexible)
			Dim patronRegex As String = "<div class=""monto-section"">\s*<div class=""monto-label"">Monto</div>\s*<div class=""monto-value"">@Monto</div>\s*</div>"
			Dim nuevaSeccionSinIndentacion As String = nuevaSeccionMontos.Replace("            ", "").Trim()
			
			' Reemplazar usando regex (más flexible con espacios y saltos de línea)
			htmlTemplate = Regex.Replace(htmlTemplate, patronRegex, nuevaSeccionSinIndentacion, RegexOptions.IgnoreCase Or RegexOptions.Multiline)
			
			' También intentar reemplazo directo por si acaso
			Dim patronBusqueda As String = "<div class=""monto-section"">" & vbCrLf & "                <div class=""monto-label"">Monto</div>" & vbCrLf & "                <div class=""monto-value"">@Monto</div>" & vbCrLf & "            </div>"
			While htmlTemplate.Contains(patronBusqueda)
				htmlTemplate = htmlTemplate.Replace(patronBusqueda, nuevaSeccionSinIndentacion)
			End While
			
			' Verificar si el reemplazo funcionó
			Dim reemplazoExitoso As Boolean = Not htmlTemplate.Contains("@Monto") OrElse (htmlTemplate.Contains("Intereses") AndAlso Not String.IsNullOrEmpty(montoInteresesFormateado)) OrElse (htmlTemplate.Contains("Capital") AndAlso Not String.IsNullOrEmpty(montoCapitalFormateado))
			ModGlobal.EscribirLog($"Reemplazo de sección de montos completado. Éxito: {reemplazoExitoso}, Longitud del HTML: {htmlTemplate.Length}")
			
			' Si aún contiene @Monto y debería haber sido reemplazado, hacer un último intento
			If htmlTemplate.Contains("@Monto") AndAlso (Not String.IsNullOrEmpty(montoCapitalFormateado) OrElse Not String.IsNullOrEmpty(montoInteresesFormateado)) Then
				ModGlobal.EscribirLog("Advertencia: @Monto aún presente después del reemplazo. Intentando reemplazo directo final.")
				htmlTemplate = htmlTemplate.Replace("@Monto", If(Not String.IsNullOrEmpty(montoCapitalFormateado), montoCapitalFormateado, If(Not String.IsNullOrEmpty(montoInteresesFormateado), montoInteresesFormateado, "0.00")))
			End If

			ModGlobal.EscribirLog($"Comprobante generado exitosamente. Capital: {capitalMovimientoId}, Intereses: {interesesMovimientoId}")

			Return New With {
				.Resultado = "SUCCESS",
				.Html = htmlTemplate,
				.CapitalMovimientoID = capitalMovimientoId,
				.InteresesMovimientoID = interesesMovimientoId
			}

		Catch ex As Exception
			ModGlobal.EscribirLog("Error en GenerarComprobante: " & ex.Message & " | StackTrace: " & ex.StackTrace)
			Return New With {
				.Resultado = "ERROR",
				.Mensaje = "Error al generar comprobante: " & ex.Message
			}
		End Try
	End Function

	<WebMethod()>
	<ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
	Public Shared Function MarcarComprobanteImpreso(capitalMovimientoId As String, interesesMovimientoId As String) As Object
		Try
			ModGlobal.EscribirLog($"MarcarComprobanteImpreso iniciado. CapitalMovimientoID: {capitalMovimientoId}, InteresesMovimientoID: {interesesMovimientoId}")

			Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
			Dim totalFilasAfectadas As Integer = 0
			Dim errores As New List(Of String)

			' Marcar movimiento de capital como impreso (si existe)
			If Not String.IsNullOrEmpty(capitalMovimientoId) Then
				Dim sSqlCapital As String = "Exec spMovimientos_MarcarImpreso"
				With objSql.Parametros
					.Clear()
					.Add("@MovimientoID", Integer.Parse(capitalMovimientoId))
				End With
				Dim dtCapital As DataTable = objSql.GetDataTableSql(sSqlCapital)
				
				If objSql.MensajeError <> "" Then
					errores.Add("Error al marcar capital como impreso: " & objSql.MensajeError)
				ElseIf dtCapital.Rows.Count > 0 Then
					totalFilasAfectadas += Convert.ToInt32(dtCapital.Rows(0)("FilasAfectadas"))
				End If
			End If

			' Marcar movimiento de intereses como impreso (si existe)
			If Not String.IsNullOrEmpty(interesesMovimientoId) Then
				Dim sSqlIntereses As String = "Exec spMovimientos_MarcarImpreso"
				With objSql.Parametros
					.Clear()
					.Add("@MovimientoID", Integer.Parse(interesesMovimientoId))
				End With
				Dim dtIntereses As DataTable = objSql.GetDataTableSql(sSqlIntereses)
				
				If objSql.MensajeError <> "" Then
					errores.Add("Error al marcar intereses como impreso: " & objSql.MensajeError)
				ElseIf dtIntereses.Rows.Count > 0 Then
					totalFilasAfectadas += Convert.ToInt32(dtIntereses.Rows(0)("FilasAfectadas"))
				End If
			End If

			If errores.Count > 0 Then
				ModGlobal.EscribirLog("Errores al marcar como impreso: " & String.Join("; ", errores))
				Return New With {
					.Resultado = "ERROR",
					.Mensaje = String.Join("; ", errores)
				}
			End If

			If totalFilasAfectadas > 0 Then
				ModGlobal.EscribirLog($"Comprobante marcado como impreso. Filas afectadas: {totalFilasAfectadas}")
				Return New With {
					.Resultado = "SUCCESS",
					.Mensaje = "Comprobante marcado como impreso"
				}
			Else
				ModGlobal.EscribirLog("No se encontraron movimientos para marcar como impresos")
				Return New With {
					.Resultado = "ERROR",
					.Mensaje = "No se encontraron movimientos"
				}
			End If

		Catch ex As Exception
			ModGlobal.EscribirLog("Error en MarcarComprobanteImpreso: " & ex.Message & " | StackTrace: " & ex.StackTrace)
			Return New With {
				.Resultado = "ERROR",
				.Mensaje = "Error al marcar comprobante como impreso: " & ex.Message
			}
		End Try
	End Function
End Class
