Imports System.Data.SqlClient
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


            Try
                uDBA.ExecuteNonQuerySql(sSql)
                Dim merror As String = uDBA.MensajeError

            Catch ex As Exception
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


        Try

            Try
                uDBA.ExecuteNonQuerySql(sSql)

            Catch ex As SqlException
                log.WriteTxt("[ID.S: " & System.Web.HttpContext.Current.Session(VariablesSesion.logID) & "] - " & ex.Message)
            End Try

        Catch ex As Exception
            log.WriteTxt("[ID.S: " & System.Web.HttpContext.Current.Session(VariablesSesion.logID) & "] - " & ex.Message)
        End Try
    End Sub


    Sub escribirLogFile(mensaje As String)
        log.WriteTxt($"[Usr:{HttpContext.Current.Session(VariablesSesion.UsuarioId)} ID: {System.Web.HttpContext.Current.Session(VariablesSesion.logID)}] - " & mensaje)
    End Sub
    Public Sub EscribirLog(Mensaje As String)

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

End Module

