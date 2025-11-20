-- =============================================
-- Script de prueba para la función fnAuditoria_ObtenerSessionInfo
-- =============================================

USE [SegmaDB]
GO

PRINT '==============================================='
PRINT 'Probando función fnAuditoria_ObtenerSessionInfo'
PRINT '==============================================='
PRINT ''

-- Ejecutar la función
DECLARE @Resultado NVARCHAR(MAX)
SET @Resultado = dbo.fnAuditoria_ObtenerSessionInfo()

PRINT 'Resultado de la función:'
PRINT ''
PRINT @Resultado
PRINT ''

-- Mostrar información formateada
PRINT 'Información extraída:'
PRINT '- SPID: ' + CAST(@@SPID AS VARCHAR(10))
PRINT '- ServerName: ' + @@SERVERNAME
PRINT '- DatabaseName: ' + DB_NAME()
PRINT '- HostName: ' + HOST_NAME()
PRINT '- LoginName: ' + SUSER_NAME()
PRINT '- AppName: ' + APP_NAME()
PRINT ''

PRINT '✅ Prueba completada'
GO














