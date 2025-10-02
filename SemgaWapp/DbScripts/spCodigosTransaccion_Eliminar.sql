-- =============================================
-- Author: Sistema SemgaWapp
-- Create date: 2024
-- Description: Eliminar código de transacción (soft delete)
-- =============================================
CREATE PROCEDURE [dbo].[spCodigosTransaccion_Eliminar]
    @ID INT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION;
        
        -- Variables para resultado
        DECLARE @Resultado VARCHAR(20) = 'SUCCESS'
        DECLARE @Mensaje VARCHAR(500) = ''
        
        -- Validar que existe
        IF NOT EXISTS (SELECT 1 FROM tbCodigosTransaccion WHERE ID = @ID AND SnEliminado = 0)
        BEGIN
            SET @Resultado = 'ERROR';
            SET @Mensaje = 'No se encontró el código de transacción para eliminar';
            ROLLBACK TRANSACTION;
            SELECT @Resultado AS Resultado, @Mensaje AS Mensaje;
            RETURN;
        END
        
        -- Verificar si está siendo usado en transacciones
        IF EXISTS (
            SELECT 1 FROM tbMovimientos 
            WHERE CodigoTransaccion IN (
                SELECT CodigoTransaccion FROM tbCodigosTransaccion WHERE ID = @ID
            )
        )
        BEGIN
            SET @Resultado = 'ERROR';
            SET @Mensaje = 'No se puede eliminar el código de transacción porque está siendo usado en movimientos';
            ROLLBACK TRANSACTION;
            SELECT @Resultado AS Resultado, @Mensaje AS Mensaje;
            RETURN;
        END
        
        -- Soft delete
        UPDATE tbCodigosTransaccion SET
            SnEliminado = 1,
            SnActivo = 0
        WHERE ID = @ID;
        
        SET @Resultado = 'SUCCESS';
        SET @Mensaje = 'Código de transacción eliminado correctamente';
        
        COMMIT TRANSACTION;
        
        -- Devolver resultado
        SELECT @Resultado AS Resultado, @Mensaje AS Mensaje;
        
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SELECT 'ERROR' AS Resultado, 'Error: ' + ERROR_MESSAGE() AS Mensaje;
    END CATCH
END
