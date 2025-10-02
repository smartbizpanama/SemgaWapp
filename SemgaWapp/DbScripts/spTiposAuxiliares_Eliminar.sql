CREATE PROCEDURE [dbo].[spTiposAuxiliares_Eliminar]
    @ID INT
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @Resultado VARCHAR(20) = 'ERROR';
    DECLARE @Mensaje VARCHAR(500) = '';
    
    BEGIN TRY
        -- Validar que existe
        IF NOT EXISTS (SELECT 1 FROM tbTiposAuxiliares WHERE ID = @ID AND snEliminado = 0)
        BEGIN
            SET @Mensaje = 'El tipo auxiliar no existe o ya fue eliminado';
            GOTO FINAL;
        END
        
        -- Soft delete
        UPDATE tbTiposAuxiliares 
        SET snEliminado = 1 
        WHERE ID = @ID;
        
        SET @Resultado = 'SUCCESS';
        SET @Mensaje = 'Tipo auxiliar eliminado exitosamente';
        
    END TRY
    BEGIN CATCH
        SET @Mensaje = 'Error en la base de datos: ' + ERROR_MESSAGE();
    END CATCH
    
    FINAL:
    SELECT @Resultado AS Resultado, @Mensaje AS Mensaje;
END

