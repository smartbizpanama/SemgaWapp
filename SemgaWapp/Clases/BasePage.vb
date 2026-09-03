Imports System.Configuration
Imports System.Data.SqlClient
Imports System.Web
Imports System.Web.Script.Services
Imports System.Web.Services
Imports System.Web.UI
Imports System.Web.UI.HtmlControls
Imports SBUtility

''' <summary>
''' Página base que aplica el icono (appIcon) como favicon y el título como appIcon + appName + [BDName] en todas las páginas.
''' </summary>
Public Class BasePage
    Inherits System.Web.UI.Page

    Protected Overrides Sub OnPreRenderComplete(e As EventArgs)
        MyBase.OnPreRenderComplete(e)
        AplicarIconoYNombreApp()
        AplicarColorFondoApp()
    End Sub

    ''' <summary>
    ''' Lee appIcon, appName y el nombre de BD de la cadena de conexión desencriptada; aplica favicon y título: appIcon + appName + [BDName].
    ''' </summary>
    Private Sub AplicarIconoYNombreApp()
        Dim appIcon As String = Nothing
        Dim appName As String = Nothing
        Try
            appIcon = ConfigurationManager.AppSettings("appIcon")
            If String.IsNullOrWhiteSpace(appIcon) Then appIcon = ConfigurationManager.AppSettings("AppIcon")
            appName = ConfigurationManager.AppSettings("appName")
        Catch
            ' Si no existe la clave, no hacer nada
        End Try

        ' Título: appName + [BDName] (el icono va solo en el favicon para no duplicarlo en la pestaña)
        If Not String.IsNullOrWhiteSpace(appName) Then
            Dim bdName As String = ObtenerNombreBaseDatos()
            Dim parteBd As String = If(String.IsNullOrWhiteSpace(bdName), "", " [" & bdName & "]")
            Dim tituloBase As String = (appName.Trim() & parteBd).Trim()
            Dim sufijo As String = ""
            Dim separador As String = " - "
            If Not String.IsNullOrWhiteSpace(Me.Title) AndAlso Me.Title.IndexOf(separador) >= 0 Then
                sufijo = separador & Me.Title.Substring(Me.Title.IndexOf(separador) + separador.Length).Trim()
            End If
            Me.Title = tituloBase & sufijo
        End If

        If String.IsNullOrWhiteSpace(appIcon) Then Return

        ' Favicon en la pestaña del navegador
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

    ''' <summary>
    ''' Obtiene el nombre de la base de datos desde la cadena de conexión desencriptada del Web.config.
    ''' </summary>
    Private Shared Function ObtenerNombreBaseDatos() As String
        Try
            Dim cifrada As String = ConfigurationManager.AppSettings("ConnectionString")
            If String.IsNullOrWhiteSpace(cifrada) Then Return ""
            Dim uSec As New SBEncryption
            Dim conexion As String = uSec.Decrypt(cifrada.Trim())
            If String.IsNullOrWhiteSpace(conexion) Then Return ""
            Dim builder As New SqlConnectionStringBuilder(conexion)
            Dim nombre As String = If(builder.InitialCatalog, "").Trim()
            Return nombre
        Catch
            Return ""
        End Try
    End Function

    ''' <summary>
    ''' Lee appBackgroundColor1 y appBackgroundColor2 del Web.config y aplica el fondo (gradiente) al body en todas las páginas.
    ''' </summary>
    Private Sub AplicarColorFondoApp()
        Dim c1 As String = Nothing
        Dim c2 As String = Nothing
        Try
            c1 = ConfigurationManager.AppSettings("appBackgroundColor1")
            c2 = ConfigurationManager.AppSettings("appBackgroundColor2")
        Catch
        End Try
        If String.IsNullOrWhiteSpace(c1) Then c1 = "#87CEEB"
        If String.IsNullOrWhiteSpace(c2) Then c2 = "#B0E0E6"
        c1 = ValidarColorHex(c1.Trim())
        c2 = ValidarColorHex(c2.Trim())

        If Me.Header Is Nothing Then Return
        Dim css As String = "body { background: linear-gradient(135deg, " & c1 & " 0%, " & c2 & " 100%) !important; }"
        Dim style As New HtmlControls.HtmlGenericControl("style")
        style.Attributes("type") = "text/css"
        style.InnerHtml = css
        Me.Header.Controls.Add(style)
    End Sub

    ''' <summary>
    ''' Valida que el valor sea un color hex (#RGB o #RRGGBB) para evitar inyección en CSS.
    ''' </summary>
    Private Shared Function ValidarColorHex(valor As String) As String
        If String.IsNullOrWhiteSpace(valor) Then Return "#87CEEB"
        If valor.Length <> 4 AndAlso valor.Length <> 7 Then Return "#87CEEB"
        If valor(0) <> "#"c Then Return "#87CEEB"
        For i As Integer = 1 To valor.Length - 1
            Dim c As Char = valor(i)
            If Not (Char.IsDigit(c) OrElse (c >= "a"c AndAlso c <= "f"c) OrElse (c >= "A"c AndAlso c <= "F"c)) Then Return "#87CEEB"
        Next
        Return valor
    End Function

    ''' <summary>
    ''' Fecha/hora de referencia (internet) y fecha/hora del servidor SQL (GETDATE), para encabezados de pantalla.
    ''' </summary>
    <WebMethod(EnableSession:=True)>
    <ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
    Public Shared Function ObtenerFechasReferenciaTitulo(timeZoneCliente As String) As Object
        Dim ctx As HttpContext = HttpContext.Current
        If ctx Is Nothing OrElse ctx.Session Is Nothing Then
            Return New With {.Resultado = "ERROR", .Mensaje = "Sin contexto"}
        End If
        If ctx.Session(VariablesSesion.UsuarioId) Is Nothing Then
            Return New With {.Resultado = "ERROR", .Mensaje = "Sesión expirada"}
        End If
        Dim cnnObj As Object = ctx.Session(VariablesSesion.ConnectionString)
        If cnnObj Is Nothing OrElse String.IsNullOrWhiteSpace(cnnObj.ToString()) Then
            Return New With {.Resultado = "ERROR", .Mensaje = "Sin cadena de conexión"}
        End If
        Dim tz As String = If(timeZoneCliente, "")
        Return ModGlobal.ObtenerFechasReferenciaParaTitulo(cnnObj.ToString(), tz)
    End Function
End Class
