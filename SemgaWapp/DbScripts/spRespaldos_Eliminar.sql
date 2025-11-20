-- =============================================
-- STORED PROCEDURE PARA ELIMINAR RESPALDO (SOFT DELETE)
-- =============================================

CREATE PROCEDURE [dbo].[spRespaldos_Eliminar]
    @ID INT,
    @UsuarioElimina INT = NULL,
    @EliminarFisicamente BIT = 0
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        -- Validar parámetros requeridos
        IF @ID IS NULL OR @ID <= 0
        BEGIN
            SELECT 'ERROR' AS Resultado, 'El ID del respaldo es requerido' AS Mensaje
            RETURN
        END
        
        -- Verificar que el respaldo existe
        IF NOT EXISTS (SELECT 1 FROM tbRespaldos WHERE ID = @ID)
        BEGIN
            SELECT 'ERROR' AS Resultado, 'El respaldo especificado no existe' AS Mensaje
            RETURN
        END
        
        -- Verificar que el respaldo no esté ya eliminado (si es soft delete)
        IF @EliminarFisicamente = 0 AND EXISTS (SELECT 1 FROM tbRespaldos WHERE ID = @ID AND SnEliminado = 1)
        BEGIN
            SELECT 'ERROR' AS Resultado, 'El respaldo ya está marcado como eliminado' AS Mensaje
            RETURN
        END
        
        IF @EliminarFisicamente = 1
        BEGIN
            -- Eliminación física del registro
            DELETE FROM tbRespaldos WHERE ID = @ID
            
            SELECT 'SUCCESS' AS Resultado, 'Respaldo eliminado físicamente exitosamente' AS Mensaje
        END
        ELSE
        BEGIN
            -- Soft delete - marcar como eliminado
            UPDATE tbRespaldos 
            SET 
                SnEliminado = 1,
                FechaModificacion = GETDATE()
            WHERE ID = @ID
            
            SELECT 'SUCCESS' AS Resultado, 'Respaldo marcado como eliminado exitosamente' AS Mensaje
        END
        
    END TRY
    BEGIN CATCH
        -- Retornar error en caso de excepción
        SELECT 'ERROR' AS Resultado, 'Error al eliminar el respaldo: ' + ERROR_MESSAGE() AS Mensaje
    END CATCH
END






