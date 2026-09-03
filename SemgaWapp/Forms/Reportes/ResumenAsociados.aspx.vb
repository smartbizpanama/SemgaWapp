Imports System.Web.Services
Imports System.Web.Script.Services
Imports System.Web.Script.Serialization
Imports System.Data
Imports System.Text
Imports System.Web
Imports SBSqlClient
Imports SBUtility

Public Class ResumenAsociados
	Inherits BasePage

	Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
		If Session(VariablesSesion.UsuarioId) Is Nothing Then
			Response.Redirect("~/Login.aspx")
			Return
		End If
		If ModGlobal.ValidarYRedirigirSiSinPermiso(HttpContext.Current) Then Return

		If Request.QueryString("action") = "download" AndAlso Not String.IsNullOrEmpty(Request.QueryString("file")) Then
			DescargarArchivo(Request.QueryString("file"))
		End If
	End Sub

	<WebMethod(EnableSession:=True)>
	<ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
	Public Shared Function ObtenerUsuarios() As String
		Dim serializer As New JavaScriptSerializer()
		Try
			ModGlobal.EscribirLog("ResumenAsociados ObtenerUsuarios iniciado")

			Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
			Dim sSql As String = "Exec spUsuarios_Listar"

			Dim dt As DataTable = objSql.GetDataTableSql(sSql)

			If objSql.MensajeError <> "" Then
				ModGlobal.EscribirLog("Error en BD al obtener usuarios: " & objSql.MensajeError)
				Dim resultError As New Dictionary(Of String, Object)
				resultError("Success") = False
				resultError("Message") = "Error en la base de datos: " & objSql.MensajeError
				resultError("Data") = New List(Of Object)
				Return serializer.Serialize(resultError)
			End If

			Dim usuarios As New List(Of Object)
			For Each row As DataRow In dt.Rows
				Dim usuario As New Dictionary(Of String, Object)
				usuario("Id") = If(row("Id") IsNot DBNull.Value, Convert.ToInt32(row("Id")), 0)
				usuario("Usuario") = If(row("Usuario") IsNot DBNull.Value, row("Usuario").ToString(), "")
				usuarios.Add(usuario)
			Next

			Dim resultSuccess As New Dictionary(Of String, Object)
			resultSuccess("Success") = True
			resultSuccess("Message") = ""
			resultSuccess("Data") = usuarios
			Return serializer.Serialize(resultSuccess)

		Catch ex As Exception
			ModGlobal.EscribirLog($"Error en ResumenAsociados ObtenerUsuarios: {ex.Message}")
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
			ModGlobal.EscribirLog("ResumenAsociados ObtenerRubros iniciado")

			Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
			Dim sSql As String = "Exec spRubros_Listar"

			Dim dt As DataTable = objSql.GetDataTableSql(sSql)

			If objSql.MensajeError <> "" Then
				Dim resultError As New Dictionary(Of String, Object)
				resultError("Success") = False
				resultError("Message") = "Error en la base de datos: " & objSql.MensajeError
				resultError("Data") = New List(Of Object)
				Return serializer.Serialize(resultError)
			End If

			Dim rubros As New List(Of Object)
			For Each row As DataRow In dt.Rows
				Dim rubro As New Dictionary(Of String, Object)
				rubro("CodigoRubro") = If(row("CodigoRubro") IsNot DBNull.Value, row("CodigoRubro").ToString(), "")
				rubro("Descripcion") = If(row("Descripcion") IsNot DBNull.Value, row("Descripcion").ToString(), "")
				rubros.Add(rubro)
			Next

			Dim resultSuccess As New Dictionary(Of String, Object)
			resultSuccess("Success") = True
			resultSuccess("Message") = ""
			resultSuccess("Data") = rubros
			Return serializer.Serialize(resultSuccess)

		Catch ex As Exception
			ModGlobal.EscribirLog($"Error en ResumenAsociados ObtenerRubros: {ex.Message}")
			Dim resultError As New Dictionary(Of String, Object)
			resultError("Success") = False
			resultError("Message") = "Error al obtener rubros: " & ex.Message
			resultError("Data") = New List(Of Object)
			Return serializer.Serialize(resultError)
		End Try
	End Function

	<WebMethod(EnableSession:=True)>
	<ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
	Public Shared Function ObtenerTiposAuxiliares() As String
		Dim serializer As New JavaScriptSerializer()
		Try
			ModGlobal.EscribirLog("ResumenAsociados ObtenerTiposAuxiliares iniciado")

			Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
			Dim sSql As String = "Exec spTiposAuxiliares_Listar"

			Dim dt As DataTable = objSql.GetDataTableSql(sSql)

			If objSql.MensajeError <> "" Then
				Dim resultError As New Dictionary(Of String, Object)
				resultError("Success") = False
				resultError("Message") = "Error en la base de datos: " & objSql.MensajeError
				resultError("Data") = New List(Of Object)
				Return serializer.Serialize(resultError)
			End If

			Dim tipos As New List(Of Object)
			For Each row As DataRow In dt.Rows
				Dim item As New Dictionary(Of String, Object)
				item("ID") = If(row("ID") IsNot DBNull.Value, Convert.ToInt32(row("ID")), 0)
				item("Descripcion") = If(row("Descripcion") IsNot DBNull.Value, row("Descripcion").ToString(), "")
				tipos.Add(item)
			Next

			Dim resultSuccess As New Dictionary(Of String, Object)
			resultSuccess("Success") = True
			resultSuccess("Message") = ""
			resultSuccess("Data") = tipos
			Return serializer.Serialize(resultSuccess)

		Catch ex As Exception
			ModGlobal.EscribirLog($"Error en ResumenAsociados ObtenerTiposAuxiliares: {ex.Message}")
			Dim resultError As New Dictionary(Of String, Object)
			resultError("Success") = False
			resultError("Message") = "Error al obtener tipos de auxiliar: " & ex.Message
			resultError("Data") = New List(Of Object)
			Return serializer.Serialize(resultError)
		End Try
	End Function

	<WebMethod(EnableSession:=True)>
	<ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
	Public Shared Function BuscarAsociados(busqueda As String) As Object
		Try
			If HttpContext.Current Is Nothing OrElse HttpContext.Current.Session Is Nothing Then
				Return New With {.Resultado = "ERROR", .Data = "", .Mensaje = "Sesión no disponible"}
			End If

			Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))

			Dim esNumero As Boolean = False
			Dim numeroAsociado As Integer = 0
			If Integer.TryParse(busqueda, numeroAsociado) Then
				esNumero = True
			End If

			Dim sSql As String
			If esNumero Then
				sSql = "Exec spBuscarAsociadoPorID"
				With objSql.Parametros
					.Add("@NumeroAsociado", numeroAsociado)
				End With
			Else
				sSql = "Exec spBuscarAsociados"
				With objSql.Parametros
					.Add("@Busqueda", busqueda)
				End With
			End If

			Dim dt As DataTable = objSql.GetDataTableSql(sSql)

			If objSql.MensajeError <> "" Then
				Return New With {.Resultado = "ERROR", .Data = "", .Mensaje = "Error en la base de datos: " & objSql.MensajeError}
			End If

			Dim asociados As New List(Of Object)
			If dt.Rows.Count > 0 Then
				For i As Integer = 0 To dt.Rows.Count - 1
					Dim row As DataRow = dt.Rows(i)
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
			Return New With {.Resultado = "SUCCESS", .Data = jsonData, .Mensaje = ""}

		Catch ex As Exception
			ModGlobal.EscribirLog("ResumenAsociados BuscarAsociados: " & ex.Message)
			Return New With {.Resultado = "ERROR", .Data = "", .Mensaje = "Error al buscar asociados: " & ex.Message}
		End Try
	End Function

	Private Shared Function ResumenRowStr(r As DataRow, col As String) As String
		If r Is Nothing OrElse Not r.Table.Columns.Contains(col) OrElse r.IsNull(col) Then Return ""
		Return r(col).ToString().Trim()
	End Function

	Private Shared Function ResumenRowDec(r As DataRow, col As String) As Decimal
		If r Is Nothing OrElse Not r.Table.Columns.Contains(col) OrElse r.IsNull(col) Then Return 0D
		Return Convert.ToDecimal(r(col))
	End Function

	''' <summary>Ejecuta spMovimientos_ListarResumenAsociado con los mismos filtros que el reporte.</summary>
	Private Shared Function ConsultarResumenAsociadoDataTable(idUsuario As Object, numeroAsociado As Object, fechaDesde As Object, fechaHasta As Object, codigoRubro As Object, idTipoAuxiliar As Object, ByRef mensajeErrorSql As String) As DataTable
		mensajeErrorSql = ""
		Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
		Dim sSql As String = "Exec spMovimientos_ListarResumenAsociado"
		With objSql.Parametros
			If idUsuario IsNot Nothing AndAlso Not String.IsNullOrEmpty(idUsuario.ToString()) Then
				Dim uid As Integer
				If Integer.TryParse(idUsuario.ToString(), uid) Then .Add("@IdUsuario", uid)
			End If
			If fechaDesde IsNot Nothing AndAlso Not String.IsNullOrEmpty(fechaDesde.ToString()) AndAlso fechaDesde.ToString().Length = 8 Then
				.Add("@FechaDesde", fechaDesde.ToString())
			End If
			If fechaHasta IsNot Nothing AndAlso Not String.IsNullOrEmpty(fechaHasta.ToString()) AndAlso fechaHasta.ToString().Length = 8 Then
				.Add("@FechaHasta", fechaHasta.ToString())
			End If
			If codigoRubro IsNot Nothing AndAlso Not String.IsNullOrWhiteSpace(codigoRubro.ToString()) Then
				.Add("@CodigoRubro", codigoRubro.ToString().Trim())
			End If
			If idTipoAuxiliar IsNot Nothing AndAlso Not String.IsNullOrWhiteSpace(idTipoAuxiliar.ToString()) Then
				Dim tid As Integer
				If Integer.TryParse(idTipoAuxiliar.ToString(), tid) Then .Add("@IdTipoAux", tid)
			End If
			If numeroAsociado IsNot Nothing AndAlso Not String.IsNullOrWhiteSpace(numeroAsociado.ToString()) Then
				Dim na As Integer
				If Integer.TryParse(numeroAsociado.ToString(), na) Then .Add("@NumeroAsociado", na)
			End If
		End With
		ModGlobal.EscribirLog($"ResumenAsociado: {sSql} {objSql.getParamList()}")
		Dim dt As DataTable = objSql.GetDataTableSql(sSql)
		If objSql.MensajeError <> "" Then
			mensajeErrorSql = objSql.MensajeError
			Return Nothing
		End If
		Return dt
	End Function

	''' <summary>HTML agrupado: Rubro → Tipo auxiliar → filas Asociado, Cuenta, DR, CR.</summary>
	Private Shared Function ConstruirHtmlContenidoResumen(dt As DataTable) As String
		If dt Is Nothing OrElse dt.Rows.Count = 0 Then
			Return "<p style=""padding:12px;color:#6c757d;text-align:center;"">No se encontraron registros con los filtros indicados.</p>"
		End If
		dt.DefaultView.Sort = "CodigoRubro, TipoAuxiliar, NumeroAsociado, Cuenta"
		Dim rows As New List(Of DataRow)
		For Each drv As DataRowView In dt.DefaultView
			rows.Add(drv.Row)
		Next

		Dim sb As New StringBuilder()
		Dim totalGenDR As Decimal = 0
		Dim totalGenCR As Decimal = 0
		Dim totalGenReg As Integer = 0

		Dim i As Integer = 0
		While i < rows.Count
			Dim codRubro As String = ResumenRowStr(rows(i), "CodigoRubro")
			Dim nomRubro As String = ResumenRowStr(rows(i), "Rubro")
			If String.IsNullOrEmpty(nomRubro) Then nomRubro = codRubro

			sb.AppendLine("<div class=""grupo-rubro"">")
			sb.AppendLine("<div class=""grupo-rubro-header"">" & HttpUtility.HtmlEncode(nomRubro) & "</div>")

			Dim totalRubroDR As Decimal = 0
			Dim totalRubroCR As Decimal = 0
			Dim cntRubro As Integer = 0

			While i < rows.Count AndAlso ResumenRowStr(rows(i), "CodigoRubro") = codRubro
				Dim tipoAux As String = ResumenRowStr(rows(i), "TipoAuxiliar")

				sb.AppendLine("<div class=""grupo-tipo-aux"">")
				sb.AppendLine("<div class=""grupo-tipo-aux-header"">" & HttpUtility.HtmlEncode(tipoAux) & "</div>")
				sb.AppendLine("<table class=""tabla-datos""><thead><tr>")
				sb.AppendLine("<th class=""col-asociado-res"">Asociado</th><th class=""col-cuenta-res"">Cuenta</th><th class=""col-dr"">Débito</th><th class=""col-cr"">Crédito</th>")
				sb.AppendLine("</tr></thead><tbody>")

				Dim totalTipoDR As Decimal = 0
				Dim totalTipoCR As Decimal = 0

				While i < rows.Count AndAlso ResumenRowStr(rows(i), "CodigoRubro") = codRubro AndAlso ResumenRowStr(rows(i), "TipoAuxiliar") = tipoAux
					Dim r As DataRow = rows(i)
					Dim mdr As Decimal = ResumenRowDec(r, "MontoDR")
					Dim mcr As Decimal = ResumenRowDec(r, "MontoCR")
					totalTipoDR += mdr
					totalTipoCR += mcr
					totalRubroDR += mdr
					totalRubroCR += mcr
					totalGenDR += mdr
					totalGenCR += mcr
					cntRubro += 1
					totalGenReg += 1

					sb.AppendLine("<tr>")
					sb.AppendLine("<td class=""col-asociado-res"">" & HttpUtility.HtmlEncode(ResumenRowStr(r, "Asociado")) & "</td>")
					sb.AppendLine("<td class=""col-cuenta-res"">" & HttpUtility.HtmlEncode(ResumenRowStr(r, "Cuenta")) & "</td>")
					sb.AppendLine("<td class=""monto col-dr"">" & mdr.ToString("$###,###,##0.00", System.Globalization.CultureInfo.InvariantCulture) & "</td>")
					sb.AppendLine("<td class=""monto col-cr"">" & mcr.ToString("$###,###,##0.00", System.Globalization.CultureInfo.InvariantCulture) & "</td>")
					sb.AppendLine("</tr>")
					i += 1
				End While

				sb.AppendLine("</tbody></table>")
				sb.AppendLine("<div class=""grupo-tipo-aux-total"">Subtotal " & HttpUtility.HtmlEncode(tipoAux) & " — DR " &
					totalTipoDR.ToString("$###,###,##0.00", System.Globalization.CultureInfo.InvariantCulture) & " | CR " &
					totalTipoCR.ToString("$###,###,##0.00", System.Globalization.CultureInfo.InvariantCulture) & "</div>")
				sb.AppendLine("</div>")
			End While

			Dim balRubro As Decimal = totalRubroDR - totalRubroCR
			Dim drF As String = totalRubroDR.ToString("$###,###,##0.00", System.Globalization.CultureInfo.InvariantCulture)
			Dim crF As String = totalRubroCR.ToString("$###,###,##0.00", System.Globalization.CultureInfo.InvariantCulture)
			Dim balF As String = balRubro.ToString("$###,###,##0.00", System.Globalization.CultureInfo.InvariantCulture)
			Dim claseBalRubro As String = If(balRubro < 0, "badge-total-bal-neg", "badge-total-bal-pos")
			sb.AppendLine("<div class=""grupo-rubro-total"">")
			sb.AppendLine("<span class=""total-label"">TOTAL " & HttpUtility.HtmlEncode(nomRubro.ToUpperInvariant()) & ":</span>")
			sb.AppendLine("<span class=""total-registros"">" & cntRubro.ToString() & " registro(s)</span>")
			sb.AppendLine("<span class=""totales-badges"">")
			sb.AppendLine("<span class=""badge-total badge-total-dr""><span class=""badge-nombre"">DR</span> " & drF & "</span>")
			sb.AppendLine("<span class=""badge-total badge-total-cr""><span class=""badge-nombre"">CR</span> " & crF & "</span>")
			sb.AppendLine("<span class=""badge-total " & claseBalRubro & """><span class=""badge-nombre"">BAL</span> " & balF & "</span>")
			sb.AppendLine("</span></div>")
			sb.AppendLine("<div class=""grupo-rubro-post-total"" aria-hidden=""true""></div>")
			sb.AppendLine("</div>")
		End While

		Dim balGen As Decimal = totalGenDR - totalGenCR
		Dim drGF As String = totalGenDR.ToString("$###,###,##0.00", System.Globalization.CultureInfo.InvariantCulture)
		Dim crGF As String = totalGenCR.ToString("$###,###,##0.00", System.Globalization.CultureInfo.InvariantCulture)
		Dim balGF As String = balGen.ToString("$###,###,##0.00", System.Globalization.CultureInfo.InvariantCulture)
		Dim claseBalGen As String = If(balGen < 0, "badge-total-bal-neg", "badge-total-bal-pos")
		sb.AppendLine("<div class=""total-general"">")
		sb.AppendLine("<span class=""total-label"">TOTAL GENERAL:</span>")
		sb.AppendLine("<span class=""total-registros"">" & totalGenReg.ToString() & " registro(s)</span>")
		sb.AppendLine("<span class=""totales-badges"">")
		sb.AppendLine("<span class=""badge-total badge-total-dr""><span class=""badge-nombre"">DR</span> " & drGF & "</span>")
		sb.AppendLine("<span class=""badge-total badge-total-cr""><span class=""badge-nombre"">CR</span> " & crGF & "</span>")
		sb.AppendLine("<span class=""badge-total " & claseBalGen & """><span class=""badge-nombre"">BAL</span> " & balGF & "</span>")
		sb.AppendLine("</span></div>")

		Return sb.ToString()
	End Function

	<WebMethod(EnableSession:=True)>
	<ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
	Public Shared Function BuscarResumenAsociados(idUsuario As Object, numeroAsociado As Object, fechaDesde As Object, fechaHasta As Object, codigoRubro As Object, idTipoAuxiliar As Object, textoRubroFiltro As String, textoTipoAuxFiltro As String, textoAsociadoFiltro As String) As String
		Dim serializer As New JavaScriptSerializer()
		Try
			If fechaDesde Is Nothing OrElse String.IsNullOrEmpty(fechaDesde.ToString()) Then
				Return serializer.Serialize(New Dictionary(Of String, Object) From {{"Success", False}, {"Message", "La fecha desde es obligatoria"}, {"Html", ""}})
			End If
			If fechaHasta Is Nothing OrElse String.IsNullOrEmpty(fechaHasta.ToString()) Then
				Return serializer.Serialize(New Dictionary(Of String, Object) From {{"Success", False}, {"Message", "La fecha hasta es obligatoria"}, {"Html", ""}})
			End If

			Dim errSql As String = ""
			Dim dt As DataTable = ConsultarResumenAsociadoDataTable(idUsuario, numeroAsociado, fechaDesde, fechaHasta, codigoRubro, idTipoAuxiliar, errSql)
			If Not String.IsNullOrEmpty(errSql) Then
				Return serializer.Serialize(New Dictionary(Of String, Object) From {{"Success", False}, {"Message", "Error en la base de datos: " & errSql}, {"Html", ""}})
			End If

			Dim usuarioActual As String = ""
			If HttpContext.Current.Session(VariablesSesion.NombreUsuario) IsNot Nothing Then
				usuarioActual = HttpContext.Current.Session(VariablesSesion.NombreUsuario).ToString()
			End If

			Dim templatePath As String = HttpContext.Current.Server.MapPath("~/Forms/Reportes/ReporteResumenAsociados.html")
			Dim htmlTemplate As String = System.IO.File.ReadAllText(templatePath)

			Dim fechaDesdeFormateada As String = ""
			Dim fechaHastaFormateada As String = ""
			If fechaDesde.ToString().Length = 8 Then
				Dim fs As String = fechaDesde.ToString()
				fechaDesdeFormateada = fs.Substring(6, 2) & "/" & fs.Substring(4, 2) & "/" & fs.Substring(0, 4)
			End If
			If fechaHasta.ToString().Length = 8 Then
				Dim fh As String = fechaHasta.ToString()
				fechaHastaFormateada = fh.Substring(6, 2) & "/" & fh.Substring(4, 2) & "/" & fh.Substring(0, 4)
			End If

			htmlTemplate = htmlTemplate.Replace("@Usuario", HttpUtility.HtmlEncode(usuarioActual))
			htmlTemplate = htmlTemplate.Replace("@FechaDesde", HttpUtility.HtmlEncode(fechaDesdeFormateada))
			htmlTemplate = htmlTemplate.Replace("@FechaHasta", HttpUtility.HtmlEncode(fechaHastaFormateada))
			htmlTemplate = htmlTemplate.Replace("@RubroFiltro", HttpUtility.HtmlEncode(If(String.IsNullOrWhiteSpace(textoRubroFiltro), "Todos", textoRubroFiltro.Trim())))
			htmlTemplate = htmlTemplate.Replace("@TipoAuxFiltro", HttpUtility.HtmlEncode(If(String.IsNullOrWhiteSpace(textoTipoAuxFiltro), "Todos", textoTipoAuxFiltro.Trim())))
			htmlTemplate = htmlTemplate.Replace("@AsociadoFiltro", HttpUtility.HtmlEncode(If(String.IsNullOrWhiteSpace(textoAsociadoFiltro), "Todos", textoAsociadoFiltro.Trim())))
			htmlTemplate = htmlTemplate.Replace("@ContenidoRubros", ConstruirHtmlContenidoResumen(dt))
			htmlTemplate = htmlTemplate.Replace("@FechaHoraImpresion", DateTime.Now.ToString("dd/MM/yyyy HH:mm:ss"))

			Return serializer.Serialize(New Dictionary(Of String, Object) From {
				{"Success", True},
				{"Message", ""},
				{"Html", htmlTemplate}
			})
		Catch ex As Exception
			ModGlobal.EscribirLog("BuscarResumenAsociados: " & ex.Message)
			Return serializer.Serialize(New Dictionary(Of String, Object) From {{"Success", False}, {"Message", ex.Message}, {"Html", ""}})
		End Try
	End Function

	<WebMethod(EnableSession:=True)>
	<ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
	Public Shared Function ExportarResumenAsociadosExcel(idUsuario As Object, numeroAsociado As Object, fechaDesde As Object, fechaHasta As Object, codigoRubro As Object, idTipoAuxiliar As Object) As String
		Dim serializer As New JavaScriptSerializer()
		Try
			If fechaDesde Is Nothing OrElse String.IsNullOrEmpty(fechaDesde.ToString()) Then
				Return serializer.Serialize(New Dictionary(Of String, Object) From {{"Resultado", "ERROR"}, {"Mensaje", "La fecha desde es obligatoria"}, {"NombreArchivo", ""}})
			End If
			If fechaHasta Is Nothing OrElse String.IsNullOrEmpty(fechaHasta.ToString()) Then
				Return serializer.Serialize(New Dictionary(Of String, Object) From {{"Resultado", "ERROR"}, {"Mensaje", "La fecha hasta es obligatoria"}, {"NombreArchivo", ""}})
			End If

			Dim errSql As String = ""
			Dim dt As DataTable = ConsultarResumenAsociadoDataTable(idUsuario, numeroAsociado, fechaDesde, fechaHasta, codigoRubro, idTipoAuxiliar, errSql)
			If Not String.IsNullOrEmpty(errSql) Then
				Return serializer.Serialize(New Dictionary(Of String, Object) From {{"Resultado", "ERROR"}, {"Mensaje", errSql}, {"NombreArchivo", ""}})
			End If

			Dim nombreArchivo As String = "ResumenAsociados_" & DateTime.Now.ToString("yyyyMMdd_HHmmss") & ".xlsx"
			nombreArchivo = nombreArchivo.Replace(" ", "_").Replace("/", "_")

			Using workbook As New ClosedXML.Excel.XLWorkbook()
				Dim ws = workbook.Worksheets.Add("Resumen")
				ws.Cell(1, 1).Value = "Resumen asociados (por rubro y tipo auxiliar)"
				ws.Cell(1, 1).Style.Font.Bold = True
				ws.Cell(1, 1).Style.Font.FontSize = 14
				ws.Range(1, 1, 1, 6).Merge()
				ws.Cell(2, 1).Value = "Generado: " & DateTime.Now.ToString("dd/MM/yyyy HH:mm:ss")
				ws.Range(2, 1, 2, 6).Merge()

				Dim fila As Integer = 4
				If dt Is Nothing OrElse dt.Rows.Count = 0 Then
					ws.Cell(fila, 1).Value = "Sin registros con los filtros indicados."
					ws.Range(fila, 1, fila, 6).Merge()
				Else
					dt.DefaultView.Sort = "CodigoRubro, TipoAuxiliar, NumeroAsociado, Cuenta"
					Dim rows As New List(Of DataRow)
					For Each drv As DataRowView In dt.DefaultView
						rows.Add(drv.Row)
					Next

					Dim i As Integer = 0
					While i < rows.Count
						Dim codRubro As String = ResumenRowStr(rows(i), "CodigoRubro")
						Dim nomRubro As String = ResumenRowStr(rows(i), "Rubro")
						If String.IsNullOrEmpty(nomRubro) Then nomRubro = codRubro

						ws.Cell(fila, 1).Value = "RUBRO: " & nomRubro
						ws.Range(fila, 1, fila, 6).Merge()
						ws.Row(fila).Style.Font.Bold = True
						ws.Row(fila).Style.Fill.BackgroundColor = ClosedXML.Excel.XLColor.LightBlue
						fila += 1

						While i < rows.Count AndAlso ResumenRowStr(rows(i), "CodigoRubro") = codRubro
							Dim tipoAux As String = ResumenRowStr(rows(i), "TipoAuxiliar")
							ws.Cell(fila, 1).Value = "Tipo auxiliar: " & tipoAux
							ws.Range(fila, 1, fila, 6).Merge()
							ws.Row(fila).Style.Font.Bold = True
							ws.Row(fila).Style.Fill.BackgroundColor = ClosedXML.Excel.XLColor.LightGreen
							fila += 1

							ws.Cell(fila, 1).Value = "Asociado"
							ws.Cell(fila, 2).Value = "Cuenta"
							ws.Cell(fila, 3).Value = "Débito"
							ws.Cell(fila, 4).Value = "Crédito"
							ws.Range(fila, 1, fila, 4).Style.Font.Bold = True
							fila += 1

							Dim subDr As Decimal = 0
							Dim subCr As Decimal = 0
							While i < rows.Count AndAlso ResumenRowStr(rows(i), "CodigoRubro") = codRubro AndAlso ResumenRowStr(rows(i), "TipoAuxiliar") = tipoAux
								Dim r As DataRow = rows(i)
								Dim mdr As Decimal = ResumenRowDec(r, "MontoDR")
								Dim mcr As Decimal = ResumenRowDec(r, "MontoCR")
								subDr += mdr
								subCr += mcr
								ws.Cell(fila, 1).Value = ResumenRowStr(r, "Asociado")
								ws.Cell(fila, 2).Value = ResumenRowStr(r, "Cuenta")
								ws.Cell(fila, 3).Value = mdr
								ws.Cell(fila, 3).Style.NumberFormat.Format = "#,##0.00"
								ws.Cell(fila, 4).Value = mcr
								ws.Cell(fila, 4).Style.NumberFormat.Format = "#,##0.00"
								fila += 1
								i += 1
							End While
							ws.Cell(fila, 1).Value = "Subtotal " & tipoAux
							ws.Cell(fila, 3).Value = subDr
							ws.Cell(fila, 3).Style.NumberFormat.Format = "#,##0.00"
							ws.Cell(fila, 4).Value = subCr
							ws.Cell(fila, 4).Style.NumberFormat.Format = "#,##0.00"
							ws.Range(fila, 1, fila, 6).Style.Font.Bold = True
							fila += 2
						End While
					End While
				End If
				ws.Columns().AdjustToContents()
				Dim dirTemp As String = HttpContext.Current.Server.MapPath("~/Temp/")
				If Not System.IO.Directory.Exists(dirTemp) Then System.IO.Directory.CreateDirectory(dirTemp)
				workbook.SaveAs(System.IO.Path.Combine(dirTemp, nombreArchivo))
			End Using

			Return serializer.Serialize(New Dictionary(Of String, Object) From {
				{"Resultado", "SUCCESS"},
				{"Mensaje", ""},
				{"NombreArchivo", nombreArchivo}
			})
		Catch ex As Exception
			ModGlobal.EscribirLog("ExportarResumenAsociadosExcel: " & ex.Message)
			Return serializer.Serialize(New Dictionary(Of String, Object) From {{"Resultado", "ERROR"}, {"Mensaje", ex.Message}, {"NombreArchivo", ""}})
		End Try
	End Function

	<WebMethod(EnableSession:=True)>
	<ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
	Public Shared Function ExportarAExcel(nombreReporte As String, datos As Object()) As String
		Dim resultado As String = ""
		Dim serializer As New JavaScriptSerializer()

		Try
			ModGlobal.EscribirLog("ResumenAsociados ExportarAExcel iniciado")

			Dim titulo As String = If(String.IsNullOrWhiteSpace(nombreReporte), "Resumen Asociados", nombreReporte.Trim())
			Dim nombreArchivo As String = $"ResumenAsociados_{DateTime.Now:yyyyMMdd_HHmmss}.xlsx"
			nombreArchivo = nombreArchivo.Replace(" ", "_").Replace("/", "_")

			Using workbook As New ClosedXML.Excel.XLWorkbook()
				Dim worksheet = workbook.Worksheets.Add("Datos")

				worksheet.Cell(1, 1).Value = titulo
				worksheet.Cell(1, 1).Style.Font.Bold = True
				worksheet.Cell(1, 1).Style.Font.FontSize = 14
				worksheet.Range(1, 1, 1, 20).Merge()

				worksheet.Cell(2, 1).Value = "Generado el: " & DateTime.Now.ToString("dd/MM/yyyy HH:mm:ss")
				worksheet.Cell(2, 1).Style.Font.Italic = True
				worksheet.Range(2, 1, 2, 20).Merge()

				Dim filaInicio As Integer = 4

				If datos IsNot Nothing AndAlso datos.Length > 0 Then
					Dim columnas As New List(Of String)
					For Each key In datos(0).Keys
						columnas.Add(key)
					Next

					For i As Integer = 0 To columnas.Count - 1
						worksheet.Cell(filaInicio, i + 1).Value = columnas(i)
						worksheet.Cell(filaInicio, i + 1).Style.Font.Bold = True
						worksheet.Cell(filaInicio, i + 1).Style.Fill.BackgroundColor = ClosedXML.Excel.XLColor.LightBlue
					Next

					For i As Integer = 0 To datos.Length - 1
						Dim fila As Integer = filaInicio + 1 + i
						For j As Integer = 0 To columnas.Count - 1
							Dim valor As String = If(datos(i)(columnas(j)) IsNot Nothing, datos(i)(columnas(j)).ToString(), "")
							worksheet.Cell(fila, j + 1).Value = valor
						Next
					Next

					worksheet.Columns().AdjustToContents()
					worksheet.Range(filaInicio, 1, filaInicio + datos.Length, columnas.Count).Style.Border.OutsideBorder = ClosedXML.Excel.XLBorderStyleValues.Thin
					worksheet.Range(filaInicio, 1, filaInicio + datos.Length, columnas.Count).Style.Border.InsideBorder = ClosedXML.Excel.XLBorderStyleValues.Thin
				End If

				Dim directorioTemp As String = HttpContext.Current.Server.MapPath("~/Temp/")
				If Not System.IO.Directory.Exists(directorioTemp) Then
					System.IO.Directory.CreateDirectory(directorioTemp)
				End If
				Dim rutaArchivo As String = System.IO.Path.Combine(directorioTemp, nombreArchivo)
				workbook.SaveAs(rutaArchivo)
			End Using

			Dim successResponse As New Dictionary(Of String, Object)
			successResponse("Resultado") = "SUCCESS"
			successResponse("Mensaje") = "Archivo Excel generado exitosamente"
			successResponse("NombreArchivo") = nombreArchivo
			resultado = serializer.Serialize(successResponse)

		Catch ex As Exception
			ModGlobal.EscribirLog($"Error en ResumenAsociados ExportarAExcel: {ex.Message}")
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
				System.IO.File.Delete(rutaArchivo)
			Else
				Response.Write("Archivo no encontrado")
			End If
		Catch ex As Exception
			ModGlobal.EscribirLog("ResumenAsociados descarga: " & ex.Message)
			Response.Write("Error al descargar archivo")
		End Try
	End Sub

End Class
