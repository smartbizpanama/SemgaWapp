-- =============================================
-- Función para obtener información de sesión de SQL Server
-- Devuelve JSON con todos los datos posibles que se puedan recolectar
-- de la sesión actual de la base de datos
-- =============================================

USE [SegmaDB]
GO

-- Eliminar función si existe
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fnAuditoria_ObtenerSessionInfo]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
    DROP FUNCTION [dbo].[fnAuditoria_ObtenerSessionInfo]
GO

CREATE FUNCTION [dbo].[fnAuditoria_ObtenerSessionInfo]()
RETURNS NVARCHAR(MAX)
AS
BEGIN
    DECLARE @SessionInfo NVARCHAR(MAX) = ''
    
    -- Obtener información básica de la sesión SQL
    DECLARE @SPID INT = @@SPID
    DECLARE @HostName NVARCHAR(128) = ISNULL(HOST_NAME(), '')
    DECLARE @AppName NVARCHAR(128) = ISNULL(APP_NAME(), '')
    DECLARE @LoginName NVARCHAR(128) = ISNULL(SUSER_NAME(), '')
    DECLARE @UserName NVARCHAR(128) = ISNULL(USER_NAME(), '')
    DECLARE @DatabaseName NVARCHAR(128) = ISNULL(DB_NAME(), '')
    DECLARE @ServerName NVARCHAR(128) = ISNULL(@@SERVERNAME, '')
    DECLARE @DbUser NVARCHAR(128) = ISNULL(SUSER_SNAME(), '')
    
    -- Variables para información adicional
    DECLARE @ProgramName NVARCHAR(128) = ''
    DECLARE @ClientNetAddress NVARCHAR(48) = ''
    DECLARE @LoginTime NVARCHAR(23) = CONVERT(NVARCHAR(23), GETDATE(), 126)
    DECLARE @CPU NVARCHAR(20) = '0'
    DECLARE @MemoryUsage NVARCHAR(20) = '0'
    DECLARE @Reads NVARCHAR(20) = '0'
    DECLARE @Writes NVARCHAR(20) = '0'
    
    -- Obtener información adicional de sys.dm_exec_sessions si está disponible
    SELECT 
        @ProgramName = ISNULL(s.program_name, ''),
        @ClientNetAddress = ISNULL(c.client_net_address, ''),
        @LoginTime = ISNULL(CONVERT(NVARCHAR(23), s.login_time, 126), CONVERT(NVARCHAR(23), GETDATE(), 126)),
        @CPU = CAST(ISNULL(s.cpu_time, 0) AS NVARCHAR(20)),
        @MemoryUsage = CAST(ISNULL(s.memory_usage, 0) AS NVARCHAR(20)),
        @Reads = CAST(ISNULL(s.reads, 0) AS NVARCHAR(20)),
        @Writes = CAST(ISNULL(s.writes, 0) AS NVARCHAR(20))
    FROM sys.dm_exec_sessions s
    LEFT JOIN sys.dm_exec_connections c ON s.session_id = c.session_id
    WHERE s.session_id = @@SPID
    
    -- Obtener propiedades del servidor
    DECLARE @ServerVersion NVARCHAR(50) = CAST(ISNULL(SERVERPROPERTY('ProductVersion'), '') AS NVARCHAR(50))
    DECLARE @ServerEdition NVARCHAR(100) = CAST(ISNULL(SERVERPROPERTY('Edition'), '') AS NVARCHAR(100))
    DECLARE @ServerBuild NVARCHAR(50) = CAST(ISNULL(SERVERPROPERTY('ProductLevel'), '') AS NVARCHAR(50))
    DECLARE @Language NVARCHAR(50) = CAST(ISNULL(SERVERPROPERTY('Language'), '') AS NVARCHAR(50))
    DECLARE @IsClustered NVARCHAR(5) = CAST(CASE WHEN SERVERPROPERTY('IsClustered') = 1 THEN 'true' ELSE 'false' END AS NVARCHAR(5))
    DECLARE @IsIntegratedSecurityOnly NVARCHAR(5) = CAST(CASE WHEN SERVERPROPERTY('IsIntegratedSecurityOnly') = 1 THEN 'true' ELSE 'false' END AS NVARCHAR(5))
    DECLARE @MachineName NVARCHAR(128) = CAST(ISNULL(SERVERPROPERTY('MachineName'), '') AS NVARCHAR(128))
    
    -- Construir JSON con toda la información recolectada
    SET @SessionInfo = '{' +
        '"Tipo":"SessionInfoSQL",' +
        '"Timestamp":"' + CONVERT(NVARCHAR(23), GETDATE(), 126) + '",' +
        '"SPID":' + CAST(@SPID AS NVARCHAR(10)) + ',' +
        '"ServerName":"' + @ServerName + '",' +
        '"DatabaseName":"' + @DatabaseName + '",' +
        '"LoginName":"' + @LoginName + '",' +
        '"UserName":"' + @UserName + '",' +
        '"DbUser":"' + @DbUser + '",' +
        '"HostName":"' + @HostName + '",' +
        '"AppName":"' + @AppName + '",' +
        '"ProgramName":"' + @ProgramName + '",' +
        '"ClientNetAddress":"' + @ClientNetAddress + '",' +
        '"LoginTime":"' + @LoginTime + '",' +
        '"CPU":' + @CPU + ',' +
        '"MemoryUsage":' + @MemoryUsage + ',' +
        '"Reads":' + @Reads + ',' +
        '"Writes":' + @Writes + ',' +
        '"ServerVersion":"' + @ServerVersion + '",' +
        '"ServerEdition":"' + @ServerEdition + '",' +
        '"ServerBuild":"' + @ServerBuild + '",' +
        '"Language":"' + @Language + '",' +
        '"IsClustered":' + @IsClustered + ',' +
        '"IsIntegratedSecurityOnly":' + @IsIntegratedSecurityOnly + ',' +
        '"MachineName":"' + @MachineName + '"}'
    
    RETURN @SessionInfo
END
GO

PRINT '✅ Función fnAuditoria_ObtenerSessionInfo creada exitosamente'
PRINT 'Esta función obtiene información completa de la sesión SQL actual'
PRINT 'Útil para borrados físicos donde no hay SessionInfo en tbLogSesionHdr'
GO
