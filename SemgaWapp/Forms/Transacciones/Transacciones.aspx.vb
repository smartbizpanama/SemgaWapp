Imports System.Web.Services
Imports System.Web.Script.Services
Imports System.Web.Script.Serialization
Imports SBSqlClient
Imports SBUtility
Imports System.Data
Imports System.Web.Security

Public Class Transacciones
	Inherits System.Web.UI.Page

	Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
		' Verificar sesión
		If Session(VariablesSesion.UsuarioId) Is Nothing Then
			Response.Redirect("~/Login.aspx")
			Return
		End If
	End Sub


	<WebMethod()>
	<ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
	Public Shared Function BuscarAsociados(busqueda As String) As Object
		Try
			ModGlobal.EscribirLog("🔍 BuscarAsociados iniciado. Búsqueda: " & busqueda)

			Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))

			' Detectar si es un número (ID) o texto
			Dim esNumero As Boolean = False
			Dim numeroAsociado As Integer = 0

			If Integer.TryParse(busqueda, numeroAsociado) Then
				esNumero = True
				ModGlobal.EscribirLog("🔍 Búsqueda por ID detectada: " & numeroAsociado)
			Else
				ModGlobal.EscribirLog("🔍 Búsqueda por texto detectada: " & busqueda)
			End If

			Dim sSql As String
			If esNumero Then
				sSql = "Exec spBuscarAsociadoPorID"
				ModGlobal.EscribirLog("📡 Ejecutando SQL por ID: " & sSql)
				With objSql.Parametros
					.Add("@NumeroAsociado", numeroAsociado)
				End With
			Else
				sSql = "Exec spBuscarAsociados"
				ModGlobal.EscribirLog("📡 Ejecutando SQL por texto: " & sSql)
				With objSql.Parametros
					.Add("@Busqueda", busqueda)
				End With
			End If

			ModGlobal.EscribirLog($"Ejecutando: {sSql} {objSql.getParamList()}")
			Dim dt As DataTable = objSql.GetDataTableSql(sSql)

			' Verificar si hubo error en la base de datos
			If objSql.MensajeError <> "" Then
				ModGlobal.EscribirLog("❌ Error en BD al buscar asociados: " & objSql.MensajeError)
				Return New With {
					.Resultado = "ERROR",
					.Data = "",
					.Mensaje = "Error en la base de datos: " & objSql.MensajeError
				}
			End If

			ModGlobal.EscribirLog("📊 Resultados encontrados: " & dt.Rows.Count & " registros")

			' Crear lista de objetos simples para evitar referencias circulares
			Dim asociados As New List(Of Object)

			If dt.Rows.Count > 0 Then
				For i As Integer = 0 To dt.Rows.Count - 1
					Dim row As DataRow = dt.Rows(i)

					' Log para verificar qué campos están disponibles
					ModGlobal.EscribirLog("📋 Campos disponibles en la fila:")
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
							ModGlobal.EscribirLog($"✅ JsonAuxiliares encontrado: {jsonAuxiliaresValue}")

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

							ModGlobal.EscribirLog($"📊 Rubros procesados: {rubrosUnicos.Count}")
							ModGlobal.EscribirLog($"📊 Auxiliares por rubro: {auxiliaresPorRubro.Count}")
							ModGlobal.EscribirLog($"📊 Transacciones por rubro: {transaccionesPorRubro.Count}")

						Catch ex As Exception
							ModGlobal.EscribirLog($"❌ Error al procesar JsonAuxiliares: {ex.Message}")
						End Try
					Else
						ModGlobal.EscribirLog("❌ JsonAuxiliares NO encontrado o vacío")
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
					ModGlobal.EscribirLog($"📋 Objeto asociado antes de serializar: Rubros = {asociado.Rubros.Count}, Auxiliares = {asociado.AuxiliaresPorRubro.Count}, Transacciones = {asociado.TransaccionesPorRubro.Count}")
					asociados.Add(asociado)


				Next
			End If

			Dim jsonData As String = New JavaScriptSerializer().Serialize(asociados)
			ModGlobal.EscribirLog("📋 JSON generado (primeros 200 chars): " & jsonData.Substring(0, Math.Min(200, jsonData.Length)))

			' Log específico para verificar datos procesados en el JSON final
			If jsonData.Contains("Rubros") AndAlso jsonData.Contains("AuxiliaresPorRubro") AndAlso jsonData.Contains("TransaccionesPorRubro") Then
				ModGlobal.EscribirLog("✅ Datos procesados (Rubros, AuxiliaresPorRubro, TransaccionesPorRubro) encontrados en JSON final")
			Else
				ModGlobal.EscribirLog("❌ Datos procesados NO encontrados en JSON final")
			End If

			Return New With {
				.Resultado = "SUCCESS",
				.Data = jsonData,
				.Mensaje = ""
			}
		Catch ex As Exception
			ModGlobal.EscribirLog("❌ Error en BuscarAsociados: " & ex.Message & " | StackTrace: " & ex.StackTrace)
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
			ModGlobal.EscribirLog("🔍 ObtenerRubros iniciado")

			Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
			Dim sSql As String = "Exec spAuxiliares_ObtenerRubros"

			ModGlobal.EscribirLog($"Ejecutando: {sSql} {objSql.getParamList()}")
			Dim dt As DataTable = objSql.GetDataTableSql(sSql)

			' Verificar si hubo error en la base de datos
			If objSql.MensajeError <> "" Then
				ModGlobal.EscribirLog("❌ Error en BD al obtener rubros: " & objSql.MensajeError)
				Return New With {
					.Resultado = "ERROR",
					.Data = "",
					.Mensaje = "Error en la base de datos: " & objSql.MensajeError
				}
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
			ModGlobal.EscribirLog("❌ Error en ObtenerRubros: " & ex.Message & " | StackTrace: " & ex.StackTrace)
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
			ModGlobal.EscribirLog("🔍 ObtenerAuxiliaresAsociado iniciado. Número: " & numeroAsociado)

			Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
			Dim sSql As String = "Exec spAuxiliares_ObtenerAuxiliaresPorAsociado"

			With objSql.Parametros
				.Add("@NumeroAsociado", numeroAsociado)
			End With

			ModGlobal.EscribirLog($"Ejecutando: {sSql} {objSql.getParamList()}")
			Dim dt As DataTable = objSql.GetDataTableSql(sSql)

			' Verificar si hubo error en la base de datos
			If objSql.MensajeError <> "" Then
				ModGlobal.EscribirLog("❌ Error en BD al obtener auxiliares: " & objSql.MensajeError)
				Return New With {
					.Resultado = "ERROR",
					.Data = "",
					.Mensaje = "Error en la base de datos: " & objSql.MensajeError
				}
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
			ModGlobal.EscribirLog("❌ Error en ObtenerAuxiliaresAsociado: " & ex.Message & " | StackTrace: " & ex.StackTrace)
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
			ModGlobal.EscribirLog("🔍 ObtenerCodigosTransaccion iniciado. Rubro: " & codigoRubro)

			Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
			Dim sSql As String = "Exec spTransacciones_ObtenerCodigosPorRubro"

			With objSql.Parametros
				.Add("@CodigoRubro", codigoRubro)
			End With

			ModGlobal.EscribirLog($"Ejecutando: {sSql} {objSql.getParamList()}")
			Dim dt As DataTable = objSql.GetDataTableSql(sSql)

			' Verificar si hubo error en la base de datos
			If objSql.MensajeError <> "" Then
				ModGlobal.EscribirLog("❌ Error en BD al obtener códigos: " & objSql.MensajeError)
				Return New With {
					.Resultado = "ERROR",
					.Data = "",
					.Mensaje = "Error en la base de datos: " & objSql.MensajeError
				}
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
			ModGlobal.EscribirLog("❌ Error en ObtenerCodigosTransaccion: " & ex.Message & " | StackTrace: " & ex.StackTrace)
			Return New With {
				.Resultado = "ERROR",
				.Data = "",
				.Mensaje = "Error al obtener códigos de transacción: " & ex.Message
			}
		End Try
	End Function

	<WebMethod()>
	<ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
	Public Shared Function GuardarMovimiento(movimientoData As String) As Object
		Try
			ModGlobal.EscribirLog("🔍 GuardarMovimiento iniciado")
			ModGlobal.EscribirLog("📄 Datos recibidos: " & movimientoData)

			Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
			Dim movimientoDict As Dictionary(Of String, Object) = DirectCast(New JavaScriptSerializer().Deserialize(movimientoData, GetType(Dictionary(Of String, Object))), Dictionary(Of String, Object))

			Dim sSql As String = "Exec spMovimientos_GuardarMovimiento"

			With objSql.Parametros
				.Add("@NumeroAsociado", movimientoDict("NumeroAsociado"))
				.Add("@CodigoRubro", movimientoDict("CodigoRubro"))
				.Add("@IDAuxiliar", movimientoDict("IDAuxiliar"))
				.Add("@CodigoTransaccion", movimientoDict("CodigoTransaccion"))
				.Add("@Monto", movimientoDict("Monto"))
				.Add("@Observaciones", If(String.IsNullOrEmpty(movimientoDict("Observaciones").ToString()), "", movimientoDict("Observaciones")))
				.Add("@UsuarioID", HttpContext.Current.Session(VariablesSesion.UsuarioId))
			End With

			ModGlobal.EscribirLog($"Ejecutando: {sSql} {objSql.getParamList()}")
			Dim dt As DataTable = objSql.GetDataTableSql(sSql)

			' Verificar si hubo error en la base de datos
			If objSql.MensajeError <> "" Then
				ModGlobal.EscribirLog("❌ Error en BD al guardar movimiento: " & objSql.MensajeError)
				Return New With {
					.Resultado = "ERROR",
					.Mensaje = "Error en la base de datos: " & objSql.MensajeError
				}
			End If

			Return New With {
				.Resultado = "SUCCESS",
				.Mensaje = "Movimiento guardado correctamente",
				.MovimientoID = dt.Rows(0)(2)
			}
		Catch ex As Exception
			ModGlobal.EscribirLog("❌ Error en GuardarMovimiento: " & ex.Message & " | StackTrace: " & ex.StackTrace)
			Return New With {
				.Resultado = "ERROR",
				.Mensaje = "Error al guardar movimiento: " & ex.Message
			}
		End Try
	End Function

	<WebMethod()>
	<ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
	Public Shared Function GenerarComprobante(movimientoId As String) As Object
		Try
			ModGlobal.EscribirLog("🖨️ GenerarComprobante iniciado. MovimientoID: " & movimientoId)

			Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))

			' Obtener datos del movimiento usando stored procedure
			Dim sSql As String = "Exec spMovimientos_ObtenerDatosComprobante"

			With objSql.Parametros
				.Add("@MovimientoID", Integer.Parse(movimientoId))
			End With

			Dim dt As DataTable = objSql.GetDataTableSql(sSql)

			If dt.Rows.Count = 0 Then
				ModGlobal.EscribirLog("❌ No se encontró el movimiento con ID: " & movimientoId)
				Return New With {
					.Resultado = "ERROR",
					.Mensaje = "No se encontró el movimiento"
				}
			End If

			Dim row As DataRow = dt.Rows(0)

			' Formatear MovimientoID con ceros a la izquierda
			Dim movimientoIdFormateado As String = Right("000000000000" & movimientoId, 12)

			' Formatear fecha y hora
			Dim fechaHora As String = Convert.ToDateTime(row("FechaMovimiento")).ToString("dd/MM/yyyy HH:mm")

			' Formatear monto
			Dim montoFormateado As String = Convert.ToDecimal(row("Monto")).ToString("N2")

			' Leer el template HTML
			Dim templatePath As String = HttpContext.Current.Server.MapPath("~/Forms/Transacciones/ComprobanteTransaccion.html")
			Dim htmlTemplate As String = System.IO.File.ReadAllText(templatePath)

			' Reemplazar placeholders
			htmlTemplate = htmlTemplate.Replace("@MovimientoID", movimientoIdFormateado)
			htmlTemplate = htmlTemplate.Replace("@FechaHora", fechaHora)
			htmlTemplate = htmlTemplate.Replace("@Usuario", row("UsuarioNombre").ToString())
			htmlTemplate = htmlTemplate.Replace("@NumeroAsociado", row("NumeroAsociado").ToString())
			htmlTemplate = htmlTemplate.Replace("@NombreAsociado", row("NombreAsociado").ToString())
			htmlTemplate = htmlTemplate.Replace("@DescripcionAuxiliar", row("DescripcionTipoAuxiliar").ToString())
			htmlTemplate = htmlTemplate.Replace("@Cuenta", row("Cuenta").ToString())
			htmlTemplate = htmlTemplate.Replace("@DescripcionTransaccion", row("DescripcionTransaccion").ToString())
			htmlTemplate = htmlTemplate.Replace("@Monto", montoFormateado)

			ModGlobal.EscribirLog("✅ Comprobante generado exitosamente para movimiento: " & movimientoId)

			Return New With {
				.Resultado = "SUCCESS",
				.Html = htmlTemplate
			}

		Catch ex As Exception
			ModGlobal.EscribirLog("❌ Error en GenerarComprobante: " & ex.Message & " | StackTrace: " & ex.StackTrace)
			Return New With {
				.Resultado = "ERROR",
				.Mensaje = "Error al generar comprobante: " & ex.Message
			}
		End Try
	End Function

	<WebMethod()>
	<ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
	Public Shared Function MarcarComprobanteImpreso(movimientoId As String) As Object
		Try
			ModGlobal.EscribirLog("🖨️ MarcarComprobanteImpreso iniciado. MovimientoID: " & movimientoId)

			Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))

			' Actualizar el campo snImpreso usando stored procedure
			Dim sSql As String = "Exec spMovimientos_MarcarImpreso"

			With objSql.Parametros
				.Add("@MovimientoID", Integer.Parse(movimientoId))
			End With

			Dim dt As DataTable = objSql.GetDataTableSql(sSql)

			' Verificar si hubo error en la base de datos
			If objSql.MensajeError <> "" Then
				ModGlobal.EscribirLog("❌ Error en BD al marcar como impreso: " & objSql.MensajeError)
				Return New With {
					.Resultado = "ERROR",
					.Mensaje = "Error en la base de datos: " & objSql.MensajeError
				}
			End If

			Dim filasAfectadas As Integer = 0
			If dt.Rows.Count > 0 Then
				filasAfectadas = Convert.ToInt32(dt.Rows(0)("FilasAfectadas"))
			End If

			If filasAfectadas > 0 Then
				ModGlobal.EscribirLog("✅ Comprobante marcado como impreso para movimiento: " & movimientoId)
				Return New With {
					.Resultado = "SUCCESS",
					.Mensaje = "Comprobante marcado como impreso"
				}
			Else
				ModGlobal.EscribirLog("❌ No se encontró el movimiento con ID: " & movimientoId)
				Return New With {
					.Resultado = "ERROR",
					.Mensaje = "No se encontró el movimiento"
				}
			End If

		Catch ex As Exception
			ModGlobal.EscribirLog("❌ Error en MarcarComprobanteImpreso: " & ex.Message & " | StackTrace: " & ex.StackTrace)
			Return New With {
				.Resultado = "ERROR",
				.Mensaje = "Error al marcar comprobante como impreso: " & ex.Message
			}
		End Try
	End Function
End Class
