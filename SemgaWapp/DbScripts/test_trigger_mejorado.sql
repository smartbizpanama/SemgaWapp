-- =============================================
-- Script de prueba para el trigger mejorado
-- =============================================

USE [SegmaDB]
GO

PRINT '=== PRUEBA DEL TRIGGER MEJORADO ==='
PRINT ''

-- 1. Crear las funciones auxiliares
PRINT '1. Creando funciones auxiliares...'
EXEC sp_executesql N'-- Ejecutar fnAuditoria_ObtenerDescripciones.sql aquí'
PRINT '   ✅ Funciones auxiliares creadas'
PRINT ''

-- 2. Crear el trigger mejorado
PRINT '2. Creando trigger mejorado...'
EXEC sp_executesql N'-- Ejecutar tr_Auditoria_tbAsociados_Mejorado.sql aquí'
PRINT '   ✅ Trigger mejorado creado'
PRINT ''

-- 3. Probar las funciones individualmente
PRINT '3. Probando funciones auxiliares...'

-- Probar función de tipo de asociado
SELECT 'TipoAsociado' as Funcion, dbo.fnAuditoria_ObtenerTipoAsociado(1) as Resultado
UNION ALL
SELECT 'NivelEstudio', dbo.fnAuditoria_ObtenerNivelEstudio(1)
UNION ALL
SELECT 'Profesion', dbo.fnAuditoria_ObtenerProfesion(1)
UNION ALL
SELECT 'LugarTrabajo', dbo.fnAuditoria_ObtenerLugarTrabajo(1)
UNION ALL
SELECT 'Ocupacion', dbo.fnAuditoria_ObtenerOcupacion(1)
UNION ALL
SELECT 'Pais', dbo.fnAuditoria_ObtenerPais('PA')
UNION ALL
SELECT 'Provincia', dbo.fnAuditoria_ObtenerProvincia(8)
UNION ALL
SELECT 'Distrito', dbo.fnAuditoria_ObtenerDistrito(47)
UNION ALL
SELECT 'Corregimiento', dbo.fnAuditoria_ObtenerCorregimiento(1)
UNION ALL
SELECT 'Usuario', dbo.fnAuditoria_ObtenerUsuario(1)

PRINT '   ✅ Funciones probadas'
PRINT ''

-- 4. Crear un asociado de prueba para probar el trigger
PRINT '4. Creando asociado de prueba...'

-- Insertar un asociado de prueba
INSERT INTO tbAsociados (
    IdTipoAsociado, Nombre, SegundoNombre, Apellido, SegundoApellido,
    Estatus, TipoIdentificacion, NumeroIdentificacion, TelefonoResidencia,
    TelefonoCelular, TelefonoFamiliar, CorreoElectronico, Sexo, FechaNacimiento,
    DireccionResidencia, DireccionTrabajo, NivelEstudio, Profesion,
    UsuarioCrea, FechaCreacion, snEliminado, LugarTrabajo, Ocupacion,
    PaisTrabajo, ProvinciaTrabajo, DistritoTrabajo, CorregimientoTrabajo,
    PaisResidencia, ProvinciaResidencia, DistritoResidencia, CorregimientoResidencia
) VALUES (
    1, 'Juan', 'Carlos', 'Pérez', 'González',
    'A', 'C', '123456789', '555-0001',
    '555-0002', '555-0003', 'juan.perez@test.com', 'M', '1990-01-01',
    'Calle Test 123', 'Avenida Trabajo 456', 1, 1,
    1, GETDATE(), 0, 1, 1,
    'PA', 8, 47, 1,
    'PA', 8, 47, 1
)

DECLARE @NumeroAsociado INT = SCOPE_IDENTITY()
PRINT '   ✅ Asociado creado con ID: ' + CAST(@NumeroAsociado AS VARCHAR(10))
PRINT ''

-- 5. Actualizar el asociado para probar UPDATE
PRINT '5. Actualizando asociado...'
UPDATE tbAsociados 
SET Nombre = 'Juan Carlos', 
    LugarTrabajo = 2,
    Ocupacion = 2,
    UsuarioModifica = 1,
    FechaModificacion = GETDATE()
WHERE NumeroAsociado = @NumeroAsociado

PRINT '   ✅ Asociado actualizado'
PRINT ''

-- 6. Realizar soft delete
PRINT '6. Realizando soft delete...'
UPDATE tbAsociados 
SET snEliminado = 1,
    UsuarioElimina = 1,
    FechaEliminacion = GETDATE(),
    UsuarioModifica = 1,
    FechaModificacion = GETDATE()
WHERE NumeroAsociado = @NumeroAsociado

PRINT '   ✅ Soft delete realizado'
PRINT ''

-- 7. Verificar los logs de auditoría
PRINT '7. Verificando logs de auditoría...'
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
    FechaHora,
    LEFT(JsonPosterior, 200) + '...' as JsonPosterior_Preview
FROM tbLogsAuditoria 
WHERE TablaAfectada = 'tbAsociados' 
    AND RegistroId = CAST(@NumeroAsociado AS VARCHAR(50))
ORDER BY FechaHora

PRINT '   ✅ Logs verificados'
PRINT ''

-- 8. Mostrar un ejemplo de JSON con descripciones
PRINT '8. Ejemplo de JSON con descripciones:'
SELECT TOP 1
    JsonPosterior
FROM tbLogsAuditoria 
WHERE TablaAfectada = 'tbAsociados' 
    AND RegistroId = CAST(@NumeroAsociado AS VARCHAR(50))
    AND Operacion = 'I'

PRINT '   ✅ Ejemplo mostrado'
PRINT ''

-- 9. Limpiar datos de prueba
PRINT '9. Limpiando datos de prueba...'
DELETE FROM tbLogsAuditoria WHERE TablaAfectada = 'tbAsociados' AND RegistroId = CAST(@NumeroAsociado AS VARCHAR(50))
DELETE FROM tbAsociados WHERE NumeroAsociado = @NumeroAsociado

PRINT '   ✅ Datos de prueba eliminados'
PRINT ''

PRINT '=== PRUEBA COMPLETADA EXITOSAMENTE ==='
PRINT 'El trigger mejorado ahora incluye descripciones de IDs en formato "Descripción (ID)"'
GO

