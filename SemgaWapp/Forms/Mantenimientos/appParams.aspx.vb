Imports System.Web.Services
Imports System.Web.Script.Services
Imports System.Web.Script.Serialization
Imports System.Data
Imports System.Collections.Generic
Imports SBSqlClient
Imports SBUtility

Public Class appParams
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        ' Página de carga
    End Sub

#Region "WebMethods"

    <WebMethod()>
    <ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
    Public Shared Function ListarGrupos() As String
        Dim objSql As SBSqlClientInterface = Nothing
        Try
            objSql = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
            Dim sSql As String = "Exec spParametrosAplicacion_ListarGrupos"

            ModGlobal.EscribirLog($"Ejecutando: {sSql} {objSql.getParamList()}")

            Dim dt As DataTable = objSql.GetDataTableSql(sSql)

            If String.IsNullOrEmpty(objSql.MensajeError) Then
                Dim grupos As New List(Of Object)

                For Each row As DataRow In dt.Rows
                    Dim grupo As New With {
                        .ParamGroup = row("ParamGroup").ToString()
                    }
                    grupos.Add(grupo)
                Next

                Dim json As New JavaScriptSerializer()
                Return json.Serialize(New With {
                    .Resultado = "SUCCESS",
                    .Mensaje = "Grupos obtenidos exitosamente",
                    .Datos = json.Serialize(grupos)
                })
            Else
                Return New JavaScriptSerializer().Serialize(New With {
                    .Resultado = "ERROR",
                    .Mensaje = objSql.MensajeError
                })
            End If

        Catch ex As Exception
            ModGlobal.EscribirLog($"Error en ListarGrupos: {ex.Message}")
            Return New JavaScriptSerializer().Serialize(New With {
                .Resultado = "ERROR",
                .Mensaje = "Error interno del servidor: " & ex.Message
            })
        End Try
    End Function

    <WebMethod()>
    <ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
    Public Shared Function ListarParametros(filtros As Object) As String
        Dim objSql As SBSqlClientInterface = Nothing
        Try
            objSql = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
            Dim sSql As String = "Exec spParametrosAplicacion_Listar"

            ' Agregar parámetros solo si no están vacíos
            If filtros IsNot Nothing Then
                Dim filtrosDict As Dictionary(Of String, Object) = filtros

                If filtrosDict.ContainsKey("ParamGroup") AndAlso Not String.IsNullOrEmpty(filtrosDict("ParamGroup").ToString()) Then
                    objSql.Parametros.Add("@ParamGroup", filtrosDict("ParamGroup").ToString())
                End If

                If filtrosDict.ContainsKey("Buscar") AndAlso Not String.IsNullOrEmpty(filtrosDict("Buscar").ToString()) Then
                    objSql.Parametros.Add("@Buscar", filtrosDict("Buscar").ToString())
                End If
            End If

            ModGlobal.EscribirLog($"Ejecutando: {sSql} {objSql.getParamList()}")

            Dim dt As DataTable = objSql.GetDataTableSql(sSql)

            If String.IsNullOrEmpty(objSql.MensajeError) Then
                Dim parametros As New List(Of Object)

                ModGlobal.EscribirLog($"Filas encontradas: {dt.Rows.Count}")

                For Each row As DataRow In dt.Rows
                    Dim parametro As New With {
                        .ParamKey = row("ParamKey").ToString(),
                        .ParamDescription = row("ParamDescription").ToString(),
                        .ParamGroup = row("ParamGroup").ToString(),
                        .ParamValue = row("ParamValue").ToString()
                    }
                    parametros.Add(parametro)
                Next

                ModGlobal.EscribirLog($"Parámetros procesados: {parametros.Count}")

                Dim json As New JavaScriptSerializer()
                Return json.Serialize(New With {
                    .Resultado = "SUCCESS",
                    .Mensaje = "Parámetros obtenidos exitosamente",
                    .Datos = json.Serialize(parametros)
                })
            Else
                ModGlobal.EscribirLog($"Error en BD: {objSql.MensajeError}")
                Return New JavaScriptSerializer().Serialize(New With {
                    .Resultado = "ERROR",
                    .Mensaje = objSql.MensajeError
                })
            End If

        Catch ex As Exception
            ModGlobal.EscribirLog($"Error en ListarParametros: {ex.Message}")
            Return New JavaScriptSerializer().Serialize(New With {
                .Resultado = "ERROR",
                .Mensaje = "Error interno del servidor: " & ex.Message
            })

        End Try
    End Function

    <WebMethod()>
    <ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
    Public Shared Function GuardarParametro(paramKey As String, paramValue As String) As String
        Dim objSql As SBSqlClientInterface = Nothing
        Try
            objSql = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
            Dim sSql As String = "Exec spParametrosAplicacion_Guardar"

            objSql.Parametros.Add("@ParamKey", paramKey)
            objSql.Parametros.Add("@ParamValue", paramValue)

            ModGlobal.EscribirLog($"Ejecutando: {sSql} {objSql.getParamList()}")

            Dim dt As DataTable = objSql.GetDataTableSql(sSql)

            If String.IsNullOrEmpty(objSql.MensajeError) Then
                If dt.Rows.Count > 0 Then
                    Dim resultado As String = dt.Rows(0)("Resultado").ToString()
                    Dim mensaje As String = dt.Rows(0)("Mensaje").ToString()

                    Return New JavaScriptSerializer().Serialize(New With {
                        .Resultado = resultado,
                        .Mensaje = mensaje
                    })
                Else
                    Return New JavaScriptSerializer().Serialize(New With {
                        .Resultado = "ERROR",
                        .Mensaje = "No se recibió respuesta del servidor"
                    })
                End If
            Else
                Return New JavaScriptSerializer().Serialize(New With {
                    .Resultado = "ERROR",
                    .Mensaje = objSql.MensajeError
                })
            End If

        Catch ex As Exception
            ModGlobal.EscribirLog($"Error en GuardarParametro: {ex.Message}")
            Return New JavaScriptSerializer().Serialize(New With {
                .Resultado = "ERROR",
                .Mensaje = "Error interno del servidor: " & ex.Message
            })
        End Try
    End Function

#End Region

End Class