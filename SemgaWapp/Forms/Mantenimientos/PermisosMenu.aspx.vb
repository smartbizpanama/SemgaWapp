Imports System.Data
Imports System.Web.Services
Imports System.Web.Script.Services
Imports System.Web.Script.Serialization
Imports SBSqlClient
Imports SBUtility

Public Class PermisosMenu
    Inherits BasePage

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Session("UsuarioId") Is Nothing Then
            Response.Redirect("~/Login.aspx")
            Return
        End If
        ' Puede asignar permisos de menú: admin (acceso total) o quien tenga permiso a Gestión de usuarios
        If Not ModGlobal.EsPermisosMenuAdmin(HttpContext.Current) AndAlso
           Not ModGlobal.TienePermisoMenuParaUrl(HttpContext.Current, "Forms/Mantenimientos/GestionUsuarios.aspx") Then
            Response.Redirect("~/Forms/Mantenimientos/dashboardSistemas.aspx")
            Return
        End If
    End Sub

    <WebMethod()>
    <ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
    Public Shared Function ListarUsuarios() As String
        Try
            Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
            Dim sSql As String = "SELECT Id, Usuario, Nombre, Apellido FROM tbUsuarios WHERE (ISNULL(snEliminado,0) = 0) ORDER BY Nombre, Apellido"
            ModGlobal.EscribirLog("Ejecutando: " & sSql & " " & objSql.getParamList())
            Dim dt As DataTable = objSql.GetDataTableSql(sSql)
            If objSql.MensajeError <> "" Then
                ModGlobal.EscribirLog("BD ERROR: ListarUsuarios - " & objSql.MensajeError)
                Return "ERROR: " & objSql.MensajeError
            End If
            ModGlobal.EscribirLog("BD OK: ListarUsuarios")
            Return DataTableToJSON(dt)
        Catch ex As Exception
            Return "ERROR: " & ex.Message
        End Try
    End Function

    ''' <summary>Obtiene ítems de tbMenuPrincipal y si el usuario tiene permiso (spMenuPrincipal_PermisosUsuario).</summary>
    <WebMethod()>
    <ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
    Public Shared Function ObtenerPermisosMenuUsuario(idUsuario As Integer) As String
        Try
            Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
            Dim sSql As String = "EXEC spMenuPrincipal_PermisosUsuario @IdUsuario"
            With objSql.Parametros
                .Add("@IdUsuario", idUsuario)
            End With
            ModGlobal.EscribirLog("Ejecutando: " & sSql & " " & objSql.getParamList())
            Dim dt As DataTable = objSql.GetDataTableSql(sSql)
            If objSql.MensajeError <> "" Then
                ModGlobal.EscribirLog("BD ERROR: ObtenerPermisosMenuUsuario - " & objSql.MensajeError)
                Return "ERROR: " & objSql.MensajeError
            End If
            ModGlobal.EscribirLog("BD OK: ObtenerPermisosMenuUsuario")
            Return DataTableToJSON(dt)
        Catch ex As Exception
            Return "ERROR: " & ex.Message
        End Try
    End Function

    ''' <summary>Guarda permisos en tbMenuUsuario (spMenuPrincipal_GuardarPermisos). idsMenuJson: array JSON de IdMenu, ej. [1,2,3,4].</summary>
    <WebMethod()>
    <ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
    Public Shared Function GuardarPermisos(idUsuario As Integer, idsMenuJson As String) As String
        Try
            Dim objSql As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
            Dim sSql As String = "EXEC spMenuPrincipal_GuardarPermisos @IdUsuario, @IdsMenuJson"
            With objSql.Parametros
                .Add("@IdUsuario", idUsuario)
                .Add("@IdsMenuJson", If(String.IsNullOrEmpty(idsMenuJson), "[]", idsMenuJson))
            End With
            ModGlobal.EscribirLog("Ejecutando: " & sSql & " " & objSql.getParamList())
            objSql.ExecuteNonQuerySql(sSql)
            If objSql.MensajeError <> "" Then
                ModGlobal.EscribirLog("BD ERROR: GuardarPermisos - " & objSql.MensajeError)
                Return "ERROR: " & objSql.MensajeError
            End If
            ModGlobal.EscribirLog("BD OK: GuardarPermisos")
            Return "OK"
        Catch ex As Exception
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
                    Dim val As Object = row(col)
                    If val IsNot Nothing AndAlso TypeOf val Is Boolean Then
                        dict.Add(col.ColumnName, val)
                    Else
                        dict.Add(col.ColumnName, If(row(col) Is DBNull.Value, Nothing, row(col)))
                    End If
                Next
                rows.Add(dict)
            Next
            Return serializer.Serialize(rows)
        Catch
            Return "[]"
        End Try
    End Function
End Class
