Imports System.Web.Services
Imports System.Web.Script.Services
Imports SBUtility

Partial Public Class dashboardReportes
    Inherits BasePage

    Protected PermisosMenuAdminValue As Boolean
    Protected PermisosMenuUrlsJsonValue As String

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        ' Verificar sesión
        If Session(VariablesSesion.UsuarioId) Is Nothing Then
            Response.Redirect("~/Login.aspx")
            Return
        End If
        If ModGlobal.ValidarYRedirigirSiSinPermiso(HttpContext.Current) Then Return
        PermisosMenuAdminValue = ModGlobal.EsPermisosMenuAdmin(HttpContext.Current)
        PermisosMenuUrlsJsonValue = ModGlobal.GetPermisosMenuUrlsJson(HttpContext.Current)
    End Sub
End Class
