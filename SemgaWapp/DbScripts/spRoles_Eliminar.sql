-- =============================================
-- Author: Sistema SemgaWapp
-- Create date: 2024
-- Description: Eliminar rol (soft delete)
-- =============================================
CREATE PROCEDURE [dbo].[spRoles_Eliminar]
    @Id INT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION;
        
        -- Variables para resultado
        DECLARE @Resultado VARCHAR(20) = 'SUCCESS'
        DECLARE @Mensaje VARCHAR(500) = ''
        
        -- Validar que existe
        IF NOT EXISTS (SELECT 1 FROM tbRoles WHERE Id = @Id AND snEliminado = 0)
        BEGIN
            SET @Resultado = 'ERROR';
            SET @Mensaje = 'No se encontró el rol para eliminar';
            ROLLBACK TRANSACTION;
            SELECT @Resultado AS Resultado, @Mensaje AS Mensaje;
            RETURN;
        END
        
        -- Verificar si está siendo usado en otras tablas (ejemplo: usuarios)
        -- IF EXISTS (
        --     SELECT 1 FROM tbUsuarios 
        --     WHERE RolId = @Id AND snEliminado = 0
        -- )
        -- BEGIN
        --     SET @Resultado = 'ERROR';
        --     SET @Mensaje = 'No se puede eliminar el rol porque está siendo usado';
        --     ROLLBACK TRANSACTION;
        --     SELECT @Resultado AS Resultado, @Mensaje AS Mensaje;
        --     RETURN;
        -- END
        
        -- Soft delete
        UPDATE tbRoles SET
            snEliminado = 1,
            Activo = 0,
            FechaModificacion = GETDATE()
        WHERE Id = @Id;
        
        SET @Resultado = 'SUCCESS';
        SET @Mensaje = 'Rol eliminado correctamente';
        
        COMMIT TRANSACTION;
        
        -- Devolver resultado
        SELECT @Resultado AS Resultado, @Mensaje AS Mensaje;
        
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SELECT 'ERROR' AS Resultado, 'Error: ' + ERROR_MESSAGE() AS Mensaje;
    END CATCH
END


