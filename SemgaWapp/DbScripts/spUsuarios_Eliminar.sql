CREATE PROCEDURE [dbo].[spUsuarios_Eliminar]
    @ID INT
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @Resultado VARCHAR(20) = 'ERROR';
    DECLARE @Mensaje VARCHAR(500) = '';
    
    BEGIN TRY
        -- Verificar que el usuario existe
        IF NOT EXISTS (SELECT 1 FROM tbUsuarios WHERE Id = @ID AND snEliminado = 0)
        BEGIN
            SET @Mensaje = 'El usuario no existe';
            GOTO FINAL;
        END
        
        -- Verificar que no sea el último usuario del sistema
        IF (SELECT COUNT(*) FROM tbUsuarios WHERE snEliminado = 0) <= 1
        BEGIN
            SET @Mensaje = 'No se puede eliminar el último usuario del sistema';
            GOTO FINAL;
        END
        
        -- Soft delete
        UPDATE tbUsuarios SET
            snEliminado = 1,
            FechaModificacion = GETDATE(),
            ModificadoPor = NULL
        WHERE Id = @ID;
        
        SET @Resultado = 'SUCCESS';
        SET @Mensaje = 'Usuario eliminado exitosamente';
        
    END TRY
    BEGIN CATCH
        SET @Mensaje = 'Error en la base de datos: ' + ERROR_MESSAGE();
    END CATCH
    
    FINAL:
    SELECT @Resultado AS Resultado, @Mensaje AS Mensaje;
END

