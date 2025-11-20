Imports System.Web.Services
Imports System.Web.Script.Services
Imports System.Web.Script.Serialization
Imports System.Data
Imports SBSqlClient
Imports SBUtility

Public Class Reportes
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        ' Manejar descarga de archivos
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

    <WebMethod()>
    <ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
    Public Shared Function ObtenerReportes() As String
        Dim resultado As String = ""
        Dim serializer As New JavaScriptSerializer()

        Try
            ModGlobal.EscribirLog("ESTA EJECUTANDO EL METODO ObtenerReportes")

            ' Obtener ID del usuario desde la sesión
            Dim usuarioId As Integer = 0
            If HttpContext.Current.Session(VariablesSesion.UsuarioId) IsNot Nothing Then
                Integer.TryParse(HttpContext.Current.Session(VariablesSesion.UsuarioId).ToString(), usuarioId)
            End If

            ModGlobal.EscribirLog("Parametro obtenido - UsuarioId: " & usuarioId.ToString())

            If usuarioId = 0 Then
                ModGlobal.EscribirLog("Validacion: Usuario no autenticado")
                Dim errorResponse As New With {
                    .Resultado = "ERROR",
                    .Mensaje = "Usuario no autenticado",
                    .Data = ""
                }
                Return serializer.Serialize(errorResponse)
            End If

            ' Verificar cadena de conexión
            Dim connectionString As String = ""
            If HttpContext.Current.Session(VariablesSesion.ConnectionString) IsNot Nothing Then
                connectionString = HttpContext.Current.Session(VariablesSesion.ConnectionString).ToString()
            End If

            If String.IsNullOrEmpty(connectionString) Then
                ModGlobal.EscribirLog("Validacion: Cadena de conexion no encontrada")
                Dim errorResponse As New With {
                    .Resultado = "ERROR",
                    .Mensaje = "Cadena de conexión no encontrada",
                    .Data = ""
                }
                Return serializer.Serialize(errorResponse)
            End If

            ' Ejecutar stored procedure usando el patrón correcto
            Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
            Dim sSql As String = "Exec spReportes_Listar"

            With objSql.Parametros
                .Add("@IdUsuario", usuarioId)
            End With

            ModGlobal.EscribirLog($"Ejecutando SQL: {sSql} {objSql.getParamList()}")
            Dim dt As DataTable = objSql.GetDataTableSql(sSql)

            ' Verificar si hubo error en la base de datos
            If objSql.MensajeError <> "" Then
                ModGlobal.EscribirLog("Error en BD al obtener reportes: " & objSql.MensajeError)
                Dim errorResponse As New With {
                    .Resultado = "ERROR",
                    .Mensaje = "Error en la base de datos: " & objSql.MensajeError,
                    .Data = ""
                }
                Return serializer.Serialize(errorResponse)
            End If

            ModGlobal.EscribirLog("Ejecucion SQL completada sin errores. Registros obtenidos: " & If(dt IsNot Nothing, dt.Rows.Count.ToString(), "0"))

            If dt IsNot Nothing AndAlso dt.Rows.Count > 0 Then
                Dim reportes As New List(Of Object)

                For Each row As DataRow In dt.Rows
                    Dim reporte As New With {
                        .ID = If(IsDBNull(row("ID")), 0, Convert.ToInt32(row("ID"))),
                        .Nombre = If(IsDBNull(row("Nombre")), "", row("Nombre").ToString()),
                        .Tipo = If(IsDBNull(row("Tipo")), "", row("Tipo").ToString()),
                        .Comando = If(IsDBNull(row("Comando")), "", row("Comando").ToString()),
                        .Descripcion = If(IsDBNull(row("Descripcion")), "", row("Descripcion").ToString()),
                        .SnActivo = If(IsDBNull(row("SnActivo")), False, Convert.ToBoolean(row("SnActivo"))),
                        .SnEliminado = If(IsDBNull(row("SnEliminado")), False, Convert.ToBoolean(row("SnEliminado")))
                    }
                    reportes.Add(reporte)
                Next

                ModGlobal.EscribirLog("Reportes procesados: " & reportes.Count.ToString())

                Dim successResponse As New With {
                    .Resultado = "SUCCESS",
                    .Mensaje = "Reportes obtenidos exitosamente",
                    .Data = serializer.Serialize(reportes)
                }
                resultado = serializer.Serialize(successResponse)
            Else
                ModGlobal.EscribirLog("Validacion: No se encontraron reportes")
                Dim emptyResponse As New With {
                    .Resultado = "SUCCESS",
                    .Mensaje = "No se encontraron reportes",
                    .Data = ""
                }
                resultado = serializer.Serialize(emptyResponse)
            End If

            ModGlobal.EscribirLog("Metodo ObtenerReportes completado exitosamente")
        Catch ex As Exception
            ModGlobal.EscribirLog("Error en ObtenerReportes: " & ex.Message & " | StackTrace: " & ex.StackTrace)

            Dim errorResponse As New With {
                .Resultado = "ERROR",
                .Mensaje = "Error al obtener reportes: " & ex.Message,
                .Data = ""
            }
            resultado = serializer.Serialize(errorResponse)
        End Try

        Return resultado
    End Function

    <WebMethod()>
    <ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
    Public Shared Function EjecutarComandoReporte(idReporte As Integer, nombreReporte As String, comandoSQL As String) As String
        Dim resultado As String = ""
        Dim serializer As New JavaScriptSerializer()

        Try
            ModGlobal.EscribirLog("ESTA EJECUTANDO EL METODO EjecutarComandoReporte")
            ModGlobal.EscribirLog($"Parametros recibidos - IDReporte: {idReporte}, NombreReporte: {nombreReporte}, ComandoSQL: {comandoSQL}")

            ' Obtener ID del usuario desde la sesión
            Dim usuarioId As Integer = 0
            If HttpContext.Current.Session(VariablesSesion.UsuarioId) IsNot Nothing Then
                Integer.TryParse(HttpContext.Current.Session(VariablesSesion.UsuarioId).ToString(), usuarioId)
            End If

            ModGlobal.EscribirLog("Parametro obtenido - UsuarioId: " & usuarioId.ToString())

            If usuarioId = 0 Then
                ModGlobal.EscribirLog("Validacion: Usuario no autenticado")
                Dim errorResponse As New With {
                    .Resultado = "ERROR",
                    .Mensaje = "Usuario no autenticado",
                    .Data = ""
                }
                Return serializer.Serialize(errorResponse)
            End If

            ' Verificar cadena de conexión
            Dim connectionString As String = ""
            If HttpContext.Current.Session(VariablesSesion.ConnectionString) IsNot Nothing Then
                connectionString = HttpContext.Current.Session(VariablesSesion.ConnectionString).ToString()
            End If

            If String.IsNullOrEmpty(connectionString) Then
                ModGlobal.EscribirLog("Validacion: Cadena de conexion no encontrada")
                Dim errorResponse As New With {
                    .Resultado = "ERROR",
                    .Mensaje = "Cadena de conexión no encontrada",
                    .Data = ""
                }
                Return serializer.Serialize(errorResponse)
            End If

            ' Ejecutar comando SQL usando el patrón correcto
            Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
            Dim sSql As String = comandoSQL

            objSql.Parametros.Add("@IdUsuario", usuarioId)

            ModGlobal.EscribirLog($"Ejecutando SQL: {sSql} {objSql.getParamList()}")
            Dim dt As DataTable = objSql.GetDataTableSql(sSql)

            ' Verificar si hubo error en la base de datos
            If objSql.MensajeError <> "" Then
                ModGlobal.EscribirLog("Error en BD al ejecutar comando: " & objSql.MensajeError)
                Dim errorResponse As New With {
                    .Resultado = "ERROR",
                    .Mensaje = "Error en la base de datos: " & objSql.MensajeError,
                    .Data = ""
                }
                Return serializer.Serialize(errorResponse)
            End If

            ModGlobal.EscribirLog("Ejecucion SQL completada sin errores. Registros obtenidos: " & If(dt IsNot Nothing, dt.Rows.Count.ToString(), "0"))

            If dt IsNot Nothing AndAlso dt.Rows.Count > 0 Then
                Dim resultados As New List(Of Object)

                For Each row As DataRow In dt.Rows
                    Dim fila As New Dictionary(Of String, Object)
                    For Each col As DataColumn In dt.Columns
                        If IsDBNull(row(col)) Then
                            fila(col.ColumnName) = ""
                        Else
                            ' Preservar el formato original del valor
                            Dim valor As Object = row(col)
                            If TypeOf valor Is Decimal OrElse TypeOf valor Is Double OrElse TypeOf valor Is Single Then
                                ' Para números, usar formato con coma decimal
                                Dim numero As Decimal = Convert.ToDecimal(valor)
                                fila(col.ColumnName) = numero '.ToString("N2").Replace(".", ",")
                            Else
                                fila(col.ColumnName) = valor.ToString()
                            End If
                        End If
                    Next
                    resultados.Add(fila)
                Next

                ModGlobal.EscribirLog("Resultados procesados: " & resultados.Count.ToString())

                Dim successResponse As New With {
                    .Resultado = "SUCCESS",
                    .Mensaje = "Comando ejecutado exitosamente",
                    .Data = serializer.Serialize(resultados)
                }
                resultado = serializer.Serialize(successResponse)
            Else
                ModGlobal.EscribirLog("Validacion: No se encontraron resultados")
                Dim emptyResponse As New With {
                    .Resultado = "SUCCESS",
                    .Mensaje = "No se encontraron resultados",
                    .Data = ""
                }
                resultado = serializer.Serialize(emptyResponse)
            End If

            ModGlobal.EscribirLog("Metodo EjecutarComandoReporte completado exitosamente")
        Catch ex As Exception
            ModGlobal.EscribirLog("Error en EjecutarComandoReporte: " & ex.Message & " | StackTrace: " & ex.StackTrace)

            Dim errorResponse As New With {
                .Resultado = "ERROR",
                .Mensaje = "Error al ejecutar comando: " & ex.Message,
                .Data = ""
            }
            resultado = serializer.Serialize(errorResponse)
        End Try

        Return resultado
    End Function

    <WebMethod()>
    <ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
    Public Shared Function ExportarAExcel(nombreReporte As String, datos As Object()) As String
        Dim resultado As String = ""
        Dim serializer As New JavaScriptSerializer()

        Try
            ModGlobal.EscribirLog("ESTA EJECUTANDO EL METODO ExportarAExcel")
            ModGlobal.EscribirLog($"Parametros recibidos - NombreReporte: {nombreReporte}, CantidadRegistros: {datos.Length}")

            ' Generar nombre de archivo único
            Dim nombreArchivo As String = $"{nombreReporte}_{DateTime.Now:yyyyMMdd_HHmmss}.xlsx"
            nombreArchivo = nombreArchivo.Replace(" ", "_").Replace("/", "_")

            ' Crear workbook con ClosedXML
            Using workbook As New ClosedXML.Excel.XLWorkbook()
                Dim worksheet = workbook.Worksheets.Add("Reporte")

                ' Agregar título
                worksheet.Cell(1, 1).Value = nombreReporte
                worksheet.Cell(1, 1).Style.Font.Bold = True
                worksheet.Cell(1, 1).Style.Font.FontSize = 14
                worksheet.Range(1, 1, 1, 10).Merge()

                ' Agregar fecha de generación
                worksheet.Cell(2, 1).Value = "Generado el: " & DateTime.Now.ToString("dd/MM/yyyy HH:mm:ss")
                worksheet.Cell(2, 1).Style.Font.Italic = True
                worksheet.Range(2, 1, 2, 10).Merge()

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

            Dim successResponse As New With {
                .Resultado = "SUCCESS",
                .Mensaje = "Archivo Excel generado exitosamente",
                .NombreArchivo = nombreArchivo
            }
            resultado = serializer.Serialize(successResponse)
            ModGlobal.EscribirLog("Metodo ExportarAExcel completado exitosamente")

        Catch ex As Exception
            ModGlobal.EscribirLog("Error en ExportarAExcel: " & ex.Message & " | StackTrace: " & ex.StackTrace)

            Dim errorResponse As New With {
                .Resultado = "ERROR",
                .Mensaje = "Error al generar archivo Excel: " & ex.Message,
                .NombreArchivo = ""
            }
            resultado = serializer.Serialize(errorResponse)
        End Try

        Return resultado
    End Function

    <WebMethod()>
    <ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
    Public Shared Function ExportarACSV(nombreReporte As String, datos As Object(), separador As String) As String
        Dim resultado As String = ""
        Dim serializer As New JavaScriptSerializer()

        Try
            ModGlobal.EscribirLog("ESTA EJECUTANDO EL METODO ExportarACSV")
            ModGlobal.EscribirLog($"Parametros recibidos - NombreReporte: {nombreReporte}, CantidadRegistros: {datos.Length}, Separador: {separador}")

            ' Validar separador
            If String.IsNullOrEmpty(separador) Then
                separador = ","
                ModGlobal.EscribirLog("Validacion: Separador vacio, usando separador por defecto: ,")
            End If

            ' Generar nombre de archivo único
            Dim nombreArchivo As String = $"{nombreReporte}_{DateTime.Now:yyyyMMdd_HHmmss}.csv"
            nombreArchivo = nombreArchivo.Replace(" ", "_").Replace("/", "_")

            ' Crear archivo CSV
            Dim rutaArchivo As String = HttpContext.Current.Server.MapPath("~/Temp/" & nombreArchivo)
            Dim directorioTemp As String = HttpContext.Current.Server.MapPath("~/Temp/")

            ' Crear directorio si no existe
            If Not System.IO.Directory.Exists(directorioTemp) Then
                System.IO.Directory.CreateDirectory(directorioTemp)
            End If

            Using writer As New System.IO.StreamWriter(rutaArchivo, False, System.Text.Encoding.UTF8)
                If datos.Length > 0 Then
                    ' Obtener columnas del primer registro
                    Dim columnas As New List(Of String)
                    For Each key In datos(0).Keys
                        columnas.Add(key)
                    Next

                    ' Escribir encabezados
                    writer.WriteLine(String.Join(separador, columnas.Select(Function(col) """" & col & """")))

                    ' Escribir datos
                    For Each registro In datos
                        Dim valores As New List(Of String)
                        For Each col In columnas
                            Dim valor As String = If(registro(col) IsNot Nothing, registro(col).ToString().Replace("""", """"""), "")
                            valores.Add("""" & valor & """")
                        Next
                        writer.WriteLine(String.Join(separador, valores))
                    Next
                End If
            End Using

            ModGlobal.EscribirLog("Archivo CSV guardado exitosamente: " & nombreArchivo)

            Dim successResponse As New With {
                .Resultado = "SUCCESS",
                .Mensaje = "Archivo CSV generado exitosamente",
                .NombreArchivo = nombreArchivo
            }
            resultado = serializer.Serialize(successResponse)
            ModGlobal.EscribirLog("Metodo ExportarACSV completado exitosamente")

        Catch ex As Exception
            ModGlobal.EscribirLog("Error en ExportarACSV: " & ex.Message & " | StackTrace: " & ex.StackTrace)

            Dim errorResponse As New With {
                .Resultado = "ERROR",
                .Mensaje = "Error al generar archivo CSV: " & ex.Message,
                .NombreArchivo = ""
            }
            resultado = serializer.Serialize(errorResponse)
        End Try

        Return resultado
    End Function


End Class