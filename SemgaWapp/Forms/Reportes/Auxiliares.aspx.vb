Imports System.Web.Services
Imports System.Web.Script.Services
Imports System.Web.Script.Serialization
Imports System.Data
Imports System.Collections
Imports SBSqlClient
Imports SBUtility

Public Class Auxiliares
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
				Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
				Response.AddHeader("Content-Disposition", "attachment; filename=" & nombreArchivo)
				Response.TransmitFile(rutaArchivo)
				Response.End()
				System.IO.File.Delete(rutaArchivo)
			Else
				Response.Write("Archivo no encontrado")
			End If
		Catch ex As Exception
			ModGlobal.EscribirLog("Auxiliares DescargarArchivo: " & ex.Message)
		End Try
	End Sub

	<WebMethod(EnableSession:=True)>
	<ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
	Public Shared Function ObtenerRubros() As String
		Dim serializer As New JavaScriptSerializer()
		Try
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
			ModGlobal.EscribirLog("Auxiliares ObtenerRubros: " & ex.Message)
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
				item("TipoAuxiliar") = If(row("TipoAuxiliar") IsNot DBNull.Value, Convert.ToInt32(row("TipoAuxiliar")), 0)
				item("CodigoRubro") = If(row("CodigoRubro") IsNot DBNull.Value, row("CodigoRubro").ToString(), "")
				item("Descripcion") = If(row("Descripcion") IsNot DBNull.Value, row("Descripcion").ToString(), "")
				item("RubroDescripcion") = If(row.Table.Columns.Contains("RubroDescripcion") AndAlso row("RubroDescripcion") IsNot DBNull.Value,
					row("RubroDescripcion").ToString(), "")
				tipos.Add(item)
			Next

			Dim resultSuccess As New Dictionary(Of String, Object)
			resultSuccess("Success") = True
			resultSuccess("Message") = ""
			resultSuccess("Data") = tipos
			Return serializer.Serialize(resultSuccess)

		Catch ex As Exception
			ModGlobal.EscribirLog("Auxiliares ObtenerTiposAuxiliares: " & ex.Message)
			Dim resultError As New Dictionary(Of String, Object)
			resultError("Success") = False
			resultError("Message") = "Error al obtener tipos de auxiliar: " & ex.Message
			resultError("Data") = New List(Of Object)
			Return serializer.Serialize(resultError)
		End Try
	End Function

	Private Shared Sub AgregarParametrosHistorialAuxiliares(objSql As SBSqlClientInterface, mesHistorial As Object, anioHistorial As Object, versionHistorial As Object)
		With objSql.Parametros
			If mesHistorial IsNot Nothing AndAlso Not String.IsNullOrEmpty(mesHistorial.ToString()) Then
				Dim mesHist As Integer
				If Integer.TryParse(mesHistorial.ToString(), mesHist) AndAlso mesHist >= 1 AndAlso mesHist <= 12 Then
					.Add("@MesHistorial", mesHist)
				End If
			End If
			If anioHistorial IsNot Nothing AndAlso Not String.IsNullOrEmpty(anioHistorial.ToString()) Then
				Dim anioHist As Integer
				If Integer.TryParse(anioHistorial.ToString(), anioHist) AndAlso anioHist >= 1980 Then
					.Add("@AnioHistorial", anioHist)
				End If
			End If
			If versionHistorial IsNot Nothing AndAlso Not String.IsNullOrEmpty(versionHistorial.ToString()) Then
				Dim verHist As Integer
				If Integer.TryParse(versionHistorial.ToString(), verHist) AndAlso verHist >= 0 Then
					.Add("@VersionHistorial", verHist)
				End If
			End If
		End With
	End Sub

	<WebMethod(EnableSession:=True)>
	<ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
	Public Shared Function ListarPeriodosHistorialAuxiliares() As String
		Dim serializer As New JavaScriptSerializer()
		Try
			Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
			Dim sSql As String = "Exec spAuxiliares_Historial_ListarPeriodos"
			ModGlobal.EscribirLog($"Ejecutando: {sSql}")
			Dim dt As DataTable = objSql.GetDataTableSql(sSql)

			If objSql.MensajeError <> "" Then
				Return serializer.Serialize(New Dictionary(Of String, Object) From {
					{"Success", False},
					{"Message", "Error en la base de datos: " & objSql.MensajeError},
					{"Data", New List(Of Object)()}
				})
			End If

			Dim lista As New List(Of Dictionary(Of String, Object))
			If dt IsNot Nothing Then
				For Each row As DataRow In dt.Rows
					Dim item As New Dictionary(Of String, Object)
					For Each col As DataColumn In dt.Columns
						If row(col) IsNot DBNull.Value AndAlso row(col) IsNot Nothing Then
							item(col.ColumnName) = row(col)
						Else
							item(col.ColumnName) = Nothing
						End If
					Next
					lista.Add(item)
				Next
			End If

			Return serializer.Serialize(New Dictionary(Of String, Object) From {
				{"Success", True},
				{"Message", ""},
				{"Data", lista}
			})
		Catch ex As Exception
			ModGlobal.EscribirLog($"Error en ListarPeriodosHistorialAuxiliares: {ex.Message}")
			Return serializer.Serialize(New Dictionary(Of String, Object) From {
				{"Success", False},
				{"Message", "Error al listar periodos de historial: " & ex.Message},
				{"Data", New List(Of Object)()}
			})
		End Try
	End Function

	<WebMethod(EnableSession:=True)>
	<ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
	Public Shared Function ListarAuxiliaresReporte(
		codigosRubroJson As String,
		tiposAuxiliarJson As String,
		numeroAsociado As Object,
		mesHistorial As Object,
		anioHistorial As Object,
		versionHistorial As Object,
		pageSize As Integer,
		pageIndex As Integer,
		sortColumn As Integer,
		sortDirection As String) As String

		Dim serializer As New JavaScriptSerializer()
		Try
			ModGlobal.EscribirLog("ListarAuxiliaresReporte iniciado")

			Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
			Dim sSql As String = "Exec spAuxiliares_Reporte"

			Dim jsonRubros As String = NormalizarJsonArrayFiltro(codigosRubroJson)
			Dim jsonTipos As String = NormalizarJsonArrayFiltro(tiposAuxiliarJson)

			With objSql.Parametros
				If jsonRubros IsNot Nothing Then
					.Add("@CodigosRubroJson", jsonRubros)
				End If
				If jsonTipos IsNot Nothing Then
					.Add("@TiposAuxiliarJson", jsonTipos)
				End If

				Dim numAsoc As Integer
				If numeroAsociado IsNot Nothing AndAlso Integer.TryParse(numeroAsociado.ToString(), numAsoc) Then
					.Add("@NumeroAsociado", numAsoc)
				End If

				If pageSize > 0 Then
					.Add("@PageSize", pageSize)
				End If
				If pageIndex >= 0 Then
					.Add("@PageIndex", pageIndex)
				End If
				If sortColumn > 0 Then
					.Add("@SortColumn", sortColumn)
				End If
				If Not String.IsNullOrWhiteSpace(sortDirection) Then
					.Add("@SortDirection", sortDirection.Trim())
				End If
			End With
			AgregarParametrosHistorialAuxiliares(objSql, mesHistorial, anioHistorial, versionHistorial)

			ModGlobal.EscribirLog($"Ejecutando: {sSql} {objSql.getParamList()}")
			Dim dt As DataTable = objSql.GetDataTableSql(sSql)

			If objSql.MensajeError <> "" Then
				ModGlobal.EscribirLog("Error en BD al listar reporte auxiliares: " & objSql.MensajeError)
				Dim resultError As New Dictionary(Of String, Object)
				resultError("Success") = False
				resultError("Message") = "Error en la base de datos: " & objSql.MensajeError
				resultError("Data") = New List(Of Object)
				Return serializer.Serialize(resultError)
			End If

			Return SerializarDataTableResultado(dt, serializer)

		Catch ex As Exception
			ModGlobal.EscribirLog("ListarAuxiliaresReporte: " & ex.Message)
			Dim resultError As New Dictionary(Of String, Object)
			resultError("Success") = False
			resultError("Message") = "Error al listar auxiliares: " & ex.Message
			resultError("Data") = New List(Of Object)
			Return serializer.Serialize(resultError)
		End Try
	End Function

	<WebMethod(EnableSession:=True)>
	<ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
	Public Shared Function ListarAuxiliaresResumen(
		codigosRubroJson As String,
		tiposAuxiliarJson As String,
		numeroAsociado As Object,
		mesHistorial As Object,
		anioHistorial As Object,
		versionHistorial As Object,
		pageSize As Integer,
		pageIndex As Integer,
		sortColumn As Integer,
		sortDirection As String) As String

		Dim serializer As New JavaScriptSerializer()
		Try
			ModGlobal.EscribirLog("ListarAuxiliaresResumen iniciado")

			Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
			Dim sSql As String = "Exec spAuxiliares_ReporteResumen"

			Dim jsonRubros As String = NormalizarJsonArrayFiltro(codigosRubroJson)
			Dim jsonTipos As String = NormalizarJsonArrayFiltro(tiposAuxiliarJson)

			With objSql.Parametros
				If jsonRubros IsNot Nothing Then
					.Add("@CodigosRubroJson", jsonRubros)
				End If
				If jsonTipos IsNot Nothing Then
					.Add("@TiposAuxiliarJson", jsonTipos)
				End If

				Dim numAsoc As Integer
				If numeroAsociado IsNot Nothing AndAlso Integer.TryParse(numeroAsociado.ToString(), numAsoc) Then
					.Add("@NumeroAsociado", numAsoc)
				End If

				If pageSize > 0 Then
					.Add("@PageSize", pageSize)
				End If
				If pageIndex >= 0 Then
					.Add("@PageIndex", pageIndex)
				End If
				If sortColumn > 0 Then
					.Add("@SortColumn", sortColumn)
				End If
				If Not String.IsNullOrWhiteSpace(sortDirection) Then
					.Add("@SortDirection", sortDirection.Trim())
				End If
			End With
			AgregarParametrosHistorialAuxiliares(objSql, mesHistorial, anioHistorial, versionHistorial)

			ModGlobal.EscribirLog($"Ejecutando: {sSql} {objSql.getParamList()}")
			Dim dt As DataTable = objSql.GetDataTableSql(sSql)

			If objSql.MensajeError <> "" Then
				Dim resultError As New Dictionary(Of String, Object)
				resultError("Success") = False
				resultError("Message") = "Error en la base de datos: " & objSql.MensajeError
				resultError("Data") = New List(Of Object)
				Return serializer.Serialize(resultError)
			End If

			Return SerializarDataTableResultado(dt, serializer)

		Catch ex As Exception
			ModGlobal.EscribirLog("ListarAuxiliaresResumen: " & ex.Message)
			Dim resultError As New Dictionary(Of String, Object)
			resultError("Success") = False
			resultError("Message") = "Error al listar resumen de auxiliares: " & ex.Message
			resultError("Data") = New List(Of Object)
			Return serializer.Serialize(resultError)
		End Try
	End Function

	Private Shared Function SerializarDataTableResultado(dt As DataTable, serializer As JavaScriptSerializer) As String
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
	End Function

	<WebMethod(EnableSession:=True)>
	<ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
	Public Shared Function ExportarAExcel(
		nombreReporte As String,
		datosResumen As Object(),
		datosDetalle As Object(),
		codigosRubroJson As String,
		tiposAuxiliarJson As String,
		numeroAsociado As Object,
		mesHistorial As Object,
		anioHistorial As Object,
		versionHistorial As Object,
		rubrosFiltroTexto As String,
		tiposAuxiliarFiltroTexto As String,
		etiquetaAsociado As String) As String
		Dim serializer As New JavaScriptSerializer()
		Try
			Dim dr As Object() = If(datosResumen IsNot Nothing, datosResumen, New Object() {})
			Dim dd As Object() = If(datosDetalle IsNot Nothing, datosDetalle, New Object() {})
			ModGlobal.EscribirLog("Auxiliares ExportarAExcel - Resumen: " & dr.Length.ToString() & ", Detallado: " & dd.Length.ToString())

			Dim colsResumen As String() = {"Rubro / Tipo auxiliar", "Auxiliares", "Asociados", "Saldo"}
			Dim colsDetalle As String() = {
				"ID Auxiliar", "Número de Asociado", "Código Rubro", "Rubro", "ID Tipo Auxiliar", "Tipo Auxiliar",
				"Cuota", "Saldo", "Fecha de Creación", "Hora de Creación", "Fecha de Modificación", "Hora de Modificación",
				"ID Usuario Crea", "Usuario que Crea", "ID Usuario Modifica", "Usuario que Modifica",
				"Monto Original", "Fecha de Otorgamiento", "Hora de Otorgamiento", "Tasa de Interés", "Pago Mensual",
				"Interés Calculado", "Interés Pagado", "Fecha Último Pago", "Hora Último Pago",
				"Fecha Último Retiro", "Hora Último Retiro", "¿Activo?", "¿Eliminado?", "Monto Pignorado",
				"ID Usuario Elimina", "Usuario que Elimina", "Fecha de Eliminación", "Hora de Eliminación"
			}

			Dim titulo As String = If(String.IsNullOrWhiteSpace(nombreReporte), "Auxiliares", nombreReporte.Trim())
			Dim nombreArchivo As String = "Auxiliares_" & DateTime.Now.ToString("yyyyMMdd_HHmmss") & ".xlsx"
			Dim lineaGen As String = "Generado el: " & DateTime.Now.ToString("dd/MM/yyyy HH:mm:ss")
			Dim lineaFiltros As String = ConstruirLineaFiltrosAuxiliaresExcel(
				rubrosFiltroTexto, tiposAuxiliarFiltroTexto, numeroAsociado, etiquetaAsociado,
				mesHistorial, anioHistorial, versionHistorial)

			Using workbook As New ClosedXML.Excel.XLWorkbook()
				Dim wsResumen = workbook.Worksheets.Add("Resumen")
				EscribirHojaResumenAuxiliaresExcel(wsResumen, titulo & " — Resumen", lineaGen, lineaFiltros, dr, colsResumen)
				wsResumen.Columns().AdjustToContents()

				Dim wsDetallado = workbook.Worksheets.Add("Detallado")
				EscribirHojaAuxiliaresExcel(wsDetallado, titulo & " — Detallado", lineaGen, lineaFiltros, dd, colsDetalle)
				wsDetallado.Columns().AdjustToContents()

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
			ModGlobal.EscribirLog("Auxiliares ExportarAExcel: " & ex.Message)
			Dim resultError As New Dictionary(Of String, Object)
			resultError("Resultado") = "ERROR"
			resultError("Mensaje") = "Error al generar Excel: " & ex.Message
			resultError("NombreArchivo") = ""
			Return serializer.Serialize(resultError)
		End Try
	End Function

	Private Shared Sub AplicarEstiloEncabezadoTablaExcel(celda As ClosedXML.Excel.IXLCell)
		celda.Style.Font.Bold = True
		celda.Style.Font.FontColor = ClosedXML.Excel.XLColor.White
		celda.Style.Fill.BackgroundColor = ClosedXML.Excel.XLColor.FromHtml("#1A3A5C")
	End Sub

	Private Shared Function EsFilaRubroExcel(idict As IDictionary) As Boolean
		If idict Is Nothing OrElse Not idict.Contains("EsFilaRubro") Then Return False
		Dim v = idict("EsFilaRubro")
		If TypeOf v Is Boolean Then Return CBool(v)
		Return String.Equals(If(v, "").ToString(), "true", StringComparison.OrdinalIgnoreCase)
	End Function

	Private Shared ReadOnly NombresMesesHistorialAuxiliares As String() = {
		"Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio",
		"Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"
	}

	Private Shared Function ConstruirLineaFiltrosAuxiliaresExcel(
		rubrosFiltroTexto As String,
		tiposAuxiliarFiltroTexto As String,
		numeroAsociado As Object,
		etiquetaAsociado As String,
		mesHistorial As Object,
		anioHistorial As Object,
		versionHistorial As Object) As String

		Dim partes As New List(Of String)

		If Not String.IsNullOrWhiteSpace(rubrosFiltroTexto) Then
			partes.Add("Rubros: " & rubrosFiltroTexto.Trim())
		End If

		If Not String.IsNullOrWhiteSpace(tiposAuxiliarFiltroTexto) Then
			partes.Add("Tipos auxiliar: " & tiposAuxiliarFiltroTexto.Trim())
		End If

		Dim txtAsociado As String = If(etiquetaAsociado, "").Trim()
		If String.IsNullOrWhiteSpace(txtAsociado) AndAlso numeroAsociado IsNot Nothing AndAlso Not String.IsNullOrWhiteSpace(numeroAsociado.ToString()) Then
			txtAsociado = "N° " & numeroAsociado.ToString().Trim()
		End If
		If Not String.IsNullOrWhiteSpace(txtAsociado) Then
			partes.Add("Asociado: " & txtAsociado)
		End If

		If mesHistorial IsNot Nothing AndAlso anioHistorial IsNot Nothing AndAlso versionHistorial IsNot Nothing Then
			Dim mesHist As Integer
			Dim anioHist As Integer
			Dim verHist As Integer
			If Integer.TryParse(mesHistorial.ToString(), mesHist) AndAlso mesHist >= 1 AndAlso mesHist <= 12 AndAlso
			   Integer.TryParse(anioHistorial.ToString(), anioHist) AndAlso anioHist >= 1980 AndAlso
			   Integer.TryParse(versionHistorial.ToString(), verHist) AndAlso verHist >= 0 Then
				Dim nombreMes As String = NombresMesesHistorialAuxiliares(mesHist - 1)
				partes.Add("Período historial: " & nombreMes & " " & anioHist.ToString() & " v" & verHist.ToString())
			End If
		End If

		If partes.Count = 0 Then Return ""
		Return "Filtros aplicados: " & String.Join(" — ", partes)
	End Function

	Private Shared Sub EscribirLineaFiltrosAuxExcel(ws As ClosedXML.Excel.IXLWorksheet, lineaFiltros As String, mergeSpan As Integer)
		ws.Cell(3, 1).Value = lineaFiltros
		ws.Cell(3, 1).Style.Font.Italic = True
		ws.Cell(3, 1).Style.Font.FontSize = 11
		ws.Range(3, 1, 3, mergeSpan).Merge()
	End Sub

	Private Shared Sub EscribirHojaResumenAuxiliaresExcel(ws As ClosedXML.Excel.IXLWorksheet, titulo As String, lineaGenerado As String, lineaFiltros As String, datos As Object(), columnas As String())
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
			EscribirLineaFiltrosAuxExcel(ws, lineaFiltros, mergeSpan)
			filaInicio = 5
		End If

		For i As Integer = 0 To numCols - 1
			ws.Cell(filaInicio, i + 1).Value = columnas(i)
			AplicarEstiloEncabezadoTablaExcel(ws.Cell(filaInicio, i + 1))
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
				If EsFilaRubroExcel(idict) Then
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

	Private Shared Sub EscribirHojaAuxiliaresExcel(ws As ClosedXML.Excel.IXLWorksheet, titulo As String, lineaGenerado As String, lineaFiltros As String, datos As Object(), columnas As String())
		Dim numCols As Integer = columnas.Length
		Dim mergeSpan As Integer = Math.Max(numCols, 1)

		ws.Cell(1, 1).Value = titulo
		ws.Cell(1, 1).Style.Font.Bold = True
		ws.Cell(1, 1).Style.Font.FontSize = 14
		ws.Range(1, 1, 1, mergeSpan).Merge()

		ws.Cell(2, 1).Value = lineaGenerado
		ws.Cell(2, 1).Style.Font.Italic = True
		ws.Range(2, 1, 2, mergeSpan).Merge()

		Dim filaInicio As Integer = 4
		If Not String.IsNullOrWhiteSpace(lineaFiltros) Then
			EscribirLineaFiltrosAuxExcel(ws, lineaFiltros, mergeSpan)
			filaInicio = 5
		End If

		For i As Integer = 0 To numCols - 1
			ws.Cell(filaInicio, i + 1).Value = columnas(i)
			AplicarEstiloEncabezadoTablaExcel(ws.Cell(filaInicio, i + 1))
		Next

		Dim tieneFilas As Boolean = datos IsNot Nothing AndAlso datos.Length > 0
		Dim ultFila As Integer = filaInicio

		If tieneFilas Then
			For r As Integer = 0 To datos.Length - 1
				Dim idict As IDictionary = TryCast(datos(r), IDictionary)
				For c As Integer = 0 To numCols - 1
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

		If tieneFilas Then
			ws.Range(filaInicio, 1, ultFila, numCols).Style.Border.OutsideBorder = ClosedXML.Excel.XLBorderStyleValues.Thin
			ws.Range(filaInicio, 1, ultFila, numCols).Style.Border.InsideBorder = ClosedXML.Excel.XLBorderStyleValues.Thin
		Else
			ws.Range(filaInicio, 1, ultFila, mergeSpan).Style.Border.OutsideBorder = ClosedXML.Excel.XLBorderStyleValues.Thin
		End If
	End Sub

	''' <summary>Devuelve Nothing si el JSON de filtro está vacío, es [] o no es válido.</summary>
	Private Shared Function NormalizarJsonArrayFiltro(json As String) As String
		If String.IsNullOrWhiteSpace(json) Then
			Return Nothing
		End If
		Dim t As String = json.Trim()
		If t = "[]" OrElse String.Equals(t, "null", StringComparison.OrdinalIgnoreCase) Then
			Return Nothing
		End If
		Return t
	End Function

End Class
