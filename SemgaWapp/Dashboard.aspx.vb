'Imports System
'Imports System.Web.Security
'Imports System.Web.UI
'Imports System.Configuration
Imports System.Web.Services
Imports System.Web.Script.Services
Imports System.Web.Script.Serialization
'Imports SemgaWapp
Imports SBSqlClient
'Imports SBUtility
'Imports System.Data

Public Class Dashboard
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        ' Verificar si el usuario está autenticado
        If Not User.Identity.IsAuthenticated Then
            Response.Redirect("~/Login.aspx")
            Return
        End If

        ' Verificar si las variables de sesión están disponibles
        If Session("UsuarioId") Is Nothing Then
            ' Si no hay variables de sesión, redirigir al login
            FormsAuthentication.SignOut()
            Response.Redirect("~/Login.aspx")
            Return
        End If

        ' Configurar la página para no cachear
        Response.Cache.SetCacheability(HttpCacheability.NoCache)
        Response.Cache.SetExpires(DateTime.UtcNow.AddHours(-1))
        Response.Cache.SetNoStore()

        ' Verificar si la aplicación está en modo mantenimiento
        If ConfigurationManager.AppSettings("MaintenanceMode") = "true" Then
            Response.Redirect("~/Maintenance.aspx")
            Return
        End If

        ' Registrar actividad del usuario
        LogUserActivity()

        ' Actualizar última actividad en sesión
        Session("LastActivity") = DateTime.Now
    End Sub

    Protected Sub btnLogout_Click(sender As Object, e As EventArgs)
        Try
            ' Registrar logout
            LogUserLogout()

            ' Cerrar sesión
            FormsAuthentication.SignOut()

            ' Limpiar variables de sesión
            Session.Clear()
            Session.Abandon()

            ' Limpiar cookies de sesión
            Response.Cookies.Clear()

            ' Redirigir al login
            Response.Redirect("~/Login.aspx")
        Catch ex As Exception
            ' En caso de error, forzar el logout
            FormsAuthentication.SignOut()
            Session.Clear()
            Response.Redirect("~/Login.aspx")
        End Try
    End Sub

    Private Sub LogUserActivity()
        Try
            ' Aquí podrías registrar la actividad del usuario en la base de datos
            ' Por ejemplo, registrar que el usuario accedió al dashboard
            Dim usuarioId = Session("UsuarioId")
            Dim nombreUsuario = Session("NombreUsuario")
            Dim ipAddress = Request.UserHostAddress
            Dim userAgent = Request.UserAgent
            Dim timestamp = DateTime.Now

            ' Log de actividad (implementar según necesidades)
            ' LogActivity(usuarioId, nombreUsuario, "Dashboard_Access", ipAddress, userAgent, timestamp)
        Catch ex As Exception
            ' Si falla el logging, no hacer nada para evitar interrumpir la experiencia del usuario
        End Try
    End Sub

    Private Sub LogUserLogout()
        Try
            ' Aquí podrías registrar el logout del usuario
            Dim usuarioId = Session("UsuarioId")
            Dim nombreUsuario = Session("NombreUsuario")
            Dim ipAddress = Request.UserHostAddress
            Dim timestamp = DateTime.Now

            ' Log de logout (implementar según necesidades)
            ' LogActivity(usuarioId, nombreUsuario, "User_Logout", ipAddress, "", timestamp)
        Catch ex As Exception
            ' Si falla el logging, no hacer nada
        End Try
    End Sub

    ''' <summary>
    ''' Obtiene los parámetros de monitoreo de inactividad desde la sesión
    ''' </summary>
    ''' <returns>JSON con los parámetros de monitoreo</returns>
    <System.Web.Services.WebMethod()>
    Public Shared Function ObtenerParametrosInactividad() As String
        Try
            Dim parametros As New Dictionary(Of String, String)

            ' Obtener parámetros de la sesión
            Dim monitorearInactividad As String = If(HttpContext.Current.Session(VariablesSesion.MONITOREAR_INACTIVIDAD), "0")
            Dim tiempoMonitorear As String = If(HttpContext.Current.Session(VariablesSesion.TIEMPO_MONITOREAR_INACTIVIDAD), "5")


            parametros.Add("MONITOREAR_INACTIVIDAD", monitorearInactividad)
            parametros.Add("TIEMPO_MONITOREAR_INACTIVIDAD", tiempoMonitorear)

            Dim resultado As New With {
                .d = New With {
                    .Success = True,
                    .Message = "Parámetros obtenidos exitosamente",
                    .Data = parametros
                }
            }

            Dim serializer As New System.Web.Script.Serialization.JavaScriptSerializer()
            Dim jsonResult As String = serializer.Serialize(resultado)
            
            
            Return jsonResult

        Catch ex As Exception
            Dim resultado As New With {
                .d = New With {
                    .Success = False,
                    .Message = "Error al obtener parámetros de inactividad: " & ex.Message,
                .Data = Nothing
            }
            }
            Dim serializer As New System.Web.Script.Serialization.JavaScriptSerializer()
            Return serializer.Serialize(resultado)
        End Try
    End Function

    ''' <summary>
    ''' Obtiene parámetros de inactividad desde la sesión (versión optimizada)
    ''' Los parámetros se cargan una sola vez al hacer login
    ''' </summary>
    ''' <returns>JSON con los parámetros de inactividad</returns>
    <System.Web.Services.WebMethod()>
    Public Shared Function ObtenerParametrosInactividadSesion() As String
        Try
            Dim parametros As New Dictionary(Of String, String)

            ' Obtener parámetros directamente de la sesión (ya cargados en el login)
            Dim monitorearInactividad As String = If(HttpContext.Current.Session(VariablesSesion.MONITOREAR_INACTIVIDAD), "0")
            Dim tiempoMonitorear As String = If(HttpContext.Current.Session(VariablesSesion.TIEMPO_MONITOREAR_INACTIVIDAD), "5")


            parametros.Add("MONITOREAR_INACTIVIDAD", monitorearInactividad)
            parametros.Add("TIEMPO_MONITOREAR_INACTIVIDAD", tiempoMonitorear)

            Dim resultado As New With {
                .d = New With {
                    .Success = True,
                    .Message = "Parámetros obtenidos desde sesión exitosamente",
                    .Data = parametros
                }
            }

            Dim serializer As New System.Web.Script.Serialization.JavaScriptSerializer()
            Return serializer.Serialize(resultado)

        Catch ex As Exception
            Dim resultado As New With {
                .d = New With {
                    .Success = False,
                    .Message = "Error al obtener parámetros de inactividad desde sesión: " & ex.Message,
                    .Data = Nothing
                }
            }
            Dim serializer As New System.Web.Script.Serialization.JavaScriptSerializer()
            Return serializer.Serialize(resultado)
        End Try
    End Function

    ''' <summary>
    ''' Cierra la sesión del usuario por inactividad
    ''' </summary>
    ''' <returns>JSON con el resultado de la operación</returns>
    <System.Web.Services.WebMethod()>
    Public Shared Function CerrarSesionPorInactividad() As String
        Try
            ' Registrar el cierre de sesión por inactividad
            Dim usuarioId = HttpContext.Current.Session("UsuarioId")
            Dim nombreUsuario = HttpContext.Current.Session("NombreUsuario")
            Dim ipAddress = HttpContext.Current.Request.UserHostAddress
            Dim timestamp = DateTime.Now

            ' Log de cierre por inactividad (implementar según necesidades)
            ' LogActivity(usuarioId, nombreUsuario, "Session_Timeout_Inactivity", ipAddress, "", timestamp)

            ' Cerrar sesión
            FormsAuthentication.SignOut()
            HttpContext.Current.Session.Clear()
            HttpContext.Current.Session.Abandon()

            Dim resultado As New With {
                .Success = True,
                .Message = "Sesión cerrada por inactividad",
                .Data = Nothing
            }

            Dim serializer As New System.Web.Script.Serialization.JavaScriptSerializer()
            Return serializer.Serialize(resultado)

        Catch ex As Exception
            Dim resultado As New With {
                .Success = False,
                .Message = "Error al cerrar sesión por inactividad: " & ex.Message,
                .Data = Nothing
            }

            Dim serializer As New System.Web.Script.Serialization.JavaScriptSerializer()
            Return serializer.Serialize(resultado)
        End Try
    End Function

    ''' <summary>
    ''' Obtiene los datos del dashboard desde la base de datos
    ''' </summary>
    ''' <returns>JSON con los datos del dashboard</returns>
    <WebMethod(EnableSession:=True)>
    <ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
    Public Shared Function ObtenerDatosDashboard() As String
        Try
            Dim uDBA As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
            Dim sSql As String = "Exec spGetDashboard"

            ModGlobal.EscribirLog("Obteniendo datos del dashboard: " & sSql)
            ModGlobal.EscribirLog($"Ejecutando: {sSql} {uDBA.getParamList()}")

            Dim dtDashboard As DataTable = uDBA.GetDataTableSql(sSql)

            ModGlobal.EscribirLog("Mensaje de error de uDBA: '" & uDBA.MensajeError & "'")

            If uDBA.MensajeError = "" Then
                If dtDashboard.Rows.Count > 0 Then
                    ModGlobal.EscribirLog("Datos del dashboard obtenidos exitosamente. Registros: " & dtDashboard.Rows.Count)

                    Dim sociosActivos As Integer = 0
                    Dim jsonTiposAsociados As String = "[]"
                    Dim jsonUltimosMovimientos As String = "[]"
                    Dim auxiliaresActivos As Integer = 0
                    Dim jsonTiposAuxiliares As String = "[]"

                    ' Obtener el valor de SociosActivos
                    If dtDashboard.Rows(0)("SociosActivos") IsNot DBNull.Value Then
                        Integer.TryParse(dtDashboard.Rows(0)("SociosActivos").ToString(), sociosActivos)
                    End If

                    ' Obtener el JSON de tipos de asociados
                    If dtDashboard.Rows(0)("JsonTiposAsociados") IsNot DBNull.Value Then
                        jsonTiposAsociados = dtDashboard.Rows(0)("JsonTiposAsociados").ToString()
                    End If

                    ' Obtener el JSON de últimos movimientos por día
                    If dtDashboard.Rows(0)("JsonUltimosMovimientos") IsNot DBNull.Value Then
                        jsonUltimosMovimientos = dtDashboard.Rows(0)("JsonUltimosMovimientos").ToString()
                    End If

                    ' Obtener datos de auxiliares desde JsonAuxiliares
                    Try
                        If dtDashboard.Rows(0)("JsonAuxiliares") IsNot DBNull.Value Then
                            Dim jsonAuxiliaresRaw As String = dtDashboard.Rows(0)("JsonAuxiliares").ToString()

                            If Not String.IsNullOrEmpty(jsonAuxiliaresRaw) AndAlso jsonAuxiliaresRaw <> "[]" Then
                                ' Parsear el JSON de auxiliares
                                Dim serializerAuxiliares As New JavaScriptSerializer()
                                Dim auxiliaresData As Object() = serializerAuxiliares.Deserialize(Of Object())(jsonAuxiliaresRaw)

                                ' Calcular total de auxiliares y crear JSON para el gráfico
                                auxiliaresActivos = 0
                                Dim tiposAuxiliares As New List(Of Object)

                                For Each item As Object In auxiliaresData
                                    Dim auxiliarDict As Dictionary(Of String, Object) = DirectCast(item, Dictionary(Of String, Object))
                                    Dim cantidad As Integer = Convert.ToInt32(auxiliarDict("Auxiliares"))
                                    auxiliaresActivos += cantidad

                                    ' Agregar al JSON para el gráfico
                                    tiposAuxiliares.Add(New With {
                                        .TipoAuxiliar = auxiliarDict("Tipo").ToString(),
                                        .Cantidad = cantidad
                                    })
                                Next

                                jsonTiposAuxiliares = serializerAuxiliares.Serialize(tiposAuxiliares)
                            Else
                                auxiliaresActivos = 0
                                jsonTiposAuxiliares = "[]"
                            End If
                        Else
                            auxiliaresActivos = 0
                            jsonTiposAuxiliares = "[]"
                        End If
                    Catch ex As Exception
                        ModGlobal.EscribirLog("Error al procesar JsonAuxiliares: " & ex.Message)
                        auxiliaresActivos = 0
                        jsonTiposAuxiliares = "[]"
                    End Try

                    Dim resultado = New With {
                        .Success = True,
                        .Message = "Datos del dashboard obtenidos exitosamente",
                        .Data = New With {
                            .SociosActivos = sociosActivos,
                            .JsonTiposAsociados = jsonTiposAsociados,
                            .JsonUltimosMovimientos = jsonUltimosMovimientos,
                            .AuxiliaresActivos = auxiliaresActivos,
                            .JsonTiposAuxiliares = jsonTiposAuxiliares
                        }
                    }

                    Dim serializer As New JavaScriptSerializer()
                    Return serializer.Serialize(resultado)
                Else
                    ModGlobal.EscribirLog("No se encontraron datos del dashboard")
                    Dim resultado = New With {
                        .Success = False,
                        .Message = "No se encontraron datos del dashboard",
                        .Data = Nothing
                    }

                    Dim serializer As New JavaScriptSerializer()
                    Return serializer.Serialize(resultado)
                End If
            Else
                ModGlobal.EscribirLog("Error al obtener datos del dashboard: " & uDBA.MensajeError)
                Dim resultado = New With {
                    .Success = False,
                    .Message = "Error al obtener datos del dashboard: " & uDBA.MensajeError,
                    .Data = Nothing
                }

                Dim serializer As New JavaScriptSerializer()
                Return serializer.Serialize(resultado)
            End If

        Catch ex As Exception
            ModGlobal.EscribirLog("Error al obtener datos del dashboard: " & ex.Message)
            Dim resultado = New With {
                .Success = False,
                .Message = "Error al obtener datos del dashboard: " & ex.Message,
                .Data = Nothing
            }

            Dim serializer As New JavaScriptSerializer()
            Return serializer.Serialize(resultado)
        End Try
    End Function
End Class

