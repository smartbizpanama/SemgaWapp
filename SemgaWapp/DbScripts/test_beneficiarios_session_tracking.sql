-- =============================================
-- SCRIPT DE PRUEBA PARA SESSION TRACKING EN BENEFICIARIOS
-- =============================================

USE [SegmaDB]
GO

PRINT '=== PRUEBA DE SESSION TRACKING EN BENEFICIARIOS ==='
PRINT ''

-- Verificar que los stored procedures tienen el parámetro @IdSession
PRINT '1. Verificando parámetros de los stored procedures...'

-- Verificar spBeneficiarios_CrearBeneficiario
IF EXISTS (SELECT 1 FROM sys.parameters WHERE object_id = OBJECT_ID('spBeneficiarios_CrearBeneficiario') AND name = '@IdSession')
    PRINT '✅ spBeneficiarios_CrearBeneficiario tiene parámetro @IdSession'
ELSE
    PRINT '❌ spBeneficiarios_CrearBeneficiario NO tiene parámetro @IdSession'

-- Verificar spBeneficiarios_ActualizarBeneficiario
IF EXISTS (SELECT 1 FROM sys.parameters WHERE object_id = OBJECT_ID('spBeneficiarios_ActualizarBeneficiario') AND name = '@IdSession')
    PRINT '✅ spBeneficiarios_ActualizarBeneficiario tiene parámetro @IdSession'
ELSE
    PRINT '❌ spBeneficiarios_ActualizarBeneficiario NO tiene parámetro @IdSession'

-- Verificar spBeneficiarios_EliminarBeneficiario
IF EXISTS (SELECT 1 FROM sys.parameters WHERE object_id = OBJECT_ID('spBeneficiarios_EliminarBeneficiario') AND name = '@IdSession')
    PRINT '✅ spBeneficiarios_EliminarBeneficiario tiene parámetro @IdSession'
ELSE
    PRINT '❌ spBeneficiarios_EliminarBeneficiario NO tiene parámetro @IdSession'

PRINT ''

-- Verificar que el campo SysLastSessionID existe en tbBeneficiarios
PRINT '2. Verificando campo SysLastSessionID en tbBeneficiarios...'
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'tbBeneficiarios' AND COLUMN_NAME = 'SysLastSessionID')
    PRINT '✅ Campo SysLastSessionID existe en tbBeneficiarios'
ELSE
    PRINT '❌ Campo SysLastSessionID NO existe en tbBeneficiarios'

PRINT ''

-- Probar crear un beneficiario con session tracking
PRINT '3. Probando creación de beneficiario con session tracking...'
DECLARE @TestSessionId NVARCHAR(50) = 'TEST_SESSION_' + FORMAT(GETDATE(), 'yyyyMMddHHmmss')
DECLARE @TestUsuario NVARCHAR(50) = '1'
DECLARE @TestNumeroAsociado INT = 1

BEGIN TRY
    EXEC spBeneficiarios_CrearBeneficiario
        @NumeroAsociado = @TestNumeroAsociado,
        @Nombre = 'Test',
        @Apellido = 'Beneficiario',
        @TipoIdentificacion = 'C',
        @NumeroIdentificacion = 'TEST123456789',
        @IDParentezco = 1,
        @Porcentaje = 50.00,
        @Usuario = @TestUsuario,
        @IdSession = @TestSessionId

    PRINT '✅ Beneficiario creado exitosamente con session tracking'
    
    -- Obtener el ID del beneficiario creado
    DECLARE @IDBeneficiario INT
    SELECT @IDBeneficiario = MAX(IDBeneficiario) 
    FROM tbBeneficiarios 
    WHERE NumeroAsociado = @TestNumeroAsociado
    
    -- Verificar que se guardó el session ID
    DECLARE @SessionIdGuardado NVARCHAR(50)
    SELECT @SessionIdGuardado = SysLastSessionID 
    FROM tbBeneficiarios 
    WHERE IDBeneficiario = @IDBeneficiario
    
    IF @SessionIdGuardado = @TestSessionId
        PRINT '✅ Session ID guardado correctamente: ' + @SessionIdGuardado
    ELSE
        PRINT '❌ Session ID NO se guardó correctamente. Esperado: ' + @TestSessionId + ', Actual: ' + ISNULL(@SessionIdGuardado, 'NULL')
    
    -- Probar actualizar el beneficiario
    PRINT ''
    PRINT '4. Probando actualización de beneficiario...'
    
    DECLARE @TestSessionIdUpdated NVARCHAR(50) = @TestSessionId + N'_UPDATED'
    
    EXEC spBeneficiarios_ActualizarBeneficiario
        @IDBeneficiario = @IDBeneficiario,
        @Nombre = 'Test Actualizado',
        @Apellido = 'Beneficiario Actualizado',
        @TipoIdentificacion = 'C',
        @NumeroIdentificacion = 'TEST123456789',
        @IDParentezco = 1,
        @Porcentaje = 60.00,
        @Usuario = @TestUsuario,
        @IdSession = @TestSessionIdUpdated
    
    PRINT '✅ Beneficiario actualizado exitosamente'
    
    -- Verificar que se actualizó el session ID
    SELECT @SessionIdGuardado = SysLastSessionID 
    FROM tbBeneficiarios 
    WHERE IDBeneficiario = @IDBeneficiario
    
    IF @SessionIdGuardado = @TestSessionIdUpdated
        PRINT '✅ Session ID actualizado correctamente: ' + @SessionIdGuardado
    ELSE
        PRINT '❌ Session ID NO se actualizó correctamente'
    
    -- Probar eliminar el beneficiario
    PRINT ''
    PRINT '5. Probando eliminación de beneficiario...'
    
    DECLARE @TestSessionIdDeleted NVARCHAR(50) = @TestSessionId + N'_DELETED'
    
    EXEC spBeneficiarios_EliminarBeneficiario
        @IDBeneficiario = @IDBeneficiario,
        @Usuario = @TestUsuario,
        @IdSession = @TestSessionIdDeleted
    
    PRINT '✅ Beneficiario eliminado exitosamente'
    
    -- Verificar que se actualizó el session ID en la eliminación
    SELECT @SessionIdGuardado = SysLastSessionID 
    FROM tbBeneficiarios 
    WHERE IDBeneficiario = @IDBeneficiario
    
    IF @SessionIdGuardado = @TestSessionIdDeleted
        PRINT '✅ Session ID de eliminación guardado correctamente: ' + @SessionIdGuardado
    ELSE
        PRINT '❌ Session ID de eliminación NO se guardó correctamente'
    
    -- Limpiar datos de prueba
    DELETE FROM tbBeneficiarios WHERE IDBeneficiario = @IDBeneficiario
    PRINT '✅ Datos de prueba limpiados'
    
END TRY
BEGIN CATCH
    PRINT '❌ Error en la prueba: ' + ERROR_MESSAGE()
END CATCH

PRINT ''
PRINT '=== PRUEBA COMPLETADA ==='
GO

