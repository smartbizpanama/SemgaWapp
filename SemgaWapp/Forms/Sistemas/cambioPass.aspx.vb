Imports System.Data.SqlClient
Imports SBSqlClient
Imports SBUtility

Public Class cambioPass
    Inherits BasePage

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Session(VariablesSesion.UsuarioId) Is Nothing Then
            Response.Redirect("~/Login.aspx")
            Return
        End If
    End Sub

    Protected Sub btnCambiar_Click(sender As Object, e As EventArgs)
        pnlMensaje.Visible = False
        litMensaje.Text = ""

        Dim nueva As String = (If(txtNuevaClave.Text, "")).Trim()
        Dim repetir As String = (If(txtRepetirClave.Text, "")).Trim()

        If String.IsNullOrEmpty(nueva) Then
            MostrarMensaje("Ingrese la nueva contraseña.", False)
            Return
        End If
        If nueva <> repetir Then
            MostrarMensaje("Las contraseñas no coinciden.", False)
            Return
        End If

        Dim usuarioId As Integer = Convert.ToInt32(Session(VariablesSesion.UsuarioId))
        Dim cnn As String = TryCast(Session(VariablesSesion.ConnectionString), String)
        If String.IsNullOrEmpty(cnn) Then
            MostrarMensaje("Error de sesión. Vuelva a iniciar sesión.", False)
            Return
        End If

        Dim sbEncr As New SBEncryption
        Dim claveEncriptada As String = sbEncr.Encrypt(nueva)

        Try
            Dim objSql As SBSqlClientInterface = ModGlobal.GetDbaObject(cnn)
            objSql.Parametros.Add("@IdUsuario", usuarioId)
            objSql.Parametros.Add("@Clave", claveEncriptada)
            objSql.ExecuteNonQuerySql("EXEC spUsuarios_CambiarClave @IdUsuario, @Clave")

            If objSql.MensajeError <> "" Then
                ModGlobal.EscribirLog("cambioPass: " & objSql.MensajeError)
                MostrarMensaje("Error al cambiar la contraseña. Intente de nuevo.", False)
                Return
            End If

            ModGlobal.EscribirLog("Contraseña actualizada para UsuarioId: " & usuarioId)
            MostrarMensaje("Contraseña actualizada correctamente.", True)
            txtNuevaClave.Text = ""
            txtRepetirClave.Text = ""
        Catch ex As Exception
            ModGlobal.EscribirLog("cambioPass: " & ex.Message)
            MostrarMensaje("Error al cambiar la contraseña: " & ex.Message, False)
        End Try
    End Sub

    Private Sub MostrarMensaje(texto As String, esExito As Boolean)
        pnlMensaje.Visible = True
        pnlMensaje.CssClass = If(esExito, "mensaje ok", "mensaje error")
        litMensaje.Text = texto
    End Sub
End Class
