Imports System.Collections
Imports System.Data
Imports System.Web.Script.Services
Imports System.Web.Services
Imports System.Web.Script.Serialization
Imports System.Globalization
Imports SBSqlClient
Imports SBUtility

Partial Public Class Finanzas
	Inherits BasePage

	Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
		If Session(VariablesSesion.UsuarioId) Is Nothing Then
			Response.Redirect("~/Login.aspx")
			Return
		End If
		If ModGlobal.ValidarYRedirigirSiSinPermiso(HttpContext.Current) Then Return
	End Sub

#Region "Asientos Contables"
	<WebMethod(EnableSession:=True)>
	<ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
	Public Shared Function ObtenerCuentas() As String
		Dim serializer As New JavaScriptSerializer()
		Try
			ModGlobal.EscribirLog("ESTA EJECUTANDO EL METODO ObtenerCuentas (Finanzas)")

			Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
			Dim sSql As String = "Exec spCuentas_ListarParaDropdown"

			ModGlobal.EscribirLog(String.Format("Ejecutando SQL: {0} {1}", sSql, objSql.getParamList()))
			Dim dt As DataTable = objSql.GetDataTableSql(sSql)

			If objSql.MensajeError <> "" Then
				ModGlobal.EscribirLog("BD ERROR: ObtenerCuentas - " & objSql.MensajeError)
				Return serializer.Serialize(New With {
						.Resultado = "ERROR",
						.Datos = "",
						.Mensaje = "Error en la base de datos: " & objSql.MensajeError
					})
			End If
			ModGlobal.EscribirLog("BD OK: ObtenerCuentas - " & dt.Rows.Count.ToString() & " registros")

			Dim cuentas As New List(Of Object)
			For Each row As DataRow In dt.Rows
				cuentas.Add(New With {
						.Cuenta = row("Cuenta").ToString(),
						.NombreCuenta = row("NombreCuenta").ToString(),
						.Saldo = If(row.Table.Columns.Contains("Saldo") AndAlso Not row.IsNull("Saldo"), Convert.ToDecimal(row("Saldo")), 0D)
					})
			Next

			ModGlobal.EscribirLog("Metodo ObtenerCuentas (Finanzas) completado exitosamente")
			Return serializer.Serialize(New With {
					.Resultado = "SUCCESS",
					.Datos = serializer.Serialize(cuentas),
					.Mensaje = ""
				})

		Catch ex As Exception
			ModGlobal.EscribirLog("Error en ObtenerCuentas (Finanzas): " & ex.Message & " | StackTrace: " & ex.StackTrace)
			Return serializer.Serialize(New With {
					.Resultado = "ERROR",
					.Datos = "",
					.Mensaje = "Error al obtener cuentas: " & ex.Message
				})
		End Try
	End Function

	<WebMethod(EnableSession:=True)>
	<ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
	Public Shared Function GuardarAsiento(asientoData As Object) As String
		Dim serializer As New JavaScriptSerializer()
		Try
			ModGlobal.EscribirLog("ESTA EJECUTANDO EL METODO GuardarAsiento")
			ModGlobal.EscribirLog("Parametros recibidos: " & serializer.Serialize(asientoData))

			Dim asientoDict As Dictionary(Of String, Object) = TryCast(asientoData, Dictionary(Of String, Object))
			If asientoDict Is Nothing Then
				Return serializer.Serialize(New With {
					.Resultado = "ERROR",
					.Mensaje = "Datos de asiento inválidos"
				})
			End If

			Dim cabeceraObj As Object = If(asientoDict.ContainsKey("Cabecera"), asientoDict("Cabecera"), Nothing)
			Dim cabeceraDict As Dictionary(Of String, Object) = TryCast(cabeceraObj, Dictionary(Of String, Object))
			If cabeceraDict Is Nothing Then
				Return serializer.Serialize(New With {
					.Resultado = "ERROR",
					.Mensaje = "La cabecera del asiento es requerida"
				})
			End If

			Dim fechaStr As String = If(cabeceraDict.ContainsKey("Fecha") AndAlso cabeceraDict("Fecha") IsNot Nothing, cabeceraDict("Fecha").ToString(), String.Empty)
			Dim comentario As String = If(cabeceraDict.ContainsKey("Comentario") AndAlso cabeceraDict("Comentario") IsNot Nothing, cabeceraDict("Comentario").ToString().Trim(), String.Empty)

			If String.IsNullOrWhiteSpace(fechaStr) Then
				Return serializer.Serialize(New With {
					.Resultado = "ERROR",
					.Mensaje = "La fecha del asiento es requerida"
				})
			End If

			If String.IsNullOrWhiteSpace(comentario) Then
				Return serializer.Serialize(New With {
					.Resultado = "ERROR",
					.Mensaje = "El comentario del asiento es requerido"
				})
			End If

			Dim fecha As DateTime
			If Not DateTime.TryParse(fechaStr, CultureInfo.InvariantCulture, DateTimeStyles.None, fecha) Then
				Return serializer.Serialize(New With {
					.Resultado = "ERROR",
					.Mensaje = "La fecha del asiento no es válida"
				})
			End If
			Dim fechaFormateadaParaSp As String = fecha.ToString("yyyyMMdd", CultureInfo.InvariantCulture)

			Dim detallesObj As Object = If(asientoDict.ContainsKey("Detalles"), asientoDict("Detalles"), Nothing)
			Dim detallesLista As List(Of Dictionary(Of String, Object)) = Nothing

			Try
				detallesLista = serializer.ConvertToType(Of List(Of Dictionary(Of String, Object)))(detallesObj)
			Catch ex As Exception
				ModGlobal.EscribirLog("No se pudo convertir Detalles mediante ConvertToType: " & ex.Message)
			End Try

			If (detallesLista Is Nothing OrElse detallesLista.Count = 0) AndAlso detallesObj IsNot Nothing Then
				If TypeOf detallesObj Is String Then
					Try
						detallesLista = serializer.Deserialize(Of List(Of Dictionary(Of String, Object)))(detallesObj.ToString())
					Catch ex As Exception
						ModGlobal.EscribirLog("No se pudo deserializar Detalles desde string: " & ex.Message)
					End Try
				ElseIf TypeOf detallesObj Is ArrayList Then
					Dim tempLista As New List(Of Dictionary(Of String, Object))()
					For Each item In CType(detallesObj, ArrayList)
						Dim detalleDictTemp As Dictionary(Of String, Object) = TryCast(item, Dictionary(Of String, Object))
						If detalleDictTemp IsNot Nothing Then
							tempLista.Add(detalleDictTemp)
						End If
					Next
					If tempLista.Count > 0 Then
						detallesLista = tempLista
					End If
				End If
			End If

			If detallesLista Is Nothing OrElse detallesLista.Count = 0 Then
				Return serializer.Serialize(New With {
					.Resultado = "ERROR",
					.Mensaje = "Debe incluir al menos una cuenta en el asiento"
				})
			End If

			Dim totalDebito As Decimal = 0D
			Dim totalCredito As Decimal = 0D
			Dim detallesProcesados As New List(Of Dictionary(Of String, Object))()

			For i As Integer = 0 To detallesLista.Count - 1
				Dim detalleDict As Dictionary(Of String, Object) = detallesLista(i)
				If detalleDict Is Nothing Then
					Return serializer.Serialize(New With {
						.Resultado = "ERROR",
						.Mensaje = $"El detalle en la posición {i + 1} es inválido"
					})
				End If

				Dim cuenta As String = If(detalleDict.ContainsKey("Cuenta") AndAlso detalleDict("Cuenta") IsNot Nothing, detalleDict("Cuenta").ToString(), String.Empty)
				If String.IsNullOrWhiteSpace(cuenta) Then
					Return serializer.Serialize(New With {
						.Resultado = "ERROR",
						.Mensaje = $"La cuenta es requerida en la línea {i + 1}"
					})
				End If

				Dim debitoDecimal As Decimal = 0D
				Dim creditoDecimal As Decimal = 0D

				If detalleDict.ContainsKey("Debito") AndAlso detalleDict("Debito") IsNot Nothing Then
					Decimal.TryParse(detalleDict("Debito").ToString(), NumberStyles.Any, CultureInfo.InvariantCulture, debitoDecimal)
				End If

				If detalleDict.ContainsKey("Credito") AndAlso detalleDict("Credito") IsNot Nothing Then
					Decimal.TryParse(detalleDict("Credito").ToString(), NumberStyles.Any, CultureInfo.InvariantCulture, creditoDecimal)
				End If

				If debitoDecimal = 0D AndAlso creditoDecimal = 0D Then
					Return serializer.Serialize(New With {
						.Resultado = "ERROR",
						.Mensaje = $"Debe indicar un valor en débito o crédito en la línea {i + 1}"
					})
				End If

				If debitoDecimal <> 0D AndAlso creditoDecimal <> 0D Then
					Return serializer.Serialize(New With {
						.Resultado = "ERROR",
						.Mensaje = $"Solo puede registrar débito o crédito en la línea {i + 1}"
					})
				End If

				totalDebito += debitoDecimal
				totalCredito += creditoDecimal

				detallesProcesados.Add(New Dictionary(Of String, Object) From {
					{"Cuenta", cuenta},
					{"Debito", debitoDecimal},
					{"Credito", creditoDecimal}
				})
			Next

			If Math.Round(totalDebito, 2) <> Math.Round(totalCredito, 2) Then
				Return serializer.Serialize(New With {
					.Resultado = "ERROR",
					.Mensaje = "El asiento no está balanceado. El total de débitos debe ser igual al total de créditos."
				})
			End If

			Dim detalleJson As String = serializer.Serialize(detallesProcesados)

			Dim connectionString As String = HttpContext.Current.Session(VariablesSesion.ConnectionString)
			Dim objSql As SBSqlClientInterface = GetDbaObject(connectionString)
			objSql.Parametros.Clear()
			objSql.Parametros.Add("@Fecha", fechaFormateadaParaSp)
			objSql.Parametros.Add("@Comentario", comentario)
			objSql.Parametros.Add("@DetalleJson", detalleJson)
			objSql.Parametros.Add("@CodTipoAsiento", "ASM")
			objSql.Parametros.Add("@BaseID", 0)

			ModGlobal.EscribirLog("Ejecutando SQL: Exec spAsientos_Guardar " & objSql.getParamList())
			Dim dtResultado As DataTable = objSql.GetDataTableSql("Exec spAsientos_Guardar")

			If objSql.MensajeError <> "" Then
				ModGlobal.EscribirLog("BD ERROR: spAsientos_Guardar - " & objSql.MensajeError)
				Return serializer.Serialize(New With {
					.Resultado = "ERROR",
					.Mensaje = "Error en la base de datos: " & objSql.MensajeError
				})
			End If
			ModGlobal.EscribirLog("BD OK: spAsientos_Guardar")

			Dim asientoId As Integer = 0
			Dim nombreUsuario As String = ""
			Dim apellidoUsuario As String = ""
			
			' Obtener nombre del usuario de la sesión
			If HttpContext.Current.Session(VariablesSesion.Nombre) IsNot Nothing Then
				nombreUsuario = HttpContext.Current.Session(VariablesSesion.Nombre).ToString()
			End If
			If HttpContext.Current.Session(VariablesSesion.Apellido) IsNot Nothing Then
				apellidoUsuario = HttpContext.Current.Session(VariablesSesion.Apellido).ToString()
			End If
			Dim nombreCompletoUsuario As String = (nombreUsuario & " " & apellidoUsuario).Trim()
			If String.IsNullOrWhiteSpace(nombreCompletoUsuario) AndAlso HttpContext.Current.Session(VariablesSesion.NombreUsuario) IsNot Nothing Then
				nombreCompletoUsuario = HttpContext.Current.Session(VariablesSesion.NombreUsuario).ToString()
			End If

			If dtResultado.Rows.Count > 0 Then
				Dim resultado As String = dtResultado.Rows(0)("Resultado").ToString()
				Dim mensaje As String = dtResultado.Rows(0)("Mensaje").ToString()

				If resultado <> "SUCCESS" Then
					Return serializer.Serialize(New With {
						.Resultado = resultado,
						.Mensaje = mensaje,
						.AsientoID = 0,
						.Usuario = nombreCompletoUsuario
					})
				End If

				' Obtener el ID del asiento del resultado
				If dtResultado.Columns.Contains("AsientoID") AndAlso Not IsDBNull(dtResultado.Rows(0)("AsientoID")) Then
					Integer.TryParse(dtResultado.Rows(0)("AsientoID").ToString(), asientoId)
				End If
			End If

			ModGlobal.EscribirLog("Metodo GuardarAsiento completado exitosamente. AsientoID: " & asientoId.ToString())
			Return serializer.Serialize(New With {
				.Resultado = "SUCCESS",
				.Mensaje = "Asiento registrado correctamente",
				.AsientoID = asientoId,
				.Usuario = nombreCompletoUsuario
			})

		Catch ex As Exception
			ModGlobal.EscribirLog("Error en GuardarAsiento: " & ex.Message & " | StackTrace: " & ex.StackTrace)
			Return serializer.Serialize(New With {
				.Resultado = "ERROR",
				.Mensaje = "Error al guardar asiento: " & ex.Message
			})
		End Try
	End Function
#End Region
End Class