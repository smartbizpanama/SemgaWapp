-- =============================================
-- Prueba simple del trigger mejorado
-- =============================================

USE [SegmaDB]
GO

PRINT '=== PRUEBA SIMPLE DEL TRIGGER MEJORADO ==='
PRINT ''

-- 1. Crear un asociado de prueba
PRINT '1. Creando asociado de prueba...'
INSERT INTO tbAsociados (
    IdTipoAsociado, Nombre, SegundoNombre, Apellido, SegundoApellido,
    Estatus, TipoIdentificacion, NumeroIdentificacion, TelefonoResidencia,
    TelefonoCelular, TelefonoFamiliar, CorreoElectronico, Sexo, FechaNacimiento,
    DireccionResidencia, DireccionTrabajo, NivelEstudio, Profesion,
    UsuarioCrea, FechaCreacion, snEliminado, LugarTrabajo, Ocupacion,
    PaisTrabajo, ProvinciaTrabajo, DistritoTrabajo, CorregimientoTrabajo,
    PaisResidencia, ProvinciaResidencia, DistritoResidencia, CorregimientoResidencia
) VALUES (
    1, 'María', 'Elena', 'Rodríguez', 'López',
    'A', 'C', '987654321', '555-1001',
    '555-1002', '555-1003', 'maria.rodriguez@test.com', 'F', '1985-05-15',
    'Calle Prueba 456', 'Avenida Test 789', 2, 2,
    1, GETDATE(), 0, 2, 2,
    'PA', 8, 47, 1,
    'PA', 8, 47, 1
)

DECLARE @NumeroAsociado INT = SCOPE_IDENTITY()
PRINT '   ✅ Asociado creado con ID: ' + CAST(@NumeroAsociado AS VARCHAR(10))
PRINT ''

-- 2. Actualizar el asociado
PRINT '2. Actualizando asociado...'
UPDATE tbAsociados 
SET Nombre = 'María Elena', 
    LugarTrabajo = 3,
    Ocupacion = 3,
    UsuarioModifica = 1,
    FechaModificacion = GETDATE()
WHERE NumeroAsociado = @NumeroAsociado

PRINT '   ✅ Asociado actualizado'
PRINT ''

-- 3. Verificar los logs de auditoría
PRINT '3. Verificando logs de auditoría...'
SELECT 
    Id,
    Operacion,
    CASE Operacion 
        WHEN 'I' THEN 'INSERT'
        WHEN 'U' THEN 'UPDATE'
        WHEN 'D' THEN 'SOFT DELETE'
        WHEN 'X' THEN 'DELETE FÍSICO'
    END as TipoOperacion,
    RegistroId,
    UsuarioId,
    FechaHora
FROM tbLogsAuditoria 
WHERE TablaAfectada = 'tbAsociados' 
    AND RegistroId = CAST(@NumeroAsociado AS VARCHAR(50))
ORDER BY FechaHora

PRINT '   ✅ Logs verificados'
PRINT ''

-- 4. Mostrar un ejemplo de JSON con descripciones
PRINT '4. Ejemplo de JSON con descripciones:'
SELECT TOP 1
    LEFT(JsonPosterior, 500) + '...' as JsonPosterior_Preview
FROM tbLogsAuditoria 
WHERE TablaAfectada = 'tbAsociados' 
    AND RegistroId = CAST(@NumeroAsociado AS VARCHAR(50))
    AND Operacion = 'I'

PRINT '   ✅ Ejemplo mostrado'
PRINT ''

-- 5. Limpiar datos de prueba
PRINT '5. Limpiando datos de prueba...'
DELETE FROM tbLogsAuditoria WHERE TablaAfectada = 'tbAsociados' AND RegistroId = CAST(@NumeroAsociado AS VARCHAR(50))
DELETE FROM tbAsociados WHERE NumeroAsociado = @NumeroAsociado

PRINT '   ✅ Datos de prueba eliminados'
PRINT ''

PRINT '=== PRUEBA COMPLETADA EXITOSAMENTE ==='
PRINT 'El trigger mejorado ahora incluye descripciones de IDs en formato "Descripción (ID)"'
GO

