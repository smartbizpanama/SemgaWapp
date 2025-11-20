USE [SegmaDB]
GO

-- Eliminar el stored procedure existente si existe
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'spAuxiliares_EliminarAuxiliar_ConAuditoria')
    DROP PROCEDURE [dbo].[spAuxiliares_EliminarAuxiliar_ConAuditoria]
GO

-- Crear el stored procedure corregido
CREATE PROCEDURE [dbo].[spAuxiliares_EliminarAuxiliar_ConAuditoria]
    @ID INT,
    @NumeroAsociado INT,
    @UsuarioElimina NVARCHAR(50),
    @EquipoElimina NVARCHAR(MAX)
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        -- Verificar que el auxiliar existe y pertenece al asociado
        IF NOT EXISTS (
            SELECT 1 
            FROM tbAuxiliares 
            WHERE ID = @ID 
            AND NumeroAsociado = @NumeroAsociado 
            AND snEliminado = 0
        )
        BEGIN
            RAISERROR('El auxiliar no existe o no pertenece al asociado especificado', 16, 1);
            RETURN;
        END
        
        -- Actualizar el auxiliar con eliminacion logica y auditoria
        UPDATE tbAuxiliares 
        SET 
            snEliminado = 1,
            FechaModificacion = GETDATE(),
            UsuarioModifica = @UsuarioElimina,
            UsuarioElimina = @UsuarioElimina,
            FechaElimina = GETDATE(),
            EquipoElimina = @EquipoElimina
        WHERE 
            ID = @ID 
            AND NumeroAsociado = @NumeroAsociado 
            AND snEliminado = 0;
        
        -- Verificar que se actualizo correctamente
        IF @@ROWCOUNT = 0
        BEGIN
            RAISERROR('No se pudo eliminar el auxiliar', 16, 1);
            RETURN;
        END
        
        -- Retornar exito
        SELECT 'Auxiliar eliminado correctamente' AS Mensaje;
        
    END TRY
    BEGIN CATCH
        DECLARE @Mensaje NVARCHAR(2048);
        SET @Mensaje = ERROR_MESSAGE();
        RAISERROR(@Mensaje, 16, 1);
    END CATCH
END
GO

