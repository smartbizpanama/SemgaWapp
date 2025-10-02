-- =============================================
-- Author: Sistema SemgaWapp
-- Create date: 2024
-- Description: Eliminar rubro (soft delete)
-- =============================================
CREATE PROCEDURE [dbo].[spRubros_Eliminar]
    @IDRubro INT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION;
        
        -- Variables para resultado
        DECLARE @Resultado VARCHAR(20) = 'SUCCESS'
        DECLARE @Mensaje VARCHAR(500) = ''
        
        -- Validar que existe
        IF NOT EXISTS (SELECT 1 FROM tbRubros WHERE IDRubro = @IDRubro AND snEliminado = 0)
        BEGIN
            SET @Resultado = 'ERROR';
            SET @Mensaje = 'No se encontró el rubro para eliminar';
            ROLLBACK TRANSACTION;
            SELECT @Resultado AS Resultado, @Mensaje AS Mensaje;
            RETURN;
        END
        
        -- Verificar si está siendo usado en otras tablas (ejemplo: códigos de transacción)
        IF EXISTS (
            SELECT 1 FROM tbCodigosTransaccion 
            WHERE CodigoRubro = (SELECT CodigoRubro FROM tbRubros WHERE IDRubro = @IDRubro)
                AND snEliminado = 0
        )
        BEGIN
            SET @Resultado = 'ERROR';
            SET @Mensaje = 'No se puede eliminar el rubro porque está siendo usado en códigos de transacción';
            ROLLBACK TRANSACTION;
            SELECT @Resultado AS Resultado, @Mensaje AS Mensaje;
            RETURN;
        END
        
        -- Soft delete
        UPDATE tbRubros SET
            snEliminado = 1
        WHERE IDRubro = @IDRubro;
        
        SET @Resultado = 'SUCCESS';
        SET @Mensaje = 'Rubro eliminado correctamente';
        
        COMMIT TRANSACTION;
        
        -- Devolver resultado
        SELECT @Resultado AS Resultado, @Mensaje AS Mensaje;
        
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SELECT 'ERROR' AS Resultado, 'Error: ' + ERROR_MESSAGE() AS Mensaje;
    END CATCH
END


