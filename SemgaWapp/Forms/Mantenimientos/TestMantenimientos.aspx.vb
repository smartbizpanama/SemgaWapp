Imports System

Public Class TestMantenimientos
    Inherits BasePage

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Session(VariablesSesion.UsuarioId) Is Nothing Then
            Response.Redirect("~/Login.aspx")
            Return
        End If
        If ModGlobal.ValidarYRedirigirSiSinPermiso(HttpContext.Current) Then Return
    End Sub

End Class

