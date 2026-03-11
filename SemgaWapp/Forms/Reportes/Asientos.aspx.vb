Imports System.Web.Services
Imports System.Web.Script.Services
Imports System.Web.Script.Serialization
Imports System.Data
Imports SBSqlClient
Imports SBUtility

Public Class Asientos
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
			ModGlobal.EscribirLog("Error al descargar archivo: " & ex.Message)
			Response.Write("Error al descargar archivo")
		End Try
	End Sub

	<WebMethod(EnableSession:=True)>
	<ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
	Public Shared Function ListarAsientos(fechaDesde As String, fechaHasta As String) As String
		Dim serializer As New JavaScriptSerializer()
		Try
			ModGlobal.EscribirLog("ListarAsientos iniciado")

			Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
			Dim sSql As String = "Exec spAsientos_Listar"

			With objSql.Parametros
				If Not String.IsNullOrWhiteSpace(fechaDesde) AndAlso fechaDesde.Length = 8 Then
					.Add("@FechaDesde", fechaDesde)
				End If
				If Not String.IsNullOrWhiteSpace(fechaHasta) AndAlso fechaHasta.Length = 8 Then
					.Add("@FechaHasta", fechaHasta)
				End If
			End With

			ModGlobal.EscribirLog($"Ejecutando: {sSql} {objSql.getParamList()}")
			Dim dt As DataTable = objSql.GetDataTableSql(sSql)

			If objSql.MensajeError <> "" Then
				ModGlobal.EscribirLog("Error en BD al listar asientos: " & objSql.MensajeError)
				Dim resultError As New Dictionary(Of String, Object)
				resultError("Success") = False
				resultError("Message") = "Error en la base de datos: " & objSql.MensajeError
				resultError("Data") = New List(Of Object)
				Return serializer.Serialize(resultError)
			End If

			Dim lista As New List(Of Dictionary(Of String, Object))
			For Each row As DataRow In dt.Rows
				Dim item As New Dictionary(Of String, Object)
				For Each col As DataColumn In dt.Columns
					If row(col) IsNot DBNull.Value AndAlso row(col) IsNot Nothing Then
						item(col.ColumnName) = row(col).ToString()
					Else
						item(col.ColumnName) = ""
					End If
				Next
				lista.Add(item)
			Next

			Dim resultSuccess As New Dictionary(Of String, Object)
			resultSuccess("Success") = True
			resultSuccess("Message") = ""
			resultSuccess("Data") = lista
			Return serializer.Serialize(resultSuccess)

		Catch ex As Exception
			ModGlobal.EscribirLog($"Error en ListarAsientos: {ex.Message} | StackTrace: {ex.StackTrace}")
			Dim resultError As New Dictionary(Of String, Object)
			resultError("Success") = False
			resultError("Message") = "Error al listar asientos: " & ex.Message
			resultError("Data") = New List(Of Object)
			Return serializer.Serialize(resultError)
		End Try
	End Function

	<WebMethod(EnableSession:=True)>
	<ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
	Public Shared Function ExportarAExcel(nombreReporte As String, datos As Object()) As String
		Dim serializer As New JavaScriptSerializer()
		Try
			ModGlobal.EscribirLog("ExportarAExcel Asientos - Cantidad: " & If(datos Is Nothing, 0, datos.Length))
			Dim nombreArchivo As String = $"Asientos_{DateTime.Now:yyyyMMdd_HHmmss}.xlsx"
			nombreArchivo = nombreArchivo.Replace(" ", "_").Replace("/", "_")
			Using workbook As New ClosedXML.Excel.XLWorkbook()
				Dim worksheet = workbook.Worksheets.Add("Asientos")
				worksheet.Cell(1, 1).Value = nombreReporte
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
				workbook.SaveAs(HttpContext.Current.Server.MapPath("~/Temp/" & nombreArchivo))
			End Using
			Dim resultSuccess As New Dictionary(Of String, Object)
			resultSuccess("Resultado") = "SUCCESS"
			resultSuccess("Mensaje") = "Archivo generado"
			resultSuccess("NombreArchivo") = nombreArchivo
			Return serializer.Serialize(resultSuccess)
		Catch ex As Exception
			ModGlobal.EscribirLog("Error ExportarAExcel Asientos: " & ex.Message)
			Dim resultError As New Dictionary(Of String, Object)
			resultError("Resultado") = "ERROR"
			resultError("Mensaje") = "Error al generar Excel: " & ex.Message
			resultError("NombreArchivo") = ""
			Return serializer.Serialize(resultError)
		End Try
	End Function

End Class
