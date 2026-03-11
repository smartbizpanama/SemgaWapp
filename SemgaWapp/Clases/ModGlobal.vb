Imports System.Data.SqlClient
Imports System.Web
Imports System.Web.Script.Serialization
Imports SBSqlClient
Imports SBUtility
Module ModGlobal
    'VARIABLES LOG
    Private log As SBLogWriter
    Public logID As String
    Private LogType As Integer
    Public Sub IniciarSesionLog(Usuario As String)

        LogType = GetAppKey("LogType")
        logID = Guid.NewGuid().ToString.ToUpper
        System.Web.HttpContext.Current.Session(VariablesSesion.logID) = logID

        log = New SBLogWriter(System.Web.HttpContext.Current.Server.MapPath("Logs\LOG.DAT"))

        'log.WriteTxt("Sesión iniciada por " & Usuario & vbCrLf & "Datos sesión: IDS [" & logID & "] - IP [" & GetIp() & "] - HOST [" & GetHost() & "]")
        log.WriteTxt("Sesión iniciada por " & Usuario & " - Datos sesión: ID.S [" & logID & "]")

        'Tipos: 0 = File, 1 = BD

        If LogType = 1 Or LogType = 2 Then
            Dim Cnn As String = ConfigurationManager.AppSettings("ConnectionString").Trim
            Dim uDBA As SBSqlClientInterface = GetDbaObject(Cnn)
            Dim sSql As String = "Exec spSysAppLogInicioSesion"

            ' Crear JSON con información completa de la sesión
            Dim jsonSessionInfo As String = CrearJsonSessionInfo(Usuario, logID)

            With uDBA.Parametros
                .Add("@Usr", Usuario)
                .Add("@SID", logID)
                .Add("@jsonSessionInfo", jsonSessionInfo)
            End With

            EscribirLogSoloArchivo("Ejecutando: " & sSql & " " & uDBA.getParamList())
            Try
                uDBA.ExecuteNonQuerySql(sSql)
                If uDBA.MensajeError <> "" Then
                    EscribirLogSoloArchivo("BD ERROR: InicioSesion - " & uDBA.MensajeError)
                Else
                    EscribirLogSoloArchivo("BD OK: InicioSesion")
                End If
            Catch ex As Exception
                EscribirLogSoloArchivo("BD ERROR: InicioSesion - " & uDBA.LimpiarMsgErrorDB(ex.Message))
                log.WriteTxt("[ID.S: " & logID & "] - " & uDBA.LimpiarMsgErrorDB(ex.Message))
            End Try
        End If

    End Sub


    Sub escribirLogBD(Mensaje As String)
        Dim Cnn As String = ConfigurationManager.AppSettings("ConnectionString").Trim
        Dim uDBA As SBSqlClientInterface = GetDbaObject(Cnn)

        Dim sSql As String = "Exec spSysAppLogAdd"

        With uDBA.Parametros
            .Add("@Men", Mensaje)
            .Add("@SID", System.Web.HttpContext.Current.Session(VariablesSesion.logID))
        End With

        ' Escribir solo a archivo para evitar recursión (EscribirLog -> escribirLogBD -> EscribirLog -> ...)
        EscribirLogSoloArchivo("Ejecutando: " & sSql & " " & uDBA.getParamList())
        Try
            Try
                uDBA.ExecuteNonQuerySql(sSql)
                If uDBA.MensajeError <> "" Then
                    EscribirLogSoloArchivo("BD ERROR: LogAdd - " & uDBA.MensajeError)
                Else
                    EscribirLogSoloArchivo("BD OK: LogAdd")
                End If
            Catch ex As SqlException
                EscribirLogSoloArchivo("BD ERROR: LogAdd - " & ex.Message)
                log.WriteTxt("[ID.S: " & System.Web.HttpContext.Current.Session(VariablesSesion.logID) & "] - " & ex.Message)
            End Try
        Catch ex As Exception
            EscribirLogSoloArchivo("BD ERROR: LogAdd - " & ex.Message)
            log.WriteTxt("[ID.S: " & System.Web.HttpContext.Current.Session(VariablesSesion.logID) & "] - " & ex.Message)
        End Try
    End Sub

    ''' <summary>Escribe al log solo en archivo, sin pasar por BD. Evita recursión cuando ya estamos en escribirLogBD.</summary>
    Private Sub EscribirLogSoloArchivo(mensaje As String)
        If log Is Nothing Then
            Debug.WriteLine(mensaje)
            Return
        End If
        Try
            Dim prefix As String = ""
            If HttpContext.Current IsNot Nothing AndAlso HttpContext.Current.Session IsNot Nothing Then
                Dim usr As Object = HttpContext.Current.Session(VariablesSesion.UsuarioId)
                Dim sid As Object = HttpContext.Current.Session(VariablesSesion.logID)
                prefix = $"[Usr:{If(usr, "")} ID: {If(sid, "")}] - "
            End If
            log.WriteTxt(prefix & mensaje)
        Catch
            log.WriteTxt(mensaje)
        End Try
        Debug.WriteLine(mensaje)
    End Sub


    Sub escribirLogFile(mensaje As String)
        log.WriteTxt($"[Usr:{HttpContext.Current.Session(VariablesSesion.UsuarioId)} ID: {System.Web.HttpContext.Current.Session(VariablesSesion.logID)}] - " & mensaje)
    End Sub
    Public Sub EscribirLog(Mensaje As String)
        If log Is Nothing Then
            Debug.WriteLine(Mensaje)
            Return
        End If
        Select Case LogType
            Case 0
                escribirLogFile(Mensaje)
            Case 1
                escribirLogBD(Mensaje)
            Case 2
                escribirLogFile(Mensaje)
                escribirLogBD(Mensaje)
        End Select

        Debug.WriteLine(Mensaje)
    End Sub

    ''' <summary>Ejecuta GetDataTableSql registrando en log la sentencia antes y el resultado (éxito o error) después.</summary>
    Public Function EjecutarGetDataTableConLog(objSql As SBSqlClientInterface, sSql As String, Optional descripcion As String = "") As DataTable
        Dim params As String = If(objSql IsNot Nothing, objSql.getParamList(), "")
        EscribirLog("Ejecutando: " & sSql & " " & params)
        Dim dt As DataTable = objSql.GetDataTableSql(sSql)
        If objSql.MensajeError <> "" Then
            EscribirLog("BD ERROR: " & If(descripcion <> "", descripcion & " - ", "") & objSql.MensajeError)
        Else
            EscribirLog("BD OK: " & If(descripcion <> "", descripcion, "GetDataTable"))
        End If
        Return dt
    End Function

    ''' <summary>Ejecuta ExecuteNonQuerySql registrando en log la sentencia antes y el resultado (éxito o error) después.</summary>
    Public Sub EjecutarNonQueryConLog(objSql As SBSqlClientInterface, sSql As String, Optional descripcion As String = "")
        Dim params As String = If(objSql IsNot Nothing, objSql.getParamList(), "")
        EscribirLog("Ejecutando: " & sSql & " " & params)
        objSql.ExecuteNonQuerySql(sSql)
        If objSql.MensajeError <> "" Then
            EscribirLog("BD ERROR: " & If(descripcion <> "", descripcion & " - ", "") & objSql.MensajeError)
        Else
            EscribirLog("BD OK: " & If(descripcion <> "", descripcion, "ExecuteNonQuery"))
        End If
    End Sub

    Public Function GetDbaObject(sCnn As String) As SBSqlClientInterface

        Try
            Dim uPass As New SBEncryption
            Dim sCnnStr As String = uPass.Decrypt(sCnn)
            Dim uDBA As New SBSqlClientInterface(sCnnStr)

            Return uDBA
        Catch ex As Exception
            System.Diagnostics.Trace.WriteLine($"{DateTime.Now}: error en GetDbaObject: {ex.Message}")
            System.Diagnostics.Trace.Flush()
        End Try

    End Function

    Public Function GetAppKey(KeyName As String) As String

        Dim val As String
        Try
            val = ConfigurationManager.AppSettings(KeyName)
        Catch ex As Exception
            val = ""
        End Try

        Return val
    End Function

    Private Function CrearJsonSessionInfo(Usuario As String, logID As String) As String
        Try
            Dim context As HttpContext = HttpContext.Current
            Dim request As HttpRequest = context.Request
            Dim session As HttpSessionState = context.Session

            ' Información básica de la sesión
            Dim sessionInfo As New Dictionary(Of String, Object) From {
                {"Usuario", Usuario},
                {"IdSesion", logID},
                {"HoraInicioSesion", DateTime.Now.ToString("yyyy-MM-ddTHH:mm:ss.fffZ")},
                {"Timestamp", DateTimeOffset.Now.ToUnixTimeMilliseconds()}
            }

            ' Información del servidor
            sessionInfo.Add("Servidor", New Dictionary(Of String, Object) From {
                {"ServerName", System.Environment.MachineName},
                {"ServerTime", DateTime.Now.ToString("yyyy-MM-ddTHH:mm:ss.fffZ")},
                {"TimeZone", TimeZoneInfo.Local.Id},
                {"OSVersion", System.Environment.OSVersion.ToString()},
                {"ProcessorCount", System.Environment.ProcessorCount.ToString()},
                {"WorkingSet", System.Environment.WorkingSet.ToString()}
            })

            ' Información de la aplicación
            sessionInfo.Add("Aplicacion", New Dictionary(Of String, Object) From {
                {"AppDomain", AppDomain.CurrentDomain.FriendlyName},
                {"BaseDirectory", AppDomain.CurrentDomain.BaseDirectory},
                {"Version", System.Reflection.Assembly.GetExecutingAssembly().GetName().Version.ToString()},
                {"ProcessId", System.Diagnostics.Process.GetCurrentProcess().Id.ToString()},
                {"ThreadId", System.Threading.Thread.CurrentThread.ManagedThreadId.ToString()}
            })

            ' Información de la petición HTTP
            If request IsNot Nothing Then
                sessionInfo.Add("Request", New Dictionary(Of String, Object) From {
                    {"UserAgent", request.UserAgent},
                    {"UserHostAddress", request.UserHostAddress},
                    {"UserHostName", request.UserHostName},
                    {"HttpMethod", request.HttpMethod},
                    {"Url", request.Url.ToString()},
                    {"RawUrl", request.RawUrl},
                    {"QueryString", request.QueryString.ToString()},
                    {"ContentType", request.ContentType},
                    {"ContentLength", request.ContentLength},
                    {"IsSecureConnection", request.IsSecureConnection},
                    {"IsLocal", request.IsLocal},
                    {"AcceptTypes", If(request.AcceptTypes IsNot Nothing, String.Join(",", request.AcceptTypes), "")},
                    {"Headers", ObtenerHeaders(request)},
                    {"Cookies", ObtenerCookies(request)},
                    {"Form", ObtenerFormData(request)}
                })
            End If

            ' Información de la sesión ASP.NET
            If session IsNot Nothing Then
                sessionInfo.Add("Session", New Dictionary(Of String, Object) From {
                    {"SessionID", session.SessionID},
                    {"Timeout", session.Timeout},
                    {"IsNewSession", session.IsNewSession},
                    {"IsReadOnly", session.IsReadOnly},
                    {"Count", session.Count},
                    {"Mode", session.Mode.ToString()},
                    {"Keys", ObtenerSessionKeys(session)}
                })
            End If

            ' Información del navegador (si está disponible)
            If request IsNot Nothing AndAlso request.Browser IsNot Nothing Then
                sessionInfo.Add("Browser", New Dictionary(Of String, Object) From {
                    {"Browser", request.Browser.Browser},
                    {"Version", request.Browser.Version},
                    {"MajorVersion", request.Browser.MajorVersion},
                    {"MinorVersion", request.Browser.MinorVersion},
                    {"Platform", request.Browser.Platform},
                    {"IsMobileDevice", request.Browser.IsMobileDevice},
                    {"IsCrawler", request.Browser.Crawler},
                    {"JavaScript", request.Browser.JavaScript},
                    {"VBScript", request.Browser.VBScript},
                    {"Frames", request.Browser.Frames},
                    {"Tables", request.Browser.Tables},
                    {"Cookies", request.Browser.Cookies},
                    {"ActiveXControls", request.Browser.ActiveXControls}
                })
            End If

            ' Información de red
            Try
                sessionInfo.Add("Network", New Dictionary(Of String, Object) From {
                    {"LocalIP", ObtenerIPLocal()},
                    {"HostName", System.Environment.MachineName},
                    {"DomainName", System.Environment.UserDomainName},
                    {"UserName", System.Environment.UserName}
                })
            Catch ex As Exception
                sessionInfo.Add("Network", New Dictionary(Of String, Object) From {
                    {"Error", ex.Message}
                })
            End Try

            ' Convertir a JSON
            Dim json As String = Newtonsoft.Json.JsonConvert.SerializeObject(sessionInfo, Newtonsoft.Json.Formatting.Indented)
            Return json

        Catch ex As Exception
            ' En caso de error, devolver JSON básico
            Dim timestamp As String = DateTime.Now.ToString("yyyy-MM-ddTHH:mm:ss.fffZ")
            Return "{""Usuario"":""" & Usuario & """,""IdSesion"":""" & logID & """,""Error"":""" & ex.Message & """,""Timestamp"":""" & timestamp & """}"
        End Try
    End Function

    Private Function ObtenerHeaders(request As HttpRequest) As Dictionary(Of String, String)
        Dim headers As New Dictionary(Of String, String)
        Try
            For Each key As String In request.Headers.AllKeys
                headers.Add(key, request.Headers(key))
            Next
        Catch ex As Exception
            headers.Add("Error", ex.Message)
        End Try
        Return headers
    End Function

    Private Function ObtenerCookies(request As HttpRequest) As Dictionary(Of String, String)
        Dim cookies As New Dictionary(Of String, String)
        Try
            For Each cookieName As String In request.Cookies.AllKeys
                cookies.Add(cookieName, request.Cookies(cookieName).Value)
            Next
        Catch ex As Exception
            cookies.Add("Error", ex.Message)
        End Try
        Return cookies
    End Function

    Private Function ObtenerFormData(request As HttpRequest) As Dictionary(Of String, String)
        Dim formData As New Dictionary(Of String, String)
        Try
            For Each key As String In request.Form.AllKeys
                formData.Add(key, request.Form(key))
            Next
        Catch ex As Exception
            formData.Add("Error", ex.Message)
        End Try
        Return formData
    End Function

    Private Function ObtenerSessionKeys(session As HttpSessionState) As List(Of String)
        Dim keys As New List(Of String)
        Try
            For Each key As String In session.Keys
                keys.Add(key)
            Next
        Catch ex As Exception
            keys.Add("Error: " & ex.Message)
        End Try
        Return keys
    End Function

    Private Function ObtenerIPLocal() As String
        Try
            Dim host As System.Net.IPHostEntry = System.Net.Dns.GetHostEntry(System.Net.Dns.GetHostName())
            For Each ip As System.Net.IPAddress In host.AddressList
                If ip.AddressFamily = System.Net.Sockets.AddressFamily.InterNetwork Then
                    Return ip.ToString()
                End If
            Next
            Return "No disponible"
        Catch ex As Exception
            Return "Error: " & ex.Message
        End Try
    End Function

    ''' <summary>
    ''' Normaliza una ruta de página para comparación (quita ~/ y query string).
    ''' </summary>
    Public Function NormalizarRutaMenu(ruta As String) As String
        If String.IsNullOrWhiteSpace(ruta) Then Return ""
        Dim s As String = ruta.Trim().Replace("\"c, "/"c)
        If s.StartsWith("~/") Then s = s.Substring(2)
        If s.StartsWith("/") Then s = s.Substring(1)
        Dim i As Integer = s.IndexOf("?"c)
        If i >= 0 Then s = s.Substring(0, i)
        Return s.ToLowerInvariant()
    End Function

    ''' <summary>
    ''' Indica si el usuario tiene permiso para acceder a la página actual según los permisos de menú en sesión.
    ''' Si es administrador (MenuPermisosAdmin) o la ruta actual está en MenuPermisosJson, devuelve True.
    ''' </summary>
    Public Function TienePermisoMenuPagina(context As HttpContext) As Boolean
        If context Is Nothing OrElse context.Session Is Nothing Then Return False
        If context.Session("UsuarioId") Is Nothing Then Return False
        If context.Session(VariablesSesion.MenuPermisosAdmin) IsNot Nothing AndAlso
            Convert.ToBoolean(context.Session(VariablesSesion.MenuPermisosAdmin)) Then
            Return True
        End If
        Dim json As String = TryCast(context.Session(VariablesSesion.MenuPermisosJson), String)
        If String.IsNullOrWhiteSpace(json) OrElse json = "[]" Then Return False
        Dim rutaActual As String = NormalizarRutaMenu(context.Request.AppRelativeCurrentExecutionFilePath)
        If String.IsNullOrEmpty(rutaActual) Then Return False
        Try
            Dim serializer As New JavaScriptSerializer()
            Dim lista As Object() = serializer.Deserialize(Of Object())(json)
            For Each item As Object In lista
                Dim d As Dictionary(Of String, Object) = TryCast(item, Dictionary(Of String, Object))
                If d IsNot Nothing AndAlso d.ContainsKey("UrlDestino") AndAlso d("UrlDestino") IsNot Nothing Then
                    Dim urlPermitida As String = NormalizarRutaMenu(d("UrlDestino").ToString())
                    If rutaActual = urlPermitida Then Return True
                End If
            Next
        Catch ex As Exception
            EscribirLog("TienePermisoMenuPagina: " & ex.Message)
        End Try
        Return False
    End Function

    ''' <summary>
    ''' Indica si el usuario tiene permiso para una URL dada (admin o esa URL está en el menú permitido).
    ''' Útil para permitir una acción si el usuario tiene acceso a otra página (ej. asignar permisos si tiene Gestión de usuarios).
    ''' </summary>
    Public Function TienePermisoMenuParaUrl(context As HttpContext, urlDestino As String) As Boolean
        If context Is Nothing OrElse context.Session Is Nothing Then Return False
        If String.IsNullOrWhiteSpace(urlDestino) Then Return False
        If EsPermisosMenuAdmin(context) Then Return True
        If context.Session("UsuarioId") Is Nothing Then Return False
        Dim json As String = TryCast(context.Session(VariablesSesion.MenuPermisosJson), String)
        If String.IsNullOrWhiteSpace(json) OrElse json = "[]" Then Return False
        Dim rutaBuscada As String = NormalizarRutaMenu(urlDestino)
        If String.IsNullOrEmpty(rutaBuscada) Then Return False
        Try
            Dim serializer As New JavaScriptSerializer()
            Dim lista As Object() = serializer.Deserialize(Of Object())(json)
            For Each item As Object In lista
                Dim d As Dictionary(Of String, Object) = TryCast(item, Dictionary(Of String, Object))
                If d IsNot Nothing AndAlso d.ContainsKey("UrlDestino") AndAlso d("UrlDestino") IsNot Nothing Then
                    Dim urlPermitida As String = NormalizarRutaMenu(d("UrlDestino").ToString())
                    If rutaBuscada = urlPermitida Then Return True
                End If
            Next
        Catch ex As Exception
            EscribirLog("TienePermisoMenuParaUrl: " & ex.Message)
        End Try
        Return False
    End Function

    ''' <summary>
    ''' Devuelve True si el usuario es administrador de menú (acceso a todos los mosaicos).
    ''' </summary>
    Public Function EsPermisosMenuAdmin(context As HttpContext) As Boolean
        If context Is Nothing OrElse context.Session Is Nothing Then Return False
        Dim v As Object = context.Session(VariablesSesion.MenuPermisosAdmin)
        Return v IsNot Nothing AndAlso Convert.ToBoolean(v)
    End Function

    ''' <summary>
    ''' Devuelve JSON con array de URLs permitidas para el menú (para filtrar mosaicos en cliente). "true" si es admin.
    ''' </summary>
    Public Function GetPermisosMenuUrlsJson(context As HttpContext) As String
        If context Is Nothing OrElse context.Session Is Nothing Then Return "[]"
        Try
            If EsPermisosMenuAdmin(context) Then Return "true"
            Dim json As String = TryCast(context.Session(VariablesSesion.MenuPermisosJson), String)
            If String.IsNullOrWhiteSpace(json) OrElse json = "[]" Then Return "[]"
            Dim serializer As New JavaScriptSerializer()
            Dim lista As Object() = serializer.Deserialize(Of Object())(json)
            Dim urls As New List(Of String)
            For Each item As Object In lista
                Dim d As Dictionary(Of String, Object) = TryCast(item, Dictionary(Of String, Object))
                If d IsNot Nothing AndAlso d.ContainsKey("UrlDestino") AndAlso d("UrlDestino") IsNot Nothing Then
                    urls.Add(NormalizarRutaMenu(d("UrlDestino").ToString()))
                End If
            Next
            Return serializer.Serialize(urls)
        Catch
            Return "[]"
        End Try
    End Function

    ''' <summary>
    ''' Valida permiso de menú para la página actual. Si no tiene permiso, guarda mensaje en sesión y redirige al Dashboard.
    ''' Llamar al inicio de Page_Load en páginas que requieren validación (excepto Login y Dashboard).
    ''' </summary>
    ''' <returns>True si se redirigió (sin permiso); False si el usuario tiene permiso y puede continuar.</returns>
    Public Function ValidarYRedirigirSiSinPermiso(context As HttpContext) As Boolean
        If context Is Nothing Then Return False
        If Not TienePermisoMenuPagina(context) Then
            context.Session(VariablesSesion.MensajePermiso) = "No tiene permiso para acceder a esta opción."
            context.Response.Redirect("~/Dashboard.aspx", False)
            context.ApplicationInstance.CompleteRequest()
            Return True
        End If
        Return False
    End Function

End Module

