Public Class dashboardSistemas
	Inherits BasePage

	''' <summary>Para script de permisos en aspx: true si admin de menú.</summary>
	Protected PermisosMenuAdminValue As Boolean
	''' <summary>Para script de permisos en aspx: JSON de URLs permitidas.</summary>
	Protected PermisosMenuUrlsJsonValue As String

	Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
		If Session(VariablesSesion.UsuarioId) Is Nothing Then
			Response.Redirect("~/Login.aspx")
			Return
		End If
		If ModGlobal.ValidarYRedirigirSiSinPermiso(HttpContext.Current) Then Return
		PermisosMenuAdminValue = ModGlobal.EsPermisosMenuAdmin(HttpContext.Current)
		PermisosMenuUrlsJsonValue = ModGlobal.GetPermisosMenuUrlsJson(HttpContext.Current)
	End Sub

End Class
