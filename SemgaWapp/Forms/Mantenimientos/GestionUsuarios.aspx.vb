Imports System.Data
Imports System.Data.SqlClient
Imports System.Configuration
Imports System.Web.Services
Imports System.Web.Script.Services
Imports System.Web.Script.Serialization
Imports SBSqlClient
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
            ModGlobal.EscribirLog("CargarUsuarios iniciado")

            Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
            Dim sSql As String = "Exec sp_ObtenerUsuarios"

            With objSql.Parametros
                If Not String.IsNullOrEmpty(filtroNombre) Then
                    .Add("@FiltroNombre", filtroNombre)
                End If
                If Not String.IsNullOrEmpty(filtroUsuario) Then
                    .Add("@FiltroUsuario", filtroUsuario)
                End If
                If Not String.IsNullOrEmpty(filtroEstado) Then
                    .Add("@FiltroEstado", filtroEstado)
                End If
                If Not String.IsNullOrEmpty(filtroRol) Then
                    .Add("@FiltroRol", filtroRol)
                End If

            End With

            ModGlobal.EscribirLog($"Ejecutando: {sSql} {objSql.getParamList()}")
            Dim dt As DataTable = objSql.GetDataTableSql(sSql)

            ' Verificar si hubo error en la base de datos
            If objSql.MensajeError <> "" Then
                ModGlobal.EscribirLog("Error en BD al cargar usuarios: " & objSql.MensajeError)
                Return "ERROR: " & objSql.MensajeError
            Else
                ModGlobal.EscribirLog("Comando ejecutado correctamente - CargarUsuarios")
            End If

            Return DataTableToJSON(dt)
        Catch ex As Exception
            ModGlobal.EscribirLog("Error en CargarUsuarios: " & ex.Message)
            Return "ERROR: " & ex.Message
        End Try
    End Function

    <WebMethod()>
    <ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
    Public Shared Function CargarRoles() As String
        Try
            ModGlobal.EscribirLog("CargarRoles iniciado")

            Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
            Dim sSql As String = "SELECT Id, Nombre FROM tbRoles WHERE Activo = 1 ORDER BY Nombre"

            ModGlobal.EscribirLog($"Ejecutando: {sSql} {objSql.getParamList()}")
            Dim dt As DataTable = objSql.GetDataTableSql(sSql)

            ' Verificar si hubo error en la base de datos
            If objSql.MensajeError <> "" Then
                ModGlobal.EscribirLog("Error en BD al cargar roles: " & objSql.MensajeError)
                Return "ERROR: " & objSql.MensajeError
            Else
                ModGlobal.EscribirLog("Comando ejecutado correctamente - CargarRoles")
            End If

            Return DataTableToJSON(dt)
        Catch ex As Exception
            ModGlobal.EscribirLog("Error en CargarRoles: " & ex.Message)
            Return "ERROR: " & ex.Message
        End Try
    End Function

    <WebMethod()>
    <ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
    Public Shared Function CargarDepartamentos() As String
        Try
            ModGlobal.EscribirLog("CargarDepartamentos iniciado")

            Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
            Dim sSql As String = "SELECT Id, Nombre FROM tbDepartamentos WHERE Activo = 1 ORDER BY Nombre"

            ModGlobal.EscribirLog($"Ejecutando: {sSql} {objSql.getParamList()}")
            Dim dt As DataTable = objSql.GetDataTableSql(sSql)

            ' Verificar si hubo error en la base de datos
            If objSql.MensajeError <> "" Then
                ModGlobal.EscribirLog("Error en BD al cargar departamentos: " & objSql.MensajeError)
                Return "ERROR: " & objSql.MensajeError
            Else
                ModGlobal.EscribirLog("Comando ejecutado correctamente - CargarDepartamentos")
            End If

            Return DataTableToJSON(dt)
        Catch ex As Exception
            ModGlobal.EscribirLog("Error en CargarDepartamentos: " & ex.Message)
            Return "ERROR: " & ex.Message
        End Try
    End Function

    <WebMethod()>
    <ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
    Public Shared Function ObtenerUsuario(ByVal usuarioId As Integer) As String
        Try
            ModGlobal.EscribirLog("ObtenerUsuario iniciado. UsuarioId: " & usuarioId)

            Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
            Dim sSql As String = "Exec sp_ObtenerUsuarioPorId"

            With objSql.Parametros
                .Add("@UsuarioId", usuarioId)
            End With

            ModGlobal.EscribirLog($"Ejecutando: {sSql} {objSql.getParamList()}")
            Dim dt As DataTable = objSql.GetDataTableSql(sSql)

            ' Verificar si hubo error en la base de datos
            If objSql.MensajeError <> "" Then
                ModGlobal.EscribirLog("Error en BD al obtener usuario: " & objSql.MensajeError)
                Return "ERROR: " & objSql.MensajeError
            Else
                ModGlobal.EscribirLog("Comando ejecutado correctamente - ObtenerUsuario")
            End If

            Return DataTableToJSON(dt)
        Catch ex As Exception
            ModGlobal.EscribirLog("Error en ObtenerUsuario: " & ex.Message)
            Return "ERROR: " & ex.Message
        End Try
    End Function

    <WebMethod()>
    <ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
    Public Shared Function GuardarUsuario(ByVal usuarioId As Integer, ByVal nombre As String, ByVal apellido As String, ByVal usuario As String, ByVal clave As String, ByVal email As String, ByVal telefono As String, ByVal rol As Integer, ByVal departamento As Integer, ByVal estado As String) As String
        Try
            ModGlobal.EscribirLog("GuardarUsuario iniciado. UsuarioId: " & usuarioId)

            Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
            Dim sSql As String = "Exec spUsuarios_Guardar"
            Dim usuarioActual As Integer = HttpContext.Current.Session(VariablesSesion.UsuarioId)
            Dim uSec As SBEncryption = New SBEncryption()

            With objSql.Parametros
                .Add("@ID", usuarioId)
                .Add("@Nombre", nombre)
                .Add("@Apellido", apellido)
                .Add("@Usuario", usuario)

                If Not clave.Trim() = "" Then
                    .Add("@Clave", uSec.Encrypt(clave))
                End If

                .Add("@Email", email)
                .Add("@Telefono", telefono)
                .Add("@Rol", rol)
                .Add("@Departamento", departamento)
                .Add("@Estado", estado)
                .Add("@UsuarioID", usuarioActual)
                .Add("@IdSession", HttpContext.Current.Session(VariablesSesion.logID).ToString())
            End With

            ModGlobal.EscribirLog($"Ejecutando: {sSql} {objSql.getParamList()}")
            Dim dt As DataTable = objSql.GetDataTableSql(sSql)

            ' Verificar si hubo error en la base de datos
            If objSql.MensajeError <> "" Then
                ModGlobal.EscribirLog("Error en BD al guardar usuario: " & objSql.MensajeError)
                Return "ERROR: " & objSql.MensajeError
            Else
                ModGlobal.EscribirLog("Comando ejecutado correctamente - GuardarUsuario")
            End If

            Dim resultado As Object = If(dt.Rows.Count > 0, dt.Rows(0)(0), "OK")
            Return If(resultado IsNot Nothing, resultado.ToString(), "OK")
        Catch ex As Exception
            ModGlobal.EscribirLog("Error en GuardarUsuario: " & ex.Message)
            Return "ERROR: " & ex.Message
        End Try
    End Function

    <WebMethod()>
    <ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
    Public Shared Function EliminarUsuario(ByVal usuarioId As Integer) As String
        Try
            ModGlobal.EscribirLog("EliminarUsuario iniciado. UsuarioId: " & usuarioId)

            Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
            Dim sSql As String = "Exec spUsuarios_Eliminar"
            Dim usuarioActual As Integer = HttpContext.Current.Session(VariablesSesion.UsuarioId)

            With objSql.Parametros
                .Add("@ID", usuarioId)
                .Add("@UsuarioID", usuarioActual)
                .Add("@IdSession", HttpContext.Current.Session(VariablesSesion.logID).ToString())
            End With

            ModGlobal.EscribirLog($"Ejecutando: {sSql} {objSql.getParamList()}")
            Dim dt As DataTable = objSql.GetDataTableSql(sSql)

            ' Verificar si hubo error en la base de datos
            If objSql.MensajeError <> "" Then
                ModGlobal.EscribirLog("Error en BD al eliminar usuario: " & objSql.MensajeError)
                Return "ERROR: " & objSql.MensajeError
            Else
                ModGlobal.EscribirLog("Comando ejecutado correctamente - EliminarUsuario")
            End If

            Dim resultado As Object = If(dt.Rows.Count > 0, dt.Rows(0)(0), "OK")
            Return If(resultado IsNot Nothing, resultado.ToString(), "OK")
        Catch ex As Exception
            ModGlobal.EscribirLog("Error en EliminarUsuario: " & ex.Message)
            Return "ERROR: " & ex.Message
        End Try
    End Function

    <WebMethod()>
    <ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
    Public Shared Function CambiarEstadoUsuario(ByVal usuarioId As Integer, ByVal nuevoEstado As String) As String
        Try
            ModGlobal.EscribirLog("CambiarEstadoUsuario iniciado. UsuarioId: " & usuarioId & ", Estado: " & nuevoEstado)

            Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
            Dim sSql As String = "Exec sp_CambiarEstadoUsuario"
            Dim usuarioActual As Integer = HttpContext.Current.Session(VariablesSesion.UsuarioId)

            With objSql.Parametros
                .Add("@UsuarioId", usuarioId)
                .Add("@NuevoEstado", nuevoEstado)
                .Add("@UsuarioActual", usuarioActual)
            End With

            ModGlobal.EscribirLog($"Ejecutando: {sSql} {objSql.getParamList()}")
            Dim dt As DataTable = objSql.GetDataTableSql(sSql)

            ' Verificar si hubo error en la base de datos
            If objSql.MensajeError <> "" Then
                ModGlobal.EscribirLog("Error en BD al cambiar estado usuario: " & objSql.MensajeError)
                Return "ERROR: " & objSql.MensajeError
            Else
                ModGlobal.EscribirLog("Comando ejecutado correctamente - CambiarEstadoUsuario")
            End If

            Dim resultado As Object = If(dt.Rows.Count > 0, dt.Rows(0)(0), "OK")
            Return If(resultado IsNot Nothing, resultado.ToString(), "OK")
        Catch ex As Exception
            ModGlobal.EscribirLog("Error en CambiarEstadoUsuario: " & ex.Message)
            Return "ERROR: " & ex.Message
        End Try
    End Function

    <WebMethod()>
    <ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
    Public Shared Function VerificarUsuarioExistente(ByVal usuario As String, ByVal usuarioId As Integer) As String
        Try
            ModGlobal.EscribirLog("VerificarUsuarioExistente iniciado. Usuario: " & usuario & ", UsuarioId: " & usuarioId)

            Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
            Dim sSql As String = "SELECT COUNT(*) FROM tbUsuarios WHERE Usuario = @Usuario AND Id != @UsuarioId"

            With objSql.Parametros
                .Add("@Usuario", usuario)
                .Add("@UsuarioId", usuarioId)
            End With

            ModGlobal.EscribirLog($"Ejecutando: {sSql} {objSql.getParamList()}")
            Dim dt As DataTable = objSql.GetDataTableSql(sSql)

            ' Verificar si hubo error en la base de datos
            If objSql.MensajeError <> "" Then
                ModGlobal.EscribirLog("Error en BD al verificar usuario existente: " & objSql.MensajeError)
                Return "ERROR: " & objSql.MensajeError
            Else
                ModGlobal.EscribirLog("Comando ejecutado correctamente - VerificarUsuarioExistente")
            End If

            Dim count As Integer = Convert.ToInt32(dt.Rows(0)(0))
            Return If(count > 0, "EXISTE", "NO_EXISTE")
        Catch ex As Exception
            ModGlobal.EscribirLog("Error en VerificarUsuarioExistente: " & ex.Message)
            Return "ERROR: " & ex.Message
        End Try
    End Function

    <WebMethod()>
    <ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
    Public Shared Function VerificarEmailExistente(ByVal email As String, ByVal usuarioId As Integer) As String
        Try
            ModGlobal.EscribirLog("VerificarEmailExistente iniciado. Email: " & email & ", UsuarioId: " & usuarioId)

            Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
            Dim sSql As String = "SELECT COUNT(*) FROM tbUsuarios WHERE Email = @Email AND Id != @UsuarioId"

            With objSql.Parametros
                .Add("@Email", email)
                .Add("@UsuarioId", usuarioId)
            End With

            ModGlobal.EscribirLog($"Ejecutando: {sSql} {objSql.getParamList()}")
            Dim dt As DataTable = objSql.GetDataTableSql(sSql)

            ' Verificar si hubo error en la base de datos
            If objSql.MensajeError <> "" Then
                ModGlobal.EscribirLog("Error en BD al verificar email existente: " & objSql.MensajeError)
                Return "ERROR: " & objSql.MensajeError
            Else
                ModGlobal.EscribirLog("Comando ejecutado correctamente - VerificarEmailExistente")
            End If

            Dim count As Integer = Convert.ToInt32(dt.Rows(0)(0))
            Return If(count > 0, "EXISTE", "NO_EXISTE")
        Catch ex As Exception
            ModGlobal.EscribirLog("Error en VerificarEmailExistente: " & ex.Message)
            Return "ERROR: " & ex.Message
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

