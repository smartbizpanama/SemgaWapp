Imports System.Data
Imports System.Data.SqlClient
Imports System.Configuration
Imports System.Web.Services
Imports System.Web.Script.Services
Imports System.Web.Script.Serialization
Imports SBUtility

Public Class GestionUsuarios
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        ' Verificar autenticación
        If Session("UsuarioId") Is Nothing Then
            Response.Redirect("~/Login.aspx")
            Return
        End If
    End Sub

    <WebMethod()>
    <ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
    Public Shared Function CargarUsuarios(ByVal filtroNombre As String, ByVal filtroUsuario As String, ByVal filtroEstado As String, ByVal filtroRol As String) As String
        Try
            Dim connectionString As String = GetDecryptedConnectionString()
            Dim dt As New DataTable()

            Using conn As New SqlConnection(connectionString)
                Dim cmd As New SqlCommand("sp_ObtenerUsuarios", conn)
                cmd.CommandType = CommandType.StoredProcedure

                cmd.Parameters.AddWithValue("@FiltroNombre", If(String.IsNullOrEmpty(filtroNombre), DBNull.Value, filtroNombre))
                cmd.Parameters.AddWithValue("@FiltroUsuario", If(String.IsNullOrEmpty(filtroUsuario), DBNull.Value, filtroUsuario))
                cmd.Parameters.AddWithValue("@FiltroEstado", If(String.IsNullOrEmpty(filtroEstado), DBNull.Value, filtroEstado))
                cmd.Parameters.AddWithValue("@FiltroRol", If(String.IsNullOrEmpty(filtroRol), DBNull.Value, filtroRol))

                conn.Open()
                Dim adapter As New SqlDataAdapter(cmd)
                adapter.Fill(dt)
            End Using

            Return DataTableToJSON(dt)
        Catch ex As Exception
            
            Return "ERROR: " & ex.Message
        End Try
    End Function

    <WebMethod()>
    <ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
    Public Shared Function CargarRoles() As String
        Try
            Dim connectionString As String = GetDecryptedConnectionString()
            Dim dt As New DataTable()

            Using conn As New SqlConnection(connectionString)
                Dim cmd As New SqlCommand("SELECT Id, Nombre FROM tbRoles WHERE Activo = 1 ORDER BY Nombre", conn)
                conn.Open()
                Dim adapter As New SqlDataAdapter(cmd)
                adapter.Fill(dt)
            End Using

            Return DataTableToJSON(dt)
        Catch ex As Exception
            
            Return "ERROR: " & ex.Message
        End Try
    End Function

    <WebMethod()>
    <ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
    Public Shared Function CargarDepartamentos() As String
        Try
            Dim connectionString As String = GetDecryptedConnectionString()
            Dim dt As New DataTable()

            Using conn As New SqlConnection(connectionString)
                Dim cmd As New SqlCommand("SELECT Id, Nombre FROM tbDepartamentos WHERE Activo = 1 ORDER BY Nombre", conn)
                conn.Open()
                Dim adapter As New SqlDataAdapter(cmd)
                adapter.Fill(dt)
            End Using

            Return DataTableToJSON(dt)
        Catch ex As Exception
            
            Return "ERROR: " & ex.Message
        End Try
    End Function

    <WebMethod()>
    <ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
    Public Shared Function ObtenerUsuario(ByVal usuarioId As Integer) As String
        Try
            Dim connectionString As String = GetDecryptedConnectionString()
            Dim dt As New DataTable()

            Using conn As New SqlConnection(connectionString)
                Dim cmd As New SqlCommand("sp_ObtenerUsuarioPorId", conn)
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.AddWithValue("@UsuarioId", usuarioId)

                conn.Open()
                Dim adapter As New SqlDataAdapter(cmd)
                adapter.Fill(dt)
            End Using

            Return DataTableToJSON(dt)
        Catch ex As Exception
            
            Return "ERROR: " & ex.Message
        End Try
    End Function

    <WebMethod()>
    <ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
    Public Shared Function GuardarUsuario(ByVal usuarioId As Integer, ByVal nombre As String, ByVal apellido As String, ByVal usuario As String, ByVal clave As String, ByVal email As String, ByVal telefono As String, ByVal rol As Integer, ByVal departamento As Integer, ByVal estado As String) As String
        Try
            Dim connectionString As String = GetDecryptedConnectionString()
            Dim usuarioActual As Integer = HttpContext.Current.Session("UsuarioId")

            Using conn As New SqlConnection(connectionString)
                Dim cmd As New SqlCommand("sp_GuardarUsuario", conn)
				cmd.CommandType = CommandType.StoredProcedure
				Dim uSec As SBEncryption = New SBEncryption()
				cmd.Parameters.AddWithValue("@UsuarioId", usuarioId)
                cmd.Parameters.AddWithValue("@Nombre", nombre)
                cmd.Parameters.AddWithValue("@Apellido", apellido)
                cmd.Parameters.AddWithValue("@Usuario", usuario)
                cmd.Parameters.AddWithValue("@Clave", If(String.IsNullOrEmpty(clave), DBNull.Value, uSec.Encrypt(clave)))
                cmd.Parameters.AddWithValue("@Email", email)
                cmd.Parameters.AddWithValue("@Telefono", If(String.IsNullOrEmpty(telefono), DBNull.Value, telefono))
                cmd.Parameters.AddWithValue("@Rol", rol)
                cmd.Parameters.AddWithValue("@Departamento", If(departamento = 0, DBNull.Value, departamento))
                cmd.Parameters.AddWithValue("@Estado", estado)
                cmd.Parameters.AddWithValue("@UsuarioActual", usuarioActual)

                conn.Open()
                Dim resultado As Object = cmd.ExecuteScalar()
                Return If(resultado IsNot Nothing, resultado.ToString(), "OK")
            End Using
        Catch ex As Exception
            
            Return "ERROR: " & ex.Message
        End Try
    End Function

    <WebMethod()>
    <ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
    Public Shared Function EliminarUsuario(ByVal usuarioId As Integer) As String
        Try
            Dim connectionString As String = GetDecryptedConnectionString()
            Dim usuarioActual As Integer = HttpContext.Current.Session("UsuarioId")

            Using conn As New SqlConnection(connectionString)
                Dim cmd As New SqlCommand("sp_EliminarUsuario", conn)
                cmd.CommandType = CommandType.StoredProcedure

                cmd.Parameters.AddWithValue("@UsuarioId", usuarioId)
                cmd.Parameters.AddWithValue("@UsuarioActual", usuarioActual)

                conn.Open()
                Dim resultado As Object = cmd.ExecuteScalar()
                Return If(resultado IsNot Nothing, resultado.ToString(), "OK")
            End Using
        Catch ex As Exception
            
            Return "ERROR: " & ex.Message
        End Try
    End Function

    <WebMethod()>
    <ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
    Public Shared Function CambiarEstadoUsuario(ByVal usuarioId As Integer, ByVal nuevoEstado As String) As String
        Try
            Dim connectionString As String = GetDecryptedConnectionString()
            Dim usuarioActual As Integer = HttpContext.Current.Session("UsuarioId")

            Using conn As New SqlConnection(connectionString)
                Dim cmd As New SqlCommand("sp_CambiarEstadoUsuario", conn)
                cmd.CommandType = CommandType.StoredProcedure

                cmd.Parameters.AddWithValue("@UsuarioId", usuarioId)
                cmd.Parameters.AddWithValue("@NuevoEstado", nuevoEstado)
                cmd.Parameters.AddWithValue("@UsuarioActual", usuarioActual)

                conn.Open()
                Dim resultado As Object = cmd.ExecuteScalar()
                Return If(resultado IsNot Nothing, resultado.ToString(), "OK")
            End Using
        Catch ex As Exception
            
            Return "ERROR: " & ex.Message
        End Try
    End Function

    <WebMethod()>
    <ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
    Public Shared Function VerificarUsuarioExistente(ByVal usuario As String, ByVal usuarioId As Integer) As String
        Try
            Dim connectionString As String = GetDecryptedConnectionString()

            Using conn As New SqlConnection(connectionString)
                Dim cmd As New SqlCommand("SELECT COUNT(*) FROM tbUsuarios WHERE Usuario = @Usuario AND Id != @UsuarioId", conn)
                cmd.Parameters.AddWithValue("@Usuario", usuario)
                cmd.Parameters.AddWithValue("@UsuarioId", usuarioId)

                conn.Open()
                Dim count As Integer = Convert.ToInt32(cmd.ExecuteScalar())
                Return If(count > 0, "EXISTE", "NO_EXISTE")
            End Using
        Catch ex As Exception
            
            Return "ERROR: " & ex.Message
        End Try
    End Function

    <WebMethod()>
    <ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
    Public Shared Function VerificarEmailExistente(ByVal email As String, ByVal usuarioId As Integer) As String
        Try
            Dim connectionString As String = GetDecryptedConnectionString()

            Using conn As New SqlConnection(connectionString)
                Dim cmd As New SqlCommand("SELECT COUNT(*) FROM tbUsuarios WHERE Email = @Email AND Id != @UsuarioId", conn)
                cmd.Parameters.AddWithValue("@Email", email)
                cmd.Parameters.AddWithValue("@UsuarioId", usuarioId)

                conn.Open()
                Dim count As Integer = Convert.ToInt32(cmd.ExecuteScalar())
                Return If(count > 0, "EXISTE", "NO_EXISTE")
            End Using
        Catch ex As Exception
            
            Return "ERROR: " & ex.Message
        End Try
    End Function

    Private Shared Function GetDecryptedConnectionString() As String
		Try
			Dim uSec As SBEncryption = New SBEncryption()
            Dim encryptedConnectionString As String = HttpContext.Current.Session(VariablesSesion.ConnectionString) 'HttpContext.Current.Session(VariablesSesion.ConnectionString)
            Return uSec.Decrypt(encryptedConnectionString)
        Catch ex As Exception
            
            Return HttpContext.Current.Session(VariablesSesion.ConnectionString)
        End Try
    End Function

    Private Shared Function DataTableToJSON(dt As DataTable) As String
        Try
            Dim serializer As New JavaScriptSerializer()
            Dim rows As New List(Of Dictionary(Of String, Object))()

            For Each row As DataRow In dt.Rows
                Dim dict As New Dictionary(Of String, Object)()
                For Each col As DataColumn In dt.Columns
                    dict.Add(col.ColumnName, If(row(col) Is DBNull.Value, Nothing, row(col)))
                Next
                rows.Add(dict)
            Next

            Return serializer.Serialize(rows)
        Catch ex As Exception
            
            Return "[]"
        End Try
    End Function
End Class

