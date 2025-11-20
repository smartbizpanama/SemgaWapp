-- =============================================
-- SCRIPT DE PRUEBA FINAL PARA WEBMETHODS CORREGIDOS
-- =============================================

USE [SegmaDB]
GO

PRINT '=== PRUEBA FINAL DE WEBMETHODS CORREGIDOS ==='
PRINT ''

-- Probar crear un socio
PRINT '1. Probando creación de socio...'
DECLARE @TestSessionId NVARCHAR(50) = 'TEST_SESSION_' + FORMAT(GETDATE(), 'yyyyMMddHHmmss')
DECLARE @TestIdentificacion NVARCHAR(50) = 'TEST_' + FORMAT(GETDATE(), 'yyyyMMddHHmmss')
DECLARE @TestUsuario NVARCHAR(50) = 'TEST_USER'

BEGIN TRY
    CREATE TABLE #TempResult (NumeroAsociado INT)
    
    INSERT INTO #TempResult
    EXEC spGestionSocios_CrearSocio
        @IdTipoAsociado = 1,
        @Nombre = 'Test',
        @Apellido = 'WebMethod',
        @TipoIdentificacion = 'C',
        @NumeroIdentificacion = @TestIdentificacion,
        @Usuario = @TestUsuario,
        @IdSession = @TestSessionId

    PRINT '✅ Socio creado exitosamente'
    
    DECLARE @NumeroAsociado INT
    SELECT @NumeroAsociado = NumeroAsociado FROM #TempResult
    
    -- Verificar que se guardó el session ID
    DECLARE @SessionIdGuardado NVARCHAR(50)
    SELECT @SessionIdGuardado = SysLastSessionID 
    FROM tbAsociados 
    WHERE NumeroAsociado = @NumeroAsociado
    
    IF @SessionIdGuardado = @TestSessionId
        PRINT '✅ Session ID guardado correctamente: ' + @SessionIdGuardado
    ELSE
        PRINT '❌ Session ID NO se guardó correctamente'
    
    -- Probar actualizar el socio
    PRINT ''
    PRINT '2. Probando actualización de socio...'
    
    DECLARE @TestSessionIdUpdated NVARCHAR(50) = @TestSessionId + N'_UPDATED'
    
    EXEC spGestionSocios_ActualizarSocio
        @NumeroAsociado = @NumeroAsociado,
        @Nombre = 'Test Actualizado',
        @Usuario = @TestUsuario,
        @IdSession = @TestSessionIdUpdated
    
    PRINT '✅ Socio actualizado exitosamente'
    
    -- Verificar que se actualizó el session ID
    SELECT @SessionIdGuardado = SysLastSessionID 
    FROM tbAsociados 
    WHERE NumeroAsociado = @NumeroAsociado
    
    IF @SessionIdGuardado = @TestSessionIdUpdated
        PRINT '✅ Session ID actualizado correctamente: ' + @SessionIdGuardado
    ELSE
        PRINT '❌ Session ID NO se actualizó correctamente'
    
    -- Probar eliminar el socio
    PRINT ''
    PRINT '3. Probando eliminación de socio...'
    
    DECLARE @UsuarioElimina INT = 1
    DECLARE @TestSessionIdDeleted NVARCHAR(50) = @TestSessionId + N'_DELETED'
    
    EXEC spGestionSocios_EliminarAsociado
        @NumeroAsociado = @NumeroAsociado,
        @UsuarioElimina = @UsuarioElimina,
        @IdSession = @TestSessionIdDeleted
    
    PRINT '✅ Socio eliminado exitosamente'
    
    -- Verificar que se actualizó el session ID en la eliminación
    SELECT @SessionIdGuardado = SysLastSessionID 
    FROM tbAsociados 
    WHERE NumeroAsociado = @NumeroAsociado
    
    IF @SessionIdGuardado = @TestSessionIdDeleted
        PRINT '✅ Session ID de eliminación guardado correctamente: ' + @SessionIdGuardado
    ELSE
        PRINT '❌ Session ID de eliminación NO se guardó correctamente'
    
    -- Limpiar datos de prueba
    DELETE FROM tbAsociados WHERE NumeroAsociado = @NumeroAsociado
    PRINT '✅ Datos de prueba limpiados'
    
    DROP TABLE #TempResult
    
END TRY
BEGIN CATCH
    PRINT '❌ Error en la prueba: ' + ERROR_MESSAGE()
    IF OBJECT_ID('tempdb..#TempResult') IS NOT NULL
        DROP TABLE #TempResult
END CATCH

PRINT ''
PRINT '=== PRUEBA COMPLETADA ==='
GO
