Imports System.Web.Services
Imports System.Web.Script.Services
Imports System.Web.Script.Serialization
Imports System.Data
Imports SBSqlClient
Imports SBUtility

Public Class Movimientos
	Inherits BasePage

	Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
		' Verificar sesión
		If Session(VariablesSesion.UsuarioId) Is Nothing Then
			Response.Redirect("~/Login.aspx")
			Return
		End If
		If ModGlobal.ValidarYRedirigirSiSinPermiso(HttpContext.Current) Then Return

		' Manejar descarga de archivos
		If Request.QueryString("action") = "download" AndAlso Not String.IsNullOrEmpty(Request.QueryString("file")) Then
			DescargarArchivo(Request.QueryString("file"))
		End If
	End Sub

	<WebMethod(EnableSession:=True)>
	<ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
	Public Shared Function ObtenerUsuarios() As String
		Dim serializer As New JavaScriptSerializer()
		Try
			ModGlobal.EscribirLog("ObtenerUsuarios iniciado")

			Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
			Dim sSql As String = "Exec spUsuarios_Listar"

			ModGlobal.EscribirLog($"Ejecutando: {sSql} {objSql.getParamList()}")
			Dim dt As DataTable = objSql.GetDataTableSql(sSql)

			' Verificar si hubo error en la base de datos
			If objSql.MensajeError <> "" Then
				ModGlobal.EscribirLog("Error en BD al obtener usuarios: " & objSql.MensajeError)
				Dim resultError As New Dictionary(Of String, Object)
				resultError("Success") = False
				resultError("Message") = "Error en la base de datos: " & objSql.MensajeError
				resultError("Data") = New List(Of Object)
				Return serializer.Serialize(resultError)
			End If

			' Crear lista de objetos
			Dim usuarios As New List(Of Object)

			For Each row As DataRow In dt.Rows
				Dim usuario As New Dictionary(Of String, Object)
				usuario("Id") = If(row("Id") IsNot DBNull.Value, Convert.ToInt32(row("Id")), 0)
				usuario("Usuario") = If(row("Usuario") IsNot DBNull.Value, row("Usuario").ToString(), "")
				usuarios.Add(usuario)
			Next

			ModGlobal.EscribirLog($"Usuarios obtenidos: {usuarios.Count}")

			Dim resultSuccess As New Dictionary(Of String, Object)
			resultSuccess("Success") = True
			resultSuccess("Message") = ""
			resultSuccess("Data") = usuarios
			Return serializer.Serialize(resultSuccess)

		Catch ex As Exception
			ModGlobal.EscribirLog($"Error en ObtenerUsuarios: {ex.Message} | StackTrace: {ex.StackTrace}")
			Dim resultError As New Dictionary(Of String, Object)
			resultError("Success") = False
			resultError("Message") = "Error al obtener usuarios: " & ex.Message
			resultError("Data") = New List(Of Object)
			Return serializer.Serialize(resultError)
		End Try
	End Function

	<WebMethod(EnableSession:=True)>
	<ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
	Public Shared Function ObtenerRubros() As String
		Dim serializer As New JavaScriptSerializer()
		Try
			ModGlobal.EscribirLog("ObtenerRubros iniciado")

			Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
			Dim sSql As String = "Exec spRubros_Listar"

			ModGlobal.EscribirLog($"Ejecutando: {sSql} {objSql.getParamList()}")
			Dim dt As DataTable = objSql.GetDataTableSql(sSql)

			' Verificar si hubo error en la base de datos
			If objSql.MensajeError <> "" Then
				ModGlobal.EscribirLog("Error en BD al obtener rubros: " & objSql.MensajeError)
				Dim resultError As New Dictionary(Of String, Object)
				resultError("Success") = False
				resultError("Message") = "Error en la base de datos: " & objSql.MensajeError
				resultError("Data") = New List(Of Object)
				Return serializer.Serialize(resultError)
			End If

			' Crear lista de objetos
			Dim rubros As New List(Of Object)

			For Each row As DataRow In dt.Rows
				Dim rubro As New Dictionary(Of String, Object)
				rubro("CodigoRubro") = If(row("CodigoRubro") IsNot DBNull.Value, row("CodigoRubro").ToString(), "")
				rubro("Descripcion") = If(row("Descripcion") IsNot DBNull.Value, row("Descripcion").ToString(), "")
				rubros.Add(rubro)
			Next

			ModGlobal.EscribirLog($"Rubros obtenidos: {rubros.Count}")

			Dim resultSuccess As New Dictionary(Of String, Object)
			resultSuccess("Success") = True
			resultSuccess("Message") = ""
			resultSuccess("Data") = rubros
			Return serializer.Serialize(resultSuccess)

		Catch ex As Exception
			ModGlobal.EscribirLog($"Error en ObtenerRubros: {ex.Message} | StackTrace: {ex.StackTrace}")
			Dim resultError As New Dictionary(Of String, Object)
			resultError("Success") = False
			resultError("Message") = "Error al obtener rubros: " & ex.Message
			resultError("Data") = New List(Of Object)
			Return serializer.Serialize(resultError)
		End Try
	End Function

	<WebMethod(EnableSession:=True)>
	<ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
	Public Shared Function BuscarAsociados(busqueda As String) As Object
		Try
			ModGlobal.EscribirLog("[Movimientos.aspx.vb] BuscarAsociados - INICIO")
			ModGlobal.EscribirLog("[Movimientos.aspx.vb] Búsqueda recibida: " & busqueda)
			ModGlobal.EscribirLog("[Movimientos.aspx.vb] HttpContext.Current es Nothing: " & (HttpContext.Current Is Nothing).ToString())
			
			If HttpContext.Current Is Nothing Then
				ModGlobal.EscribirLog("[Movimientos.aspx.vb] ERROR: HttpContext.Current es Nothing")
				Return New With {
					.Resultado = "ERROR",
					.Data = "",
					.Mensaje = "HttpContext.Current no está disponible"
				}
			End If
			
			ModGlobal.EscribirLog("[Movimientos.aspx.vb] Session es Nothing: " & (HttpContext.Current.Session Is Nothing).ToString())
			
			If HttpContext.Current.Session Is Nothing Then
				ModGlobal.EscribirLog("[Movimientos.aspx.vb] ERROR: Session es Nothing")
				Return New With {
					.Resultado = "ERROR",
					.Data = "",
					.Mensaje = "Sesión no disponible"
				}
			End If
			
			ModGlobal.EscribirLog("[Movimientos.aspx.vb] ConnectionString en Session: " & (HttpContext.Current.Session(VariablesSesion.ConnectionString) IsNot Nothing).ToString())

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

					' Crear objeto asociado (versión simplificada para reportes)
					Dim asociado As New With {
						.NumeroAsociado = row("NumeroAsociado").ToString(),
						.NombreCompleto = row("NombreCompleto").ToString(),
						.NumeroIdentificacion = row("NumeroIdentificacion").ToString(),
						.TipoAsociado = row("TipoAsociado").ToString(),
						.CodTipoDoc = row("CodTipoDoc").ToString(),
						.CantAuxiliares = If(row.Table.Columns.Contains("CantAuxiliares"), row("CantAuxiliares").ToString(), "0")
					}

					asociados.Add(asociado)
				Next
			End If

			Dim jsonData As String = New JavaScriptSerializer().Serialize(asociados)
			ModGlobal.EscribirLog("[Movimientos.aspx.vb] JSON generado (primeros 200 chars): " & jsonData.Substring(0, Math.Min(200, jsonData.Length)))
			ModGlobal.EscribirLog("[Movimientos.aspx.vb] BuscarAsociados - ÉXITO, retornando " & asociados.Count & " asociados")

			Return New With {
				.Resultado = "SUCCESS",
				.Data = jsonData,
				.Mensaje = ""
			}
		Catch ex As Exception
			ModGlobal.EscribirLog("[Movimientos.aspx.vb] ERROR en BuscarAsociados: " & ex.Message)
			ModGlobal.EscribirLog("[Movimientos.aspx.vb] StackTrace: " & ex.StackTrace)
			Return New With {
				.Resultado = "ERROR",
				.Data = "",
				.Mensaje = "Error al buscar asociados: " & ex.Message
			}
		End Try
	End Function

	<WebMethod(EnableSession:=True)>
	<ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
	Public Shared Function ObtenerCodigosTransaccion() As String
		Dim serializer As New JavaScriptSerializer()
		Try
			ModGlobal.EscribirLog("ObtenerCodigosTransaccion iniciado")

			Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
			Dim sSql As String = "Exec spCodigosTransaccion_Listar"

			ModGlobal.EscribirLog($"Ejecutando: {sSql} {objSql.getParamList()}")
			Dim dt As DataTable = objSql.GetDataTableSql(sSql)

			' Verificar si hubo error en la base de datos
			If objSql.MensajeError <> "" Then
				ModGlobal.EscribirLog("Error en BD al obtener códigos de transacción: " & objSql.MensajeError)
				Dim resultError As New Dictionary(Of String, Object)
				resultError("Success") = False
				resultError("Message") = "Error en la base de datos: " & objSql.MensajeError
				resultError("Data") = New List(Of Object)
				Return serializer.Serialize(resultError)
			End If

			' Crear lista de objetos
			Dim transacciones As New List(Of Object)

			For Each row As DataRow In dt.Rows
				Dim transaccion As New Dictionary(Of String, Object)
				transaccion("CodigoTransaccion") = If(row("CodigoTransaccion") IsNot DBNull.Value, row("CodigoTransaccion").ToString(), "")
				transaccion("Descripcion") = If(row("Descripcion") IsNot DBNull.Value, row("Descripcion").ToString(), "")
				transacciones.Add(transaccion)
			Next

			ModGlobal.EscribirLog($"Códigos de transacción obtenidos: {transacciones.Count}")

			Dim resultSuccess As New Dictionary(Of String, Object)
			resultSuccess("Success") = True
			resultSuccess("Message") = ""
			resultSuccess("Data") = transacciones
			Return serializer.Serialize(resultSuccess)

		Catch ex As Exception
			ModGlobal.EscribirLog($"Error en ObtenerCodigosTransaccion: {ex.Message} | StackTrace: {ex.StackTrace}")
			Dim resultError As New Dictionary(Of String, Object)
			resultError("Success") = False
			resultError("Message") = "Error al obtener códigos de transacción: " & ex.Message
			resultError("Data") = New List(Of Object)
			Return serializer.Serialize(resultError)
		End Try
	End Function

	<WebMethod(EnableSession:=True)>
	<ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
	Public Shared Function BuscarMovimientos(idUsuario As Object, numeroAsociado As Object, fechaDesde As Object, fechaHasta As Object, codigoRubro As Object, codigoTransaccion As Object) As String
		Dim serializer As New JavaScriptSerializer()
		Try
			ModGlobal.EscribirLog("BuscarMovimientos iniciado")

			Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
			Dim sSql As String = "Exec spMovimientos_Listar"

			' Agregar parámetros solo si tienen valor
			With objSql.Parametros
				If idUsuario IsNot Nothing AndAlso Not String.IsNullOrEmpty(idUsuario.ToString()) Then
					Dim usuarioId As Integer
					If Integer.TryParse(idUsuario.ToString(), usuarioId) Then
						.Add("@IdUsuario", usuarioId)
						ModGlobal.EscribirLog($"Agregando filtro @IdUsuario: {usuarioId}")
					End If
				End If

				If numeroAsociado IsNot Nothing AndAlso Not String.IsNullOrEmpty(numeroAsociado.ToString()) Then
					Dim asociadoId As Integer
					If Integer.TryParse(numeroAsociado.ToString(), asociadoId) Then
						.Add("@NumeroAsociado", asociadoId)
						ModGlobal.EscribirLog($"Agregando filtro @NumeroAsociado: {asociadoId}")
					End If
				End If

				If fechaDesde IsNot Nothing AndAlso Not String.IsNullOrEmpty(fechaDesde.ToString()) Then
					' Enviar fecha en formato yyyyMMdd como string
					Dim fechaDesdeStr As String = fechaDesde.ToString()
					If fechaDesdeStr.Length = 8 Then
						.Add("@FechaDesde", fechaDesdeStr)
						ModGlobal.EscribirLog($"Agregando filtro @FechaDesde: {fechaDesdeStr}")
					End If
				End If

				If fechaHasta IsNot Nothing AndAlso Not String.IsNullOrEmpty(fechaHasta.ToString()) Then
					' Enviar fecha en formato yyyyMMdd como string
					Dim fechaHastaStr As String = fechaHasta.ToString()
					If fechaHastaStr.Length = 8 Then
						.Add("@FechaHasta", fechaHastaStr)
						ModGlobal.EscribirLog($"Agregando filtro @FechaHasta: {fechaHastaStr}")
					End If
				End If

				If codigoRubro IsNot Nothing AndAlso Not String.IsNullOrEmpty(codigoRubro.ToString()) Then
					.Add("@CodigoRubro", codigoRubro.ToString())
					ModGlobal.EscribirLog($"Agregando filtro @CodigoRubro: {codigoRubro}")
				End If

				If codigoTransaccion IsNot Nothing AndAlso Not String.IsNullOrEmpty(codigoTransaccion.ToString()) Then
					.Add("@CodigoTransaccion", codigoTransaccion.ToString())
					ModGlobal.EscribirLog($"Agregando filtro @CodigoTransaccion: {codigoTransaccion}")
				End If
			End With

			ModGlobal.EscribirLog($"Ejecutando: {sSql} {objSql.getParamList()}")
			Dim dt As DataTable = objSql.GetDataTableSql(sSql)

			' Verificar si hubo error en la base de datos
			If objSql.MensajeError <> "" Then
				ModGlobal.EscribirLog("Error en BD al buscar movimientos: " & objSql.MensajeError)
				Dim resultError As New Dictionary(Of String, Object)
				resultError("Success") = False
				resultError("Message") = "Error en la base de datos: " & objSql.MensajeError
				resultError("Data") = New List(Of Object)
				Return serializer.Serialize(resultError)
			End If

			' Validar que las fechas estén presentes
			If fechaDesde Is Nothing OrElse String.IsNullOrEmpty(fechaDesde.ToString()) Then
				Dim resultError As New Dictionary(Of String, Object)
				resultError("Success") = False
				resultError("Message") = "La fecha desde es obligatoria"
				resultError("Data") = New List(Of Object)
				Return serializer.Serialize(resultError)
			End If

			If fechaHasta Is Nothing OrElse String.IsNullOrEmpty(fechaHasta.ToString()) Then
				Dim resultError As New Dictionary(Of String, Object)
				resultError("Success") = False
				resultError("Message") = "La fecha hasta es obligatoria"
				resultError("Data") = New List(Of Object)
				Return serializer.Serialize(resultError)
			End If

			' Obtener usuario actual
			Dim usuarioActual As String = ""
			If HttpContext.Current.Session(VariablesSesion.NombreUsuario) IsNot Nothing Then
				usuarioActual = HttpContext.Current.Session(VariablesSesion.NombreUsuario).ToString()
			End If

			' Leer el template HTML
			Dim templatePath As String = HttpContext.Current.Server.MapPath("~/Forms/Reportes/ReporteMovimientos.html")
			Dim htmlTemplate As String = System.IO.File.ReadAllText(templatePath)

			' Reemplazar datos del filtro
			Dim fechaDesdeFormateada As String = ""
			Dim fechaHastaFormateada As String = ""
			If fechaDesde.ToString().Length = 8 Then
				Dim año As String = fechaDesde.ToString().Substring(0, 4)
				Dim mes As String = fechaDesde.ToString().Substring(4, 2)
				Dim dia As String = fechaDesde.ToString().Substring(6, 2)
				fechaDesdeFormateada = $"{dia}/{mes}/{año}"
			End If
			If fechaHasta.ToString().Length = 8 Then
				Dim año As String = fechaHasta.ToString().Substring(0, 4)
				Dim mes As String = fechaHasta.ToString().Substring(4, 2)
				Dim dia As String = fechaHasta.ToString().Substring(6, 2)
				fechaHastaFormateada = $"{dia}/{mes}/{año}"
			End If

			htmlTemplate = htmlTemplate.Replace("@Usuario", usuarioActual)
			htmlTemplate = htmlTemplate.Replace("@FechaDesde", fechaDesdeFormateada)
			htmlTemplate = htmlTemplate.Replace("@FechaHasta", fechaHastaFormateada)

			' Agrupar movimientos por rubro
			Dim movimientosPorRubro As New Dictionary(Of String, List(Of DataRow))
			For Each row As DataRow In dt.Rows
				Dim codigoRubroRow As String = If(Not IsDBNull(row("CodigoRubro")), row("CodigoRubro").ToString(), "SIN_RUBRO")
				If Not movimientosPorRubro.ContainsKey(codigoRubroRow) Then
					movimientosPorRubro(codigoRubroRow) = New List(Of DataRow)
				End If
				movimientosPorRubro(codigoRubroRow).Add(row)
			Next

			' Generar contenido agrupado por rubro
			Dim contenidoRubros As String = ""
			Dim totalGeneralDR As Decimal = 0
			Dim totalGeneralCR As Decimal = 0
			Dim totalGeneralRegistros As Integer = 0

			For Each kvp As KeyValuePair(Of String, List(Of DataRow)) In movimientosPorRubro
				Dim codigoRubroGrupo As String = kvp.Key
				Dim movimientosRubro As List(Of DataRow) = kvp.Value
				Dim rubroDescripcion As String = If(movimientosRubro.Count > 0 AndAlso Not IsDBNull(movimientosRubro(0)("Rubro")), movimientosRubro(0)("Rubro").ToString(), codigoRubroGrupo)

				' Iniciar grupo de rubro
				contenidoRubros &= $"<div class=""grupo-rubro"">" & vbCrLf
				contenidoRubros &= $"    <div class=""grupo-rubro-header"">{rubroDescripcion}</div>" & vbCrLf
				contenidoRubros &= $"    <table class=""tabla-datos"">" & vbCrLf
				contenidoRubros &= $"        <thead>" & vbCrLf
				contenidoRubros &= $"            <tr>" & vbCrLf
				contenidoRubros &= $"                <th>No. Registro</th>" & vbCrLf
				contenidoRubros &= $"                <th>F. Tran./hora</th>" & vbCrLf
				contenidoRubros &= $"                <th>Asociado</th>" & vbCrLf
				contenidoRubros &= $"                <th>Codigo/Tran.</th>" & vbCrLf
				contenidoRubros &= $"                <th>Auxiliar</th>" & vbCrLf
				contenidoRubros &= $"                <th>Cuenta</th>" & vbCrLf
				contenidoRubros &= $"                <th>tipo</th>" & vbCrLf
				contenidoRubros &= $"                <th>Monto DR</th>" & vbCrLf
				contenidoRubros &= $"                <th>MONTO CR</th>" & vbCrLf
				contenidoRubros &= $"            </tr>" & vbCrLf
				contenidoRubros &= $"        </thead>" & vbCrLf
				contenidoRubros &= $"        <tbody>" & vbCrLf

				Dim totalRubroDR As Decimal = 0
				Dim totalRubroCR As Decimal = 0

				For Each row As DataRow In movimientosRubro
					Dim noRegistro As String = If(Not IsDBNull(row("NoRegistro")), row("NoRegistro").ToString(), "")
					Dim fTranHora As String = If(Not IsDBNull(row("FTranHora")), row("FTranHora").ToString(), "")
					Dim asociado As String = If(row.Table.Columns.Contains("Asociado") AndAlso Not IsDBNull(row("Asociado")), row("Asociado").ToString(), "")
					Dim codigoTran As String = If(Not IsDBNull(row("CodigoTran")), row("CodigoTran").ToString(), "")
					Dim auxiliar As String = If(Not IsDBNull(row("Auxiliar")), row("Auxiliar").ToString(), "")
					Dim cuenta As String = If(Not IsDBNull(row("Cuenta")), row("Cuenta").ToString(), "")
					Dim tipo As String = If(Not IsDBNull(row("Tipo")), row("Tipo").ToString(), "")
					Dim montoDR As Decimal = If(Not IsDBNull(row("MontoDR")), Convert.ToDecimal(row("MontoDR")), 0)
					Dim montoCR As Decimal = If(Not IsDBNull(row("MontoCR")), Convert.ToDecimal(row("MontoCR")), 0)

					totalRubroDR += montoDR
					totalRubroCR += montoCR

					Dim montoDRFormateado As String = montoDR.ToString("$###,###,##0.00", System.Globalization.CultureInfo.InvariantCulture)
					Dim montoCRFormateado As String = montoCR.ToString("$###,###,##0.00", System.Globalization.CultureInfo.InvariantCulture)

					contenidoRubros &= $"            <tr>" & vbCrLf
					contenidoRubros &= $"                <td>{noRegistro}</td>" & vbCrLf
					contenidoRubros &= $"                <td>{fTranHora}</td>" & vbCrLf
					contenidoRubros &= $"                <td>{asociado}</td>" & vbCrLf
					contenidoRubros &= $"                <td>{codigoTran}</td>" & vbCrLf
					contenidoRubros &= $"                <td>{auxiliar}</td>" & vbCrLf
					contenidoRubros &= $"                <td>{cuenta}</td>" & vbCrLf
					contenidoRubros &= $"                <td>{tipo}</td>" & vbCrLf
					contenidoRubros &= $"                <td class=""monto"">{montoDRFormateado}</td>" & vbCrLf
					contenidoRubros &= $"                <td class=""monto monto-cr"">{montoCRFormateado}</td>" & vbCrLf
					contenidoRubros &= $"            </tr>" & vbCrLf
				Next

				contenidoRubros &= $"        </tbody>" & vbCrLf
				contenidoRubros &= $"    </table>" & vbCrLf

				' Total del rubro
				Dim totalRubroDRFormateado As String = totalRubroDR.ToString("$###,###,##0.00", System.Globalization.CultureInfo.InvariantCulture)
				Dim totalRubroCRFormateado As String = totalRubroCR.ToString("$###,###,##0.00", System.Globalization.CultureInfo.InvariantCulture)
				contenidoRubros &= $"    <div class=""grupo-rubro-total"">" & vbCrLf
				contenidoRubros &= $"        <span class=""total-label"">TOTAL {rubroDescripcion.ToUpper()}:</span>" & vbCrLf
				contenidoRubros &= $"        <span>{movimientosRubro.Count} registros | Monto DR: {totalRubroDRFormateado} | MONTO CR: {totalRubroCRFormateado}</span>" & vbCrLf
				contenidoRubros &= $"    </div>" & vbCrLf
				contenidoRubros &= $"</div>" & vbCrLf

				totalGeneralDR += totalRubroDR
				totalGeneralCR += totalRubroCR
				totalGeneralRegistros += movimientosRubro.Count
			Next

			' Total general
			Dim totalGeneralDRFormateado As String = totalGeneralDR.ToString("$###,###,##0.00", System.Globalization.CultureInfo.InvariantCulture)
			Dim totalGeneralCRFormateado As String = totalGeneralCR.ToString("$###,###,##0.00", System.Globalization.CultureInfo.InvariantCulture)
			contenidoRubros &= $"<div class=""total-general"">" & vbCrLf
			contenidoRubros &= $"    <span class=""total-label"">TOTAL GENERAL:</span>" & vbCrLf
			contenidoRubros &= $"    <span>{totalGeneralRegistros} registros | Monto DR: {totalGeneralDRFormateado} | MONTO CR: {totalGeneralCRFormateado}</span>" & vbCrLf
			contenidoRubros &= $"</div>" & vbCrLf

			htmlTemplate = htmlTemplate.Replace("@ContenidoRubros", contenidoRubros)

			' Reemplazar fecha y hora de impresión
			Dim fechaHoraImpresion As String = DateTime.Now.ToString("dd/MM/yyyy HH:mm:ss")
			htmlTemplate = htmlTemplate.Replace("@FechaHoraImpresion", fechaHoraImpresion)

			ModGlobal.EscribirLog($"Reporte generado: {totalGeneralRegistros} movimientos en {movimientosPorRubro.Count} rubros")

			Dim resultSuccess As New Dictionary(Of String, Object)
			resultSuccess("Success") = True
			resultSuccess("Message") = ""
			resultSuccess("Html") = htmlTemplate
			Return serializer.Serialize(resultSuccess)

		Catch ex As Exception
			ModGlobal.EscribirLog($"Error en BuscarMovimientos: {ex.Message} | StackTrace: {ex.StackTrace}")
			Dim resultError As New Dictionary(Of String, Object)
			resultError("Success") = False
			resultError("Message") = "Error al buscar movimientos: " & ex.Message
			resultError("Data") = New List(Of Object)
			Return serializer.Serialize(resultError)
		End Try
	End Function

	<WebMethod(EnableSession:=True)>
	<ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
	Public Shared Function ExportarAExcel(nombreReporte As String, datos As Object()) As String
		Dim resultado As String = ""
		Dim serializer As New JavaScriptSerializer()

		Try
			ModGlobal.EscribirLog("ExportarAExcel iniciado")
			ModGlobal.EscribirLog($"Parametros recibidos - NombreReporte: {nombreReporte}, CantidadRegistros: {datos.Length}")

			' Generar nombre de archivo único
			Dim nombreArchivo As String = $"Movimientos_{DateTime.Now:yyyyMMdd_HHmmss}.xlsx"
			nombreArchivo = nombreArchivo.Replace(" ", "_").Replace("/", "_")

			' Crear workbook con ClosedXML
			Using workbook As New ClosedXML.Excel.XLWorkbook()
				Dim worksheet = workbook.Worksheets.Add("Movimientos")

				' Agregar título
				worksheet.Cell(1, 1).Value = "Reporte de Movimientos"
				worksheet.Cell(1, 1).Style.Font.Bold = True
				worksheet.Cell(1, 1).Style.Font.FontSize = 14
				worksheet.Range(1, 1, 1, 20).Merge()

				' Agregar fecha de generación
				worksheet.Cell(2, 1).Value = "Generado el: " & DateTime.Now.ToString("dd/MM/yyyy HH:mm:ss")
				worksheet.Cell(2, 1).Style.Font.Italic = True
				worksheet.Range(2, 1, 2, 20).Merge()

				' Espacio en blanco
				Dim filaInicio As Integer = 4

				If datos.Length > 0 Then
					' Obtener columnas del primer registro
					Dim columnas As New List(Of String)
					For Each key In datos(0).Keys
						columnas.Add(key)
					Next

					' Agregar encabezados
					For i As Integer = 0 To columnas.Count - 1
						worksheet.Cell(filaInicio, i + 1).Value = columnas(i)
						worksheet.Cell(filaInicio, i + 1).Style.Font.Bold = True
						worksheet.Cell(filaInicio, i + 1).Style.Fill.BackgroundColor = ClosedXML.Excel.XLColor.LightBlue
					Next

					' Agregar datos
					For i As Integer = 0 To datos.Length - 1
						Dim fila As Integer = filaInicio + 1 + i
						For j As Integer = 0 To columnas.Count - 1
							Dim valor As String = If(datos(i)(columnas(j)) IsNot Nothing, datos(i)(columnas(j)).ToString(), "")
							worksheet.Cell(fila, j + 1).Value = valor
						Next
					Next

					' Ajustar ancho de columnas
					worksheet.Columns().AdjustToContents()

					' Agregar bordes
					worksheet.Range(filaInicio, 1, filaInicio + datos.Length, columnas.Count).Style.Border.OutsideBorder = ClosedXML.Excel.XLBorderStyleValues.Thin
					worksheet.Range(filaInicio, 1, filaInicio + datos.Length, columnas.Count).Style.Border.InsideBorder = ClosedXML.Excel.XLBorderStyleValues.Thin
				End If

				' Guardar archivo temporalmente
				Dim rutaArchivo As String = HttpContext.Current.Server.MapPath("~/Temp/" & nombreArchivo)
				Dim directorioTemp As String = HttpContext.Current.Server.MapPath("~/Temp/")

				' Crear directorio si no existe
				If Not System.IO.Directory.Exists(directorioTemp) Then
					System.IO.Directory.CreateDirectory(directorioTemp)
				End If

				workbook.SaveAs(rutaArchivo)
				ModGlobal.EscribirLog("Archivo Excel guardado exitosamente: " & nombreArchivo)
			End Using

			Dim successResponse As New Dictionary(Of String, Object)
			successResponse("Resultado") = "SUCCESS"
			successResponse("Mensaje") = "Archivo Excel generado exitosamente"
			successResponse("NombreArchivo") = nombreArchivo
			resultado = serializer.Serialize(successResponse)
			ModGlobal.EscribirLog("Método ExportarAExcel completado exitosamente")

		Catch ex As Exception
			ModGlobal.EscribirLog($"Error en ExportarAExcel: {ex.Message} | StackTrace: {ex.StackTrace}")

			Dim errorResponse As New Dictionary(Of String, Object)
			errorResponse("Resultado") = "ERROR"
			errorResponse("Mensaje") = "Error al generar archivo Excel: " & ex.Message
			errorResponse("NombreArchivo") = ""
			resultado = serializer.Serialize(errorResponse)
		End Try

		Return resultado
	End Function

	Private Sub DescargarArchivo(nombreArchivo As String)
		Try
			Dim rutaArchivo As String = Server.MapPath("~/Temp/" & nombreArchivo)

			If System.IO.File.Exists(rutaArchivo) Then
				Response.Clear()
				Response.ContentType = "application/octet-stream"
				Response.AddHeader("Content-Disposition", "attachment; filename=" & nombreArchivo)
				Response.TransmitFile(rutaArchivo)
				Response.End()

				' Eliminar archivo temporal después de la descarga
				System.IO.File.Delete(rutaArchivo)
			Else
				Response.Write("Archivo no encontrado")
			End If
		Catch ex As Exception
			ModGlobal.EscribirLog("Error al descargar archivo: " & ex.Message)
			Response.Write("Error al descargar archivo")
		End Try
	End Sub

End Class
