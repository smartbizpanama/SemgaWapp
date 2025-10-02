Imports System.Data.SqlClient
Imports SBSqlClient
Imports SBUtility
Module ModGlobal
    'VARIABLES LOG
    Private log As SBLogWriter
    Public logID As String
    Private LogType As Integer
    Public Sub IniciarSesionLog(Usuario As String)

        LogType = GetAppKey("LogType")
        logID = Guid.NewGuid().ToString.ToUpper
        System.Web.HttpContext.Current.Session(VariablesSesion.logID) = logID

        log = New SBLogWriter(System.Web.HttpContext.Current.Server.MapPath("Logs\LOG.DAT"))

        'log.WriteTxt("Sesión iniciada por " & Usuario & vbCrLf & "Datos sesión: IDS [" & logID & "] - IP [" & GetIp() & "] - HOST [" & GetHost() & "]")
        log.WriteTxt("Sesión iniciada por " & Usuario & " - Datos sesión: ID.S [" & logID & "]")

        'Tipos: 0 = File, 1 = BD

        If LogType = 1 Or LogType = 2 Then
            Dim Cnn As String = ConfigurationManager.AppSettings("ConnectionString").Trim
            Dim uDBA As SBSqlClientInterface = GetDbaObject(Cnn)
            Dim sSql As String = "Exec spSysAppLogInicioSesion"

            With uDBA.Parametros
                .Add("@Usr", Usuario)
                .Add("@SID", logID)
            End With


            Try
                uDBA.ExecuteNonQuerySql(sSql)
            Catch ex As Exception
                log.WriteTxt("[ID.S: " & logID & "] - " & uDBA.LimpiarMsgErrorDB(ex.Message))
            End Try
        End If

    End Sub


    Sub escribirLogBD(Mensaje As String)
        Dim Cnn As String = ConfigurationManager.AppSettings("ConnectionString").Trim
        Dim uDBA As SBSqlClientInterface = GetDbaObject(Cnn)

        Dim sSql As String = "Exec spSysAppLogAdd"

        With uDBA.Parametros
            .Add("@Men", Mensaje)
            .Add("@SID", System.Web.HttpContext.Current.Session(VariablesSesion.logID))
        End With


        Try

            Try
                uDBA.ExecuteNonQuerySql(sSql)

            Catch ex As SqlException
                log.WriteTxt("[ID.S: " & System.Web.HttpContext.Current.Session(VariablesSesion.logID) & "] - " & ex.Message)
            End Try

        Catch ex As Exception
            log.WriteTxt("[ID.S: " & System.Web.HttpContext.Current.Session(VariablesSesion.logID) & "] - " & ex.Message)
        End Try
    End Sub


    Sub escribirLogFile(mensaje As String)
        log.WriteTxt($"[Usr:{HttpContext.Current.Session(VariablesSesion.UsuarioId)} ID: {System.Web.HttpContext.Current.Session(VariablesSesion.logID)}] - " & mensaje)
    End Sub
    Public Sub EscribirLog(Mensaje As String)

        Select Case LogType
            Case 0
                escribirLogFile(Mensaje)
            Case 1
                escribirLogBD(Mensaje)
            Case 2
                escribirLogFile(Mensaje)
                escribirLogBD(Mensaje)
        End Select

        Debug.WriteLine(Mensaje)
    End Sub

    Public Function GetDbaObject(sCnn As String) As SBSqlClientInterface

        Try
            Dim uPass As New SBEncryption
            Dim sCnnStr As String = uPass.Decrypt(sCnn)
            Dim uDBA As New SBSqlClientInterface(sCnnStr)

            Return uDBA
        Catch ex As Exception
            System.Diagnostics.Trace.WriteLine($"{DateTime.Now}: error en GetDbaObject: {ex.Message}")
            System.Diagnostics.Trace.Flush()
        End Try

    End Function

    Public Function GetAppKey(KeyName As String) As String

        Dim val As String
        Try
            val = ConfigurationManager.AppSettings(KeyName)
        Catch ex As Exception
            val = ""
        End Try

        Return val
    End Function

End Module

