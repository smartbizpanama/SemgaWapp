-- =============================================
-- STORED PROCEDURE PARA LIMPIAR RESPALDOS ANTIGUOS
-- =============================================

CREATE PROCEDURE [dbo].[spRespaldos_LimpiarAntiguos]
    @DiasAntiguedad INT = 30,
    @UsuarioEjecuta INT = NULL,
    @SoloEliminados BIT = 1
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        -- Validar parámetros
        IF @DiasAntiguedad IS NULL OR @DiasAntiguedad <= 0
        BEGIN
            SELECT 'ERROR' AS Resultado, 'Los días de antigüedad deben ser mayores a 0' AS Mensaje, 0 AS RegistrosEliminados
            RETURN
        END
        
        -- Calcular fecha límite
        DECLARE @FechaLimite DATETIME = DATEADD(DAY, -@DiasAntiguedad, GETDATE())
        
        DECLARE @RegistrosEliminados INT = 0
        
        IF @SoloEliminados = 1
        BEGIN
            -- Eliminar físicamente solo los respaldos marcados como eliminados y antiguos
            DELETE FROM tbRespaldos 
            WHERE SnEliminado = 1 
                AND FechaHora < @FechaLimite
            
            SET @RegistrosEliminados = @@ROWCOUNT
        END
        ELSE
        BEGIN
            -- Marcar como eliminados los respaldos antiguos (no eliminados previamente)
            UPDATE tbRespaldos 
            SET 
                SnEliminado = 1,
                FechaModificacion = GETDATE()
            WHERE SnEliminado = 0 
                AND FechaHora < @FechaLimite
            
            SET @RegistrosEliminados = @@ROWCOUNT
        END
        
        SELECT 
            'SUCCESS' AS Resultado, 
            CASE 
                WHEN @SoloEliminados = 1 THEN 'Respaldos antiguos eliminados físicamente exitosamente'
                ELSE 'Respaldos antiguos marcados como eliminados exitosamente'
            END AS Mensaje,
            @RegistrosEliminados AS RegistrosEliminados,
            @DiasAntiguedad AS DiasAntiguedad,
            @FechaLimite AS FechaLimite
        
    END TRY
    BEGIN CATCH
        -- Retornar error en caso de excepción
        SELECT 
            'ERROR' AS Resultado, 
            'Error al limpiar respaldos antiguos: ' + ERROR_MESSAGE() AS Mensaje,
            0 AS RegistrosEliminados
    END CATCH
END






