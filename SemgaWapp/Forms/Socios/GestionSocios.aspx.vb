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

        ' Manejar descarga de archivos Excel
        If Request.QueryString("action") = "download" AndAlso Not String.IsNullOrEmpty(Request.QueryString("file")) Then
            DescargarArchivo(Request.QueryString("file"))
        End If
    End Sub

    Private Sub DescargarArchivo(nombreArchivo As String)
        Try
            Dim rutaArchivo As String = Server.MapPath("~/Temp/" & nombreArchivo)
            ModGlobal.EscribirLog($"[DESCARGAR ARCHIVO] Intentando descargar: {nombreArchivo}")
            ModGlobal.EscribirLog($"[DESCARGAR ARCHIVO] Ruta completa: {rutaArchivo}")

            If System.IO.File.Exists(rutaArchivo) Then
                ModGlobal.EscribirLog($"[DESCARGAR ARCHIVO] Archivo encontrado, iniciando descarga...")
                Response.Clear()
                Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
                Response.AddHeader("Content-Disposition", "attachment; filename=" & nombreArchivo)
                Response.TransmitFile(rutaArchivo)
                Response.End()

                ' Eliminar archivo temporal después de la descarga
                Try
                    System.IO.File.Delete(rutaArchivo)
                    ModGlobal.EscribirLog($"[DESCARGAR ARCHIVO] Archivo eliminado después de descarga")
                Catch ex As Exception
                    ModGlobal.EscribirLog($"[DESCARGAR ARCHIVO] No se pudo eliminar el archivo temporal: {ex.Message}")
                End Try
            Else
                ModGlobal.EscribirLog($"[DESCARGAR ARCHIVO] Archivo no encontrado: {rutaArchivo}")
                Response.Write("Archivo no encontrado")
            End If
        Catch ex As Exception
            ModGlobal.EscribirLog($"[DESCARGAR ARCHIVO] Error al descargar archivo: {ex.Message} | StackTrace: {ex.StackTrace}")
            Response.Write("Error al descargar archivo: " & ex.Message)
        End Try
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

            ' Formatear montos con formato de moneda (incluyendo símbolo $)
            Dim montoCapital As Decimal = Convert.ToDecimal(row("Monto"))
            Dim montoCapitalFormateado As String = montoCapital.ToString("$###,###,##0.00", System.Globalization.CultureInfo.InvariantCulture)
            Dim montoInteresesFormateado As String = ""
            Dim montoIntereses As Decimal = 0

            ' Verificar si hay movimiento de intereses
            If dt.Columns.Contains("MontoIntereses") AndAlso Not IsDBNull(row("MontoIntereses")) Then
                Dim montoInteresesObj As Object = row("MontoIntereses")
                If montoInteresesObj IsNot Nothing Then
                    montoIntereses = Convert.ToDecimal(montoInteresesObj)
                    montoInteresesFormateado = montoIntereses.ToString("$###,###,##0.00", System.Globalization.CultureInfo.InvariantCulture)
                End If
            End If

            ' Calcular total (capital + intereses)
            Dim montoTotal As Decimal = montoCapital + montoIntereses
            Dim montoTotalFormateado As String = montoTotal.ToString("$###,###,##0.00", System.Globalization.CultureInfo.InvariantCulture)

            ' Leer el template HTML
            Dim templatePath As String = HttpContext.Current.Server.MapPath("~/Forms/Transacciones/ComprobanteTransaccion.html")
            Dim htmlTemplate As String = System.IO.File.ReadAllText(templatePath)

            ' Reemplazar placeholders comunes
            htmlTemplate = htmlTemplate.Replace("@MovimientoID", movimientoIdFormateado)
            htmlTemplate = htmlTemplate.Replace("@FechaHora", fechaHora)
            htmlTemplate = htmlTemplate.Replace("@Usuario", row("UsuarioNombre").ToString())
            htmlTemplate = htmlTemplate.Replace("@NumeroAsociado", row("NumeroAsociado").ToString())
            htmlTemplate = htmlTemplate.Replace("@NombreAsociado", row("NombreAsociado").ToString())

            ' Agregar identificación del asociado
            Dim tipoIdentificacion As String = ""
            Dim numeroIdentificacion As String = ""
            If dt.Columns.Contains("TipoIdentificacion") AndAlso Not IsDBNull(row("TipoIdentificacion")) Then
                tipoIdentificacion = row("TipoIdentificacion").ToString()
            End If
            If dt.Columns.Contains("NumeroIdentificacion") AndAlso Not IsDBNull(row("NumeroIdentificacion")) Then
                numeroIdentificacion = row("NumeroIdentificacion").ToString()
            End If
            htmlTemplate = htmlTemplate.Replace("@TipoIdentificacion", tipoIdentificacion)
            htmlTemplate = htmlTemplate.Replace("@NumeroIdentificacion", numeroIdentificacion)

            htmlTemplate = htmlTemplate.Replace("@DescripcionAuxiliar", row("DescripcionTipoAuxiliar").ToString())
            htmlTemplate = htmlTemplate.Replace("@Cuenta", row("Cuenta").ToString())
            htmlTemplate = htmlTemplate.Replace("@Total", montoTotalFormateado)
            
            ' Construir descripción de transacción + ' TOTAL '
            Dim descripcionTransaccionTotal As String = row("DescripcionTransaccion").ToString() & " TOTAL "
            htmlTemplate = htmlTemplate.Replace("@DescripcionTransaccionTotal", descripcionTransaccionTotal)
            htmlTemplate = htmlTemplate.Replace("@DescripcionTransaccion", row("DescripcionTransaccion").ToString())

            ' Construir sección de montos dinámicamente
            Dim nuevaSeccionMontos As String = ""

            If Not String.IsNullOrEmpty(montoCapitalFormateado) AndAlso Not String.IsNullOrEmpty(montoInteresesFormateado) Then
                ' Ambos movimientos - mostrar lado a lado
                nuevaSeccionMontos = "            <div class=""monto-container"">" & vbCrLf &
                    "                <div class=""monto-section capital"">" & vbCrLf &
                    "                    <div class=""monto-label"">Capital</div>" & vbCrLf &
                    "                    <div class=""monto-value"">" & montoCapitalFormateado & "</div>" & vbCrLf &
                    "                </div>" & vbCrLf &
                    "                <div class=""monto-section intereses"">" & vbCrLf &
                    "                    <div class=""monto-label"">Intereses</div>" & vbCrLf &
                    "                    <div class=""monto-value"">" & montoInteresesFormateado & "</div>" & vbCrLf &
                    "                </div>" & vbCrLf &
                    "            </div>"
            ElseIf Not String.IsNullOrEmpty(montoCapitalFormateado) Then
                ' Solo capital - usar color azul
                nuevaSeccionMontos = "            <div class=""monto-section capital"">" & vbCrLf &
                    "                <div class=""monto-label"">Capital</div>" & vbCrLf &
                    "                <div class=""monto-value"">" & montoCapitalFormateado & "</div>" & vbCrLf &
                    "            </div>"
            ElseIf Not String.IsNullOrEmpty(montoInteresesFormateado) Then
                ' Solo intereses - usar color azul distintivo
                nuevaSeccionMontos = "            <div class=""monto-section intereses"">" & vbCrLf &
                    "                <div class=""monto-label"">Intereses</div>" & vbCrLf &
                    "                <div class=""monto-value"">" & montoInteresesFormateado & "</div>" & vbCrLf &
                    "            </div>"
            Else
                ' Fallback: usar monto genérico si no hay ninguno
                nuevaSeccionMontos = "            <div class=""monto-section"">" & vbCrLf &
                    "                <div class=""monto-label"">Monto</div>" & vbCrLf &
                    "                <div class=""monto-value"">0.00</div>" & vbCrLf &
                    "            </div>"
            End If

            ' Reemplazar secciones de monto usando regex
            Dim patronRegex As String = "<div class=""monto-section"">\s*<div class=""monto-label"">Monto</div>\s*<div class=""monto-value"">@Monto</div>\s*</div>"
            Dim nuevaSeccionSinIndentacion As String = nuevaSeccionMontos.Replace("            ", "").Trim()

            ' Reemplazar usando regex (más flexible con espacios y saltos de línea)
            htmlTemplate = System.Text.RegularExpressions.Regex.Replace(htmlTemplate, patronRegex, nuevaSeccionSinIndentacion, System.Text.RegularExpressions.RegexOptions.IgnoreCase Or System.Text.RegularExpressions.RegexOptions.Multiline)

            ' También intentar reemplazo directo por si acaso
            Dim patronBusqueda As String = "<div class=""monto-section"">" & vbCrLf & "                <div class=""monto-label"">Monto</div>" & vbCrLf & "                <div class=""monto-value"">@Monto</div>" & vbCrLf & "            </div>"
            While htmlTemplate.Contains(patronBusqueda)
                htmlTemplate = htmlTemplate.Replace(patronBusqueda, nuevaSeccionSinIndentacion)
            End While

            ' Reemplazar placeholder antiguo para compatibilidad (solo si no se reemplazó antes)
            If htmlTemplate.Contains("@Monto") Then
                htmlTemplate = htmlTemplate.Replace("@Monto", If(Not String.IsNullOrEmpty(montoCapitalFormateado), montoCapitalFormateado, If(Not String.IsNullOrEmpty(montoInteresesFormateado), montoInteresesFormateado, "0.00")))
            End If

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
    Public Shared Function GenerarEstadoCuenta(numeroAsociado As String) As String
        Dim serializer As New JavaScriptSerializer()

        Try
            ModGlobal.EscribirLog("GenerarEstadoCuenta iniciado. NumeroAsociado: " & numeroAsociado)

            Dim uDBA As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
            uDBA.Parametros.Clear()

            ' Obtener datos del asociado
            Dim sSqlAsociado As String = "SELECT NumeroAsociado, Nombre, SegundoNombre, Apellido, SegundoApellido FROM tbAsociados WHERE NumeroAsociado = @NumeroAsociado AND snEliminado = 0"
            With uDBA.Parametros
                .Clear()
                .Add("@NumeroAsociado", Integer.Parse(numeroAsociado))
            End With

            Dim dtAsociado As DataTable = uDBA.GetDataTableSql(sSqlAsociado)

            If uDBA.MensajeError <> "" Then
                ModGlobal.EscribirLog("Error en BD al obtener datos del asociado: " & uDBA.MensajeError)
                Dim resultError As New Dictionary(Of String, Object)
                resultError("Resultado") = "ERROR"
                resultError("Mensaje") = "Error en la base de datos: " & uDBA.MensajeError
                Return serializer.Serialize(resultError)
            End If

            If dtAsociado.Rows.Count = 0 Then
                ModGlobal.EscribirLog("No se encontró el asociado con número: " & numeroAsociado)
                Dim resultNoData As New Dictionary(Of String, Object)
                resultNoData("Resultado") = "ERROR"
                resultNoData("Mensaje") = "No se encontró el asociado"
                Return serializer.Serialize(resultNoData)
            End If

            Dim rowAsociado As DataRow = dtAsociado.Rows(0)
            Dim nombreCompleto As String = $"{rowAsociado("Nombre")} {If(Not IsDBNull(rowAsociado("SegundoNombre")), rowAsociado("SegundoNombre"), "")} {rowAsociado("Apellido")} {If(Not IsDBNull(rowAsociado("SegundoApellido")), rowAsociado("SegundoApellido"), "")}".Trim()

            ' Obtener datos del estado de cuenta usando stored procedure
            uDBA.Parametros.Clear()
            Dim sSqlEstado As String = "Exec spAsociados_ObtenerEstadoCuenta"
            With uDBA.Parametros
                .Add("@NumeroAsociado", Integer.Parse(numeroAsociado))
            End With

            Dim dtEstado As DataTable = uDBA.GetDataTableSql(sSqlEstado)

            If uDBA.MensajeError <> "" Then
                ModGlobal.EscribirLog("Error en BD al obtener estado de cuenta: " & uDBA.MensajeError)
                Dim resultError As New Dictionary(Of String, Object)
                resultError("Resultado") = "ERROR"
                resultError("Mensaje") = "Error en la base de datos: " & uDBA.MensajeError
                Return serializer.Serialize(resultError)
            End If

            ' Leer el template HTML
            Dim templatePath As String = HttpContext.Current.Server.MapPath("~/Forms/Socios/EstadoCuenta.html")
            Dim htmlTemplate As String = System.IO.File.ReadAllText(templatePath)

            ' Obtener datos de identificación del stored procedure (si están disponibles)
            Dim tipoIdentificacion As String = ""
            Dim numeroIdentificacion As String = ""
            If dtEstado.Rows.Count > 0 Then
                Dim primeraFila As DataRow = dtEstado.Rows(0)
                If Not IsDBNull(primeraFila("TipoIdentificacion")) Then
                    tipoIdentificacion = primeraFila("TipoIdentificacion").ToString()
                End If
                If Not IsDBNull(primeraFila("NumeroIdentificacion")) Then
                    numeroIdentificacion = primeraFila("NumeroIdentificacion").ToString()
                End If
            End If

            ' Reemplazar datos del asociado
            htmlTemplate = htmlTemplate.Replace("@NombreAsociado", nombreCompleto)
            htmlTemplate = htmlTemplate.Replace("@NumeroAsociado", numeroAsociado)
            htmlTemplate = htmlTemplate.Replace("@TipoIdentificacion", tipoIdentificacion)
            htmlTemplate = htmlTemplate.Replace("@NumeroIdentificacion", numeroIdentificacion)

            ' Generar filas de la tabla
            Dim filasTabla As String = ""
            If dtEstado.Rows.Count > 0 Then
                For Each row As DataRow In dtEstado.Rows
                    Dim idAuxiliar As String = If(Not IsDBNull(row("IDAuxiliar")), row("IDAuxiliar").ToString(), "0")
                    Dim tipoAuxiliar As String = If(Not IsDBNull(row("TipoAuxiliar")), row("TipoAuxiliar").ToString(), "N/A")
                    Dim numeroCuenta As String = If(Not IsDBNull(row("NumeroCuenta")), row("NumeroCuenta").ToString(), "N/A")
                    Dim fechaInicio As String = If(Not IsDBNull(row("FechaInicio")), Convert.ToDateTime(row("FechaInicio")).ToString("dd/MM/yyyy"), "N/A")
                    Dim montoOriginal As String = If(Not IsDBNull(row("MontoOriginal")), Convert.ToDecimal(row("MontoOriginal")).ToString("$###,###,##0.00", System.Globalization.CultureInfo.InvariantCulture), "$0.00")
                    Dim fechaUltimoPago As String = If(Not IsDBNull(row("FechaUltimoPago")), Convert.ToDateTime(row("FechaUltimoPago")).ToString("dd/MM/yyyy"), "N/A")
                    Dim cuota As String = If(Not IsDBNull(row("Cuota")), Convert.ToDecimal(row("Cuota")).ToString("$###,###,##0.00", System.Globalization.CultureInfo.InvariantCulture), "$0.00")
                    Dim intereses As String = If(Not IsDBNull(row("Intereses")), Convert.ToDecimal(row("Intereses")).ToString("$###,###,##0.00", System.Globalization.CultureInfo.InvariantCulture), "$0.00")
                    Dim saldoActual As String = If(Not IsDBNull(row("SaldoActual")), Convert.ToDecimal(row("SaldoActual")).ToString("$###,###,##0.00", System.Globalization.CultureInfo.InvariantCulture), "$0.00")
                    Dim codigoRubro As String = If(Not IsDBNull(row("CodigoRubro")), row("CodigoRubro").ToString().ToUpper(), "")

                    ' Botón para ver detalle de intereses
                    ' Mostrar siempre el botón (el modal verificará si hay datos)
                    ' Esto permite ver el historial incluso si los intereses son 0 pero hay registros en tbAuxiliares_Intereses
                    Dim botonIntereses As String = $"<button type=""button"" class=""btn-detalle-intereses"" onclick=""mostrarDetalleIntereses({idAuxiliar})"" title=""Ver detalle de intereses""><i class=""fa fa-arrow-right""></i></button>"

                    Dim celdaIntereses As String = $"<td class=""celda-intereses"">{botonIntereses}<span class=""monto-intereses"">{intereses}</span></td>"

                    filasTabla &= $"<tr data-auxiliar-id=""{idAuxiliar}"">" & vbCrLf &
                        $"    <td>{tipoAuxiliar}</td>" & vbCrLf &
                        $"    <td>{numeroCuenta}</td>" & vbCrLf &
                        $"    <td>{fechaInicio}</td>" & vbCrLf &
                        $"    <td>{montoOriginal}</td>" & vbCrLf &
                        $"    <td>{fechaUltimoPago}</td>" & vbCrLf &
                        $"    <td>{cuota}</td>" & vbCrLf &
                        celdaIntereses & vbCrLf &
                        $"    <td>{saldoActual}</td>" & vbCrLf &
                        $"</tr>" & vbCrLf
                Next
            Else
                filasTabla = "<tr><td colspan='8' style='text-align: center; padding: 20px;'>No se encontraron registros</td></tr>"
            End If

            htmlTemplate = htmlTemplate.Replace("@FilasTabla", filasTabla)

            ' Reemplazar fecha y hora de impresión
            Dim fechaHoraImpresion As String = DateTime.Now.ToString("dd/MM/yyyy HH:mm:ss")
            htmlTemplate = htmlTemplate.Replace("@FechaHoraImpresion", fechaHoraImpresion)

            ModGlobal.EscribirLog("Estado de cuenta generado exitosamente para asociado: " & numeroAsociado)

            Dim resultado As New Dictionary(Of String, Object)
            resultado("Resultado") = "SUCCESS"
            resultado("Html") = htmlTemplate
            Return serializer.Serialize(resultado)

        Catch ex As Exception
            ModGlobal.EscribirLog("Error en GenerarEstadoCuenta: " & ex.Message & " | StackTrace: " & ex.StackTrace)
            Dim result As New Dictionary(Of String, Object)
            result("Resultado") = "ERROR"
            result("Mensaje") = "Error al generar estado de cuenta: " & ex.Message
            Return serializer.Serialize(result)
        End Try
    End Function

    <WebMethod(EnableSession:=True)>
    <ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
    Public Shared Function ObtenerHistorialIntereses(idAuxiliar As String) As String
        Dim serializer As New JavaScriptSerializer()

        Try
            ModGlobal.EscribirLog("ObtenerHistorialIntereses iniciado. IDAuxiliar: " & idAuxiliar)

            Dim uDBA As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))
            uDBA.Parametros.Clear()

            ' Obtener historial de intereses usando stored procedure
            Dim sSql As String = "Exec spAuxiliares_ObtenerHistorialIntereses"

            With uDBA.Parametros
                .Add("@IDAuxiliar", Integer.Parse(idAuxiliar))
            End With

            Dim dt As DataTable = uDBA.GetDataTableSql(sSql)

            If uDBA.MensajeError <> "" Then
                ModGlobal.EscribirLog("Error en BD al obtener historial de intereses: " & uDBA.MensajeError)
                Dim resultError As New Dictionary(Of String, Object)
                resultError("Resultado") = "ERROR"
                resultError("Mensaje") = "Error en la base de datos: " & uDBA.MensajeError
                Return serializer.Serialize(resultError)
            End If

            Dim historial As New List(Of Dictionary(Of String, Object))
            For Each row As DataRow In dt.Rows
                Dim item As New Dictionary(Of String, Object)
                For Each column As DataColumn In dt.Columns
                    item(column.ColumnName) = If(row(column) Is DBNull.Value, Nothing, row(column))
                Next
                historial.Add(item)
            Next

            ModGlobal.EscribirLog("Historial de intereses obtenido exitosamente. Registros: " & historial.Count)

            Dim resultado As New Dictionary(Of String, Object)
            resultado("Resultado") = "SUCCESS"
            resultado("Datos") = historial
            Return serializer.Serialize(resultado)

        Catch ex As Exception
            ModGlobal.EscribirLog("Error en ObtenerHistorialIntereses: " & ex.Message & " | StackTrace: " & ex.StackTrace)
            Dim result As New Dictionary(Of String, Object)
            result("Resultado") = "ERROR"
            result("Mensaje") = "Error al obtener historial de intereses: " & ex.Message
            Return serializer.Serialize(result)
        End Try
    End Function

    <WebMethod(EnableSession:=True)>
    <ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
    Public Shared Function ExportarHistorialInteresesAExcel(datos As Object(), codigoRubro As String) As String
        Dim serializer As New JavaScriptSerializer()
        Dim resultado As String = ""

        Try
            ModGlobal.EscribirLog("[EXPORTAR EXCEL] ExportarHistorialInteresesAExcel iniciado")
            ModGlobal.EscribirLog($"[EXPORTAR EXCEL] Cantidad de registros recibidos: {datos.Length}")
            ModGlobal.EscribirLog($"[EXPORTAR EXCEL] CodigoRubro recibido: {codigoRubro}")

            ' Validar datos
            If datos Is Nothing OrElse datos.Length = 0 Then
                ModGlobal.EscribirLog("[EXPORTAR EXCEL] No se recibieron datos para exportar")
                Dim errorResponse As New Dictionary(Of String, Object)
                errorResponse("Resultado") = "ERROR"
                errorResponse("Mensaje") = "No se recibieron datos para exportar"
                errorResponse("NombreArchivo") = ""
                Return serializer.Serialize(errorResponse)
            End If

            ' Generar nombre de archivo único
            Dim nombreArchivo As String = $"HistorialIntereses_{DateTime.Now:yyyyMMdd_HHmmss}.xlsx"
            nombreArchivo = nombreArchivo.Replace(" ", "_").Replace("/", "_")
            ModGlobal.EscribirLog($"[EXPORTAR EXCEL] Nombre de archivo generado: {nombreArchivo}")

            ' Crear workbook con ClosedXML
            ModGlobal.EscribirLog("[EXPORTAR EXCEL] Creando workbook con ClosedXML...")
            Using workbook As New ClosedXML.Excel.XLWorkbook()
                Dim worksheet = workbook.Worksheets.Add("Historial Intereses")
                ModGlobal.EscribirLog("[EXPORTAR EXCEL] Worksheet creado: Historial Intereses")

                ' Agregar título
                worksheet.Cell(1, 1).Value = "Historial de Intereses"
                worksheet.Cell(1, 1).Style.Font.Bold = True
                worksheet.Cell(1, 1).Style.Font.FontSize = 14
                worksheet.Range(1, 1, 1, 15).Merge()

                ' Agregar fecha de generación
                worksheet.Cell(2, 1).Value = "Generado el: " & DateTime.Now.ToString("dd/MM/yyyy HH:mm:ss")
                worksheet.Cell(2, 1).Style.Font.Italic = True
                worksheet.Range(2, 1, 2, 15).Merge()

                ' Espacio en blanco
                Dim filaInicio As Integer = 4

                If datos.Length > 0 Then
                    ' Determinar el tipo de cuenta
                    Dim esPrestamo As Boolean = codigoRubro.ToUpper() = "PR"
                    ModGlobal.EscribirLog($"[EXPORTAR EXCEL] Tipo de cuenta - Es Préstamo: {esPrestamo}")

                    ' Definir columnas según el tipo de cuenta
                    Dim columnas As New List(Of String)
                    columnas.Add("Fecha Cálculo")
                    columnas.Add("Hora")
                    columnas.Add("Fecha Últ. Cálculo")
                    columnas.Add("Saldo a Fecha")
                    columnas.Add("Interés Calc. a Fecha")

                    If esPrestamo Then
                        columnas.Add("Interés Pagado a Fecha")
                    End If

                    columnas.Add("Días Intereses")
                    columnas.Add("Tasa")
                    columnas.Add("Interés Calculado")

                    If Not esPrestamo Then
                        columnas.Add("Nuevo Saldo")
                    End If

                    columnas.Add("Usuario")

                    ' Función auxiliar para convertir string formateado a decimal
                    Dim convertirMonto As Func(Of String, Decimal) = Function(valor As String) As Decimal
                                                                         If String.IsNullOrEmpty(valor) Then Return 0
                                                                         Dim valorLimpio As String = valor.ToString().Replace(",", "").Trim()
                                                                         Dim montoDecimal As Decimal = 0
                                                                         Decimal.TryParse(valorLimpio, montoDecimal)
                                                                         Return montoDecimal
                                                                     End Function

                    ' Función auxiliar para obtener valor seguro de un diccionario
                    Dim obtenerValorSeguro As Func(Of Dictionary(Of String, Object), String, String) = Function(dict As Dictionary(Of String, Object), key As String) As String
                                                                                                           If Not dict.ContainsKey(key) Then Return "N/A"
                                                                                                           Dim valor = dict(key)
                                                                                                           If valor Is Nothing OrElse IsDBNull(valor) Then Return "N/A"
                                                                                                           Return valor.ToString()
                                                                                                       End Function

                    ' Agregar encabezados
                    ModGlobal.EscribirLog($"[EXPORTAR EXCEL] Agregando {columnas.Count} columnas de encabezados...")
                    For i As Integer = 0 To columnas.Count - 1
                        worksheet.Cell(filaInicio, i + 1).Value = columnas(i)
                        worksheet.Cell(filaInicio, i + 1).Style.Font.Bold = True
                        worksheet.Cell(filaInicio, i + 1).Style.Fill.BackgroundColor = ClosedXML.Excel.XLColor.LightBlue
                    Next
                    ModGlobal.EscribirLog("[EXPORTAR EXCEL] Encabezados agregados correctamente")

                    ' Agregar datos
                    ModGlobal.EscribirLog($"[EXPORTAR EXCEL] Agregando {datos.Length} filas de datos...")
                    For i As Integer = 0 To datos.Length - 1
                        Dim fila As Integer = filaInicio + 1 + i
                        Dim item As Dictionary(Of String, Object) = Nothing

                        Try
                            item = DirectCast(datos(i), Dictionary(Of String, Object))
                        Catch ex As Exception
                            ModGlobal.EscribirLog($"[EXPORTAR EXCEL] Error al convertir item {i}: {ex.Message}")
                            Continue For
                        End Try

                        Dim columnaActual As Integer = 1

                        If i = 0 Then
                            ModGlobal.EscribirLog($"[EXPORTAR EXCEL] Procesando primera fila. Keys disponibles: {String.Join(", ", item.Keys)}")
                        End If

                        ' Fecha Cálculo
                        worksheet.Cell(fila, columnaActual).Value = obtenerValorSeguro(item, "FechaCalculo")
                        columnaActual += 1

                        ' Hora
                        worksheet.Cell(fila, columnaActual).Value = obtenerValorSeguro(item, "HoraCalculo")
                        columnaActual += 1

                        ' Fecha Últ. Cálculo
                        worksheet.Cell(fila, columnaActual).Value = obtenerValorSeguro(item, "FechaUltCalculo")
                        columnaActual += 1

                        ' Saldo a Fecha
                        Dim saldoAFecha As Decimal = convertirMonto(obtenerValorSeguro(item, "SaldoAFecha"))
                        worksheet.Cell(fila, columnaActual).Value = saldoAFecha
                        worksheet.Cell(fila, columnaActual).Style.NumberFormat.Format = "$#,##0.00"
                        columnaActual += 1

                        ' Interés Calc. a Fecha
                        Dim interesCalcAFecha As Decimal = convertirMonto(obtenerValorSeguro(item, "InteresCalculadoAFecha"))
                        worksheet.Cell(fila, columnaActual).Value = interesCalcAFecha
                        worksheet.Cell(fila, columnaActual).Style.NumberFormat.Format = "$#,##0.00"
                        columnaActual += 1

                        ' Interés Pagado a Fecha (solo para préstamos)
                        If esPrestamo Then
                            Dim interesPagadoAFecha As Decimal = convertirMonto(obtenerValorSeguro(item, "InteresPagadoAFecha"))
                            worksheet.Cell(fila, columnaActual).Value = interesPagadoAFecha
                            worksheet.Cell(fila, columnaActual).Style.NumberFormat.Format = "$#,##0.00"
                            columnaActual += 1
                        End If

                        ' Días Intereses
                        worksheet.Cell(fila, columnaActual).Value = obtenerValorSeguro(item, "DiasIntereses")
                        columnaActual += 1

                        ' Tasa
                        Dim tasaValor As String = obtenerValorSeguro(item, "Tasa")
                        worksheet.Cell(fila, columnaActual).Value = If(tasaValor = "N/A", "0.00%", tasaValor & "%")
                        columnaActual += 1

                        ' Interés Calculado
                        Dim interesCalculado As Decimal = convertirMonto(obtenerValorSeguro(item, "InteresCalculado"))
                        worksheet.Cell(fila, columnaActual).Value = interesCalculado
                        worksheet.Cell(fila, columnaActual).Style.NumberFormat.Format = "$#,##0.00"
                        worksheet.Cell(fila, columnaActual).Style.Font.Bold = True
                        columnaActual += 1

                        ' Nuevo Saldo (solo para no-préstamos)
                        If Not esPrestamo Then
                            Dim nuevoSaldo As Decimal = convertirMonto(obtenerValorSeguro(item, "SaldoGenerado"))
                            worksheet.Cell(fila, columnaActual).Value = nuevoSaldo
                            worksheet.Cell(fila, columnaActual).Style.NumberFormat.Format = "$#,##0.00"
                            worksheet.Cell(fila, columnaActual).Style.Font.Bold = True
                            columnaActual += 1
                        End If

                        ' Usuario
                        worksheet.Cell(fila, columnaActual).Value = obtenerValorSeguro(item, "NombreUsuario")
                    Next

                    ' Ajustar ancho de columnas
                    ModGlobal.EscribirLog("[EXPORTAR EXCEL] Ajustando ancho de columnas...")
                    worksheet.Columns().AdjustToContents()

                    ' Agregar bordes
                    ModGlobal.EscribirLog("[EXPORTAR EXCEL] Agregando bordes a la tabla...")
                    worksheet.Range(filaInicio, 1, filaInicio + datos.Length, columnas.Count).Style.Border.OutsideBorder = ClosedXML.Excel.XLBorderStyleValues.Thin
                    worksheet.Range(filaInicio, 1, filaInicio + datos.Length, columnas.Count).Style.Border.InsideBorder = ClosedXML.Excel.XLBorderStyleValues.Thin
                    ModGlobal.EscribirLog($"[EXPORTAR EXCEL] Datos agregados: {datos.Length} filas procesadas")
                End If

                ' Guardar archivo temporalmente
                Dim rutaArchivo As String = HttpContext.Current.Server.MapPath("~/Temp/" & nombreArchivo)
                Dim directorioTemp As String = HttpContext.Current.Server.MapPath("~/Temp/")
                ModGlobal.EscribirLog($"[EXPORTAR EXCEL] Ruta del archivo: {rutaArchivo}")
                ModGlobal.EscribirLog($"[EXPORTAR EXCEL] Directorio temporal: {directorioTemp}")

                ' Crear directorio si no existe
                If Not System.IO.Directory.Exists(directorioTemp) Then
                    ModGlobal.EscribirLog("[EXPORTAR EXCEL] Creando directorio Temp...")
                    System.IO.Directory.CreateDirectory(directorioTemp)
                    ModGlobal.EscribirLog("[EXPORTAR EXCEL] Directorio Temp creado")
                Else
                    ModGlobal.EscribirLog("[EXPORTAR EXCEL] Directorio Temp ya existe")
                End If

                ModGlobal.EscribirLog("[EXPORTAR EXCEL] Guardando archivo Excel...")
                workbook.SaveAs(rutaArchivo)
                ModGlobal.EscribirLog($"[EXPORTAR EXCEL] Archivo Excel guardado exitosamente: {nombreArchivo}")
                ModGlobal.EscribirLog($"[EXPORTAR EXCEL] Tamaño del archivo: {If(System.IO.File.Exists(rutaArchivo), New System.IO.FileInfo(rutaArchivo).Length.ToString() & " bytes", "No se pudo verificar")}")
            End Using

            Dim successResponse As New Dictionary(Of String, Object)
            successResponse("Resultado") = "SUCCESS"
            successResponse("Mensaje") = "Archivo Excel generado exitosamente"
            successResponse("NombreArchivo") = nombreArchivo
            resultado = serializer.Serialize(successResponse)
            ModGlobal.EscribirLog($"[EXPORTAR EXCEL] Respuesta serializada. Longitud: {resultado.Length} caracteres")
            ModGlobal.EscribirLog("[EXPORTAR EXCEL] ExportarHistorialInteresesAExcel completado exitosamente")

        Catch ex As Exception
            ModGlobal.EscribirLog($"[EXPORTAR EXCEL] Error en ExportarHistorialInteresesAExcel: {ex.Message}")
            ModGlobal.EscribirLog($"[EXPORTAR EXCEL] StackTrace: {ex.StackTrace}")
            If ex.InnerException IsNot Nothing Then
                ModGlobal.EscribirLog($"[EXPORTAR EXCEL] InnerException: {ex.InnerException.Message}")
            End If
            Dim errorResponse As New Dictionary(Of String, Object)
            errorResponse("Resultado") = "ERROR"
            errorResponse("Mensaje") = "Error al generar archivo Excel: " & ex.Message
            errorResponse("NombreArchivo") = ""
            resultado = serializer.Serialize(errorResponse)
            ModGlobal.EscribirLog($"[EXPORTAR EXCEL] Respuesta de error serializada")
        End Try

        ModGlobal.EscribirLog($"[EXPORTAR EXCEL] Retornando resultado. Longitud: {resultado.Length} caracteres")
        Return resultado
    End Function

    <WebMethod(EnableSession:=True)>
    <ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
    Public Shared Function MarcarComprobanteImpreso(movimientoId As String) As String
        Dim serializer As New JavaScriptSerializer()

        Try
            ModGlobal.EscribirLog("ESTA EJECUTANDO EL METODO MarcarComprobanteImpreso")
            ModGlobal.EscribirLog("Parametro recibido - MovimientoID: " & movimientoId)

            Dim uDBA As SBSqlClientInterface = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))

            ' Primero obtener el IDMovIntereses si existe
            uDBA.Parametros.Clear()
            Dim sSqlObtener As String = "SELECT IDMovIntereses FROM tbMovimientos WHERE IDMovimiento = @MovimientoID AND snEliminado = 0"
            With uDBA.Parametros
                .Add("@MovimientoID", Integer.Parse(movimientoId))
            End With

            Dim dt As DataTable = uDBA.GetDataTableSql(sSqlObtener)
            Dim idMovIntereses As Integer = 0

            If dt.Rows.Count > 0 AndAlso Not IsDBNull(dt.Rows(0)("IDMovIntereses")) Then
                idMovIntereses = Convert.ToInt32(dt.Rows(0)("IDMovIntereses"))
                ModGlobal.EscribirLog($"Movimiento de intereses encontrado: {idMovIntereses}")
            End If

            ' Marcar el movimiento principal como impreso
            uDBA.Parametros.Clear()
            Dim sSql As String = "UPDATE tbMovimientos SET snImpreso = 1 WHERE IDMovimiento = @MovimientoID"

            With uDBA.Parametros
                .Add("@MovimientoID", Integer.Parse(movimientoId))
            End With

            ModGlobal.EscribirLog($"Ejecutando SQL: {sSql} {uDBA.getParamList()}")
            uDBA.ExecuteNonQuerySql(sSql)

            If uDBA.MensajeError <> "" Then
                ModGlobal.EscribirLog("Error en BD al marcar comprobante principal: " & uDBA.MensajeError)
                Dim resultError As New Dictionary(Of String, Object)
                resultError("Success") = False
                resultError("Message") = uDBA.MensajeError
                Return serializer.Serialize(resultError)
            End If

            ' Si existe movimiento de intereses, marcarlo también como impreso
            If idMovIntereses > 0 Then
                uDBA.Parametros.Clear()
                Dim sSqlIntereses As String = "UPDATE tbMovimientos SET snImpreso = 1 WHERE IDMovimiento = @MovimientoID"
                With uDBA.Parametros
                    .Add("@MovimientoID", idMovIntereses)
                End With

                ModGlobal.EscribirLog($"Marcando movimiento de intereses como impreso: {idMovIntereses}")
                uDBA.ExecuteNonQuerySql(sSqlIntereses)

                If uDBA.MensajeError <> "" Then
                    ModGlobal.EscribirLog("Error en BD al marcar comprobante de intereses: " & uDBA.MensajeError)
                    ' No fallar, solo loguear el error
                End If
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
