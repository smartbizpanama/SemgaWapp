Imports System.Web.Services
Imports System.Web.Script.Services
Imports System.IO
Imports System.Data.SqlClient
Imports SBUtility
Imports SBSqlClient

Public Class Respaldos
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        ' Manejar descarga de respaldo
        If Request.QueryString("action") = "download" AndAlso Not String.IsNullOrEmpty(Request.QueryString("id")) Then
            Dim id As Integer
            If Integer.TryParse(Request.QueryString("id"), id) Then
                DescargarRespaldo(id)
            End If
        End If
    End Sub

    <WebMethod(EnableSession:=True)>
    <ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
    Public Shared Function CrearRespaldo(nombreRespaldo As String, descripcion As String) As String
        Try
            ' Obtener la ruta de respaldos desde VariablesSesion
            Dim rutaRespaldos As String = HttpContext.Current.Session(VariablesSesion.BACKUP_DIR).ToString.TrimEnd("\") & "\"
            If String.IsNullOrEmpty(rutaRespaldos) Then
                Dim resultado As New With {
                    .Success = False,
                    .Message = "No se ha configurado la ruta de respaldos"
                }
                Dim serializer1 As New System.Web.Script.Serialization.JavaScriptSerializer()
                Return serializer1.Serialize(resultado)
            End If

            ' Crear directorio si no existe
            If Not Directory.Exists(rutaRespaldos) Then
                Directory.CreateDirectory(rutaRespaldos)
            End If

            ' Generar nombre automático con fecha y hora
            Dim fechaHora As String = DateTime.Now.ToString("yyyyMMdd_HHmmss")
            Dim nombreRespaldoAutomatico As String = $"Respaldo_{fechaHora}"
            Dim nombreArchivo As String = $"{nombreRespaldoAutomatico}.bak"
            Dim rutaCompleta As String = Path.Combine(rutaRespaldos, nombreArchivo)

            ' Obtener cadena de conexión desde la sesión
            Dim connectionString As String = HttpContext.Current.Session(VariablesSesion.ConnectionString)
            If String.IsNullOrEmpty(connectionString) Then
                Dim resultado As New With {
                    .Success = False,
                    .Message = "No se ha configurado la cadena de conexión"
                }
                Dim serializer2 As New System.Web.Script.Serialization.JavaScriptSerializer()
                Return serializer2.Serialize(resultado)
            End If

            ' Decryptar la cadena de conexión
            Dim uPass As New SBEncryption
            Dim connectionStringDecrypted As String = uPass.Decrypt(connectionString)
            Dim connectionStringBuilder As New SqlConnectionStringBuilder(connectionStringDecrypted)
            Dim nombreBaseDatos As String = connectionStringBuilder.InitialCatalog

            ' Crear comando SQL para respaldo (usar solo el nombre, no la ruta completa)
            Dim comandoRespaldo As String = $"BACKUP DATABASE [{nombreBaseDatos}] TO DISK = '{rutaCompleta}' WITH FORMAT, INIT, NAME = '{nombreRespaldoAutomatico}', DESCRIPTION = '{descripcion}'"

            ' Ejecutar respaldo
            Using connection As New SqlConnection(connectionStringDecrypted)
                connection.Open()
                Using command As New SqlCommand(comandoRespaldo, connection)
                    command.CommandTimeout = 0 ' Sin timeout
                    command.ExecuteNonQuery()
                End Using
            End Using

            ' Validar que el archivo de respaldo se creó correctamente
            If Not File.Exists(rutaCompleta) Then
                ModGlobal.EscribirLog("Error: El archivo de respaldo no se creó: " & rutaCompleta)
                Dim resultado As New With {
                    .Success = False,
                    .Message = "Error: El archivo de respaldo no se creó correctamente"
                }
                Dim serializerError As New System.Web.Script.Serialization.JavaScriptSerializer()
                Return serializerError.Serialize(resultado)
            End If

            ' Obtener tamaño del archivo
            Dim fileInfo As New FileInfo(rutaCompleta)
            Dim tamañoArchivo As Long = fileInfo.Length

            ' Validar que el archivo no esté vacío
            If tamañoArchivo = 0 Then
                ModGlobal.EscribirLog("Error: El archivo de respaldo está vacío: " & rutaCompleta)
                Dim resultado As New With {
                    .Success = False,
                    .Message = "Error: El archivo de respaldo está vacío"
                }
                Dim serializerVacio As New System.Web.Script.Serialization.JavaScriptSerializer()
                Return serializerVacio.Serialize(resultado)
            End If

            ' Guardar información en la base de datos
            Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
            Dim sSql As String = "Exec spRespaldos_Guardar"

            With objSql.Parametros
                .Add("@UsuarioGenera", HttpContext.Current.Session(VariablesSesion.UsuarioId))
                .Add("@NombreRespaldo", nombreRespaldoAutomatico)
                .Add("@Descripcion", descripcion)
                .Add("@Ruta", rutaCompleta)
                .Add("@Size", tamañoArchivo)
            End With


            Dim dt As DataTable = objSql.GetDataTableSql(sSql)

            ' Verificar si hubo error en la base de datos
            If objSql.MensajeError <> "" Then
                ModGlobal.EscribirLog("Error al guardar respaldo en BD: " & objSql.MensajeError)
                Dim resultadoError As New With {
                    .Success = False,
                    .Message = "Error al guardar información del respaldo: " & objSql.MensajeError
                }
                Dim serializer3 As New System.Web.Script.Serialization.JavaScriptSerializer()
                Return serializer3.Serialize(resultadoError)
            End If

            Dim resultadoExito As New With {
                .Success = True,
                .Message = "Respaldo creado exitosamente",
                .Ruta = rutaCompleta,
                .Tamaño = tamañoArchivo
            }

            Dim serializer4 As New System.Web.Script.Serialization.JavaScriptSerializer()
            Return serializer4.Serialize(resultadoExito)

        Catch ex As Exception
            ModGlobal.EscribirLog("Error al crear respaldo: " & ex.Message)
            Dim resultadoCatch As New With {
                .Success = False,
                .Message = "Error al crear respaldo: " & ex.Message
            }
            Dim serializer5 As New System.Web.Script.Serialization.JavaScriptSerializer()
            Return serializer5.Serialize(resultadoCatch)
        End Try
    End Function

    <WebMethod(EnableSession:=True)>
    <ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
    Public Shared Function ObtenerRespaldos() As String
        Try
            ModGlobal.EscribirLog("Iniciando ObtenerRespaldos")
            Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
            Dim sSql As String = "Exec spRespaldos_Listar"

            With objSql.Parametros
                .Add("@IncluirEliminados", False)
            End With

            Dim dt As DataTable = objSql.GetDataTableSql(sSql)
            ModGlobal.EscribirLog($"DataTable obtenido: {If(dt IsNot Nothing, dt.Rows.Count.ToString(), "NULL")} filas")

            ' Verificar si hubo error en la base de datos
            If objSql.MensajeError <> "" Then
                ModGlobal.EscribirLog("Error al obtener respaldos: " & objSql.MensajeError)
                Dim resultadoError As New With {
                    .Success = False,
                    .Message = "Error al obtener respaldos: " & objSql.MensajeError,
                    .Data = New List(Of Object)
                }
                Dim serializer6 As New System.Web.Script.Serialization.JavaScriptSerializer()
                Return serializer6.Serialize(resultadoError)
            End If

            Dim respaldos As New List(Of Object)

            ' Verificar si hay datos en el DataTable
            If dt IsNot Nothing AndAlso dt.Rows.Count > 0 Then
                Try
                    For Each row As DataRow In dt.Rows
                        ' Verificar que la fila no sea de resultado (contiene 'Resultado' o 'Mensaje')
                        If Not dt.Columns.Contains("Resultado") AndAlso Not dt.Columns.Contains("Mensaje") Then
                            Dim respaldo As New With {
                                .ID = row("ID").ToString(),
                                .UsuarioGenera = row("UsuarioGenera").ToString(),
                                .NombreUsuario = row("NombreUsuario").ToString(),
                                .FechaHora = row("FechaHora").ToString(),
                                .NombreRespaldo = row("NombreRespaldo").ToString(),
                                .Descripcion = row("Descripcion").ToString(),
                                .Ruta = row("Ruta").ToString(),
                                .Size = row("Size").ToString(),
                                .SizeFormateado = row("SizeFormateado").ToString(),
                                .SnEliminado = CBool(row("SnEliminado")),
                                .Estado = row("Estado").ToString(),
                                .FechaCreacion = row("FechaCreacion").ToString(),
                                .FechaModificacion = If(IsDBNull(row("FechaModificacion")), Nothing, row("FechaModificacion").ToString()),
                                .NombreArchivo = row("NombreArchivo").ToString()
                            }
                            respaldos.Add(respaldo)
                        End If
                    Next
                Catch ex As Exception
                    ModGlobal.EscribirLog("Error al procesar filas: " & ex.Message)
                End Try
            End If

            ModGlobal.EscribirLog($"Respaldos procesados: {respaldos.Count} elementos")
            Dim resultadoExito As New With {
                .Success = True,
                .Message = "Respaldos obtenidos exitosamente",
                .Data = IIf(respaldos.Count = 0, "", respaldos)
            }

            Dim serializer7 As New System.Web.Script.Serialization.JavaScriptSerializer()
            Dim resultado As String = serializer7.Serialize(resultadoExito)
            ModGlobal.EscribirLog($"Resultado serializado: {resultado}")
            Return resultado

        Catch ex As Exception
            ModGlobal.EscribirLog("Error al obtener respaldos: " & ex.Message)
            Dim resultadoCatch As New With {
                .Success = False,
                .Message = "Error al obtener respaldos: " & ex.Message,
                .Data = New List(Of Object)
            }
            Dim serializer8 As New System.Web.Script.Serialization.JavaScriptSerializer()
            Return serializer8.Serialize(resultadoCatch)
        End Try
    End Function

    <WebMethod(EnableSession:=True)>
    <ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
    Public Shared Function EliminarRespaldo(id As Integer) As String
        Try
            Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
            Dim sSql As String = "Exec spRespaldos_Eliminar"

            With objSql.Parametros
                .Add("@ID", id)
                .Add("@UsuarioElimina", HttpContext.Current.Session(VariablesSesion.UsuarioId))
                .Add("@EliminarFisicamente", False)
            End With

            Dim dt As DataTable = objSql.GetDataTableSql(sSql)

            ' Verificar si hubo error en la base de datos
            If objSql.MensajeError <> "" Then
                ModGlobal.EscribirLog("Error al eliminar respaldo: " & objSql.MensajeError)
                Dim resultadoError As New With {
                    .Success = False,
                    .Message = "Error al eliminar respaldo: " & objSql.MensajeError
                }
                Dim serializer9 As New System.Web.Script.Serialization.JavaScriptSerializer()
                Return serializer9.Serialize(resultadoError)
            End If

            If dt.Rows.Count > 0 Then
                Dim resultadoExito As New With {
                    .Success = dt.Rows(0)("Resultado").ToString() = "SUCCESS",
                    .Message = dt.Rows(0)("Mensaje").ToString()
                }
                Dim serializer10 As New System.Web.Script.Serialization.JavaScriptSerializer()
                Return serializer10.Serialize(resultadoExito)
            Else
                Dim resultadoError As New With {
                    .Success = False,
                    .Message = "Error al eliminar respaldo"
                }
                Dim serializer11 As New System.Web.Script.Serialization.JavaScriptSerializer()
                Return serializer11.Serialize(resultadoError)
            End If

        Catch ex As Exception
            ModGlobal.EscribirLog("Error al eliminar respaldo: " & ex.Message)
            Dim resultadoCatch As New With {
                .Success = False,
                .Message = "Error al eliminar respaldo: " & ex.Message
            }
            Dim serializer12 As New System.Web.Script.Serialization.JavaScriptSerializer()
            Return serializer12.Serialize(resultadoCatch)
        End Try
    End Function

    <WebMethod(EnableSession:=True)>
    <ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
    Public Shared Function ObtenerRutaRespaldos() As String
        Try
            Dim rutaRespaldos As String = HttpContext.Current.Session(VariablesSesion.BACKUP_DIR).ToString.TrimEnd("\") & "\"
            If String.IsNullOrEmpty(rutaRespaldos) Then
                rutaRespaldos = "C:\\Respaldos\\"
            End If

            Dim resultado As New With {
                .Success = True,
                .Message = "Ruta obtenida exitosamente",
                .Ruta = rutaRespaldos
            }

            Dim serializer As New System.Web.Script.Serialization.JavaScriptSerializer()
            Return serializer.Serialize(resultado)

        Catch ex As Exception
            ModGlobal.EscribirLog("Error al obtener ruta de respaldos: " & ex.Message)
            Dim resultado As New With {
                .Success = False,
                .Message = "Error al obtener ruta de respaldos: " & ex.Message,
                .Ruta = "C:\\Respaldos\\"
            }
            Dim serializer As New System.Web.Script.Serialization.JavaScriptSerializer()
            Return serializer.Serialize(resultado)
        End Try
    End Function

    Public Shared Sub DescargarRespaldo(id As Integer)
        Try
            ' Obtener información del respaldo
            Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
            Dim sSql As String = "SELECT Ruta, NombreRespaldo FROM tbRespaldos WHERE ID = @ID AND SnEliminado = 0"

            With objSql.Parametros
                .Add("@ID", id)
            End With

            Dim dt As DataTable = objSql.GetDataTableSql(sSql)

            If dt.Rows.Count = 0 Then
                HttpContext.Current.Response.Write("Respaldo no encontrado")
                Return
            End If

            Dim rutaArchivo As String = dt.Rows(0)("Ruta").ToString()
            Dim nombreArchivo As String = dt.Rows(0)("NombreRespaldo").ToString()

            ' Verificar que el archivo existe
            If Not File.Exists(rutaArchivo) Then
                HttpContext.Current.Response.Write("El archivo de respaldo no existe en el servidor")
                Return
            End If

            ' Configurar respuesta para descarga
            Dim response As HttpResponse = HttpContext.Current.Response
            response.Clear()
            response.ContentType = "application/octet-stream"
            response.AddHeader("Content-Disposition", $"attachment; filename={nombreArchivo}.bak")
            response.AddHeader("Content-Length", New FileInfo(rutaArchivo).Length.ToString())

            ' Escribir el archivo al response
            response.WriteFile(rutaArchivo)
            response.Flush()
            response.End()

        Catch ex As Exception
            ModGlobal.EscribirLog("Error al descargar respaldo: " & ex.Message)
            HttpContext.Current.Response.Write("Error al descargar respaldo: " & ex.Message)
        End Try
    End Sub

End Class