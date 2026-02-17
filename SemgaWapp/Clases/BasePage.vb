Imports System.Configuration
Imports System.Web.UI
Imports System.Web.UI.HtmlControls

''' <summary>
''' Página base que aplica el icono de aplicación (AppIcon del Web.config) como favicon en todas las ventanas.
''' </summary>
Public Class BasePage
    Inherits System.Web.UI.Page

    Protected Overrides Sub OnPreRenderComplete(e As EventArgs)
        MyBase.OnPreRenderComplete(e)
        AplicarIconoApp()
    End Sub

    ''' <summary>
    ''' Lee AppIcon del Web.config y lo aplica como favicon en el head (icono en la pestaña del navegador).
    ''' </summary>
    Private Sub AplicarIconoApp()
        Dim appIcon As String = Nothing
        Try
            appIcon = ConfigurationManager.AppSettings("AppIcon")
        Catch
            ' Si no existe la clave, no hacer nada
        End Try

        If String.IsNullOrWhiteSpace(appIcon) Then Return

        ' Solo añadir favicon (el icono en la pestaña); no duplicar en el texto del título
        ' Añadir favicon usando el icono (emoji o texto) como SVG
        If Me.Header Is Nothing Then Return

        Dim svg As String = "<svg xmlns=""http://www.w3.org/2000/svg"" viewBox=""0 0 100 100""><text y="".9em"" font-size=""90"">" &
            appIcon.Trim() & "</text></svg>"
        Dim dataUri As String = "data:image/svg+xml;charset=utf-8," & Uri.EscapeDataString(svg)

        Dim link As New HtmlLink()
        link.Href = dataUri
        link.Attributes("rel") = "icon"
        link.Attributes("type") = "image/svg+xml"
        Me.Header.Controls.Add(link)
    End Sub
End Class
