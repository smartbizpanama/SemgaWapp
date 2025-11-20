-- =============================================
-- STORED PROCEDURE PARA RESTAURAR RESPALDO (UNDO SOFT DELETE)
-- =============================================

CREATE PROCEDURE [dbo].[spRespaldos_Restaurar]
    @ID INT,
    @UsuarioRestaura INT = NULL
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
        
        -- Verificar que el respaldo esté eliminado
        IF NOT EXISTS (SELECT 1 FROM tbRespaldos WHERE ID = @ID AND SnEliminado = 1)
        BEGIN
            SELECT 'ERROR' AS Resultado, 'El respaldo no está marcado como eliminado' AS Mensaje
            RETURN
        END
        
        -- Restaurar el respaldo (desmarcar como eliminado)
        UPDATE tbRespaldos 
        SET 
            SnEliminado = 0,
            FechaModificacion = GETDATE()
        WHERE ID = @ID
        
        SELECT 'SUCCESS' AS Resultado, 'Respaldo restaurado exitosamente' AS Mensaje
        
    END TRY
    BEGIN CATCH
        -- Retornar error en caso de excepción
        SELECT 'ERROR' AS Resultado, 'Error al restaurar el respaldo: ' + ERROR_MESSAGE() AS Mensaje
    END CATCH
END






