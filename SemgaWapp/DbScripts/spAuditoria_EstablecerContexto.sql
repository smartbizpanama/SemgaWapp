-- =============================================
-- Stored Procedure para establecer contexto de usuario
-- Se debe llamar antes de cada operación de auditoría
-- =============================================

USE [SegmaDB]
GO

-- Crear stored procedure para establecer contexto
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spAuditoria_EstablecerContexto]') AND type in (N'P', N'PC'))
    DROP PROCEDURE [dbo].[spAuditoria_EstablecerContexto]
GO

CREATE PROCEDURE [dbo].[spAuditoria_EstablecerContexto]
    @UsuarioId INT
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Establecer el UsuarioId en el contexto para que el trigger lo pueda leer
    DECLARE @ContextInfo VARBINARY(128)
    SET @ContextInfo = CAST(@UsuarioId AS VARBINARY(128))
    SET CONTEXT_INFO @ContextInfo
    
    -- Log de la operación
    PRINT 'Contexto de auditoría establecido para UsuarioId: ' + CAST(@UsuarioId AS NVARCHAR(10))
END
GO

-- Crear stored procedure para limpiar contexto
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spAuditoria_LimpiarContexto]') AND type in (N'P', N'PC'))
    DROP PROCEDURE [dbo].[spAuditoria_LimpiarContexto]
GO

CREATE PROCEDURE [dbo].[spAuditoria_LimpiarContexto]
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Limpiar el contexto
    SET CONTEXT_INFO 0x00
    
    PRINT 'Contexto de auditoría limpiado'
END
GO

-- Crear función para obtener usuario actual del contexto
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fnAuditoria_ObtenerUsuarioActual]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
    DROP FUNCTION [dbo].[fnAuditoria_ObtenerUsuarioActual]
GO

CREATE FUNCTION [dbo].[fnAuditoria_ObtenerUsuarioActual]()
RETURNS INT
AS
BEGIN
    DECLARE @UsuarioId INT
    
    -- Leer el UsuarioId del contexto
    SET @UsuarioId = CAST(CONTEXT_INFO() AS INT)
    
    -- Si no hay contexto válido, retornar 0 (usuario sistema)
    IF @UsuarioId IS NULL OR @UsuarioId = 0
        SET @UsuarioId = 0
    
    RETURN @UsuarioId
END
GO

PRINT 'Stored Procedures de contexto creados exitosamente:'
PRINT '- spAuditoria_EstablecerContexto: Establece UsuarioId en contexto'
PRINT '- spAuditoria_LimpiarContexto: Limpia contexto'
PRINT '- fnAuditoria_ObtenerUsuarioActual: Obtiene UsuarioId del contexto'
GO

