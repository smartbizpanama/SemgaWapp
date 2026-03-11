Imports System
Imports System.Data
Imports System.Data.SqlClient
Imports System.Web
Imports System.Web.Services
Imports System.Web.Script.Serialization
Imports SBSqlClient
Imports SBUtility

Public Class Login
    Inherits BasePage

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        ' Verificar si el usuario ya está autenticado
        If User.Identity.IsAuthenticated Then
            Response.Redirect("Dashboard.aspx")
        End If

        ' Configurar headers de seguridad
        Response.Cache.SetCacheability(HttpCacheability.NoCache)
        Response.Cache.SetNoStore()
    End Sub

    <System.Web.Services.WebMethod(EnableSession:=True)>
    Public Shared Function ValidateLogin(username As String, password As String) As String
        Try
            ' Validar entrada
            If String.IsNullOrEmpty(username) OrElse String.IsNullOrEmpty(password) Then
                Return "Usuario y contraseña son requeridos"
            End If

            ' Desencriptar cadena de conexión
            Dim connectionString As String = GetDecryptedConnectionString()
            Dim clientIP As String = GetClientIPAddress()
            Dim sbEncr As New SBEncryption

            password = sbEncr.Encrypt(password)

            ' Llamar al stored procedure
            ModGlobal.EscribirLog("Ejecutando: sp_AutenticarUsuario @Usuario=" & username & ", @DireccionIP=" & clientIP)
            Using conn As New SqlConnection(connectionString)
                Using cmd As New SqlCommand("sp_AutenticarUsuario", conn)
                    cmd.CommandType = CommandType.StoredProcedure
                    cmd.Parameters.AddWithValue("@Usuario", username)
                    cmd.Parameters.AddWithValue("@Clave", password)
                    cmd.Parameters.AddWithValue("@DireccionIP", clientIP)

                    conn.Open()
                    Using reader As SqlDataReader = cmd.ExecuteReader()
                        If reader.Read() Then
                            ModGlobal.EscribirLog("BD OK: sp_AutenticarUsuario")
                            Dim resultado As Integer = Convert.ToInt32(reader("Resultado"))

                            If resultado = 1 Then
                                ' Login exitoso - almacenar datos en sesión

                                StoreUserDataInSession(reader)
                                Return "SUCCESS"
                            Else
                                ' Login fallido - devolver mensaje de error
                                Return reader("Mensaje").ToString()
                            End If
                        Else
                            ModGlobal.EscribirLog("BD OK: sp_AutenticarUsuario (sin filas)")
                            Return "Error al procesar la autenticación"
                        End If
                    End Using
                End Using
            End Using

        Catch ex As Exception
            ModGlobal.EscribirLog("BD ERROR: sp_AutenticarUsuario - " & ex.Message)
            Return "Error interno del servidor: " & ex.Message
        End Try
    End Function

    Private Shared Function GetDecryptedConnectionString() As String
        Try
            Dim encryptedConnectionString As String = System.Configuration.ConfigurationManager.AppSettings("ConnectionString")
            Dim uSec As New SBEncryption
            Return uSec.Decrypt(encryptedConnectionString)
        Catch ex As Exception
            Throw New Exception("Error al desencriptar la cadena de conexión: " & ex.Message)
        End Try
    End Function

    Private Shared Sub CreateAuthenticationTicket(username As String, reader As SqlDataReader)
        ' Crear ticket de autenticación con información del usuario
        Dim userData As String = String.Format("{0}|{1}|{2}|{3}|{4}",
            reader("UsuarioId"),
            reader("Nombre"),
            reader("Apellido"),
            reader("Rol"),
            reader("NivelAcceso"))

        Dim ticket As New System.Web.Security.FormsAuthenticationTicket(
            1,                          ' Version
            username,                   ' User name
            DateTime.Now,               ' Issue time
            DateTime.Now.AddMinutes(1440), ' Expiration time (24 horas)
            False,                      ' Is persistent
            userData,                   ' User data
            System.Web.Security.FormsAuthentication.FormsCookiePath)

        ' Encriptar el ticket
        Dim encryptedTicket As String = System.Web.Security.FormsAuthentication.Encrypt(ticket)

        ' Crear la cookie
        Dim authCookie As New HttpCookie(System.Web.Security.FormsAuthentication.FormsCookieName, encryptedTicket)
        authCookie.HttpOnly = True
        authCookie.Secure = False ' Cambiar a True en producción con HTTPS
        authCookie.SameSite = SameSiteMode.Strict

        ' Agregar la cookie a la respuesta
        HttpContext.Current.Response.Cookies.Add(authCookie)
    End Sub

    Private Shared Function GetClientIPAddress() As String
        Try
            Dim context As HttpContext = HttpContext.Current
            Dim ipAddress As String = context.Request.ServerVariables("HTTP_X_FORWARDED_FOR")

            If String.IsNullOrEmpty(ipAddress) Then
                ipAddress = context.Request.ServerVariables("REMOTE_ADDR")
            End If

            If String.IsNullOrEmpty(ipAddress) Then
                ipAddress = context.Request.UserHostAddress
            End If

            Return ipAddress
        Catch
            Return "Unknown"
        End Try
    End Function

    Private Shared Sub StoreUserDataInSession(reader As SqlDataReader)
        Try
            Dim context As HttpContext = HttpContext.Current

            ' Almacenar datos del usuario en sesión
            IniciarSesionLog(reader("NombreUsuario"))

            context.Session("UsuarioId") = reader("UsuarioId")
            context.Session("Nombre") = reader("Nombre")
            context.Session("Apellido") = reader("Apellido")
            context.Session("NombreUsuario") = reader("NombreUsuario")
            context.Session("Email") = reader("Email")
            context.Session("Rol") = reader("Rol")
            context.Session("Departamento") = reader("Departamento")
            context.Session("NivelAcceso") = reader("NivelAcceso")
            context.Session("RolNombre") = reader("RolNombre")
            context.Session("DepartamentoNombre") = reader("DepartamentoNombre")
            context.Session("IDSesion") = ModGlobal.logID

            ' Almacenar datos de la aplicación
            context.Session("IsAuthenticated") = True
            context.Session("LoginTime") = DateTime.Now
            context.Session("LastActivity") = DateTime.Now

            'cadena de conexion
            context.Session(VariablesSesion.ConnectionString) = System.Configuration.ConfigurationManager.AppSettings("ConnectionString")
            context.Session(VariablesSesion.Environment) = System.Configuration.ConfigurationManager.AppSettings("Environment")

            ' Cargar parámetros del sistema desde tbParamsKeys
            CargarParametrosSistema(context)

            ' Cargar permisos de menú (spMenu_PermisosUsuarios) y guardar JSON en sesión
            CargarPermisosMenuEnSesion(context)
            
            ' Crear ticket de autenticación Forms
            CreateAuthenticationTicket(reader("NombreUsuario").ToString(), reader)

        Catch ex As Exception
            Throw
        End Try
    End Sub

    Private Shared Sub CargarParametrosSistema(context As HttpContext)
        Try
            ' Desencriptar cadena de conexión
            Dim connectionString As String = GetDecryptedConnectionString()
            
            ModGlobal.EscribirLog("Ejecutando: SELECT ParamKey, ParamValue FROM tbParamsKeys")
            Using conn As New SqlConnection(connectionString)
                Using cmd As New SqlCommand("SELECT ParamKey, ParamValue FROM tbParamsKeys", conn)
                    cmd.CommandType = CommandType.Text
                    
                    conn.Open()
                    Using reader As SqlDataReader = cmd.ExecuteReader()
                        While reader.Read()
                            Dim key As String = reader("ParamKey").ToString()
                            Dim value As String = reader("ParamValue").ToString()
                            context.Session(key) = value
                        End While
                    End Using
                End Using
            End Using
            ModGlobal.EscribirLog("BD OK: CargarParametrosSistema")
        Catch ex As Exception
            ModGlobal.EscribirLog("BD ERROR: CargarParametrosSistema - " & ex.Message)
            ' No lanzar excepción para no interrumpir el login
        End Try
    End Sub

    ''' <summary>
    ''' Carga permisos de menú en sesión desde tbMenuPrincipal + tbMenuUsuario.
    ''' Si NivelAcceso=0 (administrador), marca MenuPermisosAdmin = True (acceso a todos los menús).
    ''' Para el resto, ejecuta spMenuPrincipal_PermisosUsuario y guarda solo ítems con Permitido=1.
    ''' </summary>
    Private Shared Sub CargarPermisosMenuEnSesion(context As HttpContext)
        Try
            Dim nivelObj As Object = context.Session("NivelAcceso")
            Dim nivel As Integer = If(nivelObj IsNot Nothing, Convert.ToInt32(nivelObj), 999)
            If nivel = 0 Then
                context.Session(VariablesSesion.MenuPermisosAdmin) = True
                context.Session(VariablesSesion.MenuPermisosJson) = "[]"
                Return
            End If
            context.Session(VariablesSesion.MenuPermisosAdmin) = False
            Dim usuarioIdObj As Object = context.Session("UsuarioId")
            If usuarioIdObj Is Nothing Then
                context.Session(VariablesSesion.MenuPermisosJson) = "[]"
                Return
            End If
            Dim usuarioId As Integer = Convert.ToInt32(usuarioIdObj)
            Dim cnn As String = TryCast(context.Session(VariablesSesion.ConnectionString), String)
            If String.IsNullOrEmpty(cnn) Then
                context.Session(VariablesSesion.MenuPermisosJson) = "[]"
                Return
            End If
            Dim uDBA As SBSqlClientInterface = ModGlobal.GetDbaObject(cnn)
            uDBA.Parametros.Add("@IdUsuario", usuarioId)
            Dim sSqlPermisos As String = "EXEC spMenuPrincipal_PermisosUsuario @IdUsuario"
            ModGlobal.EscribirLog("Ejecutando: " & sSqlPermisos & " " & uDBA.getParamList())
            Dim dt As DataTable = uDBA.GetDataTableSql(sSqlPermisos)
            If uDBA.MensajeError <> "" Then
                ModGlobal.EscribirLog("BD ERROR: PermisosMenu - " & uDBA.MensajeError)
            Else
                ModGlobal.EscribirLog("BD OK: PermisosMenu")
            End If
            Dim lista As New List(Of Dictionary(Of String, Object))
            If uDBA.MensajeError = "" AndAlso dt IsNot Nothing Then
                For Each row As DataRow In dt.Rows
                    Dim permitidoObj As Object = row("Permitido")
                    If permitidoObj IsNot Nothing AndAlso permitidoObj IsNot DBNull.Value AndAlso Convert.ToBoolean(permitidoObj) Then
                        Dim d As New Dictionary(Of String, Object) From {
                            {"IdMenuOpcion", row("IdMenu")},
                            {"IdMenu", row("IdMenu")},
                            {"Nombre", If(row("TextoMenu"), "").ToString()},
                            {"UrlDestino", If(row("Url"), "").ToString()},
                            {"IdPadre", row("IdParent")},
                            {"Orden", row("Orden")}
                        }
                        lista.Add(d)
                    End If
                Next
            End If
            Dim serializer As New JavaScriptSerializer()
            context.Session(VariablesSesion.MenuPermisosJson) = serializer.Serialize(lista)
        Catch ex As Exception
            context.Session(VariablesSesion.MenuPermisosAdmin) = False
            context.Session(VariablesSesion.MenuPermisosJson) = "[]"
        End Try
    End Sub

End Class
