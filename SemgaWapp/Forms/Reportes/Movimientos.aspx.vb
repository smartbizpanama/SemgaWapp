Imports System.Web.Services
Imports System.Web.Script.Services
Imports System.Web.Script.Serialization
Imports System.Data
Imports System.Data.SqlClient
Imports System.Text.RegularExpressions
Imports System.Web
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
	Public Shared Function ListarPeriodosHistorialMovimientos() As String
		Dim serializer As New JavaScriptSerializer()
		Try
			Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
			Dim sSql As String = "Exec spMovimientos_Historial_ListarPeriodos"
			ModGlobal.EscribirLog($"Ejecutando: {sSql}")
			Dim dt As DataTable = objSql.GetDataTableSql(sSql)

			If objSql.MensajeError <> "" Then
				Return serializer.Serialize(New Dictionary(Of String, Object) From {
					{"Success", False},
					{"Message", "Error en la base de datos: " & objSql.MensajeError},
					{"Data", New List(Of Object)()}
				})
			End If

			Dim lista = DataTableToListaJson(dt, True)
			Return serializer.Serialize(New Dictionary(Of String, Object) From {
				{"Success", True},
				{"Message", ""},
				{"Data", lista}
			})
		Catch ex As Exception
			ModGlobal.EscribirLog($"Error en ListarPeriodosHistorialMovimientos: {ex.Message}")
			Return serializer.Serialize(New Dictionary(Of String, Object) From {
				{"Success", False},
				{"Message", "Error al listar periodos de historial: " & ex.Message},
				{"Data", New List(Of Object)()}
			})
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

	Private Shared Sub AgregarParametrosConsultaMovimientos(objSql As SBSqlClientInterface, idUsuario As Object, numeroAsociado As Object, fechaDesde As Object, fechaHasta As Object, codigoRubro As Object, codigoTransaccion As Object, mesHistorial As Object, anioHistorial As Object, versionHistorial As Object)
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
				Dim fechaDesdeStr As String = fechaDesde.ToString()
				If fechaDesdeStr.Length = 8 Then
					.Add("@FechaDesde", fechaDesdeStr)
					ModGlobal.EscribirLog($"Agregando filtro @FechaDesde: {fechaDesdeStr}")
				End If
			End If

			If fechaHasta IsNot Nothing AndAlso Not String.IsNullOrEmpty(fechaHasta.ToString()) Then
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

			If mesHistorial IsNot Nothing AndAlso Not String.IsNullOrEmpty(mesHistorial.ToString()) Then
				Dim mesHist As Integer
				If Integer.TryParse(mesHistorial.ToString(), mesHist) AndAlso mesHist >= 1 AndAlso mesHist <= 12 Then
					.Add("@MesHistorial", mesHist)
					ModGlobal.EscribirLog($"Agregando filtro @MesHistorial: {mesHist}")
				End If
			End If

			If anioHistorial IsNot Nothing AndAlso Not String.IsNullOrEmpty(anioHistorial.ToString()) Then
				Dim anioHist As Integer
				If Integer.TryParse(anioHistorial.ToString(), anioHist) AndAlso anioHist >= 1980 Then
					.Add("@AnioHistorial", anioHist)
					ModGlobal.EscribirLog($"Agregando filtro @AnioHistorial: {anioHist}")
				End If
			End If

			If versionHistorial IsNot Nothing AndAlso Not String.IsNullOrEmpty(versionHistorial.ToString()) Then
				Dim verHist As Integer
				If Integer.TryParse(versionHistorial.ToString(), verHist) AndAlso verHist >= 0 Then
					.Add("@VersionHistorial", verHist)
					ModGlobal.EscribirLog($"Agregando filtro @VersionHistorial: {verHist}")
				End If
			End If
		End With
	End Sub

	Private Shared Function DataTableToListaJson(dt As DataTable, Optional preservarNumericos As Boolean = False) As List(Of Dictionary(Of String, Object))
		Dim lista As New List(Of Dictionary(Of String, Object))
		If dt Is Nothing Then Return lista
		For Each row As DataRow In dt.Rows
			Dim item As New Dictionary(Of String, Object)
			For Each col As DataColumn In dt.Columns
				If row(col) Is DBNull.Value OrElse row(col) Is Nothing Then
					item(col.ColumnName) = ""
				ElseIf preservarNumericos AndAlso (col.DataType Is GetType(Decimal) OrElse col.DataType Is GetType(Double) OrElse col.DataType Is GetType(Single) OrElse col.DataType Is GetType(Integer) OrElse col.DataType Is GetType(Long)) Then
					item(col.ColumnName) = row(col)
				Else
					item(col.ColumnName) = row(col).ToString()
				End If
			Next
			lista.Add(item)
		Next
		Return lista
	End Function

	''' <summary>Ejecuta spMovimientos_ReporteCierre (detalle + resumen en un DataSet).</summary>
	Private Shared Function ConsultarMovimientosReporteCierreDataSet(idUsuario As Object, numeroAsociado As Object, fechaDesde As Object, fechaHasta As Object, codigoRubro As Object, codigoTransaccion As Object, mesHistorial As Object, anioHistorial As Object, versionHistorial As Object, ByRef mensajeErrorSql As String) As DataSet
		mensajeErrorSql = ""
		Dim ds As New DataSet()
		Try
			Dim sCnnEnc As String = HttpContext.Current.Session(VariablesSesion.ConnectionString)?.ToString()
			If String.IsNullOrEmpty(sCnnEnc) Then
				mensajeErrorSql = "Sin cadena de conexión"
				Return Nothing
			End If
			Dim uPass As New SBEncryption
			Dim sCnnStr As String = uPass.Decrypt(sCnnEnc)
			Using conn As New SqlConnection(sCnnStr)
				Using cmd As New SqlCommand("dbo.spMovimientos_ReporteCierre", conn)
					cmd.CommandType = CommandType.StoredProcedure
					AgregarParametrosConsultaMovimientosSql(cmd, idUsuario, numeroAsociado, fechaDesde, fechaHasta, codigoRubro, codigoTransaccion, mesHistorial, anioHistorial, versionHistorial)
					ModGlobal.EscribirLog("Ejecutando: Exec spMovimientos_ReporteCierre (impresión cierre)")
					Using da As New SqlDataAdapter(cmd)
						conn.Open()
						da.Fill(ds)
					End Using
				End Using
			End Using
			If ds.Tables.Count > 0 Then
				ds.Tables(0).TableName = "Detalle"
				If ds.Tables.Count > 1 Then ds.Tables(1).TableName = "Resumen"
			End If
		Catch ex As Exception
			mensajeErrorSql = ex.Message
			Return Nothing
		End Try
		Return ds
	End Function

	Private Shared Sub AgregarParametrosConsultaMovimientosSql(cmd As SqlCommand, idUsuario As Object, numeroAsociado As Object, fechaDesde As Object, fechaHasta As Object, codigoRubro As Object, codigoTransaccion As Object, mesHistorial As Object, anioHistorial As Object, versionHistorial As Object)
		cmd.Parameters.Add("@IdUsuario", SqlDbType.Int).Value = DBNull.Value
		cmd.Parameters.Add("@FechaDesde", SqlDbType.VarChar, 8).Value = DBNull.Value
		cmd.Parameters.Add("@FechaHasta", SqlDbType.VarChar, 8).Value = DBNull.Value
		cmd.Parameters.Add("@CodigoRubro", SqlDbType.NVarChar, 10).Value = DBNull.Value
		cmd.Parameters.Add("@CodigoTransaccion", SqlDbType.NVarChar, 10).Value = DBNull.Value
		cmd.Parameters.Add("@NumeroAsociado", SqlDbType.Int).Value = DBNull.Value
		cmd.Parameters.Add("@MesHistorial", SqlDbType.Int).Value = DBNull.Value
		cmd.Parameters.Add("@AnioHistorial", SqlDbType.Int).Value = DBNull.Value
		cmd.Parameters.Add("@VersionHistorial", SqlDbType.Int).Value = DBNull.Value

		If idUsuario IsNot Nothing AndAlso Not String.IsNullOrEmpty(idUsuario.ToString()) Then
			Dim usuarioId As Integer
			If Integer.TryParse(idUsuario.ToString(), usuarioId) Then cmd.Parameters("@IdUsuario").Value = usuarioId
		End If
		If numeroAsociado IsNot Nothing AndAlso Not String.IsNullOrEmpty(numeroAsociado.ToString()) Then
			Dim asociadoId As Integer
			If Integer.TryParse(numeroAsociado.ToString(), asociadoId) Then cmd.Parameters("@NumeroAsociado").Value = asociadoId
		End If
		If fechaDesde IsNot Nothing AndAlso Not String.IsNullOrEmpty(fechaDesde.ToString()) AndAlso fechaDesde.ToString().Length = 8 Then
			cmd.Parameters("@FechaDesde").Value = fechaDesde.ToString()
		End If
		If fechaHasta IsNot Nothing AndAlso Not String.IsNullOrEmpty(fechaHasta.ToString()) AndAlso fechaHasta.ToString().Length = 8 Then
			cmd.Parameters("@FechaHasta").Value = fechaHasta.ToString()
		End If
		If codigoRubro IsNot Nothing AndAlso Not String.IsNullOrEmpty(codigoRubro.ToString()) Then
			cmd.Parameters("@CodigoRubro").Value = codigoRubro.ToString()
		End If
		If codigoTransaccion IsNot Nothing AndAlso Not String.IsNullOrEmpty(codigoTransaccion.ToString()) Then
			cmd.Parameters("@CodigoTransaccion").Value = codigoTransaccion.ToString()
		End If
		If mesHistorial IsNot Nothing AndAlso Not String.IsNullOrEmpty(mesHistorial.ToString()) Then
			Dim mesHist As Integer
			If Integer.TryParse(mesHistorial.ToString(), mesHist) AndAlso mesHist >= 1 AndAlso mesHist <= 12 Then
				cmd.Parameters("@MesHistorial").Value = mesHist
			End If
		End If
		If anioHistorial IsNot Nothing AndAlso Not String.IsNullOrEmpty(anioHistorial.ToString()) Then
			Dim anioHist As Integer
			If Integer.TryParse(anioHistorial.ToString(), anioHist) AndAlso anioHist >= 1980 Then
				cmd.Parameters("@AnioHistorial").Value = anioHist
			End If
		End If
		If versionHistorial IsNot Nothing AndAlso Not String.IsNullOrEmpty(versionHistorial.ToString()) Then
			Dim verHist As Integer
			If Integer.TryParse(versionHistorial.ToString(), verHist) AndAlso verHist >= 0 Then
				cmd.Parameters("@VersionHistorial").Value = verHist
			End If
		End If
	End Sub

	Private Shared Function GenerarHtmlResumenCierre(dtResumen As DataTable) As String
		If dtResumen Is Nothing OrElse dtResumen.Rows.Count = 0 Then
			Return "<p class=""sin-datos-resumen"">Sin datos de resumen para el período.</p>"
		End If
		Dim sb As New System.Text.StringBuilder()
		sb.AppendLine("<div class=""grupo-resumen-cierre"">")
		sb.AppendLine("  <div class=""grupo-resumen-cierre-header"">Resumen de cierre</div>")
		sb.AppendLine("  <table class=""tabla-datos tabla-resumen-cierre"">")
		sb.AppendLine("    <thead><tr>")
		sb.AppendLine("      <th>Rubro / Tipo auxiliar</th>")
		sb.AppendLine("      <th class=""col-num"">Mov.</th>")
		sb.AppendLine("      <th class=""col-monto"">DR</th>")
		sb.AppendLine("      <th class=""col-monto"">CR</th>")
		sb.AppendLine("      <th class=""col-monto"">Balance</th>")
		sb.AppendLine("    </tr></thead><tbody>")
		For Each row As DataRow In dtResumen.Rows
			Dim rubro As String = MovColStr(row, "Rubro", "Código Rubro")
			Dim tipo As String = MovColStr(row, "Tipo Auxiliar")
			Dim etiqueta As String = If(String.IsNullOrEmpty(tipo), rubro, rubro & " — " & tipo)
			Dim movs As String = MovColStr(row, "Movimientos")
			Dim dr As Decimal = MovColDec(row, "Débito")
			Dim cr As Decimal = MovColDec(row, "Crédito")
			Dim bal As Decimal = MovColDec(row, "Balance")
			If bal = 0D AndAlso (dr <> 0D OrElse cr <> 0D) Then bal = dr - cr
			sb.AppendLine("    <tr>")
			sb.AppendLine($"      <td>{HttpUtility.HtmlEncode(etiqueta)}</td>")
			sb.AppendLine($"      <td class=""col-num"">{HttpUtility.HtmlEncode(movs)}</td>")
			sb.AppendLine($"      <td class=""monto col-monto"">{dr.ToString("$###,###,##0.00", System.Globalization.CultureInfo.InvariantCulture)}</td>")
			sb.AppendLine($"      <td class=""monto col-monto"">{cr.ToString("$###,###,##0.00", System.Globalization.CultureInfo.InvariantCulture)}</td>")
			sb.AppendLine($"      <td class=""monto col-monto"">{bal.ToString("$###,###,##0.00", System.Globalization.CultureInfo.InvariantCulture)}</td>")
			sb.AppendLine("    </tr>")
		Next
		sb.AppendLine("  </tbody></table></div>")
		Return sb.ToString()
	End Function

	''' <summary>Ejecuta spMovimientos_Reporte o spMovimientos_ReporteResumen con los filtros del reporte.</summary>
	Private Shared Function ConsultarMovimientosDataTable(nombreSp As String, idUsuario As Object, numeroAsociado As Object, fechaDesde As Object, fechaHasta As Object, codigoRubro As Object, codigoTransaccion As Object, mesHistorial As Object, anioHistorial As Object, versionHistorial As Object, ByRef mensajeErrorSql As String) As DataTable
		mensajeErrorSql = ""
		Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
		Dim sSql As String = "Exec " & nombreSp
		AgregarParametrosConsultaMovimientos(objSql, idUsuario, numeroAsociado, fechaDesde, fechaHasta, codigoRubro, codigoTransaccion, mesHistorial, anioHistorial, versionHistorial)
		ModGlobal.EscribirLog($"Ejecutando: {sSql} {objSql.getParamList()}")
		Dim dt As DataTable = objSql.GetDataTableSql(sSql)
		If objSql.MensajeError <> "" Then
			mensajeErrorSql = objSql.MensajeError
			Return Nothing
		End If
		Return dt
	End Function

	Private Shared Function TextoHtmlPlano(html As String) As String
		If String.IsNullOrEmpty(html) Then Return ""
		Dim t As String = Regex.Replace(html, "<[^>]+>", " ")
		t = HttpUtility.HtmlDecode(t)
		Return Regex.Replace(t, "\s+", " ").Trim()
	End Function

	''' <summary>Lee la primera columna existente del DataRow (compatibilidad entre SP antiguo y nuevo).</summary>
	Private Shared Function MovColStr(row As DataRow, ParamArray columnas() As String) As String
		If row Is Nothing OrElse columnas Is Nothing Then Return ""
		For Each col As String In columnas
			If row.Table.Columns.Contains(col) AndAlso Not IsDBNull(row(col)) Then
				Return row(col).ToString().Trim()
			End If
		Next
		Return ""
	End Function

	Private Shared Function MovColDec(row As DataRow, ParamArray columnas() As String) As Decimal
		Dim s As String = MovColStr(row, columnas)
		If String.IsNullOrEmpty(s) Then Return 0D
		Dim n As Decimal
		If Decimal.TryParse(s, System.Globalization.NumberStyles.Any, System.Globalization.CultureInfo.InvariantCulture, n) Then Return n
		If Decimal.TryParse(s, n) Then Return n
		Return 0D
	End Function

	<WebMethod(EnableSession:=True)>
	<ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
	Public Shared Function BuscarMovimientos(idUsuario As Object, numeroAsociado As Object, fechaDesde As Object, fechaHasta As Object, codigoRubro As Object, codigoTransaccion As Object, mesHistorial As Object, anioHistorial As Object, versionHistorial As Object) As String
		Dim serializer As New JavaScriptSerializer()
		Try
			ModGlobal.EscribirLog("BuscarMovimientos iniciado")

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

			Dim errSql As String = ""
			Dim dsCierre As DataSet = ConsultarMovimientosReporteCierreDataSet(idUsuario, numeroAsociado, fechaDesde, fechaHasta, codigoRubro, codigoTransaccion, mesHistorial, anioHistorial, versionHistorial, errSql)
			If Not String.IsNullOrEmpty(errSql) Then
				ModGlobal.EscribirLog("Error en BD al generar reporte cierre: " & errSql)
				Dim resultError As New Dictionary(Of String, Object)
				resultError("Success") = False
				resultError("Message") = "Error en la base de datos: " & errSql
				resultError("Data") = New List(Of Object)
				Return serializer.Serialize(resultError)
			End If
			Dim dt As DataTable = Nothing
			Dim dtResumen As DataTable = Nothing
			If dsCierre IsNot Nothing Then
				If dsCierre.Tables.Contains("Detalle") Then dt = dsCierre.Tables("Detalle")
				If dsCierre.Tables.Count = 0 AndAlso dsCierre.Tables(0) IsNot Nothing Then dt = dsCierre.Tables(0)
				If dsCierre.Tables.Contains("Resumen") Then dtResumen = dsCierre.Tables("Resumen")
				If dtResumen Is Nothing AndAlso dsCierre.Tables.Count > 1 Then dtResumen = dsCierre.Tables(1)
			End If
			If dt Is Nothing Then dt = New DataTable()

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
				Dim codigoRubroRow As String = MovColStr(row, "CodigoRubro", "Código Rubro")
				If String.IsNullOrEmpty(codigoRubroRow) Then codigoRubroRow = "SIN_RUBRO"
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
				Dim rubroDescripcion As String = If(movimientosRubro.Count > 0, MovColStr(movimientosRubro(0), "Rubro"), codigoRubroGrupo)
				If String.IsNullOrEmpty(rubroDescripcion) Then rubroDescripcion = codigoRubroGrupo

				' Iniciar grupo de rubro
				contenidoRubros &= $"<div class=""grupo-rubro"">" & vbCrLf
				contenidoRubros &= $"    <div class=""grupo-rubro-header"">{rubroDescripcion}</div>" & vbCrLf
				contenidoRubros &= $"    <table class=""tabla-datos"">" & vbCrLf
				contenidoRubros &= $"        <thead>" & vbCrLf
				contenidoRubros &= $"            <tr>" & vbCrLf
				contenidoRubros &= $"                <th class=""col-no"">No.</th>" & vbCrLf
				contenidoRubros &= $"                <th class=""col-fecha"">Fecha</th>" & vbCrLf
				contenidoRubros &= $"                <th class=""col-asociado"">Asociado</th>" & vbCrLf
				contenidoRubros &= $"                <th class=""col-codigo-tran"">CODIGO/TRAN</th>" & vbCrLf
				contenidoRubros &= $"                <th class=""col-rubro"">Rubro</th>" & vbCrLf
				contenidoRubros &= $"                <th class=""col-cuenta"">Cuenta</th>" & vbCrLf
				contenidoRubros &= $"                <th class=""col-tipo"">tipo</th>" & vbCrLf
				contenidoRubros &= $"                <th class=""col-dr"">DR</th>" & vbCrLf
				contenidoRubros &= $"                <th class=""col-cr"">CR</th>" & vbCrLf
				contenidoRubros &= $"            </tr>" & vbCrLf
				contenidoRubros &= $"        </thead>" & vbCrLf
				contenidoRubros &= $"        <tbody>" & vbCrLf

				Dim totalRubroDR As Decimal = 0
				Dim totalRubroCR As Decimal = 0

				For Each row As DataRow In movimientosRubro
					Dim noRegistro As String = MovColStr(row, "NoRegistro", "ID Movimiento")
					Dim fTranHora As String = MovColStr(row, "FTranHora", "Fecha del Movimiento")
					If String.IsNullOrEmpty(fTranHora) Then
						fTranHora = Trim(MovColStr(row, "Fecha del Movimiento") & " " & MovColStr(row, "Hora del Movimiento"))
					End If
					Dim asociado As String = MovColStr(row, "Asociado", "Nombre Completo")
					Dim codTrans As String = MovColStr(row, "CodigoTransaccion", "Código Transacción")
					Dim descTrans As String = MovColStr(row, "CodigoTran", "Transacción")
					Dim codigoTran As String = descTrans
					If Not String.IsNullOrEmpty(codTrans) AndAlso Not String.IsNullOrEmpty(descTrans) AndAlso codTrans <> descTrans Then
						codigoTran = codTrans & " — " & descTrans
					ElseIf Not String.IsNullOrEmpty(codTrans) Then
						codigoTran = codTrans
					End If
					Dim rubroFila As String = MovColStr(row, "Rubro", "Auxiliar")
					Dim cuenta As String = MovColStr(row, "Cuenta")
					Dim tipo As String = MovColStr(row, "Tipo", "Tipo Auxiliar")
					Dim montoDR As Decimal = MovColDec(row, "MontoDR")
					Dim montoCR As Decimal = MovColDec(row, "MontoCR")
					If montoDR = 0D AndAlso montoCR = 0D Then
						Dim montoUnico As Decimal = MovColDec(row, "Monto")
						If montoUnico <> 0D Then montoDR = montoUnico
					End If

					totalRubroDR += montoDR
					totalRubroCR += montoCR

					Dim drFormateado As String = montoDR.ToString("$###,###,##0.00", System.Globalization.CultureInfo.InvariantCulture)
					Dim crFormateado As String = montoCR.ToString("$###,###,##0.00", System.Globalization.CultureInfo.InvariantCulture)

					contenidoRubros &= $"            <tr>" & vbCrLf
					contenidoRubros &= $"                <td class=""col-no"">{noRegistro}</td>" & vbCrLf
					contenidoRubros &= $"                <td class=""col-fecha"">{fTranHora}</td>" & vbCrLf
					contenidoRubros &= $"                <td class=""col-asociado"">{asociado}</td>" & vbCrLf
					contenidoRubros &= $"                <td class=""col-codigo-tran"">{codigoTran}</td>" & vbCrLf
					contenidoRubros &= $"                <td class=""col-rubro"">{rubroFila}</td>" & vbCrLf
					contenidoRubros &= $"                <td class=""col-cuenta"">{cuenta}</td>" & vbCrLf
					contenidoRubros &= $"                <td class=""col-tipo"">{tipo}</td>" & vbCrLf
					contenidoRubros &= $"                <td class=""monto col-dr"">{drFormateado}</td>" & vbCrLf
					contenidoRubros &= $"                <td class=""monto col-cr"">{crFormateado}</td>" & vbCrLf
					contenidoRubros &= $"            </tr>" & vbCrLf
				Next

				contenidoRubros &= $"        </tbody>" & vbCrLf
				contenidoRubros &= $"    </table>" & vbCrLf

				' Total del rubro
				Dim totalRubroBalance As Decimal = totalRubroDR - totalRubroCR
				Dim totalRubroDRFormateado As String = totalRubroDR.ToString("$###,###,##0.00", System.Globalization.CultureInfo.InvariantCulture)
				Dim totalRubroCRFormateado As String = totalRubroCR.ToString("$###,###,##0.00", System.Globalization.CultureInfo.InvariantCulture)
				Dim totalRubroBalanceFormateado As String = totalRubroBalance.ToString("$###,###,##0.00", System.Globalization.CultureInfo.InvariantCulture)
				contenidoRubros &= $"    <div class=""grupo-rubro-total"">" & vbCrLf
				contenidoRubros &= $"        <span class=""total-label"">TOTAL {rubroDescripcion.ToUpper()}:</span>" & vbCrLf
				contenidoRubros &= $"        <span class=""total-registros"">{movimientosRubro.Count} registros</span>" & vbCrLf
				contenidoRubros &= $"        <span class=""totales-badges"">" & vbCrLf
				contenidoRubros &= $"            <span class=""badge-total badge-total-dr""><span class=""badge-nombre"">DR</span> {totalRubroDRFormateado}</span>" & vbCrLf
				contenidoRubros &= $"            <span class=""badge-total badge-total-cr""><span class=""badge-nombre"">CR</span> {totalRubroCRFormateado}</span>" & vbCrLf
				Dim claseBalRubro As String = If(totalRubroBalance < 0, "badge-total-bal-neg", "badge-total-bal-pos")
				contenidoRubros &= $"            <span class=""badge-total {claseBalRubro}""><span class=""badge-nombre"">BAL</span> {totalRubroBalanceFormateado}</span>" & vbCrLf
				contenidoRubros &= $"        </span>" & vbCrLf
				contenidoRubros &= $"    </div>" & vbCrLf
				contenidoRubros &= $"</div>" & vbCrLf

				totalGeneralDR += totalRubroDR
				totalGeneralCR += totalRubroCR
				totalGeneralRegistros += movimientosRubro.Count
			Next

			' Total general
			Dim totalGeneralBalance As Decimal = totalGeneralDR - totalGeneralCR
			Dim totalGeneralDRFormateado As String = totalGeneralDR.ToString("$###,###,##0.00", System.Globalization.CultureInfo.InvariantCulture)
			Dim totalGeneralCRFormateado As String = totalGeneralCR.ToString("$###,###,##0.00", System.Globalization.CultureInfo.InvariantCulture)
			Dim totalGeneralBalanceFormateado As String = totalGeneralBalance.ToString("$###,###,##0.00", System.Globalization.CultureInfo.InvariantCulture)
			contenidoRubros &= $"<div class=""total-general"">" & vbCrLf
			contenidoRubros &= $"    <span class=""total-label"">TOTAL GENERAL:</span>" & vbCrLf
			contenidoRubros &= $"    <span class=""total-registros"">{totalGeneralRegistros} registros</span>" & vbCrLf
			contenidoRubros &= $"    <span class=""totales-badges"">" & vbCrLf
			contenidoRubros &= $"        <span class=""badge-total badge-total-dr""><span class=""badge-nombre"">DR</span> {totalGeneralDRFormateado}</span>" & vbCrLf
			contenidoRubros &= $"        <span class=""badge-total badge-total-cr""><span class=""badge-nombre"">CR</span> {totalGeneralCRFormateado}</span>" & vbCrLf
			Dim claseBalGen As String = If(totalGeneralBalance < 0, "badge-total-bal-neg", "badge-total-bal-pos")
			contenidoRubros &= $"        <span class=""badge-total {claseBalGen}""><span class=""badge-nombre"">BAL</span> {totalGeneralBalanceFormateado}</span>" & vbCrLf
			contenidoRubros &= $"    </span>" & vbCrLf
			contenidoRubros &= $"</div>" & vbCrLf

			Dim contenidoResumen As String = GenerarHtmlResumenCierre(dtResumen)
			htmlTemplate = htmlTemplate.Replace("@ContenidoResumen", contenidoResumen)
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
	Public Shared Function BuscarMovimientosTabla(idUsuario As Object, numeroAsociado As Object, fechaDesde As Object, fechaHasta As Object, codigoRubro As Object, codigoTransaccion As Object, mesHistorial As Object, anioHistorial As Object, versionHistorial As Object) As String
		Dim serializer As New JavaScriptSerializer()
		Try
			If fechaDesde Is Nothing OrElse String.IsNullOrEmpty(fechaDesde.ToString()) Then
				Return serializer.Serialize(New Dictionary(Of String, Object) From {
					{"Success", False},
					{"Message", "La fecha desde es obligatoria"},
					{"Data", New List(Of Object)()}
				})
			End If

			If fechaHasta Is Nothing OrElse String.IsNullOrEmpty(fechaHasta.ToString()) Then
				Return serializer.Serialize(New Dictionary(Of String, Object) From {
					{"Success", False},
					{"Message", "La fecha hasta es obligatoria"},
					{"Data", New List(Of Object)()}
				})
			End If

			Dim errSql As String = ""
			Dim dt As DataTable = ConsultarMovimientosDataTable("spMovimientos_Reporte", idUsuario, numeroAsociado, fechaDesde, fechaHasta, codigoRubro, codigoTransaccion, mesHistorial, anioHistorial, versionHistorial, errSql)
			If Not String.IsNullOrEmpty(errSql) Then
				Return serializer.Serialize(New Dictionary(Of String, Object) From {
					{"Success", False},
					{"Message", "Error en la base de datos: " & errSql},
					{"Data", New List(Of Object)()}
				})
			End If

			Dim lista = DataTableToListaJson(dt, False)
			Return serializer.Serialize(New Dictionary(Of String, Object) From {
				{"Success", True},
				{"Message", ""},
				{"Data", lista}
			})

		Catch ex As Exception
			ModGlobal.EscribirLog($"Error en BuscarMovimientosTabla: {ex.Message} | StackTrace: {ex.StackTrace}")
			Return serializer.Serialize(New Dictionary(Of String, Object) From {
				{"Success", False},
				{"Message", "Error al buscar movimientos: " & ex.Message},
				{"Data", New List(Of Object)()}
			})
		End Try
	End Function

	<WebMethod(EnableSession:=True)>
	<ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
	Public Shared Function ListarMovimientosResumen(idUsuario As Object, numeroAsociado As Object, fechaDesde As Object, fechaHasta As Object, codigoRubro As Object, codigoTransaccion As Object, mesHistorial As Object, anioHistorial As Object, versionHistorial As Object) As String
		Dim serializer As New JavaScriptSerializer()
		Try
			If fechaDesde Is Nothing OrElse String.IsNullOrEmpty(fechaDesde.ToString()) Then
				Return serializer.Serialize(New Dictionary(Of String, Object) From {
					{"Success", False},
					{"Message", "La fecha desde es obligatoria"},
					{"Data", New List(Of Object)()}
				})
			End If
			If fechaHasta Is Nothing OrElse String.IsNullOrEmpty(fechaHasta.ToString()) Then
				Return serializer.Serialize(New Dictionary(Of String, Object) From {
					{"Success", False},
					{"Message", "La fecha hasta es obligatoria"},
					{"Data", New List(Of Object)()}
				})
			End If

			Dim errSql As String = ""
			Dim dt As DataTable = ConsultarMovimientosDataTable("spMovimientos_ReporteResumen", idUsuario, numeroAsociado, fechaDesde, fechaHasta, codigoRubro, codigoTransaccion, mesHistorial, anioHistorial, versionHistorial, errSql)
			If Not String.IsNullOrEmpty(errSql) Then
				Return serializer.Serialize(New Dictionary(Of String, Object) From {
					{"Success", False},
					{"Message", "Error en la base de datos: " & errSql},
					{"Data", New List(Of Object)()}
				})
			End If

			Dim lista = DataTableToListaJson(dt, True)
			Return serializer.Serialize(New Dictionary(Of String, Object) From {
				{"Success", True},
				{"Message", ""},
				{"Data", lista}
			})
		Catch ex As Exception
			ModGlobal.EscribirLog($"Error en ListarMovimientosResumen: {ex.Message} | StackTrace: {ex.StackTrace}")
			Return serializer.Serialize(New Dictionary(Of String, Object) From {
				{"Success", False},
				{"Message", "Error al listar resumen: " & ex.Message},
				{"Data", New List(Of Object)()}
			})
		End Try
	End Function

	<WebMethod(EnableSession:=True)>
	<ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
	Public Shared Function ExportarMovimientosExcel(datosResumen As Object(), datosDetalle As Object(), columnasDetalle As String(), idUsuario As Object, numeroAsociado As Object, fechaDesde As String, fechaHasta As String, codigoRubro As Object, codigoTransaccion As Object, mesHistorial As Object, anioHistorial As Object, versionHistorial As Object, etiquetaUsuario As String, etiquetaAsociado As String, etiquetaRubro As String, etiquetaTransaccion As String) As String
		Dim serializer As New JavaScriptSerializer()
		Try
			Dim dr As Object() = If(datosResumen IsNot Nothing, datosResumen, New Object() {})
			Dim dd As Object() = If(datosDetalle IsNot Nothing, datosDetalle, New Object() {})
			ModGlobal.EscribirLog("ExportarMovimientosExcel - Resumen: " & dr.Length.ToString() & ", Detallado: " & dd.Length.ToString())

			If dr.Length = 0 AndAlso dd.Length = 0 Then
				Dim errVacio As New Dictionary(Of String, Object)
				errVacio("Resultado") = "ERROR"
				errVacio("Mensaje") = "No hay datos para exportar"
				errVacio("NombreArchivo") = ""
				Return serializer.Serialize(errVacio)
			End If

			Dim colsResumen As String() = {"Rubro / Tipo", "Registros", "DR", "CR", "Balance"}
			Dim colsDetalle As String() = If(columnasDetalle IsNot Nothing AndAlso columnasDetalle.Length > 0,
				columnasDetalle, ObtenerColumnasDetalleMovDesdeDatos(dd))

			Dim nombreArchivo As String = "Movimientos_" & DateTime.Now.ToString("yyyyMMdd_HHmmss") & ".xlsx"
			Dim lineaGen As String = "Generado el: " & DateTime.Now.ToString("dd/MM/yyyy HH:mm:ss")
			Dim lineaFiltros As String = ConstruirLineaFiltrosMovimientosExcel(
				idUsuario, numeroAsociado, fechaDesde, fechaHasta, codigoRubro, codigoTransaccion,
				mesHistorial, anioHistorial, versionHistorial,
				etiquetaUsuario, etiquetaAsociado, etiquetaRubro, etiquetaTransaccion)

			Using workbook As New ClosedXML.Excel.XLWorkbook()
				Dim wsResumen = workbook.Worksheets.Add("Resumen")
				EscribirHojaResumenMovimientosExcel(wsResumen, "Reporte de Movimientos — Resumen", lineaGen, lineaFiltros, dr, colsResumen)
				wsResumen.Columns().AdjustToContents()

				Dim wsDetallado = workbook.Worksheets.Add("Detallado")
				EscribirHojaDetalleMovimientosExcel(wsDetallado, "Reporte de Movimientos — Detallado", lineaGen, lineaFiltros, dd, colsDetalle)
				wsDetallado.Columns().AdjustToContents()

				Dim directorioTemp As String = HttpContext.Current.Server.MapPath("~/Temp/")
				If Not System.IO.Directory.Exists(directorioTemp) Then
					System.IO.Directory.CreateDirectory(directorioTemp)
				End If
				workbook.SaveAs(System.IO.Path.Combine(directorioTemp, nombreArchivo))
			End Using

			ModGlobal.EscribirLog("Excel movimientos guardado: " & nombreArchivo)
			Dim ok As New Dictionary(Of String, Object)
			ok("Resultado") = "SUCCESS"
			ok("Mensaje") = "Archivo Excel generado exitosamente"
			ok("NombreArchivo") = nombreArchivo
			Return serializer.Serialize(ok)
		Catch ex As Exception
			ModGlobal.EscribirLog($"Error en ExportarMovimientosExcel: {ex.Message} | StackTrace: {ex.StackTrace}")
			Dim err As New Dictionary(Of String, Object)
			err("Resultado") = "ERROR"
			err("Mensaje") = "Error al generar Excel: " & ex.Message
			err("NombreArchivo") = ""
			Return serializer.Serialize(err)
		End Try
	End Function

	Private Shared Function ObtenerColumnasDetalleMovDesdeDatos(datos As Object()) As String()
		Dim cols As New List(Of String)
		If datos Is Nothing OrElse datos.Length = 0 Then Return cols.ToArray()
		Dim idict As IDictionary = TryCast(datos(0), IDictionary)
		If idict Is Nothing Then Return cols.ToArray()
		For Each key As Object In idict.Keys
			Dim nombre As String = key.ToString()
			If Not String.Equals(nombre, "EsFilaRubro", StringComparison.OrdinalIgnoreCase) Then
				cols.Add(nombre)
			End If
		Next
		Return cols.ToArray()
	End Function

	Private Shared ReadOnly NombresMesesHistorialMovimientos As String() = {
		"Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio",
		"Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"
	}

	Private Shared Function FormatearFechaParametroYyyymmddMov(fecha As String) As String
		If String.IsNullOrWhiteSpace(fecha) OrElse fecha.Length <> 8 Then Return ""
		Return fecha.Substring(6, 2) & "/" & fecha.Substring(4, 2) & "/" & fecha.Substring(0, 4)
	End Function

	Private Shared Function ValorFiltroTextoMov(etiqueta As String, valorCodigo As Object) As String
		If Not String.IsNullOrWhiteSpace(etiqueta) Then Return etiqueta.Trim()
		If valorCodigo Is Nothing Then Return ""
		Dim s As String = valorCodigo.ToString().Trim()
		Return s
	End Function

	Private Shared Function ConstruirLineaFiltrosMovimientosExcel(
		idUsuario As Object, numeroAsociado As Object, fechaDesde As String, fechaHasta As String,
		codigoRubro As Object, codigoTransaccion As Object,
		mesHistorial As Object, anioHistorial As Object, versionHistorial As Object,
		etiquetaUsuario As String, etiquetaAsociado As String, etiquetaRubro As String, etiquetaTransaccion As String) As String

		Dim partes As New List(Of String)

		Dim txtUsuario As String = ValorFiltroTextoMov(etiquetaUsuario, idUsuario)
		If Not String.IsNullOrWhiteSpace(txtUsuario) AndAlso
		   Not String.Equals(txtUsuario, "Todos los usuarios", StringComparison.OrdinalIgnoreCase) Then
			partes.Add("Usuario: " & txtUsuario)
		End If

		Dim txtAsociado As String = ValorFiltroTextoMov(etiquetaAsociado, numeroAsociado)
		If Not String.IsNullOrWhiteSpace(txtAsociado) Then
			partes.Add("Asociado: " & txtAsociado)
		End If

		If Not String.IsNullOrWhiteSpace(fechaDesde) AndAlso fechaDesde.Trim().Length = 8 Then
			partes.Add("Fecha desde: " & FormatearFechaParametroYyyymmddMov(fechaDesde.Trim()))
		End If

		If Not String.IsNullOrWhiteSpace(fechaHasta) AndAlso fechaHasta.Trim().Length = 8 Then
			partes.Add("Fecha hasta: " & FormatearFechaParametroYyyymmddMov(fechaHasta.Trim()))
		End If

		Dim txtRubro As String = ValorFiltroTextoMov(etiquetaRubro, codigoRubro)
		If Not String.IsNullOrWhiteSpace(txtRubro) AndAlso
		   Not String.Equals(txtRubro, "Todos", StringComparison.OrdinalIgnoreCase) Then
			partes.Add("Rubro: " & txtRubro)
		End If

		Dim txtTrans As String = ValorFiltroTextoMov(etiquetaTransaccion, codigoTransaccion)
		If Not String.IsNullOrWhiteSpace(txtTrans) AndAlso
		   Not String.Equals(txtTrans, "Todos", StringComparison.OrdinalIgnoreCase) Then
			partes.Add("Tipo transacción: " & txtTrans)
		End If

		If mesHistorial IsNot Nothing AndAlso anioHistorial IsNot Nothing AndAlso versionHistorial IsNot Nothing Then
			Dim mesHist As Integer
			Dim anioHist As Integer
			Dim verHist As Integer
			If Integer.TryParse(mesHistorial.ToString(), mesHist) AndAlso mesHist >= 1 AndAlso mesHist <= 12 AndAlso
			   Integer.TryParse(anioHistorial.ToString(), anioHist) AndAlso anioHist >= 1980 AndAlso
			   Integer.TryParse(versionHistorial.ToString(), verHist) AndAlso verHist >= 0 Then
				Dim nombreMes As String = NombresMesesHistorialMovimientos(mesHist - 1)
				partes.Add("Período historial: " & nombreMes & " " & anioHist.ToString() & " v" & verHist.ToString())
			End If
		End If

		If partes.Count = 0 Then Return ""
		Return "Filtros aplicados: " & String.Join(" — ", partes)
	End Function

	Private Shared Sub EscribirLineaFiltrosMovExcel(ws As ClosedXML.Excel.IXLWorksheet, lineaFiltros As String, mergeSpan As Integer)
		ws.Cell(3, 1).Value = lineaFiltros
		ws.Cell(3, 1).Style.Font.Italic = True
		ws.Cell(3, 1).Style.Font.FontSize = 11
		ws.Range(3, 1, 3, mergeSpan).Merge()
	End Sub

	Private Shared Sub AplicarEstiloEncabezadoTablaMovExcel(celda As ClosedXML.Excel.IXLCell)
		celda.Style.Font.Bold = True
		celda.Style.Font.FontColor = ClosedXML.Excel.XLColor.White
		celda.Style.Fill.BackgroundColor = ClosedXML.Excel.XLColor.FromHtml("#1A3A5C")
	End Sub

	Private Shared Function EsFilaRubroMovExcel(idict As IDictionary) As Boolean
		If idict Is Nothing OrElse Not idict.Contains("EsFilaRubro") Then Return False
		Dim v = idict("EsFilaRubro")
		If TypeOf v Is Boolean Then Return CBool(v)
		Return String.Equals(If(v, "").ToString(), "true", StringComparison.OrdinalIgnoreCase)
	End Function

	Private Shared Sub EscribirHojaResumenMovimientosExcel(ws As ClosedXML.Excel.IXLWorksheet, titulo As String, lineaGenerado As String, lineaFiltros As String, datos As Object(), columnas As String())
		Dim numCols As Integer = columnas.Length
		Dim mergeSpan As Integer = Math.Max(numCols, 1)
		Dim colorRubro As ClosedXML.Excel.XLColor = ClosedXML.Excel.XLColor.FromHtml("#E3F2FD")

		ws.Cell(1, 1).Value = titulo
		ws.Cell(1, 1).Style.Font.Bold = True
		ws.Cell(1, 1).Style.Font.FontSize = 14
		ws.Range(1, 1, 1, mergeSpan).Merge()

		ws.Cell(2, 1).Value = lineaGenerado
		ws.Cell(2, 1).Style.Font.Italic = True
		ws.Range(2, 1, 2, mergeSpan).Merge()

		Dim filaInicio As Integer = 4
		If Not String.IsNullOrWhiteSpace(lineaFiltros) Then
			EscribirLineaFiltrosMovExcel(ws, lineaFiltros, mergeSpan)
			filaInicio = 5
		End If

		For i As Integer = 0 To numCols - 1
			ws.Cell(filaInicio, i + 1).Value = columnas(i)
			AplicarEstiloEncabezadoTablaMovExcel(ws.Cell(filaInicio, i + 1))
		Next

		Dim tieneFilas As Boolean = datos IsNot Nothing AndAlso datos.Length > 0
		Dim ultFila As Integer = filaInicio

		If tieneFilas Then
			For r As Integer = 0 To datos.Length - 1
				Dim filaExcel As Integer = filaInicio + 1 + r
				Dim idict As IDictionary = TryCast(datos(r), IDictionary)
				For c As Integer = 0 To numCols - 1
					Dim val As String = ""
					If idict IsNot Nothing AndAlso idict.Contains(columnas(c)) AndAlso idict(columnas(c)) IsNot Nothing Then
						val = idict(columnas(c)).ToString()
					End If
					ws.Cell(filaExcel, c + 1).Value = val
				Next
				If EsFilaRubroMovExcel(idict) Then
					Dim rngRubro = ws.Range(filaExcel, 1, filaExcel, numCols)
					rngRubro.Style.Font.Bold = True
					rngRubro.Style.Fill.BackgroundColor = colorRubro
				End If
			Next
			ultFila = filaInicio + datos.Length
		Else
			ws.Cell(filaInicio + 1, 1).Value = "Sin registros"
			ws.Range(filaInicio + 1, 1, filaInicio + 1, mergeSpan).Merge()
			ultFila = filaInicio + 1
		End If

		If tieneFilas Then
			ws.Range(filaInicio, 1, ultFila, numCols).Style.Border.OutsideBorder = ClosedXML.Excel.XLBorderStyleValues.Thin
			ws.Range(filaInicio, 1, ultFila, numCols).Style.Border.InsideBorder = ClosedXML.Excel.XLBorderStyleValues.Thin
		Else
			ws.Range(filaInicio, 1, ultFila, mergeSpan).Style.Border.OutsideBorder = ClosedXML.Excel.XLBorderStyleValues.Thin
		End If
	End Sub

	Private Shared Sub EscribirHojaDetalleMovimientosExcel(ws As ClosedXML.Excel.IXLWorksheet, titulo As String, lineaGenerado As String, lineaFiltros As String, datos As Object(), columnas As String())
		Dim numCols As Integer = Math.Max(columnas.Length, 1)
		Dim mergeSpan As Integer = numCols

		ws.Cell(1, 1).Value = titulo
		ws.Cell(1, 1).Style.Font.Bold = True
		ws.Cell(1, 1).Style.Font.FontSize = 14
		ws.Range(1, 1, 1, mergeSpan).Merge()

		ws.Cell(2, 1).Value = lineaGenerado
		ws.Cell(2, 1).Style.Font.Italic = True
		ws.Range(2, 1, 2, mergeSpan).Merge()

		Dim filaInicio As Integer = 4
		If Not String.IsNullOrWhiteSpace(lineaFiltros) Then
			EscribirLineaFiltrosMovExcel(ws, lineaFiltros, mergeSpan)
			filaInicio = 5
		End If

		If columnas.Length > 0 Then
			For i As Integer = 0 To columnas.Length - 1
				ws.Cell(filaInicio, i + 1).Value = columnas(i)
				AplicarEstiloEncabezadoTablaMovExcel(ws.Cell(filaInicio, i + 1))
			Next
		End If

		Dim tieneFilas As Boolean = datos IsNot Nothing AndAlso datos.Length > 0
		Dim ultFila As Integer = filaInicio

		If tieneFilas AndAlso columnas.Length > 0 Then
			For r As Integer = 0 To datos.Length - 1
				Dim idict As IDictionary = TryCast(datos(r), IDictionary)
				For c As Integer = 0 To columnas.Length - 1
					Dim val As String = ""
					If idict IsNot Nothing AndAlso idict.Contains(columnas(c)) AndAlso idict(columnas(c)) IsNot Nothing Then
						val = idict(columnas(c)).ToString()
					End If
					ws.Cell(filaInicio + 1 + r, c + 1).Value = val
				Next
			Next
			ultFila = filaInicio + datos.Length
		Else
			ws.Cell(filaInicio + 1, 1).Value = "Sin registros"
			ws.Range(filaInicio + 1, 1, filaInicio + 1, mergeSpan).Merge()
			ultFila = filaInicio + 1
		End If

		If tieneFilas AndAlso columnas.Length > 0 Then
			ws.Range(filaInicio, 1, ultFila, numCols).Style.Border.OutsideBorder = ClosedXML.Excel.XLBorderStyleValues.Thin
			ws.Range(filaInicio, 1, ultFila, numCols).Style.Border.InsideBorder = ClosedXML.Excel.XLBorderStyleValues.Thin
		Else
			ws.Range(filaInicio, 1, ultFila, mergeSpan).Style.Border.OutsideBorder = ClosedXML.Excel.XLBorderStyleValues.Thin
		End If
	End Sub

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
