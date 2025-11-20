-- =============================================
-- Script de Prueba para Códigos de Auditoría
-- Verifica que el trigger use los códigos correctos:
-- D = Soft Delete, X = Delete Físico
-- =============================================

USE [SegmaDB]
GO

PRINT '=== PRUEBA DE CÓDIGOS DE AUDITORÍA ==='
PRINT 'D = Soft Delete, X = Delete Físico'
PRINT ''

-- 1. Crear un socio de prueba
PRINT '1. Creando socio de prueba...'
INSERT INTO tbAsociados (
    IdTipoAsociado, Nombre, Apellido, Estatus, TipoIdentificacion, 
    NumeroIdentificacion, snEliminado, UsuarioCrea, FechaCreacion
) VALUES (
    1, 'PRUEBA', 'CODIGOS', 'A', 'CED', '987654321', 0, 1, GETDATE()
)

DECLARE @NumeroAsociadoPrueba INT = SCOPE_IDENTITY()
PRINT 'Socio creado con ID: ' + CAST(@NumeroAsociadoPrueba AS NVARCHAR(10))
PRINT ''

-- 2. Verificar INSERT (I)
PRINT '2. Verificando INSERT (I)...'
SELECT 
    Id, Operacion, UsuarioId, FechaHora, Comentarios
FROM tbLogsAuditoria 
WHERE TablaAfectada = 'tbAsociados' 
  AND RegistroId = CAST(@NumeroAsociadoPrueba AS NVARCHAR(50))
  AND Operacion = 'I'
ORDER BY FechaHora DESC

PRINT ''

-- 3. Realizar UPDATE normal (U)
PRINT '3. Realizando UPDATE normal (U)...'
UPDATE tbAsociados 
SET Nombre = 'PRUEBA MODIFICADO', UsuarioModifica = 1, FechaModificacion = GETDATE()
WHERE NumeroAsociado = @NumeroAsociadoPrueba

-- 4. Verificar UPDATE (U)
PRINT '4. Verificando UPDATE (U)...'
SELECT 
    Id, Operacion, UsuarioId, FechaHora, Comentarios
FROM tbLogsAuditoria 
WHERE TablaAfectada = 'tbAsociados' 
  AND RegistroId = CAST(@NumeroAsociadoPrueba AS NVARCHAR(50))
  AND Operacion = 'U'
ORDER BY FechaHora DESC

PRINT ''

-- 5. Realizar SOFT DELETE (D)
PRINT '5. Realizando SOFT DELETE (D)...'
UPDATE tbAsociados 
SET snEliminado = 1, UsuarioElimina = 1, UsuarioModifica = 1, FechaModificacion = GETDATE()
WHERE NumeroAsociado = @NumeroAsociadoPrueba

-- 6. Verificar SOFT DELETE (D)
PRINT '6. Verificando SOFT DELETE (D)...'
SELECT 
    Id, Operacion, UsuarioId, FechaHora, Comentarios
FROM tbLogsAuditoria 
WHERE TablaAfectada = 'tbAsociados' 
  AND RegistroId = CAST(@NumeroAsociadoPrueba AS NVARCHAR(50))
  AND Operacion = 'D'
ORDER BY FechaHora DESC

PRINT ''

-- 7. Crear otro socio para probar DELETE físico
PRINT '7. Creando segundo socio para DELETE físico...'
INSERT INTO tbAsociados (
    IdTipoAsociado, Nombre, Apellido, Estatus, TipoIdentificacion, 
    NumeroIdentificacion, snEliminado, UsuarioCrea, FechaCreacion
) VALUES (
    1, 'PRUEBA', 'DELETE FISICO', 'A', 'CED', '111111111', 0, 1, GETDATE()
)

DECLARE @NumeroAsociadoPrueba2 INT = SCOPE_IDENTITY()
PRINT 'Segundo socio creado con ID: ' + CAST(@NumeroAsociadoPrueba2 AS NVARCHAR(10))
PRINT ''

-- 8. Realizar DELETE FÍSICO (X)
PRINT '8. Realizando DELETE FÍSICO (X)...'
DELETE FROM tbAsociados WHERE NumeroAsociado = @NumeroAsociadoPrueba2

-- 9. Verificar DELETE FÍSICO (X)
PRINT '9. Verificando DELETE FÍSICO (X)...'
SELECT 
    Id, Operacion, UsuarioId, FechaHora, Comentarios
FROM tbLogsAuditoria 
WHERE TablaAfectada = 'tbAsociados' 
  AND RegistroId = CAST(@NumeroAsociadoPrueba2 AS NVARCHAR(50))
  AND Operacion = 'X'
ORDER BY FechaHora DESC

PRINT ''

-- 10. Mostrar resumen de todos los códigos
PRINT '10. Resumen de todos los códigos de operación:'
SELECT 
    Operacion,
    CASE 
        WHEN Operacion = 'I' THEN 'INSERT'
        WHEN Operacion = 'U' THEN 'UPDATE'
        WHEN Operacion = 'D' THEN 'SOFT DELETE'
        WHEN Operacion = 'X' THEN 'DELETE FÍSICO'
        ELSE 'OTRO'
    END as TipoOperacion,
    COUNT(*) as Cantidad
FROM tbLogsAuditoria 
WHERE TablaAfectada = 'tbAsociados' 
  AND (RegistroId = CAST(@NumeroAsociadoPrueba AS NVARCHAR(50)) 
       OR RegistroId = CAST(@NumeroAsociadoPrueba2 AS NVARCHAR(50)))
GROUP BY Operacion
ORDER BY Operacion

PRINT ''

-- 11. Mostrar todos los logs de auditoría
PRINT '11. Todos los logs de auditoría generados:'
SELECT 
    Id, Operacion, UsuarioId, FechaHora, Comentarios,
    CASE 
        WHEN Operacion = 'I' THEN 'INSERT'
        WHEN Operacion = 'U' THEN 'UPDATE'
        WHEN Operacion = 'D' THEN 'SOFT DELETE'
        WHEN Operacion = 'X' THEN 'DELETE FÍSICO'
        ELSE 'OTRO'
    END as TipoOperacion
FROM tbLogsAuditoria 
WHERE TablaAfectada = 'tbAsociados' 
  AND (RegistroId = CAST(@NumeroAsociadoPrueba AS NVARCHAR(50)) 
       OR RegistroId = CAST(@NumeroAsociadoPrueba2 AS NVARCHAR(50)))
ORDER BY FechaHora ASC

PRINT ''
PRINT '=== PRUEBA COMPLETADA ==='
PRINT 'Códigos esperados:'
PRINT '- I = INSERT (creación)'
PRINT '- U = UPDATE (modificación normal)'
PRINT '- D = SOFT DELETE (eliminación lógica)'
PRINT '- X = DELETE FÍSICO (eliminación real)'
PRINT ''

-- Limpiar datos de prueba
PRINT 'Limpiando datos de prueba...'
DELETE FROM tbLogsAuditoria WHERE TablaAfectada = 'tbAsociados' 
  AND (RegistroId = CAST(@NumeroAsociadoPrueba AS NVARCHAR(50)) 
       OR RegistroId = CAST(@NumeroAsociadoPrueba2 AS NVARCHAR(50)))
DELETE FROM tbAsociados WHERE NumeroAsociado = @NumeroAsociadoPrueba
PRINT 'Datos de prueba eliminados.'

