Imports System.Web.Services
Imports System.Web.Script.Services
Imports System.Web.Script.Serialization
Imports System.Data
Imports System.Collections
Imports System.Globalization
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

	Private Shared Sub AgregarParametrosConsultaAsientos(objSql As SBSqlClientInterface, fechaDesde As Object, fechaHasta As Object, mesHistorial As Object, anioHistorial As Object, versionHistorial As Object)
		With objSql.Parametros
			If fechaDesde IsNot Nothing AndAlso Not String.IsNullOrWhiteSpace(fechaDesde.ToString()) AndAlso fechaDesde.ToString().Length = 8 Then
				.Add("@FechaDesde", fechaDesde.ToString())
			End If
			If fechaHasta IsNot Nothing AndAlso Not String.IsNullOrWhiteSpace(fechaHasta.ToString()) AndAlso fechaHasta.ToString().Length = 8 Then
				.Add("@FechaHasta", fechaHasta.ToString())
			End If
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
	Public Shared Function ListarPeriodosHistorialAsientos() As String
		Dim serializer As New JavaScriptSerializer()
		Try
			Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
			Dim sSql As String = "Exec spAsientos_Historial_ListarPeriodos"
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
			ModGlobal.EscribirLog($"Error en ListarPeriodosHistorialAsientos: {ex.Message}")
			Return serializer.Serialize(New Dictionary(Of String, Object) From {
				{"Success", False},
				{"Message", "Error al listar periodos de historial: " & ex.Message},
				{"Data", New List(Of Object)()}
			})
		End Try
	End Function

	<WebMethod(EnableSession:=True)>
	<ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
	Public Shared Function ListarAsientos(fechaDesde As String, fechaHasta As String, mesHistorial As Object, anioHistorial As Object, versionHistorial As Object) As String
		Dim serializer As New JavaScriptSerializer()
		Try
			ModGlobal.EscribirLog("ListarAsientos iniciado")

			Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
			Dim sSql As String = "Exec spAsientos_Reporte"
			AgregarParametrosConsultaAsientos(objSql, fechaDesde, fechaHasta, mesHistorial, anioHistorial, versionHistorial)

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
	Public Shared Function ListarAsientosResumen(fechaDesde As String, fechaHasta As String, mesHistorial As Object, anioHistorial As Object, versionHistorial As Object) As String
		Dim serializer As New JavaScriptSerializer()
		Try
			ModGlobal.EscribirLog("ListarAsientosResumen iniciado")

			Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
			Dim sSql As String = "Exec spAsientos_ReporteResumen"
			AgregarParametrosConsultaAsientos(objSql, fechaDesde, fechaHasta, mesHistorial, anioHistorial, versionHistorial)

			ModGlobal.EscribirLog($"Ejecutando: {sSql} {objSql.getParamList()}")
			Dim dt As DataTable = objSql.GetDataTableSql(sSql)

			If objSql.MensajeError <> "" Then
				ModGlobal.EscribirLog("Error en BD al listar resumen asientos: " & objSql.MensajeError)
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
			ModGlobal.EscribirLog($"Error en ListarAsientosResumen: {ex.Message} | StackTrace: {ex.StackTrace}")
			Dim resultError As New Dictionary(Of String, Object)
			resultError("Success") = False
			resultError("Message") = "Error al listar resumen: " & ex.Message
			resultError("Data") = New List(Of Object)
			Return serializer.Serialize(resultError)
		End Try
	End Function

	''' <summary>
	''' Ejecuta spAsientos_ListarTotales y devuelve Trans, Débito, Crédito, Balance como texto (formato N2 en montos).
	''' </summary>
	Private Shared Function ObtenerTotalesDesdeSp(fechaDesde As String, fechaHasta As String, mesHistorial As Object, anioHistorial As Object, versionHistorial As Object) As Dictionary(Of String, Object)
		Dim item As New Dictionary(Of String, Object) From {
			{"Trans", "0"},
			{"Débito", "0,00"},
			{"Crédito", "0,00"},
			{"Balance", "0,00"}
		}
		Try
			Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
			Dim sSql As String = "Exec spAsientos_ListarTotales"
			AgregarParametrosConsultaAsientos(objSql, fechaDesde, fechaHasta, mesHistorial, anioHistorial, versionHistorial)
			Dim dt As DataTable = objSql.GetDataTableSql(sSql)
			If objSql.MensajeError <> "" Then
				ModGlobal.EscribirLog("ObtenerTotalesDesdeSp error BD: " & objSql.MensajeError)
				Return item
			End If
			If dt IsNot Nothing AndAlso dt.Rows.Count > 0 Then
				Dim row As DataRow = dt.Rows(0)
				For Each col As DataColumn In dt.Columns
					If row.IsNull(col) Then
						item(col.ColumnName) = ""
					Else
						item(col.ColumnName) = row(col).ToString()
					End If
				Next
			End If
		Catch ex As Exception
			ModGlobal.EscribirLog("ObtenerTotalesDesdeSp: " & ex.Message)
		End Try
		Return item
	End Function

	<WebMethod(EnableSession:=True)>
	<ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
	Public Shared Function ListarTotalesAsientos(fechaDesde As String, fechaHasta As String, mesHistorial As Object, anioHistorial As Object, versionHistorial As Object) As String
		Dim serializer As New JavaScriptSerializer()
		Try
			ModGlobal.EscribirLog("ListarTotalesAsientos iniciado")
			Dim item As Dictionary(Of String, Object) = ObtenerTotalesDesdeSp(fechaDesde, fechaHasta, mesHistorial, anioHistorial, versionHistorial)
			Dim resultSuccess As New Dictionary(Of String, Object)
			resultSuccess("Success") = True
			resultSuccess("Message") = ""
			resultSuccess("Data") = item
			Return serializer.Serialize(resultSuccess)
		Catch ex As Exception
			ModGlobal.EscribirLog($"Error en ListarTotalesAsientos: {ex.Message} | StackTrace: {ex.StackTrace}")
			Dim resultError As New Dictionary(Of String, Object)
			resultError("Success") = False
			resultError("Message") = "Error al obtener totales: " & ex.Message
			resultError("Data") = Nothing
			Return serializer.Serialize(resultError)
		End Try
	End Function

	''' <summary>
	''' Interpreta montos desde texto: acepta FORMAT SQL 'N2' (en-US: 10,097.77) y formato es-ES (10.097,77).
	''' El separador decimal es la coma o el punto que aparezca más a la derecha.
	''' </summary>
	Private Shared Function ParseMontoEs(val As Object) As Decimal
		If val Is Nothing Then Return 0D
		Dim s As String = val.ToString().Trim().Replace(" ", "").Replace(ChrW(&HA0), "") ' espacio duro
		If s = "" OrElse s = "-" Then Return 0D
		Dim neg As Boolean = False
		If s.StartsWith("-") Then
			neg = True
			s = s.Substring(1).Trim()
		End If
		Dim lastComma As Integer = s.LastIndexOf(","c)
		Dim lastDot As Integer = s.LastIndexOf("."c)
		Dim normalized As String
		If lastComma > lastDot Then
			' Punto = miles, coma = decimal (es-ES)
			normalized = s.Replace(".", "").Replace(",", ".")
		ElseIf lastDot > lastComma Then
			' Coma = miles, punto = decimal (Invariant / FORMAT SQL)
			normalized = s.Replace(",", "")
		Else
			' Solo coma, solo punto o solo dígitos
			If lastComma >= 0 Then
				normalized = s.Replace(".", "").Replace(",", ".")
			Else
				normalized = s
			End If
		End If
		Dim d As Decimal
		If Decimal.TryParse(normalized, NumberStyles.Number, CultureInfo.InvariantCulture, d) Then
			Return If(neg, -d, d)
		End If
		Return 0D
	End Function

	Private Shared Function SumarColumnaDatos(datos As Object(), nombreCol As String) As Decimal
		If datos Is Nothing Then Return 0D
		Dim t As Decimal = 0D
		For Each item In datos
			Dim id As IDictionary = TryCast(item, IDictionary)
			If id IsNot Nothing AndAlso id.Contains(nombreCol) Then
				t += ParseMontoEs(id(nombreCol))
			End If
		Next
		Return t
	End Function

	''' <summary>
	''' Suma balance por línea: columna Balance si viene informada; si no, Débito − Crédito.
	''' </summary>
	Private Shared Function SumarBalanceLineasDetalle(datos As Object()) As Decimal
		If datos Is Nothing Then Return 0D
		Dim t As Decimal = 0D
		For Each item In datos
			Dim id As IDictionary = TryCast(item, IDictionary)
			If id Is Nothing Then Continue For
			If id.Contains("Balance") AndAlso id("Balance") IsNot Nothing AndAlso Not String.IsNullOrWhiteSpace(id("Balance").ToString()) Then
				t += ParseMontoEs(id("Balance"))
			Else
				t += ParseMontoEs(id("Débito")) - ParseMontoEs(id("Crédito"))
			End If
		Next
		Return t
	End Function

	''' <summary>
	''' Fila de IDs distintos + TOTALES (Débito, Crédito, Balance) desde spAsientos_ListarTotales (mismo criterio en Resumen y Detallado).
	''' </summary>
	Private Shared Sub AgregarFilaTotalesAsientosHoja(ws As ClosedXML.Excel.IXLWorksheet, ultFilaDatos As Integer, columnas As String(), transCount As Integer, sumD As Decimal, sumC As Decimal, sumB As Decimal)
		Dim numCols As Integer = columnas.Length
		Dim idxD0 As Integer = System.Array.IndexOf(columnas, "Débito")
		Dim idxC0 As Integer = System.Array.IndexOf(columnas, "Crédito")
		Dim idxB0 As Integer = System.Array.IndexOf(columnas, "Balance")
		If idxD0 < 0 OrElse idxC0 < 0 Then Return

		Dim colD As Integer = idxD0 + 1
		Dim colC As Integer = idxC0 + 1
		Dim colB As Integer = If(idxB0 >= 0, idxB0 + 1, colC)

		Dim rTxn As Integer = ultFilaDatos + 2
		ws.Range(rTxn, 1, rTxn, numCols).Merge()
		ws.Cell(rTxn, 1).Value = "Total transacciones (IDs distintos): " & transCount.ToString()
		ws.Cell(rTxn, 1).Style.Alignment.Horizontal = ClosedXML.Excel.XLAlignmentHorizontalValues.Center

		Dim rTot As Integer = ultFilaDatos + 3

		ws.Range(rTot, 1, rTot, colD - 1).Merge()
		ws.Cell(rTot, 1).Value = "TOTALES"
		ws.Cell(rTot, 1).Style.Font.Bold = True
		ws.Cell(rTot, 1).Style.Alignment.Horizontal = ClosedXML.Excel.XLAlignmentHorizontalValues.Right
		ws.Cell(rTot, colD).Value = sumD
		ws.Cell(rTot, colC).Value = sumC
		ws.Cell(rTot, colB).Value = sumB
		ws.Cell(rTot, colD).Style.Font.Bold = True
		ws.Cell(rTot, colC).Style.Font.Bold = True
		ws.Cell(rTot, colB).Style.Font.Bold = True
		ws.Cell(rTot, colD).Style.NumberFormat.Format = "#,##0.00"
		ws.Cell(rTot, colC).Style.NumberFormat.Format = "#,##0.00"
		ws.Cell(rTot, colB).Style.NumberFormat.Format = "#,##0.00"
		If sumB < 0D Then
			ws.Cell(rTot, colB).Style.Font.FontColor = ClosedXML.Excel.XLColor.Red
		End If
		ws.Range(rTot, 1, rTot, numCols).Style.Border.OutsideBorder = ClosedXML.Excel.XLBorderStyleValues.Medium
	End Sub

	Private Shared Sub AplicarEstiloEncabezadoTablaExcel(celda As ClosedXML.Excel.IXLCell)
		celda.Style.Font.Bold = True
		celda.Style.Font.FontColor = ClosedXML.Excel.XLColor.White
		celda.Style.Fill.BackgroundColor = ClosedXML.Excel.XLColor.FromHtml("#1A3A5C")
	End Sub

	Private Shared Function EsFilaGrupoAsientosExcel(idict As IDictionary) As Boolean
		If idict Is Nothing OrElse Not idict.Contains("EsFilaGrupo") Then Return False
		Dim v = idict("EsFilaGrupo")
		If TypeOf v Is Boolean Then Return CBool(v)
		Return String.Equals(If(v, "").ToString(), "true", StringComparison.OrdinalIgnoreCase)
	End Function

	Private Shared ReadOnly NombresMesesHistorialAsientos As String() = {
		"Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio",
		"Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"
	}

	Private Shared Function FormatearFechaParametroYyyymmdd(fecha As String) As String
		If String.IsNullOrWhiteSpace(fecha) OrElse fecha.Length <> 8 Then Return "-"
		Return fecha.Substring(6, 2) & "/" & fecha.Substring(4, 2) & "/" & fecha.Substring(0, 4)
	End Function

	Private Shared Function ConstruirLineaFiltrosAsientosExcel(fechaDesde As String, fechaHasta As String, mesHistorial As Object, anioHistorial As Object, versionHistorial As Object) As String
		Dim partes As New List(Of String)

		If Not String.IsNullOrWhiteSpace(fechaDesde) AndAlso fechaDesde.Trim().Length = 8 Then
			partes.Add("Fecha desde: " & FormatearFechaParametroYyyymmdd(fechaDesde.Trim()))
		End If

		If Not String.IsNullOrWhiteSpace(fechaHasta) AndAlso fechaHasta.Trim().Length = 8 Then
			partes.Add("Fecha hasta: " & FormatearFechaParametroYyyymmdd(fechaHasta.Trim()))
		End If

		If mesHistorial IsNot Nothing AndAlso anioHistorial IsNot Nothing AndAlso versionHistorial IsNot Nothing Then
			Dim mesHist As Integer
			Dim anioHist As Integer
			Dim verHist As Integer
			If Integer.TryParse(mesHistorial.ToString(), mesHist) AndAlso mesHist >= 1 AndAlso mesHist <= 12 AndAlso
			   Integer.TryParse(anioHistorial.ToString(), anioHist) AndAlso anioHist >= 1980 AndAlso
			   Integer.TryParse(versionHistorial.ToString(), verHist) AndAlso verHist >= 0 Then
				Dim nombreMes As String = NombresMesesHistorialAsientos(mesHist - 1)
				partes.Add("Período historial: " & nombreMes & " " & anioHist.ToString() & " v" & verHist.ToString())
			End If
		End If

		If partes.Count = 0 Then Return ""
		Return "Filtros aplicados: " & String.Join(" — ", partes)
	End Function

	Private Shared Sub EscribirLineaFiltrosExcel(ws As ClosedXML.Excel.IXLWorksheet, lineaFiltros As String, mergeSpan As Integer)
		ws.Cell(3, 1).Value = lineaFiltros
		ws.Cell(3, 1).Style.Font.Italic = True
		ws.Cell(3, 1).Style.Font.FontSize = 11
		ws.Range(3, 1, 3, mergeSpan).Merge()
	End Sub

	Private Shared Function EscribirHojaResumenAsientosPivotExcel(ws As ClosedXML.Excel.IXLWorksheet, titulo As String, lineaGenerado As String, lineaFiltros As String, datos As Object(), columnas As String()) As Integer
		Dim numCols As Integer = columnas.Length
		Dim mergeSpan As Integer = Math.Max(numCols, 1)
		Dim colorGrupo As ClosedXML.Excel.XLColor = ClosedXML.Excel.XLColor.FromHtml("#E3F2FD")

		ws.Cell(1, 1).Value = titulo
		ws.Cell(1, 1).Style.Font.Bold = True
		ws.Cell(1, 1).Style.Font.FontSize = 14
		ws.Range(1, 1, 1, mergeSpan).Merge()

		ws.Cell(2, 1).Value = lineaGenerado
		ws.Cell(2, 1).Style.Font.Italic = True
		ws.Range(2, 1, 2, mergeSpan).Merge()

		Dim filaInicio As Integer = 4
		If Not String.IsNullOrWhiteSpace(lineaFiltros) Then
			EscribirLineaFiltrosExcel(ws, lineaFiltros, mergeSpan)
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
				If EsFilaGrupoAsientosExcel(idict) Then
					Dim rngGrupo = ws.Range(filaExcel, 1, filaExcel, numCols)
					rngGrupo.Style.Font.Bold = True
					rngGrupo.Style.Fill.BackgroundColor = colorGrupo
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
		Return ultFila
	End Function

	''' <summary>
	''' Escribe una hoja con encabezados fijos y filas desde diccionarios (JSON deserializado). Devuelve la última fila ocupada por datos (o la de "Sin registros").
	''' </summary>
	Private Shared Function EscribirHojaAsientosExcel(ws As ClosedXML.Excel.IXLWorksheet, titulo As String, lineaGenerado As String, lineaFiltros As String, datos As Object(), columnas As String()) As Integer
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
			EscribirLineaFiltrosExcel(ws, lineaFiltros, mergeSpan)
			filaInicio = 5
		End If

		For i As Integer = 0 To numCols - 1
			ws.Cell(filaInicio, i + 1).Value = columnas(i)
			ws.Cell(filaInicio, i + 1).Style.Font.Bold = True
			ws.Cell(filaInicio, i + 1).Style.Fill.BackgroundColor = ClosedXML.Excel.XLColor.LightBlue
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

		ws.Columns().AdjustToContents()
		If tieneFilas Then
			ws.Range(filaInicio, 1, ultFila, numCols).Style.Border.OutsideBorder = ClosedXML.Excel.XLBorderStyleValues.Thin
			ws.Range(filaInicio, 1, ultFila, numCols).Style.Border.InsideBorder = ClosedXML.Excel.XLBorderStyleValues.Thin
		Else
			ws.Range(filaInicio, 1, ultFila, mergeSpan).Style.Border.OutsideBorder = ClosedXML.Excel.XLBorderStyleValues.Thin
		End If
		Return ultFila
	End Function

	''' <summary>Orden de columnas del detalle: primera fila del JSON y claves nuevas al final.</summary>
	Private Shared Function ObtenerColumnasDetalleDesdeDatos(datos As Object()) As String()
		Dim cols As New List(Of String)
		Dim seen As New HashSet(Of String)(StringComparer.Ordinal)
		If datos Is Nothing Then Return cols.ToArray()
		For Each rowObj In datos
			Dim idict As IDictionary = TryCast(rowObj, IDictionary)
			If idict Is Nothing Then Continue For
			For Each key As Object In idict.Keys
				Dim k As String = If(key IsNot Nothing, key.ToString(), "")
				If k <> "" AndAlso Not seen.Contains(k) Then
					seen.Add(k)
					cols.Add(k)
				End If
			Next
		Next
		Return cols.ToArray()
	End Function

	<WebMethod(EnableSession:=True)>
	<ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
	Public Shared Function ExportarAExcel(nombreReporte As String, datosResumen As Object(), datosDetalle As Object(), columnasDetalle As String(), fechaDesde As String, fechaHasta As String, mesHistorial As Object, anioHistorial As Object, versionHistorial As Object) As String
		Dim serializer As New JavaScriptSerializer()
		Try
			Dim dr As Object() = If(datosResumen IsNot Nothing, datosResumen, New Object() {})
			Dim dd As Object() = If(datosDetalle IsNot Nothing, datosDetalle, New Object() {})
			ModGlobal.EscribirLog("ExportarAExcel Asientos - Resumen: " & dr.Length.ToString() & ", Detallado: " & dd.Length.ToString())

			Dim fd As String = If(fechaDesde, "")
			Dim fh As String = If(fechaHasta, "")
			Dim tot As Dictionary(Of String, Object) = ObtenerTotalesDesdeSp(fd, fh, mesHistorial, anioHistorial, versionHistorial)
			Dim transCount As Integer = 0
			If tot IsNot Nothing AndAlso tot.ContainsKey("Trans") AndAlso tot("Trans") IsNot Nothing Then
				Integer.TryParse(tot("Trans").ToString(), transCount)
			End If
			Dim sumD As Decimal = If(tot IsNot Nothing AndAlso tot.ContainsKey("Débito"), ParseMontoEs(tot("Débito")), 0D)
			Dim sumC As Decimal = If(tot IsNot Nothing AndAlso tot.ContainsKey("Crédito"), ParseMontoEs(tot("Crédito")), 0D)
			Dim sumB As Decimal = If(tot IsNot Nothing AndAlso tot.ContainsKey("Balance"), ParseMontoEs(tot("Balance")), sumD - sumC)

			Dim colsResumen As String() = {"Grupo / Cuenta", "Trans.", "Débito", "Crédito", "Balance"}
			Dim colsDetalle As String() = If(columnasDetalle IsNot Nothing AndAlso columnasDetalle.Length > 0,
				columnasDetalle, ObtenerColumnasDetalleDesdeDatos(dd))

			Dim nombreArchivo As String = $"Asientos_{DateTime.Now:yyyyMMdd_HHmmss}.xlsx"
			nombreArchivo = nombreArchivo.Replace(" ", "_").Replace("/", "_")
			Dim lineaGen As String = "Generado el: " & DateTime.Now.ToString("dd/MM/yyyy HH:mm:ss")
			Dim lineaFiltros As String = ConstruirLineaFiltrosAsientosExcel(fd, fh, mesHistorial, anioHistorial, versionHistorial)

			Using workbook As New ClosedXML.Excel.XLWorkbook()
				Dim wsResumen = workbook.Worksheets.Add("Resumen")
				Dim ultRes As Integer = EscribirHojaResumenAsientosPivotExcel(wsResumen, nombreReporte & " — Resumen", lineaGen, lineaFiltros, dr, colsResumen)
				AgregarFilaTotalesAsientosHoja(wsResumen, ultRes, colsResumen, transCount, sumD, sumC, sumB)
				wsResumen.Columns().AdjustToContents()

				Dim wsDetallado = workbook.Worksheets.Add("Detallado")
				Dim ultDet As Integer = EscribirHojaAsientosExcel(wsDetallado, nombreReporte & " — Detallado", lineaGen, lineaFiltros, dd, colsDetalle)
				AgregarFilaTotalesAsientosHoja(wsDetallado, ultDet, colsDetalle, transCount, sumD, sumC, sumB)
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
			ModGlobal.EscribirLog("Error ExportarAExcel Asientos: " & ex.Message)
			Dim resultError As New Dictionary(Of String, Object)
			resultError("Resultado") = "ERROR"
			resultError("Mensaje") = "Error al generar Excel: " & ex.Message
			resultError("NombreArchivo") = ""
			Return serializer.Serialize(resultError)
		End Try
	End Function

End Class
