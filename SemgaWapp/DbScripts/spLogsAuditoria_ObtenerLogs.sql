-- =============================================
-- Stored Procedure para obtener logs de auditoría
-- Con filtros por tabla, usuario, operación y fecha
-- =============================================

USE [SegmaDB]
GO

-- Eliminar SP si existe
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spLogsAuditoria_ObtenerLogs]') AND type in (N'P', N'PC'))
    DROP PROCEDURE [dbo].[spLogsAuditoria_ObtenerLogs]
GO

CREATE PROCEDURE [dbo].[spLogsAuditoria_ObtenerLogs]
    @Tabla NVARCHAR(50) = NULL,
    @Usuario NVARCHAR(100) = NULL,
    @Operacion CHAR(1) = NULL,
    @FechaDesde DATE = NULL,
    @FechaHasta DATE = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        SELECT 
            la.Id,
            ISNULL(ts.NombreDescriptivo, la.TablaAfectada) as TablaDescriptiva,
            CASE 
                WHEN la.Operacion = 'I' THEN 'Crear'
                WHEN la.Operacion = 'U' THEN 'Actualizar'
                WHEN la.Operacion = 'D' THEN 'Eliminar (Soft)'
                WHEN la.Operacion = 'X' THEN 'Eliminar (Físico)'
                ELSE la.Operacion
            END as TipoOperacion,
            la.Operacion as CodigoOperacion,
            la.RegistroId,
            ISNULL(u.Usuario, 'Sistema') as Usuario,
            ISNULL(u.Nombre + ' ' + u.Apellido, 'Usuario ' + CAST(la.UsuarioId AS NVARCHAR(10))) as NombreCompleto,
            CONVERT(DATE, la.FechaHora) as Fecha,
            CONVERT(TIME, la.FechaHora) as Hora,
            la.FechaHora as FechaHoraCompleta,
            la.Comentarios,
            la.JsonPrevio,
            la.JsonPosterior,
            la.ServidorInfo
        FROM tbLogsAuditoria la
        LEFT JOIN tbTablasSistema ts ON la.TablaAfectada = ts.Tabla
        LEFT JOIN tbUsuarios u ON la.UsuarioId = u.Id
        WHERE 1=1
            AND (@Tabla IS NULL OR ts.NombreDescriptivo LIKE '%' + @Tabla + '%' OR la.TablaAfectada LIKE '%' + @Tabla + '%')
            AND (@Usuario IS NULL OR u.Usuario LIKE '%' + @Usuario + '%' OR (u.Nombre + ' ' + u.Apellido) LIKE '%' + @Usuario + '%')
            AND (@Operacion IS NULL OR la.Operacion = @Operacion)
            AND (@FechaDesde IS NULL OR CONVERT(DATE, la.FechaHora) >= @FechaDesde)
            AND (@FechaHasta IS NULL OR CONVERT(DATE, la.FechaHora) <= @FechaHasta)
        ORDER BY la.FechaHora DESC
        
    END TRY
    BEGIN CATCH
        DECLARE @Mensaje NVARCHAR(2048);
        SET @Mensaje = ERROR_MESSAGE();
        THROW 50001, @Mensaje, 1;
    END CATCH
END
GO

PRINT 'Stored Procedure spLogsAuditoria_ObtenerLogs creado exitosamente'
PRINT 'Filtros: Tabla, Usuario, Operación, Fecha Desde, Fecha Hasta'
PRINT 'Incluye: Relación con tbTablasSistema y tbUsuarios'
GO

