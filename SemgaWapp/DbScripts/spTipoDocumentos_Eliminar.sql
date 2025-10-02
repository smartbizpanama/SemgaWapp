-- =============================================
-- Author: Sistema SemgaWapp
-- Create date: 2024
-- Description: Eliminar tipo de documento (soft delete)
-- =============================================
CREATE PROCEDURE [dbo].[spTipoDocumentos_Eliminar]
    @IDTipoDoc INT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION;
        
        -- Variables para resultado
        DECLARE @Resultado VARCHAR(20) = 'SUCCESS'
        DECLARE @Mensaje VARCHAR(500) = ''
        
        -- Validar que existe
        IF NOT EXISTS (SELECT 1 FROM tbTipoDocumentos WHERE IDTipoDoc = @IDTipoDoc AND snEliminado = 0)
        BEGIN
            SET @Resultado = 'ERROR';
            SET @Mensaje = 'No se encontró el tipo de documento para eliminar';
            ROLLBACK TRANSACTION;
            SELECT @Resultado AS Resultado, @Mensaje AS Mensaje;
            RETURN;
        END
        
        -- Verificar si está siendo usado en otras tablas (ejemplo: socios)
        -- IF EXISTS (
        --     SELECT 1 FROM tbSocios 
        --     WHERE TipoDocumento = (SELECT CodTipoDoc FROM tbTipoDocumentos WHERE IDTipoDoc = @IDTipoDoc)
        --         AND snEliminado = 0
        -- )
        -- BEGIN
        --     SET @Resultado = 'ERROR';
        --     SET @Mensaje = 'No se puede eliminar el tipo de documento porque está siendo usado en socios';
        --     ROLLBACK TRANSACTION;
        --     SELECT @Resultado AS Resultado, @Mensaje AS Mensaje;
        --     RETURN;
        -- END
        
        -- Soft delete
        UPDATE tbTipoDocumentos SET
            snEliminado = 1
        WHERE IDTipoDoc = @IDTipoDoc;
        
        SET @Resultado = 'SUCCESS';
        SET @Mensaje = 'Tipo de documento eliminado correctamente';
        
        COMMIT TRANSACTION;
        
        -- Devolver resultado
        SELECT @Resultado AS Resultado, @Mensaje AS Mensaje;
        
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SELECT 'ERROR' AS Resultado, 'Error: ' + ERROR_MESSAGE() AS Mensaje;
    END CATCH
END


