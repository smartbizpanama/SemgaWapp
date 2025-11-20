-- =============================================
-- SCRIPT DE PRUEBA PARA SESSION TRACKING
-- =============================================

USE [SegmaDB]
GO

PRINT '=== PRUEBA DE SESSION TRACKING EN ASOCIADOS ==='
PRINT ''

-- Verificar que los stored procedures tienen el parámetro @IdSession
PRINT '1. Verificando parámetros de los stored procedures...'

-- Verificar spGestionSocios_CrearSocio
IF EXISTS (SELECT 1 FROM sys.parameters WHERE object_id = OBJECT_ID('spGestionSocios_CrearSocio') AND name = '@IdSession')
    PRINT '✅ spGestionSocios_CrearSocio tiene parámetro @IdSession'
ELSE
    PRINT '❌ spGestionSocios_CrearSocio NO tiene parámetro @IdSession'

-- Verificar spGestionSocios_ActualizarSocio
IF EXISTS (SELECT 1 FROM sys.parameters WHERE object_id = OBJECT_ID('spGestionSocios_ActualizarSocio') AND name = '@IdSession')
    PRINT '✅ spGestionSocios_ActualizarSocio tiene parámetro @IdSession'
ELSE
    PRINT '❌ spGestionSocios_ActualizarSocio NO tiene parámetro @IdSession'

-- Verificar spGestionSocios_EliminarAsociado
IF EXISTS (SELECT 1 FROM sys.parameters WHERE object_id = OBJECT_ID('spGestionSocios_EliminarAsociado') AND name = '@IdSession')
    PRINT '✅ spGestionSocios_EliminarAsociado tiene parámetro @IdSession'
ELSE
    PRINT '❌ spGestionSocios_EliminarAsociado NO tiene parámetro @IdSession'

PRINT ''

-- Verificar que el campo SysLastSessionID existe en tbAsociados
PRINT '2. Verificando campo SysLastSessionID en tbAsociados...'
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'tbAsociados' AND COLUMN_NAME = 'SysLastSessionID')
    PRINT '✅ Campo SysLastSessionID existe en tbAsociados'
ELSE
    PRINT '❌ Campo SysLastSessionID NO existe en tbAsociados'

PRINT ''

-- Probar crear un socio con session tracking
PRINT '3. Probando creación de socio con session tracking...'
DECLARE @TestSessionId NVARCHAR(50) = 'TEST_SESSION_' + FORMAT(GETDATE(), 'yyyyMMddHHmmss')
DECLARE @TestIdentificacion NVARCHAR(50) = 'TEST_' + FORMAT(GETDATE(), 'yyyyMMddHHmmss')
DECLARE @TestUsuario INT = 1

BEGIN TRY
    -- Crear tabla temporal para capturar el resultado
    CREATE TABLE #TempResult (NumeroAsociado INT)
    
    INSERT INTO #TempResult
    EXEC spGestionSocios_CrearSocio
        @IdTipoAsociado = 1,
        @Nombre = 'Test',
        @Apellido = 'Session',
        @TipoIdentificacion = 'C',
        @NumeroIdentificacion = @TestIdentificacion,
        @Usuario = @TestUsuario,
        @IdSession = @TestSessionId

    PRINT '✅ Socio creado exitosamente con session tracking'
    
    -- Obtener el número de asociado del resultado
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
        PRINT '❌ Session ID NO se guardó correctamente. Esperado: ' + @TestSessionId + ', Actual: ' + ISNULL(@SessionIdGuardado, 'NULL')
    
    -- Limpiar datos de prueba
    DELETE FROM tbAsociados WHERE NumeroAsociado = @NumeroAsociado
    PRINT '✅ Datos de prueba limpiados'
    
    -- Limpiar tabla temporal
    DROP TABLE #TempResult
    
END TRY
BEGIN CATCH
    PRINT '❌ Error al probar creación: ' + ERROR_MESSAGE()
END CATCH

PRINT ''
PRINT '=== PRUEBA COMPLETADA ==='
GO
