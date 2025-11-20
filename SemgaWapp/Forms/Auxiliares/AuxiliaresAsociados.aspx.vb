Imports System.Web.Services
Imports System.Web.Script.Services
Imports System.Web.Script.Serialization
Imports SBSqlClient
Imports SBUtility
Imports System.Data
Imports System.Web.Security

Public Class AuxiliaresAsociados
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
	Public Shared Function ObtenerRubros() As Object
		Try
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
			ModGlobal.EscribirLog("Error en ObtenerRubros: " & ex.Message)
			Return New With {
				.Resultado = "ERROR",
				.Data = "",
				.Mensaje = "Error al obtener rubros: " & ex.Message
			}
		End Try
	End Function

	<WebMethod()>
	<ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
	Public Shared Function ObtenerTiposAuxiliares() As Object
		Try
			Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
			Dim sSql As String = "Exec spAuxiliares_ObtenerTiposAuxiliares"
			ModGlobal.EscribirLog($"Ejecutando: {sSql} {objSql.getParamList()}")
			Dim dt As DataTable = objSql.GetDataTableSql(sSql)

			' Verificar si hubo error en la base de datos
			If objSql.MensajeError <> "" Then
				ModGlobal.EscribirLog("Error en BD al obtener tipos de auxiliares: " & objSql.MensajeError)
				Return New With {
					.Resultado = "ERROR",
					.Data = "",
					.Mensaje = "Error en la base de datos: " & objSql.MensajeError
				}
			End If

			' Crear lista de objetos simples para evitar referencias circulares
			Dim tiposAuxiliares As New List(Of Object)

			For Each row As DataRow In dt.Rows
				Dim tipoAuxiliar As New With {
					.TipoAuxiliar = row("TipoAuxiliar").ToString(),
					.IdTipoAuxiliar = row("IdTipoAuxiliar").ToString(),
					.Descripcion = row("Descripcion").ToString(),
					.CodigoRubro = row("CodigoRubro").ToString(),
					.Tasa = If(row("Tasa") Is DBNull.Value, 0, Convert.ToDecimal(row("Tasa")))
				}
				tiposAuxiliares.Add(tipoAuxiliar)
			Next

			Return New With {
				.Resultado = "SUCCESS",
				.Data = New JavaScriptSerializer().Serialize(tiposAuxiliares),
				.Mensaje = ""
			}
		Catch ex As Exception
			ModGlobal.EscribirLog("Error en ObtenerTiposAuxiliares: " & ex.Message)
			Return New With {
				.Resultado = "ERROR",
				.Data = "",
				.Mensaje = "Error al obtener tipos de auxiliares: " & ex.Message
			}
		End Try
	End Function


	<WebMethod()>
	<ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
	Public Shared Function ObtenerAuxiliares() As Object
		Try
			Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
			Dim sSql As String = "Exec spAuxiliares_ObtenerAuxiliares"
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
			End If

			' Crear lista de objetos simples para evitar referencias circulares
			Dim auxiliares As New List(Of Object)

			For Each row As DataRow In dt.Rows
				Dim auxiliar As New With {
					.ID = row("ID").ToString(),
					.Cuenta = If(row("Cuenta") Is DBNull.Value, "", row("Cuenta").ToString()),
					.NumeroAsociado = row("NumeroAsociado").ToString(),
					.NombreAsociado = row("NombreAsociado").ToString(),
					.CodTipoDoc = If(row("CodTipoDoc") Is DBNull.Value, "", row("CodTipoDoc").ToString()),
					.NumeroIdentificacion = If(row("NumeroIdentificacion") Is DBNull.Value, "", row("NumeroIdentificacion").ToString()),
					.CodigoRubro = row("CodigoRubro").ToString(),
					.DescripcionRubro = row("DescripcionRubro").ToString(),
					.TipoAuxiliar = row("TipoAuxiliar").ToString(),
					.DescripcionTipoAuxiliar = row("DescripcionTipoAuxiliar").ToString(),
					.IdTipoAuxiliar = row("IdTipoAuxiliar").ToString(),
					.Cuota = row("Cuota").ToString(),
					.Saldo = row("Saldo").ToString(),
					.MontoOriginal = row("MontoOriginal").ToString(),
					.MontoPignorado = row("MontoPignorado").ToString(),
					.TasaInteres = row("TasaInteres").ToString(),
					.PagoMes = row("PagoMes").ToString(),
					.FechaOtorgado = If(row("FechaOtorgado") Is DBNull.Value, "", row("FechaOtorgado").ToString()),
					.FechaUltimoPago = If(row("FechaUltimoPago") Is DBNull.Value, "", row("FechaUltimoPago").ToString()),
					.FechaCreacion = If(row("FechaCreacion") Is DBNull.Value, "", row("FechaCreacion").ToString()),
					.UsuarioCrea = If(row("UsuarioCrea") Is DBNull.Value, "", row("UsuarioCrea").ToString()),
					.UsuarioModifica = If(row("UsuarioModifica") Is DBNull.Value, "", row("UsuarioModifica").ToString())
				}
				auxiliares.Add(auxiliar)
			Next

			Return New With {
				.Resultado = "SUCCESS",
				.Data = New JavaScriptSerializer().Serialize(auxiliares),
				.Mensaje = ""
			}
		Catch ex As Exception
			ModGlobal.EscribirLog("Error en ObtenerAuxiliares: " & ex.Message)
			Return New With {
				.Resultado = "ERROR",
				.Data = "",
				.Mensaje = "Error al obtener auxiliares: " & ex.Message
			}
		End Try
	End Function

	<WebMethod()>
	<ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
	Public Shared Function ObtenerTodosAuxiliares() As Object
		Try
			Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
			Dim sSql As String = "Exec spAuxiliares_ObtenerAuxiliares"
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
			End If

			' Crear lista de objetos simples para evitar referencias circulares
			Dim auxiliares As New List(Of Object)

			For Each row As DataRow In dt.Rows
				Dim auxiliar As New With {
					.ID = row("ID").ToString(),
					.Cuenta = If(row("Cuenta") Is DBNull.Value, "", row("Cuenta").ToString()),
					.NumeroAsociado = row("NumeroAsociado").ToString(),
					.NombreAsociado = row("NombreAsociado").ToString(),
					.CodTipoDoc = If(row("CodTipoDoc") Is DBNull.Value, "", row("CodTipoDoc").ToString()),
					.NumeroIdentificacion = If(row("NumeroIdentificacion") Is DBNull.Value, "", row("NumeroIdentificacion").ToString()),
					.CodigoRubro = row("CodigoRubro").ToString(),
					.DescripcionRubro = row("DescripcionRubro").ToString(),
					.TipoAuxiliar = row("TipoAuxiliar").ToString(),
					.DescripcionTipoAuxiliar = row("DescripcionTipoAuxiliar").ToString(),
					.IdTipoAuxiliar = row("IdTipoAuxiliar").ToString(),
					.Cuota = row("Cuota").ToString(),
					.Saldo = row("Saldo").ToString(),
					.MontoOriginal = row("MontoOriginal").ToString(),
					.MontoPignorado = row("MontoPignorado").ToString(),
					.TasaInteres = row("TasaInteres").ToString(),
					.PagoMes = row("PagoMes").ToString(),
					.FechaOtorgado = If(row("FechaOtorgado") Is DBNull.Value, "", row("FechaOtorgado").ToString()),
					.FechaUltimoPago = If(row("FechaUltimoPago") Is DBNull.Value, "", row("FechaUltimoPago").ToString()),
					.FechaCreacion = If(row("FechaCreacion") Is DBNull.Value, "", row("FechaCreacion").ToString()),
					.UsuarioCrea = If(row("UsuarioCrea") Is DBNull.Value, "", row("UsuarioCrea").ToString()),
					.UsuarioModifica = If(row("UsuarioModifica") Is DBNull.Value, "", row("UsuarioModifica").ToString())
				}
				auxiliares.Add(auxiliar)
			Next

			Return New With {
				.Resultado = "SUCCESS",
				.Data = New JavaScriptSerializer().Serialize(auxiliares),
				.Mensaje = ""
			}
		Catch ex As Exception
			ModGlobal.EscribirLog("Error en ObtenerTodosAuxiliares: " & ex.Message)
			Return New With {
				.Resultado = "ERROR",
				.Data = "",
				.Mensaje = "Error al obtener auxiliares: " & ex.Message
			}
		End Try
	End Function

	<WebMethod()>
	<ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
	Public Shared Function FiltrarAuxiliares(busqueda As String, tipoAuxiliar As String, codigoRubro As String) As Object
		Try
			Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
			Dim sSql As String = "Exec spAuxiliares_FiltrarAuxiliares"

			With objSql.Parametros
				If busqueda <> "" Then
					.Add("@Busqueda", busqueda)
				End If

				If tipoAuxiliar <> "" Then
					.Add("@IdTipoAuxiliar", tipoAuxiliar)
				End If

				If codigoRubro <> "" Then
					.Add("@CodigoRubro", codigoRubro)
				End If

			End With


			EscribirLog($"Ejecutando: {sSql} {objSql.getParamList()}")
			Dim dt As DataTable = objSql.GetDataTableSql(sSql)

			' Verificar si hubo error en la base de datos
			If objSql.MensajeError <> "" Then
				ModGlobal.EscribirLog("Error en BD al filtrar auxiliares: " & objSql.MensajeError)
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
				.Cuenta = If(row("Cuenta") Is DBNull.Value, "", row("Cuenta").ToString()),
				.NumeroAsociado = row("NumeroAsociado").ToString(),
					.NombreAsociado = row("NombreAsociado").ToString(),
					.CodTipoDoc = If(row("CodTipoDoc") Is DBNull.Value, "", row("CodTipoDoc").ToString()),
					.NumeroIdentificacion = If(row("NumeroIdentificacion") Is DBNull.Value, "", row("NumeroIdentificacion").ToString()),
					.CodigoRubro = row("CodigoRubro").ToString(),
					.DescripcionRubro = row("DescripcionRubro").ToString(),
					.TipoAuxiliar = row("TipoAuxiliar").ToString(),
					.DescripcionTipoAuxiliar = row("DescripcionTipoAuxiliar").ToString(),
					.Cuota = row("Cuota").ToString(),
					.Saldo = row("Saldo").ToString(),
					.MontoOriginal = row("MontoOriginal").ToString(),
					.MontoPignorado = row("MontoPignorado").ToString(),
					.TasaInteres = row("TasaInteres").ToString(),
					.PagoMes = row("PagoMes").ToString(),
					.FechaOtorgado = If(row("FechaOtorgado") Is DBNull.Value, "", row("FechaOtorgado").ToString()),
					.FechaUltimoPago = If(row("FechaUltimoPago") Is DBNull.Value, "", row("FechaUltimoPago").ToString()),
					.FechaCreacion = If(row("FechaCreacion") Is DBNull.Value, "", row("FechaCreacion").ToString()),
					.UsuarioCrea = If(row("UsuarioCrea") Is DBNull.Value, "", row("UsuarioCrea").ToString()),
					.UsuarioModifica = If(row("UsuarioModifica") Is DBNull.Value, "", row("UsuarioModifica").ToString())
				}
				auxiliares.Add(auxiliar)
			Next

			Return New With {
				.Resultado = "SUCCESS",
				.Data = New JavaScriptSerializer().Serialize(auxiliares),
				.Mensaje = ""
			}
		Catch ex As Exception
			ModGlobal.EscribirLog("Error en FiltrarAuxiliares: " & ex.Message)
			Return New With {
				.Resultado = "ERROR",
				.Data = "",
				.Mensaje = "Error al filtrar auxiliares: " & ex.Message
			}
		End Try
	End Function

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
				ModGlobal.EscribirLog("Error en BD al buscar asociados: " & objSql.MensajeError)
				Return New With {
					.Resultado = "ERROR",
					.Data = "",
					.Mensaje = "Error en la base de datos: " & objSql.MensajeError
				}
			End If

			ModGlobal.EscribirLog("Resultados encontrados: " & dt.Rows.Count & " registros")

			' Crear lista de objetos simples para evitar referencias circulares
			Dim asociados As New List(Of Object)

			If dt.Rows.Count > 0 Then
				For i As Integer = 0 To dt.Rows.Count - 1
					Dim row As DataRow = dt.Rows(i)
					Dim asociado As New With {
						.NumeroAsociado = row("NumeroAsociado").ToString(),
						.NombreCompleto = row("NombreCompleto").ToString(),
						.NumeroIdentificacion = row("NumeroIdentificacion").ToString(),
						.TipoAsociado = row("TipoAsociado").ToString(),
						.CodTipoDoc = If(row("CodTipoDoc") Is DBNull.Value, "", row("CodTipoDoc").ToString())
					}
					asociados.Add(asociado)

					If i < 5 Then
						ModGlobal.EscribirLog("👤 Asociado #" & (i + 1) & ": " & row("NombreCompleto").ToString() & " - " & row("NumeroAsociado").ToString())
					End If
				Next
			End If

			Dim jsonData As String = New JavaScriptSerializer().Serialize(asociados)
			ModGlobal.EscribirLog("JSON generado (primeros 200 chars): " & jsonData.Substring(0, Math.Min(200, jsonData.Length)))

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

	' Función para normalizar valores numéricos en el servidor
	Private Shared Function NormalizarValorNumerico(valor As Object) As Decimal
		If valor Is Nothing Then Return 0

		Dim valorStr As String = valor.ToString()
		If String.IsNullOrEmpty(valorStr) Then Return 0

		' Convertir coma a punto para formato decimal
		valorStr = valorStr.Replace(",", ".")

		' Intentar parsear como decimal
		Dim resultado As Decimal = 0
		If Decimal.TryParse(valorStr, resultado) Then
			Return resultado
		Else
			Return 0
		End If
	End Function

	<WebMethod()>
	<ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
	Public Shared Function GuardarAuxiliar(auxiliar As Object) As Object
		Try
			Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
			Dim auxiliarDict As Dictionary(Of String, Object) = DirectCast(auxiliar, Dictionary(Of String, Object))

			' Log de los valores recibidos
			ModGlobal.EscribirLog("GuardarAuxiliar - Valores recibidos:")
			ModGlobal.EscribirLog($"  TasaInteres: {auxiliarDict("TasaInteres")} (Tipo: {auxiliarDict("TasaInteres").GetType().Name})")
			ModGlobal.EscribirLog($"  PagoMes: {auxiliarDict("PagoMes")} (Tipo: {auxiliarDict("PagoMes").GetType().Name})")
			ModGlobal.EscribirLog($"  Saldo: {auxiliarDict("Saldo")} (Tipo: {auxiliarDict("Saldo").GetType().Name})")

			' Normalizar valores numéricos
			Dim cuotaNormalizada As Decimal = CDbl(auxiliarDict("Cuota")) 'NormalizarValorNumerico(auxiliarDict("Cuota"))
			Dim saldoNormalizado As Decimal = CDbl(auxiliarDict("Saldo")) ' NormalizarValorNumerico(auxiliarDict("Saldo"))
			Dim montoOriginalNormalizado As Decimal = CDbl(auxiliarDict("MontoOriginal")) 'NormalizarValorNumerico(auxiliarDict("MontoOriginal"))
			Dim montoPignoradoNormalizado As Decimal = CDbl(auxiliarDict("MontoPignorado"))
			Dim tasaInteresNormalizada As Decimal = CDbl(auxiliarDict("TasaInteres")) 'NormalizarValorNumerico(auxiliarDict("TasaInteres"))
			Dim pagoMesNormalizado As Decimal = auxiliarDict("PagoMes") 'NormalizarValorNumerico(auxiliarDict("PagoMes"))

			ModGlobal.EscribirLog("GuardarAuxiliar - Valores normalizados:")
			ModGlobal.EscribirLog($"  Cuota: {cuotaNormalizada}")
			ModGlobal.EscribirLog($"  Saldo: {saldoNormalizado}")
			ModGlobal.EscribirLog($"  MontoOriginal: {montoOriginalNormalizado}")
			ModGlobal.EscribirLog($"  MontoPignorado: {montoPignoradoNormalizado}")
			ModGlobal.EscribirLog($"  TasaInteres: {tasaInteresNormalizada}")
			ModGlobal.EscribirLog($"  PagoMes: {pagoMesNormalizado}")

			Dim sSql As String = "Exec spAuxiliares_GuardarAuxiliar"

			With objSql.Parametros
				.Add("@ID", If(auxiliarDict("ID"), 0))
				.Add("@NumeroAsociado", auxiliarDict("NumeroAsociado"))
				.Add("@CodigoRubro", auxiliarDict("CodigoRubro"))
				.Add("@TipoAuxiliar", auxiliarDict("TipoAuxiliar"))
				.Add("@Cuota", cuotaNormalizada)
				.Add("@Saldo", saldoNormalizado)
				.Add("@MontoOriginal", montoOriginalNormalizado)
				.Add("@MontoPignorado", montoPignoradoNormalizado)

				If Not (String.IsNullOrEmpty(auxiliarDict("FechaOtorgado").ToString())) Then
					.Add("@FechaOtorgado", auxiliarDict("FechaOtorgado").ToString())
				End If


				.Add("@TasaInteres", tasaInteresNormalizada)
				.Add("@PagoMes", pagoMesNormalizado)
				.Add("@UsuarioID", HttpContext.Current.Session(VariablesSesion.UsuarioId))
				.Add("@IdSession", HttpContext.Current.Session(VariablesSesion.logID).ToString())
			End With

			ModGlobal.EscribirLog($"Ejecutando: {sSql} {objSql.getParamList()}")
			Dim dt As DataTable = objSql.GetDataTableSql(sSql)

			' Verificar si hubo error en la base de datos
			If objSql.MensajeError <> "" Then
				ModGlobal.EscribirLog("Error en BD al guardar auxiliar: " & objSql.MensajeError)
				Return New With {
					.Resultado = "ERROR",
					.Mensaje = "Error en la base de datos: " & objSql.MensajeError
				}
			End If

			If dt.Rows.Count > 0 Then
				Dim row As DataRow = dt.Rows(0)
				Return New With {
					.Resultado = row("Resultado").ToString(),
					.Mensaje = row("Mensaje").ToString()
				}
			Else
				Return New With {
					.Resultado = "ERROR",
					.Mensaje = "No se recibió respuesta del procedimiento almacenado"
				}
			End If
		Catch ex As Exception
			ModGlobal.EscribirLog("Error en GuardarAuxiliar: " & ex.Message)
			Return New With {
				.Resultado = "ERROR",
				.Mensaje = "Error al guardar auxiliar: " & ex.Message
			}
		End Try
	End Function



	<WebMethod()>
	<ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
	Public Shared Function EliminarAuxiliar(id As Integer, numeroAsociado As Integer) As Object
		Try
			Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
			Dim sSql As String = "Exec spAuxiliares_EliminarAuxiliar"

			With objSql.Parametros
				.Add("@ID", id)
				.Add("@NumeroAsociado", numeroAsociado)
				.Add("@UsuarioID", HttpContext.Current.Session(VariablesSesion.UsuarioId))
				.Add("@IdSession", HttpContext.Current.Session(VariablesSesion.logID).ToString())
			End With

			ModGlobal.EscribirLog($"Ejecutando: {sSql} {objSql.getParamList()}")
			Dim dt As DataTable = objSql.GetDataTableSql(sSql)

			' Verificar si hubo error en la base de datos
			If objSql.MensajeError <> "" Then
				ModGlobal.EscribirLog("Error en BD al eliminar auxiliar: " & objSql.MensajeError)
				Return New With {
					.Resultado = "ERROR",
					.Mensaje = "Error en la base de datos: " & objSql.MensajeError
				}
			End If

			If dt.Rows.Count > 0 Then
				Dim row As DataRow = dt.Rows(0)
				Return New With {
					.Resultado = row("Resultado").ToString(),
					.Mensaje = row("Mensaje").ToString()
				}
			Else
				Return New With {
					.Resultado = "ERROR",
					.Mensaje = "No se recibió respuesta del procedimiento almacenado"
				}
			End If
		Catch ex As Exception
			ModGlobal.EscribirLog("Error en EliminarAuxiliar: " & ex.Message)
			Return New With {
				.Resultado = "ERROR",
				.Mensaje = "Error al eliminar auxiliar: " & ex.Message
			}
		End Try
	End Function

	<WebMethod()>
	<ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
	Public Shared Function ModificarMontoPignorado(auxiliarID As Integer, numeroAsociado As Integer, nuevoMonto As Decimal) As Object
		Try
			' Verificar nivel de acceso
			Dim nivelAcceso As Integer = Convert.ToInt32(HttpContext.Current.Session("NivelAcceso"))
			If nivelAcceso > 1 Then
				Return New With {
					.Resultado = "ERROR",
					.Mensaje = "No tiene permisos para realizar esta acción"
				}
			End If

			Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
			Dim sSql As String = "Exec spAuxiliares_ModificarMontoPignorado"

			With objSql.Parametros
				.Add("@AuxiliarID", auxiliarID)
				.Add("@NumeroAsociado", numeroAsociado)
				.Add("@NuevoMonto", nuevoMonto)
				.Add("@UsuarioModifica", HttpContext.Current.Session(VariablesSesion.UsuarioId))
				.Add("@IdSession", HttpContext.Current.Session(VariablesSesion.logID).ToString())
			End With

			ModGlobal.EscribirLog($"Ejecutando: {sSql} {objSql.getParamList()}")
			Dim dt As DataTable = objSql.GetDataTableSql(sSql)

			' Verificar si hubo error en la base de datos
			If objSql.MensajeError <> "" Then
				ModGlobal.EscribirLog("Error en BD al modificar monto pignorado: " & objSql.MensajeError)
				Return New With {
					.Resultado = "ERROR",
					.Mensaje = "Error en la base de datos: " & objSql.MensajeError
				}
			End If

			If dt.Rows.Count > 0 Then
				Dim row As DataRow = dt.Rows(0)
				Return New With {
					.Resultado = "OK",
					.Mensaje = row("Mensaje").ToString()
				}
			Else
				Return New With {
					.Resultado = "ERROR",
					.Mensaje = "No se recibió respuesta del procedimiento almacenado"
				}
			End If
		Catch ex As Exception
			ModGlobal.EscribirLog("Error en ModificarMontoPignorado: " & ex.Message)
			Return New With {
				.Resultado = "ERROR",
				.Mensaje = "Error al modificar monto pignorado: " & ex.Message
			}
		End Try
	End Function

	<WebMethod()>
	<ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
	Public Shared Function EliminarAuxiliarConAuditoria(id As Integer, numeroAsociado As Integer, equipoElimina As String) As Object
		Try
			' Obtener información del servidor
			Dim serverInfo As String = ObtenerInformacionServidor()

			' Combinar información del cliente y servidor
			Dim equipoInfoCompleto As String = CombinarInformacionEquipo(equipoElimina, serverInfo)

			' Log de los parametros recibidos
			ModGlobal.EscribirLog("EliminarAuxiliarConAuditoria - Parametros recibidos:")
			ModGlobal.EscribirLog($"  ID: {id}")
			ModGlobal.EscribirLog($"  NumeroAsociado: {numeroAsociado}")
			ModGlobal.EscribirLog($"  UsuarioElimina: {HttpContext.Current.Session(VariablesSesion.UsuarioId)}")
			ModGlobal.EscribirLog($"  EquipoElimina: {equipoInfoCompleto}")

			Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
			Dim sSql As String = "Exec spAuxiliares_EliminarAuxiliar_ConAuditoria"

			With objSql.Parametros
				.Add("@ID", id)
				.Add("@NumeroAsociado", numeroAsociado)
				.Add("@UsuarioElimina", HttpContext.Current.Session(VariablesSesion.UsuarioId))
				.Add("@EquipoElimina", equipoInfoCompleto)
			End With

			ModGlobal.EscribirLog($"Ejecutando: {sSql} {objSql.getParamList()}")
			Dim dt As DataTable = objSql.GetDataTableSql(sSql)

			' Verificar si hubo error en la base de datos
			If objSql.MensajeError <> "" Then
				ModGlobal.EscribirLog("Error en BD al eliminar auxiliar: " & objSql.MensajeError)
				Return New With {
					.Resultado = "ERROR",
					.Mensaje = "Error en la base de datos: " & objSql.MensajeError
				}
			End If

			If dt.Rows.Count > 0 Then
				Dim row As DataRow = dt.Rows(0)
				Return New With {
					.Resultado = "SUCCESS",
					.Mensaje = row("Mensaje").ToString()
				}
			Else
				Return New With {
					.Resultado = "ERROR",
					.Mensaje = "No se recibió respuesta del procedimiento almacenado"
				}
			End If
		Catch ex As Exception
			ModGlobal.EscribirLog("Error en EliminarAuxiliarConAuditoria: " & ex.Message)
			Return New With {
				.Resultado = "ERROR",
				.Mensaje = "Error al eliminar auxiliar: " & ex.Message
			}
		End Try
	End Function

	' Función para obtener información del servidor
	Private Shared Function ObtenerInformacionServidor() As String
		Try
			Dim request As HttpRequest = HttpContext.Current.Request

			' Obtener información del servidor
			Dim machineName As String = System.Environment.MachineName
			Dim osVersion As String = System.Environment.OSVersion.ToString()
			Dim version As String = System.Environment.Version.ToString()
			Dim workingSet As String = System.Environment.WorkingSet.ToString()
			Dim processorCount As String = System.Environment.ProcessorCount.ToString()

			Dim serverInfo As New With {
				.ipAddress = ObtenerIPCliente(request),
				.userHostAddress = request.UserHostAddress,
				.userHostName = request.UserHostName,
				.serverName = request.ServerVariables("SERVER_NAME"),
				.serverPort = request.ServerVariables("SERVER_PORT"),
				.httpHost = request.ServerVariables("HTTP_HOST"),
				.remoteAddr = request.ServerVariables("REMOTE_ADDR"),
				.remoteHost = request.ServerVariables("REMOTE_HOST"),
				.httpUserAgent = request.ServerVariables("HTTP_USER_AGENT"),
				.httpAcceptLanguage = request.ServerVariables("HTTP_ACCEPT_LANGUAGE"),
				.httpAcceptEncoding = request.ServerVariables("HTTP_ACCEPT_ENCODING"),
				.httpConnection = request.ServerVariables("HTTP_CONNECTION"),
				.httpXForwardedFor = request.ServerVariables("HTTP_X_FORWARDED_FOR"),
				.httpXRealIP = request.ServerVariables("HTTP_X_REAL_IP"),
				.serverMachineName = machineName,
				.serverOS = osVersion,
				.serverVersion = version,
				.serverWorkingSet = workingSet,
				.serverProcessorCount = processorCount,
				.timestamp = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss")
			}

			Return Newtonsoft.Json.JsonConvert.SerializeObject(serverInfo)
		Catch ex As Exception
			ModGlobal.EscribirLog("Error al obtener información del servidor: " & ex.Message)
			Return "{}"
		End Try
	End Function

	' Función para obtener la IP real del cliente
	Private Shared Function ObtenerIPCliente(request As HttpRequest) As String
		Try
			' Verificar si hay proxy o load balancer
			Dim ip As String = request.ServerVariables("HTTP_X_FORWARDED_FOR")
			If String.IsNullOrEmpty(ip) Then
				ip = request.ServerVariables("HTTP_X_REAL_IP")
			End If
			If String.IsNullOrEmpty(ip) Then
				ip = request.ServerVariables("REMOTE_ADDR")
			End If
			If String.IsNullOrEmpty(ip) Then
				ip = request.UserHostAddress
			End If

			' Si hay múltiples IPs (proxy), tomar la primera
			If ip.Contains(",") Then
				ip = ip.Split(","c)(0).Trim()
			End If

			Return ip
		Catch ex As Exception
			Return "Unknown"
		End Try
	End Function

	' Función para combinar información del cliente y servidor
	Private Shared Function CombinarInformacionEquipo(clienteInfo As String, servidorInfo As String) As String
		Try
			Dim clienteObj = Newtonsoft.Json.JsonConvert.DeserializeObject(clienteInfo)
			Dim servidorObj = Newtonsoft.Json.JsonConvert.DeserializeObject(servidorInfo)

			Dim equipoCompleto As New With {
				.cliente = clienteObj,
				.servidor = servidorObj,
				.timestampCombinado = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss")
			}

			Return Newtonsoft.Json.JsonConvert.SerializeObject(equipoCompleto)
		Catch ex As Exception
			ModGlobal.EscribirLog("Error al combinar información del equipo: " & ex.Message)
			Return clienteInfo
		End Try
	End Function


End Class
