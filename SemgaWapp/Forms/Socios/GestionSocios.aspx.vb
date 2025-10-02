Imports System.Web.Services
Imports System.Web.Script.Services
Imports System.Web.Script.Serialization
Imports SBSqlClient
Imports SBUtility
Imports System.Data
Imports Newtonsoft.Json
Imports Newtonsoft.Json.Linq
Imports System.Web.Security

Public Class GestionSocios
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        ' Verificar autenticación
        If Session(VariablesSesion.UsuarioId) Is Nothing Then
            Response.Redirect("~/Login.aspx")
            Return
        End If
    End Sub


    <WebMethod(EnableSession:=True)>
    <ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
    Public Shared Function ObtenerTiposAsociado() As String
        Dim serializer As New JavaScriptSerializer()

        Try
            Dim uDBA As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
            Dim sSql As String = "SELECT IdTipoAsociado, TipoAsociado FROM tbTipoAsociado ORDER BY TipoAsociado"



            EscribirLog("Obteniendo tipos de asociado: " & sSql)
            EscribirLog($"Ejecutando: {sSql} {uDBA.getParamList()}")

            Dim dt As DataTable = uDBA.GetDataTableSql(sSql)

            If uDBA.MensajeError = "" Then
                EscribirLog("Tipos de asociado obtenidos exitosamente. Registros: " & dt.Rows.Count)

                ' Convertir DataTable a JSON
                Dim jsonData As New List(Of Dictionary(Of String, Object))

                For Each row As DataRow In dt.Rows
                    Dim item As New Dictionary(Of String, Object)
                    For Each column As DataColumn In dt.Columns
                        item(column.ColumnName) = If(row(column) Is DBNull.Value, Nothing, row(column))
                    Next
                    jsonData.Add(item)
                Next

                ' Retornar objeto con información de éxito
                Dim result As New Dictionary(Of String, Object)
                result("Success") = True
                result("Message") = ""
                result("TotalRegistros") = dt.Rows.Count
                result("Data") = jsonData
                Return serializer.Serialize(result)
            Else
                EscribirLog("Error al obtener tipos de asociado: " & uDBA.MensajeError)

                ' Retornar objeto con información de error
                Dim result As New Dictionary(Of String, Object)
                result("Success") = False
                result("Message") = uDBA.MensajeError
                result("TotalRegistros") = 0
                result("Data") = New List(Of Object)
                Return serializer.Serialize(result)
            End If

        Catch ex As Exception
            EscribirLog("Error al obtener tipos de asociado: " & ex.Message)

            ' Retornar objeto con información de error
            Dim result As New Dictionary(Of String, Object)
            result("Success") = False
            result("Message") = ex.Message
            result("TotalRegistros") = 0
            result("Data") = New List(Of Object)
            Return serializer.Serialize(result)
        End Try
    End Function

    <WebMethod(EnableSession:=True)>
    <ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
    Public Shared Function ObtenerStatusAsociado() As String
        Dim serializer As New JavaScriptSerializer()

        Try
            Dim uDBA As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
            Dim sSql As String = "SELECT CodStatusAsociado, StatusAsociado FROM tbStatusAsociado ORDER BY StatusAsociado"

            EscribirLog("Obteniendo status de asociado: " & sSql)
            EscribirLog($"Ejecutando: {sSql} {uDBA.getParamList()}")

            Dim dt As DataTable = uDBA.GetDataTableSql(sSql)

            If uDBA.MensajeError = "" Then
                EscribirLog("Status de asociado obtenidos exitosamente. Registros: " & dt.Rows.Count)

                ' Convertir DataTable a JSON
                Dim jsonData As New List(Of Dictionary(Of String, Object))

                For Each row As DataRow In dt.Rows
                    Dim item As New Dictionary(Of String, Object)
                    For Each column As DataColumn In dt.Columns
                        item(column.ColumnName) = If(row(column) Is DBNull.Value, Nothing, row(column))
                    Next
                    jsonData.Add(item)
                Next

                ' Retornar objeto con información de éxito
                Dim result As New Dictionary(Of String, Object)
                result("Success") = True
                result("Message") = ""
                result("TotalRegistros") = dt.Rows.Count
                result("Data") = jsonData
                Return serializer.Serialize(result)
            Else
                EscribirLog("Error al obtener status de asociado: " & uDBA.MensajeError)

                ' Retornar objeto con información de error
                Dim result As New Dictionary(Of String, Object)
                result("Success") = False
                result("Message") = uDBA.MensajeError
                result("TotalRegistros") = 0
                result("Data") = New List(Of Object)
                Return serializer.Serialize(result)
            End If

        Catch ex As Exception
            EscribirLog("Error al obtener status de asociado: " & ex.Message)

            ' Retornar objeto con información de error
            Dim result As New Dictionary(Of String, Object)
            result("Success") = False
            result("Message") = ex.Message
            result("TotalRegistros") = 0
            result("Data") = New List(Of Object)
            Return serializer.Serialize(result)
        End Try
    End Function

    <WebMethod(EnableSession:=True)>
    <ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
    Public Shared Function ObtenerParametroSistema(paramKey As String) As String
        Dim serializer As New JavaScriptSerializer()
        Try
            Dim paramValue As String = HttpContext.Current.Session(paramKey)

            Dim result As New Dictionary(Of String, Object)
            result("Success") = True
            result("Message") = ""
            result("Data") = paramValue
            Return serializer.Serialize(result)
        Catch ex As Exception
            Dim result As New Dictionary(Of String, Object)
            result("Success") = False
            result("Message") = "Error al obtener parámetro: " & ex.Message
            result("Data") = Nothing
            Return serializer.Serialize(result)
        End Try
    End Function


    <WebMethod(EnableSession:=True)>
    <ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
    Public Shared Function ObtenerTiposDocumento() As String
        Dim serializer As New JavaScriptSerializer()

        Try
            Dim uDBA As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
            Dim sSql As String = "SELECT CodTipoDoc, TipoDocumento FROM tbTipoDocumentos ORDER BY TipoDocumento"

            EscribirLog("Obteniendo tipos de documento: " & sSql)
            EscribirLog($"Ejecutando: {sSql} {uDBA.getParamList()}")

            Dim dt As DataTable = uDBA.GetDataTableSql(sSql)

            If uDBA.MensajeError = "" Then
                EscribirLog("Tipos de documento obtenidos exitosamente. Registros: " & dt.Rows.Count)

                ' Convertir DataTable a JSON
                Dim jsonData As New List(Of Dictionary(Of String, Object))

                For Each row As DataRow In dt.Rows
                    Dim item As New Dictionary(Of String, Object)
                    For Each column As DataColumn In dt.Columns
                        item(column.ColumnName) = If(row(column) Is DBNull.Value, Nothing, row(column))
                    Next
                    jsonData.Add(item)
                Next

                ' Retornar objeto con información de éxito
                Dim result As New Dictionary(Of String, Object)
                result("Success") = True
                result("Message") = ""
                result("TotalRegistros") = dt.Rows.Count
                result("Data") = jsonData
                Return serializer.Serialize(result)
            Else
                EscribirLog("Error al obtener tipos de documento: " & uDBA.MensajeError)

                ' Retornar objeto con información de error
                Dim result As New Dictionary(Of String, Object)
                result("Success") = False
                result("Message") = uDBA.MensajeError
                result("TotalRegistros") = 0
                result("Data") = New List(Of Object)
                Return serializer.Serialize(result)
            End If

        Catch ex As Exception
            EscribirLog("Error al obtener tipos de documento: " & ex.Message)

            ' Retornar objeto con información de error
            Dim result As New Dictionary(Of String, Object)
            result("Success") = False
            result("Message") = ex.Message
            result("TotalRegistros") = 0
            result("Data") = New List(Of Object)
            Return serializer.Serialize(result)
        End Try
    End Function

    <WebMethod(EnableSession:=True)>
    <ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
    Public Shared Function ObtenerSocios(filtrosJson As String) As String
        Try
            Dim filtros = JsonConvert.DeserializeObject(Of JObject)(filtrosJson)
            Dim uDBA As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
            Dim sSql As String = "Exec spGestionSocios_ObtenerSocios"

            With uDBA.Parametros
                If Not String.IsNullOrEmpty(filtros("FiltroNombre")?.ToString()) Then
                    .Add("@FiltroNombre", filtros("FiltroNombre").ToString())
                End If
                If Not String.IsNullOrEmpty(filtros("FiltroTipo")?.ToString()) Then
                    .Add("@FiltroTipo", filtros("FiltroTipo").ToString())
                End If
                If Not String.IsNullOrEmpty(filtros("FiltroEstatus")?.ToString()) Then
                    .Add("@FiltroEstatus", filtros("FiltroEstatus").ToString())
                End If
                If Not String.IsNullOrEmpty(filtros("FiltroTipoDocumento")?.ToString()) Then
                    .Add("@FiltroTipoDocumento", filtros("FiltroTipoDocumento").ToString())
                End If
                If Not String.IsNullOrEmpty(filtros("FiltroIdentificacion")?.ToString()) Then
                    .Add("@FiltroIdentificacion", filtros("FiltroIdentificacion").ToString())
                End If
            End With

            EscribirLog("Obteniendo socios: " & sSql & " " & uDBA.getParamList())
            EscribirLog($"Ejecutando: {sSql} {uDBA.getParamList()}")

            Dim dt As DataTable = uDBA.GetDataTableSql(sSql)

            EscribirLog("Mensaje de error de uDBA: '" & uDBA.MensajeError & "'")

            If uDBA.MensajeError = "" Then
                EscribirLog("Socios obtenidos exitosamente. Registros: " & dt.Rows.Count)

                ' Convertir DataTable a JSON
                Dim serializer As New JavaScriptSerializer()
                Dim jsonData As New List(Of Dictionary(Of String, Object))

                For Each row As DataRow In dt.Rows
                    Dim item As New Dictionary(Of String, Object)
                    For Each column As DataColumn In dt.Columns
                        item(column.ColumnName) = If(row(column) Is DBNull.Value, Nothing, row(column))
                    Next
                    jsonData.Add(item)
                Next

                ' Retornar objeto con información de éxito
                Dim result As New Dictionary(Of String, Object)
                result("Success") = True
                result("Message") = ""
                result("TotalRegistros") = dt.Rows.Count
                result("Data") = jsonData

                Return serializer.Serialize(result)
            Else
                EscribirLog("Error al obtener socios: " & uDBA.MensajeError)

                ' Retornar objeto con información de error
                Dim result As New Dictionary(Of String, Object)
                result("Success") = False
                result("Message") = uDBA.MensajeError
                result("TotalRegistros") = 0
                result("Data") = New List(Of Object)

                Dim serializer As New JavaScriptSerializer()
                Return serializer.Serialize(result)
            End If

        Catch ex As Exception
            EscribirLog("Error al obtener socios: " & ex.Message)

            ' Retornar objeto con información de error
            Dim result As New Dictionary(Of String, Object)
            result("Success") = False
            result("Message") = ex.Message
            result("TotalRegistros") = 0
            result("Data") = New List(Of Object)

            Dim serializer As New JavaScriptSerializer()
            Return serializer.Serialize(result)
        End Try
    End Function

    <WebMethod(EnableSession:=True)>
    <ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
    Public Shared Function ObtenerSocioPorNumero(numeroAsociado As Integer) As String
        Dim serializer As New JavaScriptSerializer()
        Try
            Dim uDBA As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
            Dim sSql As String = "Exec spGestionSocios_ObtenerSocioPorNumero"

            With uDBA.Parametros
                .Add("@NumeroAsociado", numeroAsociado)
            End With

            EscribirLog("Obteniendo socio por número: " & sSql & " " & uDBA.getParamList())
            EscribirLog($"Ejecutando: {sSql} {uDBA.getParamList()}")

            Dim dt As DataTable = uDBA.GetDataTableSql(sSql)

            If uDBA.MensajeError = "" Then
                If dt.Rows.Count > 0 Then
                    EscribirLog("Socio obtenido exitosamente")

                    ' Convertir DataTable a JSON
                    Dim jsonData As New List(Of Dictionary(Of String, Object))

                    For Each row As DataRow In dt.Rows
                        Dim item As New Dictionary(Of String, Object)
                        For Each column As DataColumn In dt.Columns
                            item(column.ColumnName) = If(row(column) Is DBNull.Value, Nothing, row(column))
                        Next
                        jsonData.Add(item)
                    Next

                    ' Devolver estructura estándar
                    Dim result As New Dictionary(Of String, Object)
                    result("Success") = True
                    result("Message") = ""
                    result("TotalRegistros") = dt.Rows.Count
                    result("Data") = jsonData(0) ' Solo el primer (y único) socio
                    Return serializer.Serialize(result)
                Else
                    EscribirLog("Socio no encontrado")
                    Dim result As New Dictionary(Of String, Object)
                    result("Success") = False
                    result("Message") = "Socio no encontrado"
                    result("TotalRegistros") = 0
                    result("Data") = Nothing
                    Return serializer.Serialize(result)
                End If
            Else
                EscribirLog("Error al obtener socio: " & uDBA.MensajeError)
                Dim result As New Dictionary(Of String, Object)
                result("Success") = False
                result("Message") = uDBA.MensajeError
                result("TotalRegistros") = 0
                result("Data") = Nothing
                Return serializer.Serialize(result)
            End If

        Catch ex As Exception
            EscribirLog("Error al obtener socio: " & ex.Message)
            Dim result As New Dictionary(Of String, Object)
            result("Success") = False
            result("Message") = "Error al obtener socio: " & ex.Message
            result("TotalRegistros") = 0
            result("Data") = Nothing
            Return serializer.Serialize(result)
        End Try
    End Function

    Private Shared Function AplicarMayusculasAutomaticas(socioData As JObject) As JObject
        Try
            ' Verificar si está habilitada la conversión automática a mayúsculas
            Dim mayusAutomaticas As String = HttpContext.Current.Session(VariablesSesion.MAYUS_AUTOM_CREACION_SOCIOS)

            If mayusAutomaticas = "1" Then
                ' Campos de texto que deben convertirse a mayúsculas
                Dim camposTexto() As String = {
                    "Nombre", "SegundoNombre", "Apellido", "SegundoApellido",
                    "LugarTrabajo", "Ocupacion", "ProvinciaTrabajo", "DistritoTrabajo",
                    "CorregimientoTrabajo", "DireccionTrabajo", "ProvinciaResidencia",
                    "DistritoResidencia", "CorregimientoResidencia", "DireccionResidencia",
                    "NivelEstudio", "Profesion"
                }

                ' Convertir cada campo a mayúsculas si existe
                For Each campo As String In camposTexto
                    If socioData(campo) IsNot Nothing AndAlso Not String.IsNullOrEmpty(socioData(campo).ToString()) Then
                        socioData(campo) = socioData(campo).ToString().ToUpper()
                    End If
                Next
                        End If

            Return socioData
        Catch ex As Exception
            EscribirLog("Error al aplicar mayúsculas automáticas: " & ex.Message)
            Return socioData ' Retornar datos originales en caso de error
        End Try
    End Function

    <WebMethod(EnableSession:=True)>
    Public Shared Function CrearSocio(socioDataJson As String) As String
        Dim serializer As New JavaScriptSerializer()

        Try
            Dim socioData = JsonConvert.DeserializeObject(Of JObject)(socioDataJson)

            ' Aplicar mayúsculas automáticas si está habilitado
            socioData = AplicarMayusculasAutomaticas(socioData)

            Dim uDBA As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
            Dim sSql As String = "Exec spGestionSocios_CrearSocio"

            With uDBA.Parametros
                If Not String.IsNullOrEmpty(socioData("IdTipoAsociado")?.ToString()) Then
                    .Add("@IdTipoAsociado", socioData("IdTipoAsociado").ToString())
                End If
                If Not String.IsNullOrEmpty(socioData("Nombre")?.ToString()) Then
                    .Add("@Nombre", socioData("Nombre").ToString())
                End If
                If Not String.IsNullOrEmpty(socioData("SegundoNombre")?.ToString()) Then
                    .Add("@SegundoNombre", socioData("SegundoNombre").ToString())
                End If
                If Not String.IsNullOrEmpty(socioData("Apellido")?.ToString()) Then
                    .Add("@Apellido", socioData("Apellido").ToString())
                End If
                If Not String.IsNullOrEmpty(socioData("SegundoApellido")?.ToString()) Then
                    .Add("@SegundoApellido", socioData("SegundoApellido").ToString())
                End If
                If Not String.IsNullOrEmpty(socioData("Estatus")?.ToString()) Then
                    .Add("@Estatus", socioData("Estatus").ToString())
                End If
                If Not String.IsNullOrEmpty(socioData("TipoIdentificacion")?.ToString()) Then
                    .Add("@TipoIdentificacion", socioData("TipoIdentificacion").ToString())
                End If
                If Not String.IsNullOrEmpty(socioData("NumeroIdentificacion")?.ToString()) Then
                    .Add("@NumeroIdentificacion", socioData("NumeroIdentificacion").ToString())
                End If
                If Not String.IsNullOrEmpty(socioData("TelefonoResidencia")?.ToString()) Then
                    .Add("@TelefonoResidencia", socioData("TelefonoResidencia").ToString())
                End If
                If Not String.IsNullOrEmpty(socioData("TelefonoCelular")?.ToString()) Then
                    .Add("@TelefonoCelular", socioData("TelefonoCelular").ToString())
                End If
                If Not String.IsNullOrEmpty(socioData("TelefonoFamiliar")?.ToString()) Then
                    .Add("@TelefonoFamiliar", socioData("TelefonoFamiliar").ToString())
                End If
                If Not String.IsNullOrEmpty(socioData("CorreoElectronico")?.ToString()) Then
                    .Add("@CorreoElectronico", socioData("CorreoElectronico").ToString())
                End If
                If Not String.IsNullOrEmpty(socioData("Sexo")?.ToString()) Then
                    .Add("@Sexo", socioData("Sexo").ToString())
                End If
                If Not String.IsNullOrEmpty(socioData("FechaNacimiento")?.ToString()) Then
                    .Add("@FechaNacimiento", socioData("FechaNacimiento").ToString())
                End If
                If Not String.IsNullOrEmpty(socioData("ProvinciaResidencia")?.ToString()) Then
                    .Add("@ProvinciaResidencia", socioData("ProvinciaResidencia").ToString())
                End If
                If Not String.IsNullOrEmpty(socioData("DistritoResidencia")?.ToString()) Then
                    .Add("@DistritoResidencia", socioData("DistritoResidencia").ToString())
                End If
                If Not String.IsNullOrEmpty(socioData("CorregimientoResidencia")?.ToString()) Then
                    .Add("@CorregimientoResidencia", socioData("CorregimientoResidencia").ToString())
                End If
                If Not String.IsNullOrEmpty(socioData("DireccionResidencia")?.ToString()) Then
                    .Add("@DireccionResidencia", socioData("DireccionResidencia").ToString())
                End If
                If Not String.IsNullOrEmpty(socioData("ProvinciaTrabajo")?.ToString()) Then
                    .Add("@ProvinciaTrabajo", socioData("ProvinciaTrabajo").ToString())
                End If
                If Not String.IsNullOrEmpty(socioData("DistritoTrabajo")?.ToString()) Then
                    .Add("@DistritoTrabajo", socioData("DistritoTrabajo").ToString())
                End If
                If Not String.IsNullOrEmpty(socioData("CorregimientoTrabajo")?.ToString()) Then
                    .Add("@CorregimientoTrabajo", socioData("CorregimientoTrabajo").ToString())
                End If
                If Not String.IsNullOrEmpty(socioData("DireccionTrabajo")?.ToString()) Then
                    .Add("@DireccionTrabajo", socioData("DireccionTrabajo").ToString())
                End If
                If Not String.IsNullOrEmpty(socioData("LugarTrabajo")?.ToString()) Then
                    .Add("@LugarTrabajo", socioData("LugarTrabajo").ToString())
                End If
                If Not String.IsNullOrEmpty(socioData("Ocupacion")?.ToString()) Then
                    .Add("@Ocupacion", socioData("Ocupacion").ToString())
                End If
                If Not String.IsNullOrEmpty(socioData("NivelEstudio")?.ToString()) Then
                    .Add("@NivelEstudio", socioData("NivelEstudio").ToString())
                End If
                If Not String.IsNullOrEmpty(socioData("Profesion")?.ToString()) Then
                    .Add("@Profesion", socioData("Profesion").ToString())
                    End If
                .Add("@Usuario", HttpContext.Current.Session(VariablesSesion.UsuarioId).ToString())
            End With

            EscribirLog("Creando socio: " & sSql & " " & uDBA.getParamList())
            EscribirLog($"Ejecutando: {sSql} {uDBA.getParamList()}")

            Dim dt As DataTable = uDBA.GetDataTableSql(sSql)

            If uDBA.MensajeError = "" Then
                EscribirLog("Socio creado exitosamente")
                
                ' Obtener el número de asociado generado
                Dim numeroAsociadoGenerado As Integer = 0
                If dt.Rows.Count > 0 AndAlso dt.Rows(0)("NumeroAsociado") IsNot DBNull.Value Then
                    Integer.TryParse(dt.Rows(0)("NumeroAsociado").ToString(), numeroAsociadoGenerado)
                End If
                
                Dim result As New Dictionary(Of String, Object)
                result("Success") = True
                result("Message") = "Socio creado exitosamente"
                result("Data") = New With {.NumeroAsociado = numeroAsociadoGenerado}
                Return serializer.Serialize(result)
            Else
                EscribirLog("Error al crear socio: " & uDBA.MensajeError)
                Dim result As New Dictionary(Of String, Object)
                result("Success") = False
                result("Message") = "Error al crear socio: " & uDBA.MensajeError
                result("Data") = Nothing
                Return serializer.Serialize(result)
            End If

        Catch ex As Exception
            EscribirLog("Error al crear socio: " & ex.Message)
            Dim result As New Dictionary(Of String, Object)
            result("Success") = False
            result("Message") = "Error al crear socio: " & ex.Message
            result("Data") = Nothing
            Return serializer.Serialize(result)
        End Try
    End Function

    <WebMethod(EnableSession:=True)>
    Public Shared Function ActualizarSocio(socioDataJson As String) As String
        Dim serializer As New JavaScriptSerializer()

        Try
            Dim socioData = JsonConvert.DeserializeObject(Of JObject)(socioDataJson)

            ' Aplicar mayúsculas automáticas si está habilitado
            socioData = AplicarMayusculasAutomaticas(socioData)

            Dim uDBA As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
            Dim sSql As String = "Exec spGestionSocios_ActualizarSocio"

            With uDBA.Parametros
                .Add("@NumeroAsociado", socioData("NumeroAsociado").ToString())
                If Not String.IsNullOrEmpty(socioData("IdTipoAsociado")?.ToString()) Then
                    .Add("@IdTipoAsociado", socioData("IdTipoAsociado").ToString())
                End If
                If Not String.IsNullOrEmpty(socioData("Nombre")?.ToString()) Then
                    .Add("@Nombre", socioData("Nombre").ToString())
                End If
                If Not String.IsNullOrEmpty(socioData("SegundoNombre")?.ToString()) Then
                    .Add("@SegundoNombre", socioData("SegundoNombre").ToString())
                End If
                If Not String.IsNullOrEmpty(socioData("Apellido")?.ToString()) Then
                    .Add("@Apellido", socioData("Apellido").ToString())
                End If
                If Not String.IsNullOrEmpty(socioData("SegundoApellido")?.ToString()) Then
                    .Add("@SegundoApellido", socioData("SegundoApellido").ToString())
                End If
                If Not String.IsNullOrEmpty(socioData("Estatus")?.ToString()) Then
                    .Add("@Estatus", socioData("Estatus").ToString())
                End If
                If Not String.IsNullOrEmpty(socioData("TipoIdentificacion")?.ToString()) Then
                    .Add("@TipoIdentificacion", socioData("TipoIdentificacion").ToString())
                End If
                If Not String.IsNullOrEmpty(socioData("NumeroIdentificacion")?.ToString()) Then
                    .Add("@NumeroIdentificacion", socioData("NumeroIdentificacion").ToString())
                End If
                If Not String.IsNullOrEmpty(socioData("TelefonoResidencia")?.ToString()) Then
                    .Add("@TelefonoResidencia", socioData("TelefonoResidencia").ToString())
                End If
                If Not String.IsNullOrEmpty(socioData("TelefonoCelular")?.ToString()) Then
                    .Add("@TelefonoCelular", socioData("TelefonoCelular").ToString())
                End If
                If Not String.IsNullOrEmpty(socioData("TelefonoFamiliar")?.ToString()) Then
                    .Add("@TelefonoFamiliar", socioData("TelefonoFamiliar").ToString())
                End If
                If Not String.IsNullOrEmpty(socioData("CorreoElectronico")?.ToString()) Then
                    .Add("@CorreoElectronico", socioData("CorreoElectronico").ToString())
                End If
                If Not String.IsNullOrEmpty(socioData("Sexo")?.ToString()) Then
                    .Add("@Sexo", socioData("Sexo").ToString())
                End If
                If Not String.IsNullOrEmpty(socioData("FechaNacimiento")?.ToString()) Then
                    .Add("@FechaNacimiento", socioData("FechaNacimiento").ToString())
                End If
                If Not String.IsNullOrEmpty(socioData("ProvinciaResidencia")?.ToString()) Then
                    .Add("@ProvinciaResidencia", socioData("ProvinciaResidencia").ToString())
                End If
                If Not String.IsNullOrEmpty(socioData("DistritoResidencia")?.ToString()) Then
                    .Add("@DistritoResidencia", socioData("DistritoResidencia").ToString())
                End If
                If Not String.IsNullOrEmpty(socioData("CorregimientoResidencia")?.ToString()) Then
                    .Add("@CorregimientoResidencia", socioData("CorregimientoResidencia").ToString())
                End If
                If Not String.IsNullOrEmpty(socioData("DireccionResidencia")?.ToString()) Then
                    .Add("@DireccionResidencia", socioData("DireccionResidencia").ToString())
                End If
                If Not String.IsNullOrEmpty(socioData("ProvinciaTrabajo")?.ToString()) Then
                    .Add("@ProvinciaTrabajo", socioData("ProvinciaTrabajo").ToString())
                End If
                If Not String.IsNullOrEmpty(socioData("DistritoTrabajo")?.ToString()) Then
                    .Add("@DistritoTrabajo", socioData("DistritoTrabajo").ToString())
                End If
                If Not String.IsNullOrEmpty(socioData("CorregimientoTrabajo")?.ToString()) Then
                    .Add("@CorregimientoTrabajo", socioData("CorregimientoTrabajo").ToString())
                End If
                If Not String.IsNullOrEmpty(socioData("DireccionTrabajo")?.ToString()) Then
                    .Add("@DireccionTrabajo", socioData("DireccionTrabajo").ToString())
                End If
                If Not String.IsNullOrEmpty(socioData("LugarTrabajo")?.ToString()) Then
                    .Add("@LugarTrabajo", socioData("LugarTrabajo").ToString())
                End If
                If Not String.IsNullOrEmpty(socioData("Ocupacion")?.ToString()) Then
                    .Add("@Ocupacion", socioData("Ocupacion").ToString())
                End If
                If Not String.IsNullOrEmpty(socioData("NivelEstudio")?.ToString()) Then
                    .Add("@NivelEstudio", socioData("NivelEstudio").ToString())
                End If
                If Not String.IsNullOrEmpty(socioData("Profesion")?.ToString()) Then
                    .Add("@Profesion", socioData("Profesion").ToString())
                End If
                .Add("@Usuario", HttpContext.Current.Session(VariablesSesion.UsuarioId).ToString())
            End With

            EscribirLog("Actualizando socio: " & sSql & " " & uDBA.getParamList())
            EscribirLog($"Ejecutando: {sSql} {uDBA.getParamList()}")

            uDBA.ExecuteNonQuerySql(sSql)

            If uDBA.MensajeError = "" Then
                EscribirLog("Socio actualizado exitosamente")
                Dim result As New Dictionary(Of String, Object)
                result("Success") = True
                result("Message") = "Socio actualizado exitosamente"
                result("Data") = Nothing
                Return serializer.Serialize(result)
            Else
                EscribirLog("Error al actualizar socio: " & uDBA.MensajeError)
                Dim result As New Dictionary(Of String, Object)
                result("Success") = False
                result("Message") = "Error al actualizar socio: " & uDBA.MensajeError
                result("Data") = Nothing
                Return serializer.Serialize(result)
            End If

        Catch ex As Exception
            EscribirLog("Error al actualizar socio: " & ex.Message)
            Dim result As New Dictionary(Of String, Object)
            result("Success") = False
            result("Message") = "Error al actualizar socio: " & ex.Message
            result("Data") = Nothing
            Return serializer.Serialize(result)
        End Try
    End Function

    <WebMethod(EnableSession:=True)>
    <ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
    Public Shared Function ObtenerParentezcos() As String
        Dim serializer As New JavaScriptSerializer()
        Try
            Dim uDBA As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
            Dim sSql As String = "Exec spBeneficiarios_ObtenerParentezcos"

            EscribirLog("Obteniendo parentezcos: " & sSql)
            EscribirLog($"Ejecutando: {sSql} {uDBA.getParamList()}")

            Dim dt As DataTable = uDBA.GetDataTableSql(sSql)

            If uDBA.MensajeError = "" Then
                EscribirLog("Parentezcos obtenidos exitosamente")

                ' Convertir DataTable a JSON
                Dim jsonData As New List(Of Dictionary(Of String, Object))

                For Each row As DataRow In dt.Rows
                    Dim item As New Dictionary(Of String, Object)
                    For Each column As DataColumn In dt.Columns
                        item(column.ColumnName) = If(row(column) Is DBNull.Value, Nothing, row(column))
                    Next
                    jsonData.Add(item)
                Next

                ' Devolver estructura estándar
                Dim result As New Dictionary(Of String, Object)
                result("Success") = True
                result("Message") = ""
                result("TotalRegistros") = dt.Rows.Count
                result("Data") = jsonData
                Return serializer.Serialize(result)
            Else
                EscribirLog("Error al obtener parentezcos: " & uDBA.MensajeError)
                Dim result As New Dictionary(Of String, Object)
                result("Success") = False
                result("Message") = uDBA.MensajeError
                result("TotalRegistros") = 0
                result("Data") = New List(Of Object)
                Return serializer.Serialize(result)
            End If

        Catch ex As Exception
            EscribirLog("Error al obtener parentezcos: " & ex.Message)
            Dim result As New Dictionary(Of String, Object)
            result("Success") = False
            result("Message") = "Error al obtener parentezcos: " & ex.Message
            result("TotalRegistros") = 0
            result("Data") = New List(Of Object)
            Return serializer.Serialize(result)
        End Try
    End Function

    <WebMethod(EnableSession:=True)>
    <ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
    Public Shared Function ObtenerBeneficiarios(numeroAsociado As Integer) As String
        Dim serializer As New JavaScriptSerializer()
        Try
            Dim uDBA As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
            Dim sSql As String = "Exec spBeneficiarios_ObtenerBeneficiarios"

            With uDBA.Parametros
                .Add("@NumeroAsociado", numeroAsociado)
            End With

            EscribirLog("Obteniendo beneficiarios: " & sSql & " " & uDBA.getParamList())
            EscribirLog($"Ejecutando: {sSql} {uDBA.getParamList()}")

            Dim dt As DataTable = uDBA.GetDataTableSql(sSql)

            If uDBA.MensajeError = "" Then
                EscribirLog("Beneficiarios obtenidos exitosamente")

                ' Convertir DataTable a JSON
                Dim jsonData As New List(Of Dictionary(Of String, Object))

                For Each row As DataRow In dt.Rows
                    Dim item As New Dictionary(Of String, Object)
                    For Each column As DataColumn In dt.Columns
                        item(column.ColumnName) = If(row(column) Is DBNull.Value, Nothing, row(column))
                    Next
                    jsonData.Add(item)
                Next

                ' Devolver estructura estándar
                Dim result As New Dictionary(Of String, Object)
                result("Success") = True
                result("Message") = ""
                result("TotalRegistros") = dt.Rows.Count
                result("Data") = jsonData
                Return serializer.Serialize(result)
            Else
                EscribirLog("Error al obtener beneficiarios: " & uDBA.MensajeError)
                Dim result As New Dictionary(Of String, Object)
                result("Success") = False
                result("Message") = uDBA.MensajeError
                result("TotalRegistros") = 0
                result("Data") = New List(Of Object)
                Return serializer.Serialize(result)
            End If

        Catch ex As Exception
            EscribirLog("Error al obtener beneficiarios: " & ex.Message)
            Dim result As New Dictionary(Of String, Object)
            result("Success") = False
            result("Message") = "Error al obtener beneficiarios: " & ex.Message
            result("TotalRegistros") = 0
            result("Data") = New List(Of Object)
            Return serializer.Serialize(result)
        End Try
    End Function

    <WebMethod(EnableSession:=True)>
    <ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
    Public Shared Function CrearBeneficiario(beneficiarioDataJson As String) As String
        Dim serializer As New JavaScriptSerializer()
        Try
            Dim beneficiarioData = JsonConvert.DeserializeObject(Of JObject)(beneficiarioDataJson)
            Dim uDBA As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
            Dim sSql As String = "Exec spBeneficiarios_CrearBeneficiario"

            With uDBA.Parametros
                .Add("@NumeroAsociado", beneficiarioData("NumeroAsociado").ToString())
                .Add("@Nombre", beneficiarioData("Nombre").ToString())
                .Add("@Apellido", beneficiarioData("Apellido").ToString())
                .Add("@TipoIdentificacion", beneficiarioData("TipoIdentificacion").ToString())
                .Add("@NumeroIdentificacion", beneficiarioData("NumeroIdentificacion").ToString())
                .Add("@IDParentezco", beneficiarioData("IDParentezco").ToString())
                .Add("@Porcentaje", beneficiarioData("Porcentaje").ToString())
            End With

            EscribirLog("Creando beneficiario: " & sSql & " " & uDBA.getParamList())
            EscribirLog($"Ejecutando: {sSql} {uDBA.getParamList()}")

            Dim dt As DataTable = uDBA.GetDataTableSql(sSql)

            If uDBA.MensajeError = "" AndAlso dt.Rows.Count > 0 Then
                Dim resultado = dt.Rows(0)("Resultado").ToString()
                Dim mensaje = dt.Rows(0)("Mensaje").ToString()

                If resultado = "SUCCESS" Then
                    EscribirLog("Beneficiario creado exitosamente")
                    Dim result As New Dictionary(Of String, Object)
                    result("Success") = True
                    result("Message") = mensaje
                    result("Data") = Nothing
                    Return serializer.Serialize(result)
                Else
                    EscribirLog("Error al crear beneficiario: " & mensaje)
                    Dim result As New Dictionary(Of String, Object)
                    result("Success") = False
                    result("Message") = mensaje
                    result("Data") = Nothing
                    Return serializer.Serialize(result)
                End If
            Else
                EscribirLog("Error al crear beneficiario: " & uDBA.MensajeError)
                Dim result As New Dictionary(Of String, Object)
                result("Success") = False
                result("Message") = uDBA.MensajeError
                result("Data") = Nothing
                Return serializer.Serialize(result)
            End If

        Catch ex As Exception
            EscribirLog("Error al crear beneficiario: " & ex.Message)
            Dim result As New Dictionary(Of String, Object)
            result("Success") = False
            result("Message") = "Error al crear beneficiario: " & ex.Message
            result("Data") = Nothing
            Return serializer.Serialize(result)
        End Try
    End Function

    <WebMethod(EnableSession:=True)>
    <ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
    Public Shared Function ActualizarBeneficiario(beneficiarioDataJson As String) As String
        Dim serializer As New JavaScriptSerializer()
        Try
            Dim beneficiarioData = JsonConvert.DeserializeObject(Of JObject)(beneficiarioDataJson)
            Dim uDBA As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
            Dim sSql As String = "Exec spBeneficiarios_ActualizarBeneficiario"

            With uDBA.Parametros
                .Add("@IDBeneficiario", beneficiarioData("IDBeneficiario").ToString())
                .Add("@Nombre", beneficiarioData("Nombre").ToString())
                .Add("@Apellido", beneficiarioData("Apellido").ToString())
                .Add("@TipoIdentificacion", beneficiarioData("TipoIdentificacion").ToString())
                .Add("@NumeroIdentificacion", beneficiarioData("NumeroIdentificacion").ToString())
                .Add("@IDParentezco", beneficiarioData("IDParentezco").ToString())
                .Add("@Porcentaje", beneficiarioData("Porcentaje").ToString())
            End With

            EscribirLog("Actualizando beneficiario: " & sSql & " " & uDBA.getParamList())
            EscribirLog($"Ejecutando: {sSql} {uDBA.getParamList()}")

            Dim dt As DataTable = uDBA.GetDataTableSql(sSql)

            If uDBA.MensajeError = "" AndAlso dt.Rows.Count > 0 Then
                Dim resultado = dt.Rows(0)("Resultado").ToString()
                Dim mensaje = dt.Rows(0)("Mensaje").ToString()

                If resultado = "SUCCESS" Then
                    EscribirLog("Beneficiario actualizado exitosamente")
                    Dim result As New Dictionary(Of String, Object)
                    result("Success") = True
                    result("Message") = mensaje
                    result("Data") = Nothing
                    Return serializer.Serialize(result)
                Else
                    EscribirLog("Error al actualizar beneficiario: " & mensaje)
                    Dim result As New Dictionary(Of String, Object)
                    result("Success") = False
                    result("Message") = mensaje
                    result("Data") = Nothing
                    Return serializer.Serialize(result)
                End If
            Else
                EscribirLog("Error al actualizar beneficiario: " & uDBA.MensajeError)
                Dim result As New Dictionary(Of String, Object)
                result("Success") = False
                result("Message") = uDBA.MensajeError
                result("Data") = Nothing
                Return serializer.Serialize(result)
            End If

        Catch ex As Exception
            EscribirLog("Error al actualizar beneficiario: " & ex.Message)
            Dim result As New Dictionary(Of String, Object)
            result("Success") = False
            result("Message") = "Error al actualizar beneficiario: " & ex.Message
            result("Data") = Nothing
            Return serializer.Serialize(result)
        End Try
    End Function

    <WebMethod(EnableSession:=True)>
    <ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
    Public Shared Function ObtenerDatosPrueba() As String
        Try
            EscribirLog("Iniciando ObtenerDatosPrueba...")

            ' Leer el archivo JSON desde el sistema de archivos
            Dim jsonPath As String = HttpContext.Current.Server.MapPath("~/Forms/Socios/asociados.json")
            EscribirLog("Ruta del archivo JSON: " & jsonPath)

            If System.IO.File.Exists(jsonPath) Then
                EscribirLog("Archivo JSON encontrado, leyendo contenido...")
                Dim jsonContent As String = System.IO.File.ReadAllText(jsonPath)
                EscribirLog("Contenido JSON leído exitosamente, longitud: " & jsonContent.Length)

                ' Crear serializer con límite aumentado
                Dim serializer As New JavaScriptSerializer()
                serializer.MaxJsonLength = Int32.MaxValue

                ' Retornar el JSON directamente
                Dim result As New Dictionary(Of String, Object)
                result("Success") = True
                result("Message") = ""
                result("Data") = jsonContent
                EscribirLog("Retornando resultado exitoso")
                Return serializer.Serialize(result)
            Else
                EscribirLog("Archivo JSON no encontrado en: " & jsonPath)
                Dim serializer As New JavaScriptSerializer()
                Dim result As New Dictionary(Of String, Object)
                result("Success") = False
                result("Message") = "Archivo de datos de prueba no encontrado en: " & jsonPath
                result("Data") = ""
                Return serializer.Serialize(result)
            End If

        Catch ex As Exception
            EscribirLog("Error al obtener datos de prueba: " & ex.Message & " - StackTrace: " & ex.StackTrace)
            Dim serializer As New JavaScriptSerializer()
            Dim result As New Dictionary(Of String, Object)
            result("Success") = False
            result("Message") = ex.Message
            result("Data") = ""
            Return serializer.Serialize(result)
        End Try
    End Function

    <WebMethod(EnableSession:=True)>
    <ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
    Public Shared Function EliminarBeneficiario(idBeneficiario As Integer) As String
        Dim serializer As New JavaScriptSerializer()
        Try
            Dim uDBA As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
            Dim sSql As String = "Exec spBeneficiarios_EliminarBeneficiario"

            With uDBA.Parametros
                .Add("@IDBeneficiario", idBeneficiario)
            End With

            EscribirLog("Eliminando beneficiario: " & sSql & " " & uDBA.getParamList())
            EscribirLog($"Ejecutando: {sSql} {uDBA.getParamList()}")

            Dim dt As DataTable = uDBA.GetDataTableSql(sSql)

            If uDBA.MensajeError = "" AndAlso dt.Rows.Count > 0 Then
                Dim resultado = dt.Rows(0)("Resultado").ToString()
                Dim mensaje = dt.Rows(0)("Mensaje").ToString()

                If resultado = "SUCCESS" Then
                    EscribirLog("Beneficiario eliminado exitosamente")
                    Dim result As New Dictionary(Of String, Object)
                    result("Success") = True
                    result("Message") = mensaje
                    result("Data") = Nothing
                    Return serializer.Serialize(result)
                Else
                    EscribirLog("Error al eliminar beneficiario: " & mensaje)
                    Dim result As New Dictionary(Of String, Object)
                    result("Success") = False
                    result("Message") = mensaje
                    result("Data") = Nothing
                    Return serializer.Serialize(result)
                End If
            Else
                EscribirLog("Error al eliminar beneficiario: " & uDBA.MensajeError)
                Dim result As New Dictionary(Of String, Object)
                result("Success") = False
                result("Message") = uDBA.MensajeError
                result("Data") = Nothing
                Return serializer.Serialize(result)
            End If

        Catch ex As Exception
            EscribirLog("Error al eliminar beneficiario: " & ex.Message)
            Dim result As New Dictionary(Of String, Object)
            result("Success") = False
            result("Message") = "Error al eliminar beneficiario: " & ex.Message
            result("Data") = Nothing
            Return serializer.Serialize(result)
        End Try
    End Function

    ''' <summary>
    ''' Obtiene los parámetros de monitoreo de inactividad desde la sesión
    ''' </summary>
    ''' <returns>JSON con los parámetros de monitoreo</returns>
    <WebMethod(EnableSession:=True)>
    <ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
    Public Shared Function ObtenerParametrosInactividad() As String
        Try
            Dim parametros As New Dictionary(Of String, String)
            
            ' Obtener parámetros de la sesión
            Dim monitorearInactividad As String = If(HttpContext.Current.Session(VariablesSesion.MONITOREAR_INACTIVIDAD), "0")
            Dim tiempoMonitorear As String = If(HttpContext.Current.Session(VariablesSesion.TIEMPO_MONITOREAR_INACTIVIDAD), "5")
            
            parametros.Add("MONITOREAR_INACTIVIDAD", monitorearInactividad)
            parametros.Add("TIEMPO_MONITOREAR_INACTIVIDAD", tiempoMonitorear)
            
            Dim resultado As New With {
                .Success = True,
                .Message = "Parámetros obtenidos exitosamente",
                .Data = parametros
            }
            
            Dim serializer As New JavaScriptSerializer()
            Return serializer.Serialize(resultado)
            
        Catch ex As Exception
            Dim resultado As New With {
                            .Success = False,
                .Message = "Error al obtener parámetros de inactividad: " & ex.Message,
                .Data = Nothing
            }
            
            Dim serializer As New JavaScriptSerializer()
            Return serializer.Serialize(resultado)
        End Try
    End Function

    ''' <summary>
    ''' Cierra la sesión del usuario por inactividad
    ''' </summary>
    ''' <returns>JSON con el resultado de la operación</returns>
    <WebMethod(EnableSession:=True)>
    <ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
    Public Shared Function CerrarSesionPorInactividad() As String
        Try
            ' Registrar el cierre de sesión por inactividad
            Dim usuarioId = HttpContext.Current.Session("UsuarioId")
            Dim nombreUsuario = HttpContext.Current.Session("NombreUsuario")
            Dim ipAddress = HttpContext.Current.Request.UserHostAddress
            Dim timestamp = DateTime.Now
            
            ' Log de cierre por inactividad (implementar según necesidades)
            ' LogActivity(usuarioId, nombreUsuario, "Session_Timeout_Inactivity", ipAddress, "", timestamp)
            
            ' Cerrar sesión
            FormsAuthentication.SignOut()
            HttpContext.Current.Session.Clear()
            HttpContext.Current.Session.Abandon()
            
            Dim resultado As New With {
                            .Success = True,
                .Message = "Sesión cerrada por inactividad",
                .Data = Nothing
            }
            
            Dim serializer As New JavaScriptSerializer()
            Return serializer.Serialize(resultado)

        Catch ex As Exception
            Dim resultado As New With {
                .Success = False,
                .Message = "Error al cerrar sesión por inactividad: " & ex.Message,
                .Data = Nothing
            }
            
            Dim serializer As New JavaScriptSerializer()
            Return serializer.Serialize(resultado)
        End Try
    End Function

End Class
