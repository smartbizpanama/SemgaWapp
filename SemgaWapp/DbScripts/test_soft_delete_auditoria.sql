-- =============================================
-- Script de Prueba para Soft Delete con Auditoría
-- Verifica que el trigger detecte correctamente los soft deletes
-- =============================================

USE [SegmaDB]
GO

PRINT '=== PRUEBA DE SOFT DELETE CON AUDITORÍA ==='
PRINT ''

-- 1. Crear un socio de prueba
PRINT '1. Creando socio de prueba...'
INSERT INTO tbAsociados (
    IdTipoAsociado, Nombre, Apellido, Estatus, TipoIdentificacion, 
    NumeroIdentificacion, snEliminado, UsuarioCrea, FechaCreacion
) VALUES (
    1, 'PRUEBA', 'SOFT DELETE', 'A', 'CED', '123456789', 0, 1, GETDATE()
)

DECLARE @NumeroAsociadoPrueba INT = SCOPE_IDENTITY()
PRINT 'Socio creado con ID: ' + CAST(@NumeroAsociadoPrueba AS NVARCHAR(10))
PRINT ''

-- 2. Verificar que se creó el log de auditoría para INSERT
PRINT '2. Verificando log de auditoría para INSERT...'
SELECT 
    Id, TablaAfectada, RegistroId, Operacion, UsuarioId, 
    FechaHora, Comentarios
FROM tbLogsAuditoria 
WHERE TablaAfectada = 'tbAsociados' 
  AND RegistroId = CAST(@NumeroAsociadoPrueba AS NVARCHAR(50))
  AND Operacion = 'I'
ORDER BY FechaHora DESC

PRINT ''

-- 3. Realizar un UPDATE normal (no soft delete)
PRINT '3. Realizando UPDATE normal...'
UPDATE tbAsociados 
SET Nombre = 'PRUEBA MODIFICADO', UsuarioModifica = 1, FechaModificacion = GETDATE()
WHERE NumeroAsociado = @NumeroAsociadoPrueba

-- 4. Verificar que se creó el log de auditoría para UPDATE
PRINT '4. Verificando log de auditoría para UPDATE...'
SELECT 
    Id, TablaAfectada, RegistroId, Operacion, UsuarioId, 
    FechaHora, Comentarios
FROM tbLogsAuditoria 
WHERE TablaAfectada = 'tbAsociados' 
  AND RegistroId = CAST(@NumeroAsociadoPrueba AS NVARCHAR(50))
  AND Operacion = 'U'
ORDER BY FechaHora DESC

PRINT ''

-- 5. Realizar SOFT DELETE (cambiar snEliminado de 0 a 1)
PRINT '5. Realizando SOFT DELETE...'
UPDATE tbAsociados 
SET snEliminado = 1, UsuarioElimina = 1, UsuarioModifica = 1, FechaModificacion = GETDATE()
WHERE NumeroAsociado = @NumeroAsociadoPrueba

-- 6. Verificar que se creó el log de auditoría para SOFT DELETE
PRINT '6. Verificando log de auditoría para SOFT DELETE...'
SELECT 
    Id, TablaAfectada, RegistroId, Operacion, UsuarioId, 
    FechaHora, Comentarios
FROM tbLogsAuditoria 
WHERE TablaAfectada = 'tbAsociados' 
  AND RegistroId = CAST(@NumeroAsociadoPrueba AS NVARCHAR(50))
  AND Operacion = 'D'
ORDER BY FechaHora DESC

PRINT ''

-- 7. Mostrar todos los logs de auditoría para este socio
PRINT '7. Resumen de todos los logs de auditoría:'
SELECT 
    Id, Operacion, UsuarioId, FechaHora, Comentarios,
    CASE 
        WHEN Operacion = 'I' THEN 'INSERT'
        WHEN Operacion = 'U' THEN 'UPDATE'
        WHEN Operacion = 'D' THEN 'DELETE (Soft)'
        ELSE 'OTRO'
    END as TipoOperacion
FROM tbLogsAuditoria 
WHERE TablaAfectada = 'tbAsociados' 
  AND RegistroId = CAST(@NumeroAsociadoPrueba AS NVARCHAR(50))
ORDER BY FechaHora ASC

PRINT ''

-- 8. Verificar el JSON del soft delete
PRINT '8. Verificando JSON del soft delete:'
SELECT 
    Id, Operacion, 
    LEFT(JsonPrevio, 100) + '...' as JsonPrevio_Resumen,
    LEFT(JsonPosterior, 100) + '...' as JsonPosterior_Resumen
FROM tbLogsAuditoria 
WHERE TablaAfectada = 'tbAsociados' 
  AND RegistroId = CAST(@NumeroAsociadoPrueba AS NVARCHAR(50))
  AND Operacion = 'D'

PRINT ''
PRINT '=== PRUEBA COMPLETADA ==='
PRINT 'El trigger debe haber detectado:'
PRINT '- 1 INSERT (creación)'
PRINT '- 1 UPDATE (modificación normal)'
PRINT '- 1 DELETE (soft delete)'
PRINT ''

-- Limpiar datos de prueba
PRINT 'Limpiando datos de prueba...'
DELETE FROM tbLogsAuditoria WHERE TablaAfectada = 'tbAsociados' AND RegistroId = CAST(@NumeroAsociadoPrueba AS NVARCHAR(50))
DELETE FROM tbAsociados WHERE NumeroAsociado = @NumeroAsociadoPrueba
PRINT 'Datos de prueba eliminados.'

