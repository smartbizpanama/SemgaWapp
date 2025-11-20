-- =============================================
-- Stored Procedure para Eliminar Asociado
-- Valida que no tenga auxiliares antes de eliminar
-- =============================================

USE [SegmaDB]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spGestionSocios_EliminarAsociado]') AND type in (N'P', N'PC'))
    DROP PROCEDURE [dbo].[spGestionSocios_EliminarAsociado]
GO

CREATE PROCEDURE [dbo].[spGestionSocios_EliminarAsociado]
    @NumeroAsociado INT,
    @UsuarioElimina INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -- Validar que el asociado existe
        IF NOT EXISTS (SELECT 1 FROM tbAsociados WHERE NumeroAsociado = @NumeroAsociado)
        BEGIN
            RAISERROR('El asociado con número %d no existe', 16, 1, @NumeroAsociado);
            RETURN;
        END
        
        -- Validar que el asociado no esté ya eliminado
        IF EXISTS (SELECT 1 FROM tbAsociados WHERE NumeroAsociado = @NumeroAsociado AND snEliminado = 1)
        BEGIN
            RAISERROR('El asociado con número %d ya está eliminado', 16, 1, @NumeroAsociado);
            RETURN;
        END
        
        -- Validar que el asociado no tenga auxiliares activos
        DECLARE @CantidadAuxiliares INT;
        SELECT @CantidadAuxiliares = COUNT(*)
        FROM tbAuxiliares 
        WHERE NumeroAsociado = @NumeroAsociado 
        AND snEliminado = 0;
        
        IF @CantidadAuxiliares > 0
        BEGIN
            RAISERROR('No se puede eliminar el asociado %d porque tiene %d auxiliar(es) activo(s). Debe eliminar primero los auxiliares.', 16, 1, @NumeroAsociado, @CantidadAuxiliares);
            RETURN;
        END
        
        -- Validar que el asociado no tenga beneficiarios
        DECLARE @CantidadBeneficiarios INT;
        SELECT @CantidadBeneficiarios = COUNT(*)
        FROM tbBeneficiarios 
        WHERE NumeroAsociado = @NumeroAsociado 
        AND snEliminado = 0;
        
        IF @CantidadBeneficiarios > 0
        BEGIN
            RAISERROR('No se puede eliminar el asociado %d porque tiene %d beneficiario(s) activo(s). Debe eliminar primero los beneficiarios.', 16, 1, @NumeroAsociado, @CantidadBeneficiarios);
            RETURN;
        END
        
        -- Obtener información del asociado antes de eliminar (para auditoría)
        DECLARE @NombreCompleto NVARCHAR(200);
        SELECT @NombreCompleto = ISNULL(Nombre, '') + ' ' + ISNULL(Apellido, '')
        FROM tbAsociados 
        WHERE NumeroAsociado = @NumeroAsociado;
        
        -- Realizar soft delete del asociado
        UPDATE tbAsociados 
        SET 
            snEliminado = 1,
            FechaModificacion = GETDATE(),
            UsuarioModifica = @UsuarioElimina
        WHERE NumeroAsociado = @NumeroAsociado;
        
        -- Verificar que la eliminación fue exitosa
        IF @@ROWCOUNT = 0
        BEGIN
            RAISERROR('Error al eliminar el asociado %d', 16, 1, @NumeroAsociado);
            RETURN;
        END
        
        -- Retornar éxito
        SELECT 
            'SUCCESS' AS Resultado,
            'Asociado eliminado exitosamente' AS Mensaje,
            @NumeroAsociado AS NumeroAsociado,
            @NombreCompleto AS NombreCompleto,
            @UsuarioElimina AS UsuarioElimina,
            GETDATE() AS FechaEliminacion;
            
    END TRY
    BEGIN CATCH
        DECLARE @Mensaje NVARCHAR(2048);
        SET @Mensaje = ERROR_MESSAGE();
        
        -- Retornar error
        SELECT 
            'ERROR' AS Resultado,
            @Mensaje AS Mensaje,
            @NumeroAsociado AS NumeroAsociado,
            NULL AS NombreCompleto,
            @UsuarioElimina AS UsuarioElimina,
            NULL AS FechaEliminacion;
    END CATCH
END
GO

PRINT 'Stored Procedure spGestionSocios_EliminarAsociado creado exitosamente'
PRINT 'Validaciones:'
PRINT '- Asociado existe'
PRINT '- Asociado no está ya eliminado'
PRINT '- No tiene auxiliares activos'
PRINT '- No tiene beneficiarios activos'
PRINT 'Acción: Soft delete con UsuarioElimina y FechaEliminacion'
GO

