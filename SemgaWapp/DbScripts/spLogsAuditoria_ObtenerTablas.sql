-- =============================================
-- Stored Procedure para obtener tablas del sistema
-- Para el dropdown de filtros
-- =============================================

USE [SegmaDB]
GO

-- Eliminar SP si existe
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spLogsAuditoria_ObtenerTablas]') AND type in (N'P', N'PC'))
    DROP PROCEDURE [dbo].[spLogsAuditoria_ObtenerTablas]
GO

CREATE PROCEDURE [dbo].[spLogsAuditoria_ObtenerTablas]
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        SELECT DISTINCT
            ts.Tabla,
            ts.NombreDescriptivo,
            COUNT(la.Id) as CantidadLogs
        FROM tbTablasSistema ts
        LEFT JOIN tbLogsAuditoria la ON ts.Tabla = la.TablaAfectada
        GROUP BY ts.Tabla, ts.NombreDescriptivo
        ORDER BY ts.NombreDescriptivo
        
    END TRY
    BEGIN CATCH
        DECLARE @Mensaje NVARCHAR(2048);
        SET @Mensaje = ERROR_MESSAGE();
        THROW 50001, @Mensaje, 1;
    END CATCH
END
GO

PRINT 'Stored Procedure spLogsAuditoria_ObtenerTablas creado exitosamente'
PRINT 'Incluye: Cantidad de logs por tabla'
GO

