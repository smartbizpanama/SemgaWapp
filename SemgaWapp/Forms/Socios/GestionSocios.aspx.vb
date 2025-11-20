Imports System.Web.Services
Imports System.Web.Script.Services
Imports System.Web.Script.Serialization
Imports SBSqlClient
Imports SBUtility
Imports System.Data
Imports Newtonsoft.Json
Imports Newtonsoft.Json.Linq
Imports System.Web.Security
Imports System.Text

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
            ModGlobal.EscribirLog("ESTA EJECUTANDO EL METODO ObtenerTiposAsociado")

            Dim uDBA As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
            Dim sSql As String = "SELECT IdTipoAsociado, TipoAsociado FROM tbTipoAsociado ORDER BY TipoAsociado"

            ModGlobal.EscribirLog($"Ejecutando SQL: {sSql} {uDBA.getParamList()}")
            Dim dt As DataTable = uDBA.GetDataTableSql(sSql)

            If uDBA.MensajeError <> "" Then
                ModGlobal.EscribirLog("Error en BD al obtener tipos de asociado: " & uDBA.MensajeError)
                ' Retornar objeto con información de error
                Dim result As New Dictionary(Of String, Object)
                result("Success") = False
                result("Message") = uDBA.MensajeError
                result("TotalRegistros") = 0
                result("Data") = New List(Of Object)
                Return serializer.Serialize(result)
            End If

            ModGlobal.EscribirLog("Ejecucion SQL completada sin errores. Registros obtenidos: " & dt.Rows.Count.ToString())

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
            Dim resultSuccess As New Dictionary(Of String, Object)
            resultSuccess("Success") = True
            resultSuccess("Message") = ""
            resultSuccess("TotalRegistros") = dt.Rows.Count
            resultSuccess("Data") = jsonData
            ModGlobal.EscribirLog("Metodo ObtenerTiposAsociado completado exitosamente")
            Return serializer.Serialize(resultSuccess)

        Catch ex As Exception
            ModGlobal.EscribirLog("Error en ObtenerTiposAsociado: " & ex.Message & " | StackTrace: " & ex.StackTrace)

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
            ModGlobal.EscribirLog("ESTA EJECUTANDO EL METODO ObtenerStatusAsociado")

            Dim uDBA As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
            Dim sSql As String = "SELECT CodStatusAsociado, StatusAsociado FROM tbStatusAsociado ORDER BY StatusAsociado"

            ModGlobal.EscribirLog($"Ejecutando SQL: {sSql} {uDBA.getParamList()}")
            Dim dt As DataTable = uDBA.GetDataTableSql(sSql)

            If uDBA.MensajeError <> "" Then
                ModGlobal.EscribirLog("Error en BD al obtener status de asociado: " & uDBA.MensajeError)
                ' Retornar objeto con información de error
                Dim resultError As New Dictionary(Of String, Object)
                resultError("Success") = False
                resultError("Message") = uDBA.MensajeError
                resultError("TotalRegistros") = 0
                resultError("Data") = New List(Of Object)
                Return serializer.Serialize(resultError)
            End If

            ModGlobal.EscribirLog("Ejecucion SQL completada sin errores. Registros obtenidos: " & dt.Rows.Count.ToString())

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
            ModGlobal.EscribirLog("Metodo ObtenerStatusAsociado completado exitosamente")
            Return serializer.Serialize(result)

        Catch ex As Exception
            ModGlobal.EscribirLog("Error en ObtenerStatusAsociado: " & ex.Message & " | StackTrace: " & ex.StackTrace)

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
            ModGlobal.EscribirLog("ESTA EJECUTANDO EL METODO ObtenerParametroSistema")
            ModGlobal.EscribirLog("Parametro recibido - ParamKey: " & paramKey)

            Dim paramValue As String = HttpContext.Current.Session(paramKey)

            ModGlobal.EscribirLog("Parametro obtenido de sesion: " & If(paramValue IsNot Nothing, paramValue, "(nulo)"))

            Dim result As New Dictionary(Of String, Object)
            result("Success") = True
            result("Message") = ""
            result("Data") = paramValue
            ModGlobal.EscribirLog("Metodo ObtenerParametroSistema completado exitosamente")
            Return serializer.Serialize(result)
        Catch ex As Exception
            ModGlobal.EscribirLog("Error en ObtenerParametroSistema: " & ex.Message & " | StackTrace: " & ex.StackTrace)
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
            ModGlobal.EscribirLog("ESTA EJECUTANDO EL METODO ObtenerTiposDocumento")

            Dim uDBA As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
            Dim sSql As String = "SELECT CodTipoDoc, TipoDocumento FROM tbTipoDocumentos ORDER BY TipoDocumento"

            ModGlobal.EscribirLog($"Ejecutando SQL: {sSql} {uDBA.getParamList()}")

            Dim dt As DataTable = uDBA.GetDataTableSql(sSql)

            If uDBA.MensajeError <> "" Then
                ModGlobal.EscribirLog("Error en BD al obtener tipos de documento: " & uDBA.MensajeError)
                Dim resultError As New Dictionary(Of String, Object)
                resultError("Success") = False
                resultError("Message") = uDBA.MensajeError
                resultError("TotalRegistros") = 0
                resultError("Data") = New List(Of Object)
                Return serializer.Serialize(resultError)
            End If

            ModGlobal.EscribirLog("Ejecucion SQL completada sin errores. Registros obtenidos: " & dt.Rows.Count.ToString())

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
            ModGlobal.EscribirLog("Metodo ObtenerTiposDocumento completado exitosamente")
            Return serializer.Serialize(result)

        Catch ex As Exception
            ModGlobal.EscribirLog("Error en ObtenerTiposDocumento: " & ex.Message & " | StackTrace: " & ex.StackTrace)

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
            ModGlobal.EscribirLog("ESTA EJECUTANDO EL METODO ObtenerSocios")
            ModGlobal.EscribirLog("Parametro recibido - FiltrosJson: " & filtrosJson)

            Dim filtros = JsonConvert.DeserializeObject(Of JObject)(filtrosJson)
            Dim uDBA As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
            Dim sSql As String = "Exec spGestionSocios_ObtenerSocios"

            With uDBA.Parametros
                If Not String.IsNullOrEmpty(If(filtros("FiltroNombre") IsNot Nothing, filtros("FiltroNombre").ToString(), Nothing)) Then
                    .Add("@FiltroNombre", filtros("FiltroNombre").ToString())
                End If
                If Not String.IsNullOrEmpty(If(filtros("FiltroTipo") IsNot Nothing, filtros("FiltroTipo").ToString(), Nothing)) Then
                    .Add("@FiltroTipo", filtros("FiltroTipo").ToString())
                End If
                If Not String.IsNullOrEmpty(If(filtros("FiltroEstatus") IsNot Nothing, filtros("FiltroEstatus").ToString(), Nothing)) Then
                    .Add("@FiltroEstatus", filtros("FiltroEstatus").ToString())
                End If
                If Not String.IsNullOrEmpty(If(filtros("FiltroTipoDocumento") IsNot Nothing, filtros("FiltroTipoDocumento").ToString(), Nothing)) Then
                    .Add("@FiltroTipoDocumento", filtros("FiltroTipoDocumento").ToString())
                End If
                If Not String.IsNullOrEmpty(If(filtros("FiltroIdentificacion") IsNot Nothing, filtros("FiltroIdentificacion").ToString(), Nothing)) Then
                    .Add("@FiltroIdentificacion", filtros("FiltroIdentificacion").ToString())
                End If
            End With

            ModGlobal.EscribirLog($"Ejecutando SQL: {sSql} {uDBA.getParamList()}")
            Dim dt As DataTable = uDBA.GetDataTableSql(sSql)

            If uDBA.MensajeError <> "" Then
                ModGlobal.EscribirLog("Error en BD al obtener socios: " & uDBA.MensajeError)
                ' Retornar objeto con información de error
                Dim resultError As New Dictionary(Of String, Object)
                resultError("Success") = False
                resultError("Message") = uDBA.MensajeError
                resultError("TotalRegistros") = 0
                resultError("Data") = New List(Of Object)
                Dim serializerError As New JavaScriptSerializer()
                Return serializerError.Serialize(resultError)
            End If

            ModGlobal.EscribirLog("Ejecucion SQL completada sin errores. Registros obtenidos: " & dt.Rows.Count.ToString())

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

                ModGlobal.EscribirLog("Metodo ObtenerSocios completado exitosamente")
                Return serializer.Serialize(result)

        Catch ex As Exception
            ModGlobal.EscribirLog("Error en ObtenerSocios: " & ex.Message & " | StackTrace: " & ex.StackTrace)

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
            ModGlobal.EscribirLog("ESTA EJECUTANDO EL METODO ObtenerSocioPorNumero")
            ModGlobal.EscribirLog("Parametro recibido - NumeroAsociado: " & numeroAsociado.ToString())

            Dim uDBA As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
            Dim sSql As String = "Exec spGestionSocios_ObtenerSocioPorNumero"

            With uDBA.Parametros
                .Add("@NumeroAsociado", numeroAsociado)
            End With

            ModGlobal.EscribirLog($"Ejecutando SQL: {sSql} {uDBA.getParamList()}")
            Dim dt As DataTable = uDBA.GetDataTableSql(sSql)

            If uDBA.MensajeError <> "" Then
                ModGlobal.EscribirLog("Error en BD al obtener socio: " & uDBA.MensajeError)
                Dim resultError As New Dictionary(Of String, Object)
                resultError("Success") = False
                resultError("Message") = uDBA.MensajeError
                resultError("TotalRegistros") = 0
                resultError("Data") = Nothing
                Return serializer.Serialize(resultError)
            End If

            ModGlobal.EscribirLog("Ejecucion SQL completada sin errores. Registros obtenidos: " & dt.Rows.Count.ToString())

            If dt.Rows.Count > 0 Then
                ModGlobal.EscribirLog("Validacion: Socio encontrado")

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
                    ModGlobal.EscribirLog("Metodo ObtenerSocioPorNumero completado exitosamente")
                    Return serializer.Serialize(result)
                Else
                    ModGlobal.EscribirLog("Validacion: Socio no encontrado")
                    Dim result As New Dictionary(Of String, Object)
                    result("Success") = False
                    result("Message") = "Socio no encontrado"
                    result("TotalRegistros") = 0
                    result("Data") = Nothing
                    ModGlobal.EscribirLog("Metodo ObtenerSocioPorNumero completado exitosamente")
                    Return serializer.Serialize(result)
                End If

        Catch ex As Exception
            ModGlobal.EscribirLog("Error en ObtenerSocioPorNumero: " & ex.Message & " | StackTrace: " & ex.StackTrace)
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
                    "Ocupacion", "ProvinciaTrabajo", "DistritoTrabajo",
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
            ModGlobal.EscribirLog("Error en AplicarMayusculasAutomaticas: " & ex.Message & " | StackTrace: " & ex.StackTrace)
            Return socioData ' Retornar datos originales en caso de error
        End Try
    End Function

    <WebMethod(EnableSession:=True)>
    Public Shared Function CrearSocio(socioDataJson As String) As String
        Dim serializer As New JavaScriptSerializer()

        Try
            ModGlobal.EscribirLog("ESTA EJECUTANDO EL METODO CrearSocio")
            ModGlobal.EscribirLog("Datos recibidos: " & socioDataJson)

            Dim socioData = JsonConvert.DeserializeObject(Of JObject)(socioDataJson)

            ' Aplicar mayúsculas automáticas si está habilitado
            socioData = AplicarMayusculasAutomaticas(socioData)
            ModGlobal.EscribirLog("Validacion: Mayusculas automaticas aplicadas si corresponde")

            Dim uDBA As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
            Dim sSql As String = "Exec spGestionSocios_CrearSocio"

            With uDBA.Parametros
                If Not String.IsNullOrEmpty(If(socioData("IdTipoAsociado") IsNot Nothing, socioData("IdTipoAsociado").ToString(), Nothing)) Then
                    .Add("@IdTipoAsociado", socioData("IdTipoAsociado").ToString())
                End If
                If Not String.IsNullOrEmpty(If(socioData("Nombre") IsNot Nothing, socioData("Nombre").ToString(), Nothing)) Then
                    .Add("@Nombre", socioData("Nombre").ToString())
                End If
                If Not String.IsNullOrEmpty(If(socioData("SegundoNombre") IsNot Nothing, socioData("SegundoNombre").ToString(), Nothing)) Then
                    .Add("@SegundoNombre", socioData("SegundoNombre").ToString())
                End If
                If Not String.IsNullOrEmpty(If(socioData("Apellido") IsNot Nothing, socioData("Apellido").ToString(), Nothing)) Then
                    .Add("@Apellido", socioData("Apellido").ToString())
                End If
                If Not String.IsNullOrEmpty(If(socioData("SegundoApellido") IsNot Nothing, socioData("SegundoApellido").ToString(), Nothing)) Then
                    .Add("@SegundoApellido", socioData("SegundoApellido").ToString())
                End If
                If Not String.IsNullOrEmpty(If(socioData("Estatus") IsNot Nothing, socioData("Estatus").ToString(), Nothing)) Then
                    .Add("@Estatus", socioData("Estatus").ToString())
                End If
                If Not String.IsNullOrEmpty(If(socioData("TipoIdentificacion") IsNot Nothing, socioData("TipoIdentificacion").ToString(), Nothing)) Then
                    .Add("@TipoIdentificacion", socioData("TipoIdentificacion").ToString())
                End If
                If Not String.IsNullOrEmpty(If(socioData("NumeroIdentificacion") IsNot Nothing, socioData("NumeroIdentificacion").ToString(), Nothing)) Then
                    .Add("@NumeroIdentificacion", socioData("NumeroIdentificacion").ToString())
                End If
                If Not String.IsNullOrEmpty(If(socioData("TelefonoResidencia") IsNot Nothing, socioData("TelefonoResidencia").ToString(), Nothing)) Then
                    .Add("@TelefonoResidencia", socioData("TelefonoResidencia").ToString())
                End If
                If Not String.IsNullOrEmpty(If(socioData("TelefonoCelular") IsNot Nothing, socioData("TelefonoCelular").ToString(), Nothing)) Then
                    .Add("@TelefonoCelular", socioData("TelefonoCelular").ToString())
                End If
                If Not String.IsNullOrEmpty(If(socioData("TelefonoFamiliar") IsNot Nothing, socioData("TelefonoFamiliar").ToString(), Nothing)) Then
                    .Add("@TelefonoFamiliar", socioData("TelefonoFamiliar").ToString())
                End If
                If Not String.IsNullOrEmpty(If(socioData("TelefonoTrabajo") IsNot Nothing, socioData("TelefonoTrabajo").ToString(), Nothing)) Then
                    .Add("@TelefonoTrabajo", socioData("TelefonoTrabajo").ToString())
                End If
                If Not String.IsNullOrEmpty(If(socioData("CorreoElectronico") IsNot Nothing, socioData("CorreoElectronico").ToString(), Nothing)) Then
                    .Add("@CorreoElectronico", socioData("CorreoElectronico").ToString())
                End If
                .Add("@Sexo", If(socioData("Sexo") IsNot Nothing, socioData("Sexo").ToString(), ""))
                If Not String.IsNullOrEmpty(If(socioData("FechaNacimiento") IsNot Nothing, socioData("FechaNacimiento").ToString(), Nothing)) Then
                    .Add("@FechaNacimiento", socioData("FechaNacimiento").ToString())
                End If
                If Not String.IsNullOrEmpty(If(socioData("ProvinciaResidencia") IsNot Nothing, socioData("ProvinciaResidencia").ToString(), Nothing)) Then
                    .Add("@ProvinciaResidencia", socioData("ProvinciaResidencia").ToString())
                End If
                If Not String.IsNullOrEmpty(If(socioData("DistritoResidencia") IsNot Nothing, socioData("DistritoResidencia").ToString(), Nothing)) Then
                    .Add("@DistritoResidencia", socioData("DistritoResidencia").ToString())
                End If
                If Not String.IsNullOrEmpty(If(socioData("CorregimientoResidencia") IsNot Nothing, socioData("CorregimientoResidencia").ToString(), Nothing)) Then
                    .Add("@CorregimientoResidencia", socioData("CorregimientoResidencia").ToString())
                End If
                If Not String.IsNullOrEmpty(If(socioData("DireccionResidencia") IsNot Nothing, socioData("DireccionResidencia").ToString(), Nothing)) Then
                    .Add("@DireccionResidencia", socioData("DireccionResidencia").ToString())
                End If
                If Not String.IsNullOrEmpty(If(socioData("ProvinciaTrabajo") IsNot Nothing, socioData("ProvinciaTrabajo").ToString(), Nothing)) Then
                    .Add("@ProvinciaTrabajo", socioData("ProvinciaTrabajo").ToString())
                End If
                If Not String.IsNullOrEmpty(If(socioData("DistritoTrabajo") IsNot Nothing, socioData("DistritoTrabajo").ToString(), Nothing)) Then
                    .Add("@DistritoTrabajo", socioData("DistritoTrabajo").ToString())
                End If
                If Not String.IsNullOrEmpty(If(socioData("CorregimientoTrabajo") IsNot Nothing, socioData("CorregimientoTrabajo").ToString(), Nothing)) Then
                    .Add("@CorregimientoTrabajo", socioData("CorregimientoTrabajo").ToString())
                End If
                If Not String.IsNullOrEmpty(If(socioData("DireccionTrabajo") IsNot Nothing, socioData("DireccionTrabajo").ToString(), Nothing)) Then
                    .Add("@DireccionTrabajo", socioData("DireccionTrabajo").ToString())
                End If
                If Not String.IsNullOrEmpty(If(socioData("LugarTrabajo") IsNot Nothing, socioData("LugarTrabajo").ToString(), Nothing)) Then
                    .Add("@LugarTrabajo", socioData("LugarTrabajo").ToString())
                End If
                If Not String.IsNullOrEmpty(If(socioData("Ocupacion") IsNot Nothing, socioData("Ocupacion").ToString(), Nothing)) Then
                    .Add("@Ocupacion", socioData("Ocupacion").ToString())
                End If
                If Not String.IsNullOrEmpty(If(socioData("PaisTrabajo") IsNot Nothing, socioData("PaisTrabajo").ToString(), Nothing)) Then
                    .Add("@PaisTrabajo", socioData("PaisTrabajo").ToString())
                End If
                If Not String.IsNullOrEmpty(If(socioData("PaisResidencia") IsNot Nothing, socioData("PaisResidencia").ToString(), Nothing)) Then
                    .Add("@PaisResidencia", socioData("PaisResidencia").ToString())
                End If
                If Not String.IsNullOrEmpty(If(socioData("NivelEstudio") IsNot Nothing, socioData("NivelEstudio").ToString(), Nothing)) Then
                    .Add("@NivelEstudio", socioData("NivelEstudio").ToString())
                End If
                If Not String.IsNullOrEmpty(If(socioData("Profesion") IsNot Nothing, socioData("Profesion").ToString(), Nothing)) Then
                    .Add("@Profesion", socioData("Profesion").ToString())
                End If
                .Add("@Usuario", HttpContext.Current.Session(VariablesSesion.UsuarioId).ToString())
                .Add("@IdSession", HttpContext.Current.Session(VariablesSesion.logID).ToString())
            End With

            ModGlobal.EscribirLog($"Ejecutando SQL: {sSql} {uDBA.getParamList()}")
            Dim dt As DataTable = uDBA.GetDataTableSql(sSql)

            If uDBA.MensajeError <> "" Then
                ModGlobal.EscribirLog("Error en BD al crear socio: " & uDBA.MensajeError)
                Dim resultError As New Dictionary(Of String, Object)
                resultError("Success") = False
                resultError("Message") = "Error al crear socio: " & uDBA.MensajeError
                resultError("Data") = Nothing
                Return serializer.Serialize(resultError)
            End If

            ModGlobal.EscribirLog("Ejecucion SQL completada sin errores. Registros devueltos: " & dt.Rows.Count.ToString())

            ' Obtener el número de asociado generado
            Dim numeroAsociadoGenerado As Integer = 0
            If dt.Rows.Count > 0 AndAlso dt.Rows(0)("NumeroAsociado") IsNot DBNull.Value Then
                Integer.TryParse(dt.Rows(0)("NumeroAsociado").ToString(), numeroAsociadoGenerado)
                ModGlobal.EscribirLog("NumeroAsociado generado: " & numeroAsociadoGenerado.ToString())
            End If

            Dim result As New Dictionary(Of String, Object)
            result("Success") = True
            result("Message") = "Socio creado exitosamente"
            result("Data") = New With {.NumeroAsociado = numeroAsociadoGenerado}
            ModGlobal.EscribirLog("Metodo CrearSocio completado exitosamente")
            Return serializer.Serialize(result)

        Catch ex As Exception
            ModGlobal.EscribirLog("Error en CrearSocio: " & ex.Message & " | StackTrace: " & ex.StackTrace)
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
            ModGlobal.EscribirLog("ESTA EJECUTANDO EL METODO ActualizarSocio")
            ModGlobal.EscribirLog("Datos recibidos: " & socioDataJson)

            Dim socioData = JsonConvert.DeserializeObject(Of JObject)(socioDataJson)

            ' Aplicar mayúsculas automáticas si está habilitado
            socioData = AplicarMayusculasAutomaticas(socioData)
            ModGlobal.EscribirLog("Validacion: Mayusculas automaticas aplicadas si corresponde")

            Dim uDBA As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
            Dim sSql As String = "Exec spGestionSocios_ActualizarSocio"

            ModGlobal.EscribirLog("Valores extraidos - NumeroAsociado: " & socioData("NumeroAsociado").ToString())

            With uDBA.Parametros
                .Add("@NumeroAsociado", socioData("NumeroAsociado").ToString())
                If Not String.IsNullOrEmpty(If(socioData("IdTipoAsociado") IsNot Nothing, socioData("IdTipoAsociado").ToString(), Nothing)) Then
                    .Add("@IdTipoAsociado", socioData("IdTipoAsociado").ToString())
                End If
                If Not String.IsNullOrEmpty(If(socioData("Nombre") IsNot Nothing, socioData("Nombre").ToString(), Nothing)) Then
                    .Add("@Nombre", socioData("Nombre").ToString())
                End If
                If Not String.IsNullOrEmpty(If(socioData("SegundoNombre") IsNot Nothing, socioData("SegundoNombre").ToString(), Nothing)) Then
                    .Add("@SegundoNombre", socioData("SegundoNombre").ToString())
                End If
                If Not String.IsNullOrEmpty(If(socioData("Apellido") IsNot Nothing, socioData("Apellido").ToString(), Nothing)) Then
                    .Add("@Apellido", socioData("Apellido").ToString())
                End If
                If Not String.IsNullOrEmpty(If(socioData("SegundoApellido") IsNot Nothing, socioData("SegundoApellido").ToString(), Nothing)) Then
                    .Add("@SegundoApellido", socioData("SegundoApellido").ToString())
                End If
                If Not String.IsNullOrEmpty(If(socioData("Estatus") IsNot Nothing, socioData("Estatus").ToString(), Nothing)) Then
                    .Add("@Estatus", socioData("Estatus").ToString())
                End If
                If Not String.IsNullOrEmpty(If(socioData("TipoIdentificacion") IsNot Nothing, socioData("TipoIdentificacion").ToString(), Nothing)) Then
                    .Add("@TipoIdentificacion", socioData("TipoIdentificacion").ToString())
                End If
                If Not String.IsNullOrEmpty(If(socioData("NumeroIdentificacion") IsNot Nothing, socioData("NumeroIdentificacion").ToString(), Nothing)) Then
                    .Add("@NumeroIdentificacion", socioData("NumeroIdentificacion").ToString())
                End If
                If Not String.IsNullOrEmpty(If(socioData("TelefonoResidencia") IsNot Nothing, socioData("TelefonoResidencia").ToString(), Nothing)) Then
                    .Add("@TelefonoResidencia", socioData("TelefonoResidencia").ToString())
                End If
                If Not String.IsNullOrEmpty(If(socioData("TelefonoCelular") IsNot Nothing, socioData("TelefonoCelular").ToString(), Nothing)) Then
                    .Add("@TelefonoCelular", socioData("TelefonoCelular").ToString())
                End If
                If Not String.IsNullOrEmpty(If(socioData("TelefonoFamiliar") IsNot Nothing, socioData("TelefonoFamiliar").ToString(), Nothing)) Then
                    .Add("@TelefonoFamiliar", socioData("TelefonoFamiliar").ToString())
                End If
                If Not String.IsNullOrEmpty(If(socioData("TelefonoTrabajo") IsNot Nothing, socioData("TelefonoTrabajo").ToString(), Nothing)) Then
                    .Add("@TelefonoTrabajo", socioData("TelefonoTrabajo").ToString())
                End If
                If Not String.IsNullOrEmpty(If(socioData("CorreoElectronico") IsNot Nothing, socioData("CorreoElectronico").ToString(), Nothing)) Then
                    .Add("@CorreoElectronico", socioData("CorreoElectronico").ToString())
                End If
                .Add("@Sexo", If(socioData("Sexo") IsNot Nothing, socioData("Sexo").ToString(), ""))
                If Not String.IsNullOrEmpty(If(socioData("FechaNacimiento") IsNot Nothing, socioData("FechaNacimiento").ToString(), Nothing)) Then
                    .Add("@FechaNacimiento", socioData("FechaNacimiento").ToString())
                End If
                If Not String.IsNullOrEmpty(If(socioData("ProvinciaResidencia") IsNot Nothing, socioData("ProvinciaResidencia").ToString(), Nothing)) Then
                    .Add("@ProvinciaResidencia", socioData("ProvinciaResidencia").ToString())
                End If
                If Not String.IsNullOrEmpty(If(socioData("DistritoResidencia") IsNot Nothing, socioData("DistritoResidencia").ToString(), Nothing)) Then
                    .Add("@DistritoResidencia", socioData("DistritoResidencia").ToString())
                End If
                If Not String.IsNullOrEmpty(If(socioData("CorregimientoResidencia") IsNot Nothing, socioData("CorregimientoResidencia").ToString(), Nothing)) Then
                    .Add("@CorregimientoResidencia", socioData("CorregimientoResidencia").ToString())
                End If
                If Not String.IsNullOrEmpty(If(socioData("DireccionResidencia") IsNot Nothing, socioData("DireccionResidencia").ToString(), Nothing)) Then
                    .Add("@DireccionResidencia", socioData("DireccionResidencia").ToString())
                End If
                If Not String.IsNullOrEmpty(If(socioData("ProvinciaTrabajo") IsNot Nothing, socioData("ProvinciaTrabajo").ToString(), Nothing)) Then
                    .Add("@ProvinciaTrabajo", socioData("ProvinciaTrabajo").ToString())
                End If
                If Not String.IsNullOrEmpty(If(socioData("DistritoTrabajo") IsNot Nothing, socioData("DistritoTrabajo").ToString(), Nothing)) Then
                    .Add("@DistritoTrabajo", socioData("DistritoTrabajo").ToString())
                End If
                If Not String.IsNullOrEmpty(If(socioData("CorregimientoTrabajo") IsNot Nothing, socioData("CorregimientoTrabajo").ToString(), Nothing)) Then
                    .Add("@CorregimientoTrabajo", socioData("CorregimientoTrabajo").ToString())
                End If
                If Not String.IsNullOrEmpty(If(socioData("DireccionTrabajo") IsNot Nothing, socioData("DireccionTrabajo").ToString(), Nothing)) Then
                    .Add("@DireccionTrabajo", socioData("DireccionTrabajo").ToString())
                End If
                If Not String.IsNullOrEmpty(If(socioData("LugarTrabajo") IsNot Nothing, socioData("LugarTrabajo").ToString(), Nothing)) Then
                    .Add("@LugarTrabajo", socioData("LugarTrabajo").ToString())
                End If
                If Not String.IsNullOrEmpty(If(socioData("Ocupacion") IsNot Nothing, socioData("Ocupacion").ToString(), Nothing)) Then
                    .Add("@Ocupacion", socioData("Ocupacion").ToString())
                End If
                If Not String.IsNullOrEmpty(If(socioData("PaisTrabajo") IsNot Nothing, socioData("PaisTrabajo").ToString(), Nothing)) Then
                    .Add("@PaisTrabajo", socioData("PaisTrabajo").ToString())
                End If
                If Not String.IsNullOrEmpty(If(socioData("PaisResidencia") IsNot Nothing, socioData("PaisResidencia").ToString(), Nothing)) Then
                    .Add("@PaisResidencia", socioData("PaisResidencia").ToString())
                End If
                If Not String.IsNullOrEmpty(If(socioData("NivelEstudio") IsNot Nothing, socioData("NivelEstudio").ToString(), Nothing)) Then
                    .Add("@NivelEstudio", socioData("NivelEstudio").ToString())
                End If
                If Not String.IsNullOrEmpty(If(socioData("Profesion") IsNot Nothing, socioData("Profesion").ToString(), Nothing)) Then
                    .Add("@Profesion", socioData("Profesion").ToString())
                End If
                .Add("@Usuario", HttpContext.Current.Session(VariablesSesion.UsuarioId).ToString())
                .Add("@IdSession", HttpContext.Current.Session(VariablesSesion.logID).ToString())
            End With

            ModGlobal.EscribirLog($"Ejecutando SQL: {sSql} {uDBA.getParamList()}")
            uDBA.ExecuteNonQuerySql(sSql)

            If uDBA.MensajeError <> "" Then
                ModGlobal.EscribirLog("Error en BD al actualizar socio: " & uDBA.MensajeError)
                Dim resultError As New Dictionary(Of String, Object)
                resultError("Success") = False
                resultError("Message") = "Error al actualizar socio: " & uDBA.MensajeError
                resultError("Data") = Nothing
                Return serializer.Serialize(resultError)
            End If

            ModGlobal.EscribirLog("Ejecucion SQL completada sin errores")
            Dim result As New Dictionary(Of String, Object)
            result("Success") = True
            result("Message") = "Socio actualizado exitosamente"
            result("Data") = Nothing
            ModGlobal.EscribirLog("Metodo ActualizarSocio completado exitosamente")
            Return serializer.Serialize(result)

        Catch ex As Exception
            ModGlobal.EscribirLog("Error en ActualizarSocio: " & ex.Message & " | StackTrace: " & ex.StackTrace)
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
            ModGlobal.EscribirLog("ESTA EJECUTANDO EL METODO ObtenerParentezcos")

            Dim uDBA As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
            Dim sSql As String = "Exec spBeneficiarios_ObtenerParentezcos"

            ModGlobal.EscribirLog($"Ejecutando SQL: {sSql} {uDBA.getParamList()}")
            Dim dt As DataTable = uDBA.GetDataTableSql(sSql)

            If uDBA.MensajeError <> "" Then
                ModGlobal.EscribirLog("Error en BD al obtener parentezcos: " & uDBA.MensajeError)
                Dim resultError As New Dictionary(Of String, Object)
                resultError("Success") = False
                resultError("Message") = uDBA.MensajeError
                resultError("TotalRegistros") = 0
                resultError("Data") = New List(Of Object)
                Return serializer.Serialize(resultError)
            End If

            ModGlobal.EscribirLog("Ejecucion SQL completada sin errores. Registros obtenidos: " & dt.Rows.Count.ToString())

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
                ModGlobal.EscribirLog("Metodo ObtenerParentezcos completado exitosamente")
                Return serializer.Serialize(result)

        Catch ex As Exception
            ModGlobal.EscribirLog("Error en ObtenerParentezcos: " & ex.Message & " | StackTrace: " & ex.StackTrace)
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
            ModGlobal.EscribirLog("ESTA EJECUTANDO EL METODO ObtenerBeneficiarios")
            ModGlobal.EscribirLog("Parametro recibido - NumeroAsociado: " & numeroAsociado.ToString())

            Dim uDBA As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
            Dim sSql As String = "Exec spBeneficiarios_ObtenerBeneficiarios"

            With uDBA.Parametros
                .Add("@NumeroAsociado", numeroAsociado)
            End With

            ModGlobal.EscribirLog($"Ejecutando SQL: {sSql} {uDBA.getParamList()}")
            Dim dt As DataTable = uDBA.GetDataTableSql(sSql)

            If uDBA.MensajeError <> "" Then
                ModGlobal.EscribirLog("Error en BD al obtener beneficiarios: " & uDBA.MensajeError)
                Dim resultError As New Dictionary(Of String, Object)
                resultError("Success") = False
                resultError("Message") = uDBA.MensajeError
                resultError("TotalRegistros") = 0
                resultError("Data") = New List(Of Object)
                Return serializer.Serialize(resultError)
            End If

            ModGlobal.EscribirLog("Ejecucion SQL completada sin errores. Registros obtenidos: " & dt.Rows.Count.ToString())

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
                ModGlobal.EscribirLog("Metodo ObtenerBeneficiarios completado exitosamente")
                Return serializer.Serialize(result)

        Catch ex As Exception
            ModGlobal.EscribirLog("Error en ObtenerBeneficiarios: " & ex.Message & " | StackTrace: " & ex.StackTrace)
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
            ModGlobal.EscribirLog("ESTA EJECUTANDO EL METODO CrearBeneficiario")
            ModGlobal.EscribirLog("Datos recibidos: " & beneficiarioDataJson)

            Dim beneficiarioData = JsonConvert.DeserializeObject(Of JObject)(beneficiarioDataJson)
            Dim uDBA As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
            Dim sSql As String = "Exec spBeneficiarios_CrearBeneficiario"

            ' Obtener UsuarioId de la sesión
            Dim usuarioId As Integer = If(HttpContext.Current.Session(VariablesSesion.UsuarioId), 0)
            If usuarioId = 0 Then
                ModGlobal.EscribirLog("Validacion: UsuarioId no encontrado en sesion")
                Dim result As New Dictionary(Of String, Object)
                result("Success") = False
                result("Message") = "Usuario no autenticado"
                Return serializer.Serialize(result)
            End If

            With uDBA.Parametros
                .Add("@NumeroAsociado", beneficiarioData("NumeroAsociado").ToString())
                .Add("@Nombre", beneficiarioData("Nombre").ToString())
                .Add("@Apellido", beneficiarioData("Apellido").ToString())
                .Add("@TipoIdentificacion", beneficiarioData("TipoIdentificacion").ToString())
                .Add("@NumeroIdentificacion", beneficiarioData("NumeroIdentificacion").ToString())
                .Add("@IDParentezco", beneficiarioData("IDParentezco").ToString())
                .Add("@Porcentaje", beneficiarioData("Porcentaje").ToString())
                .Add("@Usuario", usuarioId.ToString())
                .Add("@IdSession", HttpContext.Current.Session(VariablesSesion.logID).ToString())
            End With

            ModGlobal.EscribirLog($"Valores extraidos - NumeroAsociado: {beneficiarioData("NumeroAsociado").ToString()}, Nombre: {beneficiarioData("Nombre").ToString()}, Apellido: {beneficiarioData("Apellido").ToString()}, IDParentezco: {beneficiarioData("IDParentezco").ToString()}, Porcentaje: {beneficiarioData("Porcentaje").ToString()}")

            ModGlobal.EscribirLog($"Ejecutando SQL: {sSql} {uDBA.getParamList()}")
            Dim dt As DataTable = uDBA.GetDataTableSql(sSql)

            If uDBA.MensajeError <> "" Then
                ModGlobal.EscribirLog("Error en BD al crear beneficiario: " & uDBA.MensajeError)
                Dim resultError As New Dictionary(Of String, Object)
                resultError("Success") = False
                resultError("Message") = uDBA.MensajeError
                resultError("Data") = Nothing
                Return serializer.Serialize(resultError)
            End If

            ModGlobal.EscribirLog("Ejecucion SQL completada sin errores. Registros devueltos: " & dt.Rows.Count.ToString())

            If dt.Rows.Count > 0 Then
                Dim resultado = dt.Rows(0)("Resultado").ToString()
                Dim mensaje = dt.Rows(0)("Mensaje").ToString()

                ModGlobal.EscribirLog("Resultado del stored procedure - Resultado: " & resultado & ", Mensaje: " & mensaje)

                If resultado = "SUCCESS" Then
                    Dim result As New Dictionary(Of String, Object)
                    result("Success") = True
                    result("Message") = mensaje
                    result("Data") = Nothing
                    ModGlobal.EscribirLog("Metodo CrearBeneficiario completado exitosamente")
                    Return serializer.Serialize(result)
                Else
                    ModGlobal.EscribirLog("Validacion: SP retorno resultado de error")
                    Dim result As New Dictionary(Of String, Object)
                    result("Success") = False
                    result("Message") = mensaje
                    result("Data") = Nothing
                    ModGlobal.EscribirLog("Metodo CrearBeneficiario completado exitosamente")
                    Return serializer.Serialize(result)
                End If
            Else
                ModGlobal.EscribirLog("No se recibio respuesta del servidor (dt.Rows.Count = 0)")
                Dim result As New Dictionary(Of String, Object)
                result("Success") = False
                result("Message") = "No se recibió respuesta del procedimiento almacenado"
                result("Data") = Nothing
                Return serializer.Serialize(result)
            End If

        Catch ex As Exception
            ModGlobal.EscribirLog("Error en CrearBeneficiario: " & ex.Message & " | StackTrace: " & ex.StackTrace)
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
            ModGlobal.EscribirLog("ESTA EJECUTANDO EL METODO ActualizarBeneficiario")
            ModGlobal.EscribirLog("Datos recibidos: " & beneficiarioDataJson)

            Dim beneficiarioData = JsonConvert.DeserializeObject(Of JObject)(beneficiarioDataJson)
            Dim uDBA As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
            Dim sSql As String = "Exec spBeneficiarios_ActualizarBeneficiario"

            ' Obtener UsuarioId de la sesión
            Dim usuarioId As Integer = If(HttpContext.Current.Session(VariablesSesion.UsuarioId), 0)
            If usuarioId = 0 Then
                ModGlobal.EscribirLog("Validacion: UsuarioId no encontrado en sesion")
                Dim result As New Dictionary(Of String, Object)
                result("Success") = False
                result("Message") = "Usuario no autenticado"
                Return serializer.Serialize(result)
            End If

            With uDBA.Parametros
                .Add("@IDBeneficiario", beneficiarioData("IDBeneficiario").ToString())
                .Add("@Nombre", beneficiarioData("Nombre").ToString())
                .Add("@Apellido", beneficiarioData("Apellido").ToString())
                .Add("@TipoIdentificacion", beneficiarioData("TipoIdentificacion").ToString())
                .Add("@NumeroIdentificacion", beneficiarioData("NumeroIdentificacion").ToString())
                .Add("@IDParentezco", beneficiarioData("IDParentezco").ToString())
                .Add("@Porcentaje", beneficiarioData("Porcentaje").ToString())
                .Add("@Usuario", usuarioId.ToString())
                .Add("@IdSession", HttpContext.Current.Session(VariablesSesion.logID).ToString())
            End With

            ModGlobal.EscribirLog($"Valores extraidos - IDBeneficiario: {beneficiarioData("IDBeneficiario").ToString()}, Nombre: {beneficiarioData("Nombre").ToString()}, Apellido: {beneficiarioData("Apellido").ToString()}, IDParentezco: {beneficiarioData("IDParentezco").ToString()}, Porcentaje: {beneficiarioData("Porcentaje").ToString()}")

            ModGlobal.EscribirLog($"Ejecutando SQL: {sSql} {uDBA.getParamList()}")
            Dim dt As DataTable = uDBA.GetDataTableSql(sSql)

            If uDBA.MensajeError <> "" Then
                ModGlobal.EscribirLog("Error en BD al actualizar beneficiario: " & uDBA.MensajeError)
                Dim resultError As New Dictionary(Of String, Object)
                resultError("Success") = False
                resultError("Message") = uDBA.MensajeError
                resultError("Data") = Nothing
                Return serializer.Serialize(resultError)
            End If

            ModGlobal.EscribirLog("Ejecucion SQL completada sin errores. Registros devueltos: " & dt.Rows.Count.ToString())

            If dt.Rows.Count > 0 Then
                Dim resultado = dt.Rows(0)("Resultado").ToString()
                Dim mensaje = dt.Rows(0)("Mensaje").ToString()

                ModGlobal.EscribirLog("Resultado del stored procedure - Resultado: " & resultado & ", Mensaje: " & mensaje)

                If resultado = "SUCCESS" Then
                    Dim result As New Dictionary(Of String, Object)
                    result("Success") = True
                    result("Message") = mensaje
                    result("Data") = Nothing
                    ModGlobal.EscribirLog("Metodo ActualizarBeneficiario completado exitosamente")
                    Return serializer.Serialize(result)
                Else
                    ModGlobal.EscribirLog("Validacion: SP retorno resultado de error")
                    Dim result As New Dictionary(Of String, Object)
                    result("Success") = False
                    result("Message") = mensaje
                    result("Data") = Nothing
                    ModGlobal.EscribirLog("Metodo ActualizarBeneficiario completado exitosamente")
                    Return serializer.Serialize(result)
                End If
            Else
                ModGlobal.EscribirLog("No se recibio respuesta del servidor (dt.Rows.Count = 0)")
                Dim result As New Dictionary(Of String, Object)
                result("Success") = False
                result("Message") = "No se recibió respuesta del procedimiento almacenado"
                result("Data") = Nothing
                Return serializer.Serialize(result)
            End If

        Catch ex As Exception
            ModGlobal.EscribirLog("Error en ActualizarBeneficiario: " & ex.Message & " | StackTrace: " & ex.StackTrace)
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
            ModGlobal.EscribirLog("ESTA EJECUTANDO EL METODO ObtenerDatosPrueba")

            ' Leer el archivo JSON desde el sistema de archivos
            Dim jsonPath As String = HttpContext.Current.Server.MapPath("~/Forms/Socios/asociados.json")
            ModGlobal.EscribirLog("Ruta del archivo JSON: " & jsonPath)

            If System.IO.File.Exists(jsonPath) Then
                ModGlobal.EscribirLog("Archivo JSON encontrado, leyendo contenido...")
                Dim jsonContent As String = System.IO.File.ReadAllText(jsonPath)
                ModGlobal.EscribirLog("Contenido JSON leído exitosamente, longitud: " & jsonContent.Length)

                ' Crear serializer con límite aumentado
                Dim serializer As New JavaScriptSerializer()
                serializer.MaxJsonLength = Int32.MaxValue

                ' Retornar el JSON directamente
                Dim result As New Dictionary(Of String, Object)
                result("Success") = True
                result("Message") = ""
                result("Data") = jsonContent
                ModGlobal.EscribirLog("Metodo ObtenerDatosPrueba completado exitosamente")
                Return serializer.Serialize(result)
            Else
                ModGlobal.EscribirLog("Validacion: Archivo JSON no encontrado en: " & jsonPath)
                Dim serializer As New JavaScriptSerializer()
                Dim result As New Dictionary(Of String, Object)
                result("Success") = False
                result("Message") = "Archivo de datos de prueba no encontrado en: " & jsonPath
                result("Data") = ""
                ModGlobal.EscribirLog("Metodo ObtenerDatosPrueba completado exitosamente")
                Return serializer.Serialize(result)
            End If

        Catch ex As Exception
            ModGlobal.EscribirLog("Error en ObtenerDatosPrueba: " & ex.Message & " | StackTrace: " & ex.StackTrace)
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
            ModGlobal.EscribirLog("ESTA EJECUTANDO EL METODO EliminarBeneficiario")
            ModGlobal.EscribirLog("Parametro recibido - IDBeneficiario: " & idBeneficiario.ToString())

            Dim uDBA As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
            Dim sSql As String = "Exec spBeneficiarios_EliminarBeneficiario"

            ' Obtener UsuarioId de la sesión
            Dim usuarioId As Integer = If(HttpContext.Current.Session(VariablesSesion.UsuarioId), 0)
            If usuarioId = 0 Then
                ModGlobal.EscribirLog("Validacion: UsuarioId no encontrado en sesion")
                Dim result As New Dictionary(Of String, Object)
                result("Success") = False
                result("Message") = "Usuario no autenticado"
                Return serializer.Serialize(result)
            End If

            With uDBA.Parametros
                .Add("@IDBeneficiario", idBeneficiario)
                .Add("@Usuario", usuarioId.ToString())
                .Add("@IdSession", HttpContext.Current.Session(VariablesSesion.logID).ToString())
            End With

            ModGlobal.EscribirLog($"Ejecutando SQL: {sSql} {uDBA.getParamList()}")
            Dim dt As DataTable = uDBA.GetDataTableSql(sSql)

            If uDBA.MensajeError <> "" Then
                ModGlobal.EscribirLog("Error en BD al eliminar beneficiario: " & uDBA.MensajeError)
                Dim resultError As New Dictionary(Of String, Object)
                resultError("Success") = False
                resultError("Message") = uDBA.MensajeError
                resultError("Data") = Nothing
                Return serializer.Serialize(resultError)
            End If

            ModGlobal.EscribirLog("Ejecucion SQL completada sin errores. Registros devueltos: " & dt.Rows.Count.ToString())

            If dt.Rows.Count > 0 Then
                Dim resultado = dt.Rows(0)("Resultado").ToString()
                Dim mensaje = dt.Rows(0)("Mensaje").ToString()

                ModGlobal.EscribirLog("Resultado del stored procedure - Resultado: " & resultado & ", Mensaje: " & mensaje)

                If resultado = "SUCCESS" Then
                    Dim result As New Dictionary(Of String, Object)
                    result("Success") = True
                    result("Message") = mensaje
                    result("Data") = Nothing
                    ModGlobal.EscribirLog("Metodo EliminarBeneficiario completado exitosamente")
                    Return serializer.Serialize(result)
                Else
                    ModGlobal.EscribirLog("Validacion: SP retorno resultado de error")
                    Dim result As New Dictionary(Of String, Object)
                    result("Success") = False
                    result("Message") = mensaje
                    result("Data") = Nothing
                    ModGlobal.EscribirLog("Metodo EliminarBeneficiario completado exitosamente")
                    Return serializer.Serialize(result)
                End If
            Else
                ModGlobal.EscribirLog("No se recibio respuesta del servidor (dt.Rows.Count = 0)")
                Dim result As New Dictionary(Of String, Object)
                result("Success") = False
                result("Message") = "No se recibió respuesta del procedimiento almacenado"
                result("Data") = Nothing
                Return serializer.Serialize(result)
            End If

        Catch ex As Exception
            ModGlobal.EscribirLog("Error en EliminarBeneficiario: " & ex.Message & " | StackTrace: " & ex.StackTrace)
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
            ModGlobal.EscribirLog("ESTA EJECUTANDO EL METODO ObtenerParametrosInactividad")

            Dim parametros As New Dictionary(Of String, String)

            ' Obtener parámetros de la sesión
            Dim monitorearInactividad As String = If(HttpContext.Current.Session(VariablesSesion.MONITOREAR_INACTIVIDAD), "0")
            Dim tiempoMonitorear As String = If(HttpContext.Current.Session(VariablesSesion.TIEMPO_MONITOREAR_INACTIVIDAD), "5")

            ModGlobal.EscribirLog($"Parametros obtenidos - MONITOREAR_INACTIVIDAD: {monitorearInactividad}, TIEMPO_MONITOREAR_INACTIVIDAD: {tiempoMonitorear}")

            parametros.Add("MONITOREAR_INACTIVIDAD", monitorearInactividad)
            parametros.Add("TIEMPO_MONITOREAR_INACTIVIDAD", tiempoMonitorear)

            Dim resultado As New With {
                .Success = True,
                .Message = "Parámetros obtenidos exitosamente",
                .Data = parametros
            }

            Dim serializer As New JavaScriptSerializer()
            ModGlobal.EscribirLog("Metodo ObtenerParametrosInactividad completado exitosamente")
            Return serializer.Serialize(resultado)

        Catch ex As Exception
            ModGlobal.EscribirLog("Error en ObtenerParametrosInactividad: " & ex.Message & " | StackTrace: " & ex.StackTrace)
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
            ModGlobal.EscribirLog("ESTA EJECUTANDO EL METODO CerrarSesionPorInactividad")

            ' Registrar el cierre de sesión por inactividad
            Dim usuarioId = HttpContext.Current.Session("UsuarioId")
            Dim nombreUsuario = HttpContext.Current.Session("NombreUsuario")
            Dim ipAddress = HttpContext.Current.Request.UserHostAddress
            Dim timestamp = DateTime.Now

            ModGlobal.EscribirLog($"Informacion de sesion - UsuarioId: {If(usuarioId IsNot Nothing, usuarioId.ToString(), "(nulo)")}, NombreUsuario: {If(nombreUsuario IsNot Nothing, nombreUsuario.ToString(), "(nulo)")}, IPAddress: {ipAddress}")

            ' Log de cierre por inactividad (implementar según necesidades)
            ' LogActivity(usuarioId, nombreUsuario, "Session_Timeout_Inactivity", ipAddress, "", timestamp)

            ' Cerrar sesión
            FormsAuthentication.SignOut()
            HttpContext.Current.Session.Clear()
            HttpContext.Current.Session.Abandon()

            ModGlobal.EscribirLog("Sesion cerrada exitosamente por inactividad")
            Dim resultado As New With {
                .Success = True,
                .Message = "Sesión cerrada por inactividad",
                .Data = Nothing
            }

            Dim serializer As New JavaScriptSerializer()
            ModGlobal.EscribirLog("Metodo CerrarSesionPorInactividad completado exitosamente")
            Return serializer.Serialize(resultado)

        Catch ex As Exception
            ModGlobal.EscribirLog("Error en CerrarSesionPorInactividad: " & ex.Message & " | StackTrace: " & ex.StackTrace)
            Dim resultado As New With {
                .Success = False,
                .Message = "Error al cerrar sesión por inactividad: " & ex.Message,
                .Data = Nothing
            }

            Dim serializer As New JavaScriptSerializer()
            Return serializer.Serialize(resultado)
        End Try
    End Function

    <WebMethod(EnableSession:=True)>
    <ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
    Public Shared Function ObtenerNivelesEstudio() As String
        Dim serializer As New JavaScriptSerializer()

        Try
            ModGlobal.EscribirLog("ESTA EJECUTANDO EL METODO ObtenerNivelesEstudio")

            Dim uDBA As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
            Dim sSql As String = "SELECT Code, Descripcion FROM tbNivelesEstudio WHERE snEliminado = 0 ORDER BY Code"

            ModGlobal.EscribirLog($"Ejecutando SQL: {sSql} {uDBA.getParamList()}")
            Dim dt As DataTable = uDBA.GetDataTableSql(sSql)

            If uDBA.MensajeError <> "" Then
                ModGlobal.EscribirLog("Error en BD al obtener niveles de estudio: " & uDBA.MensajeError)
                Dim resultError As New Dictionary(Of String, Object)
                resultError("Success") = False
                resultError("Message") = uDBA.MensajeError
                resultError("TotalRegistros") = 0
                resultError("Data") = New List(Of Object)
                Return serializer.Serialize(resultError)
            End If

            ModGlobal.EscribirLog("Ejecucion SQL completada sin errores. Registros obtenidos: " & dt.Rows.Count.ToString())

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
                ModGlobal.EscribirLog("Metodo ObtenerNivelesEstudio completado exitosamente")
                Return serializer.Serialize(result)

        Catch ex As Exception
            ModGlobal.EscribirLog("Error en ObtenerNivelesEstudio: " & ex.Message & " | StackTrace: " & ex.StackTrace)

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
    Public Shared Function ObtenerProfesiones() As String
        Dim serializer As New JavaScriptSerializer()

        Try
            ModGlobal.EscribirLog("ESTA EJECUTANDO EL METODO ObtenerProfesiones")

            Dim uDBA As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
            Dim sSql As String = "SELECT Code, Descripcion FROM tbProfesiones WHERE snEliminado = 0 ORDER BY Code"

            ModGlobal.EscribirLog($"Ejecutando SQL: {sSql} {uDBA.getParamList()}")
            Dim dt As DataTable = uDBA.GetDataTableSql(sSql)

            If uDBA.MensajeError <> "" Then
                ModGlobal.EscribirLog("Error en BD al obtener profesiones: " & uDBA.MensajeError)
                Dim resultError As New Dictionary(Of String, Object)
                resultError("Success") = False
                resultError("Message") = uDBA.MensajeError
                resultError("TotalRegistros") = 0
                resultError("Data") = New List(Of Object)
                Return serializer.Serialize(resultError)
            End If

            ModGlobal.EscribirLog("Ejecucion SQL completada sin errores. Registros obtenidos: " & dt.Rows.Count.ToString())

                Dim jsonData As New List(Of Dictionary(Of String, Object))
                For Each row As DataRow In dt.Rows
                    Dim item As New Dictionary(Of String, Object)
                    For Each column As DataColumn In dt.Columns
                        item(column.ColumnName) = If(row(column) Is DBNull.Value, Nothing, row(column))
                    Next
                    jsonData.Add(item)
                Next

                Dim result As New Dictionary(Of String, Object)
                result("Success") = True
                result("Message") = ""
                result("TotalRegistros") = dt.Rows.Count
                result("Data") = jsonData
                ModGlobal.EscribirLog("Metodo ObtenerProfesiones completado exitosamente")
                Return serializer.Serialize(result)

        Catch ex As Exception
            ModGlobal.EscribirLog("Error en ObtenerProfesiones: " & ex.Message & " | StackTrace: " & ex.StackTrace)
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
    Public Shared Function ObtenerEmpresas() As String
        Dim serializer As New JavaScriptSerializer()

        Try
            ModGlobal.EscribirLog("ESTA EJECUTANDO EL METODO ObtenerEmpresas")

            Dim uDBA As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
            Dim sSql As String = "SELECT Code, Descripcion FROM tbEmpresas WHERE snEliminado = 0 ORDER BY Code"

            ModGlobal.EscribirLog($"Ejecutando SQL: {sSql} {uDBA.getParamList()}")
            Dim dt As DataTable = uDBA.GetDataTableSql(sSql)

            If uDBA.MensajeError <> "" Then
                ModGlobal.EscribirLog("Error en BD al obtener empresas: " & uDBA.MensajeError)
                Dim resultError As New Dictionary(Of String, Object)
                resultError("Success") = False
                resultError("Message") = uDBA.MensajeError
                resultError("TotalRegistros") = 0
                resultError("Data") = New List(Of Object)
                Return serializer.Serialize(resultError)
            End If

            ModGlobal.EscribirLog("Ejecucion SQL completada sin errores. Registros obtenidos: " & dt.Rows.Count.ToString())

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
                ModGlobal.EscribirLog("Metodo ObtenerEmpresas completado exitosamente")
                Return serializer.Serialize(result)

        Catch ex As Exception
            ModGlobal.EscribirLog("Error en ObtenerEmpresas: " & ex.Message & " | StackTrace: " & ex.StackTrace)
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
    Public Shared Function ObtenerPaises() As String
        Dim serializer As New JavaScriptSerializer()

        Try
            ModGlobal.EscribirLog("ESTA EJECUTANDO EL METODO ObtenerPaises")

            Dim uDBA As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
            Dim sSql As String = "SELECT Code, Descripcion FROM tbPaises WHERE snEliminado = 0 ORDER BY Descripcion"

            ModGlobal.EscribirLog($"Ejecutando SQL: {sSql} {uDBA.getParamList()}")
            Dim dt As DataTable = uDBA.GetDataTableSql(sSql)

            If uDBA.MensajeError <> "" Then
                ModGlobal.EscribirLog("Error en BD al obtener paises: " & uDBA.MensajeError)
                Dim resultError As New Dictionary(Of String, Object)
                resultError("Success") = False
                resultError("Message") = uDBA.MensajeError
                resultError("TotalRegistros") = 0
                resultError("Data") = New List(Of Object)
                Return serializer.Serialize(resultError)
            End If

            ModGlobal.EscribirLog("Ejecucion SQL completada sin errores. Registros obtenidos: " & dt.Rows.Count.ToString())

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
                ModGlobal.EscribirLog("Metodo ObtenerPaises completado exitosamente")
                Return serializer.Serialize(result)

        Catch ex As Exception
            ModGlobal.EscribirLog("Error en ObtenerPaises: " & ex.Message & " | StackTrace: " & ex.StackTrace)
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
    Public Shared Function ObtenerProvincias() As String
        Dim serializer As New JavaScriptSerializer()

        Try
            ModGlobal.EscribirLog("ESTA EJECUTANDO EL METODO ObtenerProvincias")

            Dim uDBA As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
            Dim sSql As String = "SELECT Code, CodePais, Descripcion FROM tbProvincias WHERE snEliminado = 0 ORDER BY Code"

            ModGlobal.EscribirLog($"Ejecutando SQL: {sSql} {uDBA.getParamList()}")
            Dim dt As DataTable = uDBA.GetDataTableSql(sSql)

            If uDBA.MensajeError <> "" Then
                ModGlobal.EscribirLog("Error en BD al obtener provincias: " & uDBA.MensajeError)
                Dim resultError As New Dictionary(Of String, Object)
                resultError("Success") = False
                resultError("Message") = uDBA.MensajeError
                resultError("TotalRegistros") = 0
                resultError("Data") = New List(Of Object)
                Return serializer.Serialize(resultError)
            End If

            ModGlobal.EscribirLog("Ejecucion SQL completada sin errores. Registros obtenidos: " & dt.Rows.Count.ToString())

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
                ModGlobal.EscribirLog("Metodo ObtenerProvincias completado exitosamente")
                Return serializer.Serialize(result)

        Catch ex As Exception
            ModGlobal.EscribirLog("Error en ObtenerProvincias: " & ex.Message & " | StackTrace: " & ex.StackTrace)
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
    Public Shared Function ObtenerDistritos() As String
        Dim serializer As New JavaScriptSerializer()

        Try
            ModGlobal.EscribirLog("ESTA EJECUTANDO EL METODO ObtenerDistritos")

            Dim uDBA As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
            Dim sSql As String = "SELECT Code, CodeProvincia, Descripcion FROM tbDistritos WHERE snEliminado = 0 ORDER BY Code"

            ModGlobal.EscribirLog($"Ejecutando SQL: {sSql} {uDBA.getParamList()}")
            Dim dt As DataTable = uDBA.GetDataTableSql(sSql)

            If uDBA.MensajeError <> "" Then
                ModGlobal.EscribirLog("Error en BD al obtener distritos: " & uDBA.MensajeError)
                Dim resultError As New Dictionary(Of String, Object)
                resultError("Success") = False
                resultError("Message") = uDBA.MensajeError
                resultError("TotalRegistros") = 0
                resultError("Data") = New List(Of Object)
                Return serializer.Serialize(resultError)
            End If

            ModGlobal.EscribirLog("Ejecucion SQL completada sin errores. Registros obtenidos: " & dt.Rows.Count.ToString())

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
                ModGlobal.EscribirLog("Metodo ObtenerDistritos completado exitosamente")
                Return serializer.Serialize(result)

        Catch ex As Exception
            ModGlobal.EscribirLog("Error en ObtenerDistritos: " & ex.Message & " | StackTrace: " & ex.StackTrace)
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
    Public Shared Function ObtenerCorregimientos() As String
        Dim serializer As New JavaScriptSerializer()

        Try
            ModGlobal.EscribirLog("ESTA EJECUTANDO EL METODO ObtenerCorregimientos")

            Dim uDBA As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
            Dim sSql As String = "SELECT Code, CodeDistrito, Descripcion FROM tbCorregimientos WHERE snEliminado = 0 ORDER BY Code"

            ModGlobal.EscribirLog($"Ejecutando SQL: {sSql} {uDBA.getParamList()}")
            Dim dt As DataTable = uDBA.GetDataTableSql(sSql)

            If uDBA.MensajeError <> "" Then
                ModGlobal.EscribirLog("Error en BD al obtener corregimientos: " & uDBA.MensajeError)
                Dim resultError As New Dictionary(Of String, Object)
                resultError("Success") = False
                resultError("Message") = uDBA.MensajeError
                resultError("TotalRegistros") = 0
                resultError("Data") = New List(Of Object)
                Return serializer.Serialize(resultError)
            End If

            ModGlobal.EscribirLog("Ejecucion SQL completada sin errores. Registros obtenidos: " & dt.Rows.Count.ToString())

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
                ModGlobal.EscribirLog("Metodo ObtenerCorregimientos completado exitosamente")
                Return serializer.Serialize(result)

        Catch ex As Exception
            ModGlobal.EscribirLog("Error en ObtenerCorregimientos: " & ex.Message & " | StackTrace: " & ex.StackTrace)
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
    Public Shared Function ObtenerOcupaciones() As String
        Dim serializer As New JavaScriptSerializer()

        Try
            ModGlobal.EscribirLog("ESTA EJECUTANDO EL METODO ObtenerOcupaciones")

            Dim uDBA As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
            Dim sSql As String = "SELECT Code, Descripcion FROM tbOcupaciones WHERE snEliminado = 0 ORDER BY Code"

            ModGlobal.EscribirLog($"Ejecutando SQL: {sSql} {uDBA.getParamList()}")
            Dim dt As DataTable = uDBA.GetDataTableSql(sSql)

            If uDBA.MensajeError = "" Then
            ModGlobal.EscribirLog("Ejecucion SQL completada sin errores. Registros obtenidos: " & dt.Rows.Count.ToString())
                ModGlobal.EscribirLog("Ocupaciones obtenidas exitosamente. Registros: " & dt.Rows.Count.ToString())

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
                ModGlobal.EscribirLog("Metodo ObtenerOcupaciones completado exitosamente")
                Return serializer.Serialize(result)
            Else
                ModGlobal.EscribirLog("Error en BD al obtener ocupaciones: " & uDBA.MensajeError)
                ' Retornar objeto con información de error
                Dim result As New Dictionary(Of String, Object)
                result("Success") = False
                result("Message") = uDBA.MensajeError
                result("TotalRegistros") = 0
                result("Data") = New List(Of Object)
                Return serializer.Serialize(result)
            End If

        Catch ex As Exception
            ModGlobal.EscribirLog("Error en ObtenerOcupaciones: " & ex.Message & " | StackTrace: " & ex.StackTrace)
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
    Public Shared Function EliminarAsociado(numeroAsociado As Integer) As String
        Dim serializer As New JavaScriptSerializer()
        Try
            ModGlobal.EscribirLog($"Iniciando eliminación de socio: {numeroAsociado}")

            ' Obtener UsuarioId de la sesión
            Dim usuarioId As Integer = If(HttpContext.Current.Session(VariablesSesion.UsuarioId), 0)
            If usuarioId = 0 Then
                ModGlobal.EscribirLog("Error: UsuarioId no encontrado en sesión")
                Dim result As New Dictionary(Of String, Object)
                result("Success") = False
                result("Message") = "Usuario no autenticado"
                Return serializer.Serialize(result)
            End If

            Dim uDBA As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
            Dim sSql As String = "Exec spGestionSocios_EliminarAsociado"

            With uDBA.Parametros
                .Add("@NumeroAsociado", numeroAsociado)
                .Add("@UsuarioElimina", usuarioId)
                .Add("@IdSession", HttpContext.Current.Session(VariablesSesion.logID).ToString())
            End With

            ModGlobal.EscribirLog($"Ejecutando SQL: {sSql} {uDBA.getParamList()}")
            Dim dt As DataTable = uDBA.GetDataTableSql(sSql)

            If uDBA.MensajeError <> "" Then
                ModGlobal.EscribirLog($"Error en BD al eliminar socio: {uDBA.MensajeError}")
                Dim result As New Dictionary(Of String, Object)
                result("Success") = False
                result("Message") = uDBA.MensajeError
                Return serializer.Serialize(result)
            End If

            ' Verificar resultado del SP
            If dt.Rows.Count > 0 Then
                Dim row As DataRow = dt.Rows(0)
                Dim resultado As String = If(row("Resultado"), "").ToString()

                If resultado = "SUCCESS" Then
                    ModGlobal.EscribirLog($"Socio {numeroAsociado} eliminado exitosamente por usuario {usuarioId}")
                    Dim result As New Dictionary(Of String, Object)
                    result("Success") = True
                    result("Message") = If(row("Mensaje"), "").ToString()
                    result("Data") = New Dictionary(Of String, Object) From {
                        {"NumeroAsociado", If(row("NumeroAsociado"), 0)},
                        {"NombreCompleto", If(row("NombreCompleto"), "").ToString()},
                        {"UsuarioElimina", If(row("UsuarioElimina"), 0)},
                        {"FechaEliminacion", If(row("FechaEliminacion"), DateTime.Now).ToString()}
                    }
                    Return serializer.Serialize(result)
                Else
                    ModGlobal.EscribirLog($"Error al eliminar socio: {If(row("Mensaje"), "").ToString()}")
                    Dim result As New Dictionary(Of String, Object)
                    result("Success") = False
                    result("Message") = If(row("Mensaje"), "").ToString()
                    Return serializer.Serialize(result)
                End If
            Else
                ModGlobal.EscribirLog("Error: No se recibió respuesta del stored procedure")
                Dim result As New Dictionary(Of String, Object)
                result("Success") = False
                result("Message") = "Error interno del servidor"
                Return serializer.Serialize(result)
            End If

        Catch ex As Exception
            ModGlobal.EscribirLog($"Error en EliminarAsociado: {ex.Message} | StackTrace: {ex.StackTrace}")
            Dim result As New Dictionary(Of String, Object)
            result("Success") = False
            result("Message") = "Error interno: " & ex.Message
            Return serializer.Serialize(result)
        End Try
    End Function

    <WebMethod(EnableSession:=True)>
    <ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
    Public Shared Function ObtenerMovimientosSocio(numeroAsociado As Integer, start As Integer, length As Integer, orderColumn As String, orderDir As String) As String
        Dim serializer As New JavaScriptSerializer()

        Try
            ModGlobal.EscribirLog("ESTA EJECUTANDO EL METODO ObtenerMovimientosSocio")
            ModGlobal.EscribirLog("Parametro recibido - NumeroAsociado: " & numeroAsociado.ToString())

            If start < 0 Then start = 0
            If length <= 0 Then length = 20
            If String.IsNullOrWhiteSpace(orderColumn) Then orderColumn = "Fecha"
            If String.IsNullOrWhiteSpace(orderDir) Then orderDir = "DESC"

            start = If(start < 0, 0, start)
            length = If(length <= 0, 20, length)

            Dim orderColumnSafe As String = "Fecha"
            Select Case If(orderColumn, String.Empty).Trim().ToUpperInvariant()
                Case "RUBRO"
                    orderColumnSafe = "Rubro"
                Case "TRANSACCION"
                    orderColumnSafe = "Transaccion"
                Case "DETALLE"
                    orderColumnSafe = "Detalle"
                Case "MONTO"
                    orderColumnSafe = "Monto"
                Case "OBSERVACIONES"
                    orderColumnSafe = "Observaciones"
                Case Else
                    orderColumnSafe = "Fecha"
            End Select

            Dim orderDirSafe As String = If(String.Equals(orderDir, "ASC", StringComparison.OrdinalIgnoreCase), "ASC", "DESC")

            Dim uDBA As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
            uDBA.Parametros.Clear()
            Dim sSql As String = "Exec spMovimientos_ListarPorSocio"

            With uDBA.Parametros
                .Add("@NumeroAsociado", numeroAsociado)
                .Add("@Start", start)
                .Add("@Length", length)
                .Add("@OrderColumn", orderColumnSafe)
                .Add("@OrderDirection", orderDirSafe)
            End With

            ModGlobal.EscribirLog($"Ejecutando SQL: {sSql} {uDBA.getParamList()}")
            Dim dt As DataTable = uDBA.GetDataTableSql(sSql)

            If uDBA.MensajeError <> "" Then
                ModGlobal.EscribirLog("Error en BD al obtener movimientos: " & uDBA.MensajeError)
                Dim resultError As New Dictionary(Of String, Object)
                resultError("Success") = False
                resultError("Message") = uDBA.MensajeError
                resultError("Data") = New List(Of Object)
                Return serializer.Serialize(resultError)
            End If

            Dim jsonData As New List(Of Dictionary(Of String, Object))
            Dim totalRegistros As Integer = 0
            For Each row As DataRow In dt.Rows
                Dim item As New Dictionary(Of String, Object)
                For Each column As DataColumn In dt.Columns
                    item(column.ColumnName) = If(row(column) Is DBNull.Value, Nothing, row(column))
                Next
                If totalRegistros = 0 AndAlso item.ContainsKey("TotalRegistros") AndAlso item("TotalRegistros") IsNot Nothing Then
                    Integer.TryParse(item("TotalRegistros").ToString(), totalRegistros)
                End If
                jsonData.Add(item)
            Next

            Dim resultSuccess As New Dictionary(Of String, Object)
            resultSuccess("Success") = True
            resultSuccess("Message") = ""
            resultSuccess("Data") = jsonData
            resultSuccess("TotalRegistros") = If(totalRegistros > 0, totalRegistros, dt.Rows.Count)
            resultSuccess("Start") = start
            resultSuccess("Length") = length
            resultSuccess("OrderColumn") = orderColumnSafe
            resultSuccess("OrderDirection") = orderDirSafe

            ModGlobal.EscribirLog("Metodo ObtenerMovimientosSocio completado exitosamente")
            Return serializer.Serialize(resultSuccess)

        Catch ex As Exception
            ModGlobal.EscribirLog("Error en ObtenerMovimientosSocio: " & ex.Message & " | StackTrace: " & ex.StackTrace)
            Dim result As New Dictionary(Of String, Object)
            result("Success") = False
            result("Message") = "Error al obtener movimientos: " & ex.Message
            result("Data") = New List(Of Object)
            Return serializer.Serialize(result)
        End Try
    End Function

    <WebMethod(EnableSession:=True)>
    <ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
    Public Shared Function GenerarComprobanteMovimiento(movimientoId As String) As String
        Dim serializer As New JavaScriptSerializer()

        Try
            ModGlobal.EscribirLog("GenerarComprobanteMovimiento iniciado. MovimientoID: " & movimientoId)

            Dim uDBA As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
            uDBA.Parametros.Clear()

            ' Obtener datos del movimiento usando stored procedure
            Dim sSql As String = "Exec spMovimientos_ObtenerDatosComprobante"

            With uDBA.Parametros
                .Add("@MovimientoID", Integer.Parse(movimientoId))
            End With

            Dim dt As DataTable = uDBA.GetDataTableSql(sSql)

            ' Verificar si hubo error en la base de datos
            If uDBA.MensajeError <> "" Then
                ModGlobal.EscribirLog("Error en BD al obtener datos del comprobante: " & uDBA.MensajeError)
                Dim resultError As New Dictionary(Of String, Object)
                resultError("Resultado") = "ERROR"
                resultError("Mensaje") = "Error en la base de datos: " & uDBA.MensajeError
                Return serializer.Serialize(resultError)
            Else
                ModGlobal.EscribirLog("Comando ejecutado correctamente - GenerarComprobanteMovimiento")
            End If

            If dt.Rows.Count = 0 Then
                ModGlobal.EscribirLog("No se encontró el movimiento con ID: " & movimientoId)
                Dim resultNoData As New Dictionary(Of String, Object)
                resultNoData("Resultado") = "ERROR"
                resultNoData("Mensaje") = "No se encontró el movimiento"
                Return serializer.Serialize(resultNoData)
            End If

            Dim row As DataRow = dt.Rows(0)

            ' Formatear MovimientoID con ceros a la izquierda
            Dim movimientoIdFormateado As String = Right("000000000000" & movimientoId, 12)

            ' Formatear fecha y hora
            Dim fechaHora As String = Convert.ToDateTime(row("FechaMovimiento")).ToString("dd/MM/yyyy HH:mm")

            ' Formatear monto con punto decimal
            Dim montoFormateado As String = Convert.ToDecimal(row("Monto")).ToString("###,###,##0.00", System.Globalization.CultureInfo.InvariantCulture)

            ' Leer el template HTML
            Dim templatePath As String = HttpContext.Current.Server.MapPath("~/Forms/Transacciones/ComprobanteTransaccion.html")
            Dim htmlTemplate As String = System.IO.File.ReadAllText(templatePath)

            ' Reemplazar placeholders
            htmlTemplate = htmlTemplate.Replace("@MovimientoID", movimientoIdFormateado)
            htmlTemplate = htmlTemplate.Replace("@FechaHora", fechaHora)
            htmlTemplate = htmlTemplate.Replace("@Usuario", row("UsuarioNombre").ToString())
            htmlTemplate = htmlTemplate.Replace("@NumeroAsociado", row("NumeroAsociado").ToString())
            htmlTemplate = htmlTemplate.Replace("@NombreAsociado", row("NombreAsociado").ToString())
            htmlTemplate = htmlTemplate.Replace("@DescripcionAuxiliar", row("DescripcionTipoAuxiliar").ToString())
            htmlTemplate = htmlTemplate.Replace("@Cuenta", row("Cuenta").ToString())
            htmlTemplate = htmlTemplate.Replace("@DescripcionTransaccion", row("DescripcionTransaccion").ToString())
            htmlTemplate = htmlTemplate.Replace("@Monto", montoFormateado)

            ModGlobal.EscribirLog("Comprobante generado exitosamente para movimiento: " & movimientoId)

            Dim resultado As New Dictionary(Of String, Object)
            resultado("Resultado") = "SUCCESS"
            resultado("Html") = htmlTemplate
            Return serializer.Serialize(resultado)

        Catch ex As Exception
            ModGlobal.EscribirLog("Error en GenerarComprobanteMovimiento: " & ex.Message & " | StackTrace: " & ex.StackTrace)
            Dim result As New Dictionary(Of String, Object)
            result("Resultado") = "ERROR"
            result("Mensaje") = "Error al generar comprobante: " & ex.Message
            Return serializer.Serialize(result)
        End Try
    End Function

    <WebMethod(EnableSession:=True)>
    <ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
    Public Shared Function MarcarComprobanteImpreso(movimientoId As String) As String
        Dim serializer As New JavaScriptSerializer()

        Try
            ModGlobal.EscribirLog("ESTA EJECUTANDO EL METODO MarcarComprobanteImpreso")
            ModGlobal.EscribirLog("Parametro recibido - MovimientoID: " & movimientoId)

            Dim uDBA As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
            uDBA.Parametros.Clear()
            Dim sSql As String = "UPDATE tbMovimientos SET snImpreso = 1 WHERE IDMovimiento = @MovimientoID"

            With uDBA.Parametros
                .Add("@MovimientoID", movimientoId)
            End With

            ModGlobal.EscribirLog($"Ejecutando SQL: {sSql} {uDBA.getParamList()}")
            uDBA.ExecuteNonQuerySql(sSql)

            If uDBA.MensajeError <> "" Then
                ModGlobal.EscribirLog("Error en BD al marcar comprobante: " & uDBA.MensajeError)
                Dim resultError As New Dictionary(Of String, Object)
                resultError("Success") = False
                resultError("Message") = uDBA.MensajeError
                Return serializer.Serialize(resultError)
            End If

            Dim resultSuccess As New Dictionary(Of String, Object)
            resultSuccess("Success") = True
            resultSuccess("Message") = ""
            Return serializer.Serialize(resultSuccess)

        Catch ex As Exception
            ModGlobal.EscribirLog("Error en MarcarComprobanteImpreso: " & ex.Message & " | StackTrace: " & ex.StackTrace)
            Dim result As New Dictionary(Of String, Object)
            result("Success") = False
            result("Message") = "Error al marcar comprobante: " & ex.Message
            Return serializer.Serialize(result)
        End Try
    End Function

End Class
