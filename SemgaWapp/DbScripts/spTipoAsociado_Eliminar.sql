-- =============================================
-- Author: Sistema SemgaWapp
-- Create date: 2024
-- Description: Eliminar tipo de asociado (soft delete)
-- =============================================
CREATE PROCEDURE [dbo].[spTipoAsociado_Eliminar]
    @IdTipoAsociado INT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION;
        
        -- Variables para resultado
        DECLARE @Resultado VARCHAR(20) = 'SUCCESS'
        DECLARE @Mensaje VARCHAR(500) = ''
        
        -- Validar que existe
        IF NOT EXISTS (SELECT 1 FROM tbTipoAsociado WHERE IdTipoAsociado = @IdTipoAsociado AND snEliminado = 0)
        BEGIN
            SET @Resultado = 'ERROR';
            SET @Mensaje = 'No se encontró el tipo de asociado para eliminar';
            ROLLBACK TRANSACTION;
            SELECT @Resultado AS Resultado, @Mensaje AS Mensaje;
            RETURN;
        END
        
        -- Verificar si está siendo usado en otras tablas (ejemplo: socios)
        -- IF EXISTS (
        --     SELECT 1 FROM tbSocios 
        --     WHERE TipoAsociado = (SELECT CodTipoAsociado FROM tbTipoAsociado WHERE IdTipoAsociado = @IdTipoAsociado)
        --         AND snEliminado = 0
        -- )
        -- BEGIN
        --     SET @Resultado = 'ERROR';
        --     SET @Mensaje = 'No se puede eliminar el tipo de asociado porque está siendo usado en socios';
        --     ROLLBACK TRANSACTION;
        --     SELECT @Resultado AS Resultado, @Mensaje AS Mensaje;
        --     RETURN;
        -- END
        
        -- Soft delete
        UPDATE tbTipoAsociado SET
            snEliminado = 1
        WHERE IdTipoAsociado = @IdTipoAsociado;
        
        SET @Resultado = 'SUCCESS';
        SET @Mensaje = 'Tipo de asociado eliminado correctamente';
        
        COMMIT TRANSACTION;
        
        -- Devolver resultado
        SELECT @Resultado AS Resultado, @Mensaje AS Mensaje;
        
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SELECT 'ERROR' AS Resultado, 'Error: ' + ERROR_MESSAGE() AS Mensaje;
    END CATCH
END


