-- =============================================
-- Author: Sistema SemgaWapp
-- Create date: 2024
-- Description: Eliminar estatus de asociado (soft delete)
-- =============================================
CREATE PROCEDURE [dbo].[spStatusAsociado_Eliminar]
    @IDStatus INT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION;
        
        -- Variables para resultado
        DECLARE @Resultado VARCHAR(20) = 'SUCCESS'
        DECLARE @Mensaje VARCHAR(500) = ''
        
        -- Validar que existe
        IF NOT EXISTS (SELECT 1 FROM tbStatusAsociado WHERE IDStatus = @IDStatus AND snEliminado = 0)
        BEGIN
            SET @Resultado = 'ERROR';
            SET @Mensaje = 'No se encontró el estatus para eliminar';
            ROLLBACK TRANSACTION;
            SELECT @Resultado AS Resultado, @Mensaje AS Mensaje;
            RETURN;
        END
        
        -- Verificar si está siendo usado en otras tablas (ejemplo: socios)
        -- IF EXISTS (
        --     SELECT 1 FROM tbSocios 
        --     WHERE StatusAsociado = (SELECT CodStatusAsociado FROM tbStatusAsociado WHERE IDStatus = @IDStatus)
        --         AND snEliminado = 0
        -- )
        -- BEGIN
        --     SET @Resultado = 'ERROR';
        --     SET @Mensaje = 'No se puede eliminar el estatus porque está siendo usado en socios';
        --     ROLLBACK TRANSACTION;
        --     SELECT @Resultado AS Resultado, @Mensaje AS Mensaje;
        --     RETURN;
        -- END
        
        -- Soft delete
        UPDATE tbStatusAsociado SET
            snEliminado = 1
        WHERE IDStatus = @IDStatus;
        
        SET @Resultado = 'SUCCESS';
        SET @Mensaje = 'Estatus eliminado correctamente';
        
        COMMIT TRANSACTION;
        
        -- Devolver resultado
        SELECT @Resultado AS Resultado, @Mensaje AS Mensaje;
        
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SELECT 'ERROR' AS Resultado, 'Error: ' + ERROR_MESSAGE() AS Mensaje;
    END CATCH
END


