-- =============================================
-- Script de Prueba para Auditoría de tbBeneficiarios
-- Verifica que el trigger funcione correctamente con todos los códigos
-- =============================================

USE [SegmaDB]
GO

PRINT '=== PRUEBA DE AUDITORÍA PARA tbBeneficiarios ==='
PRINT 'Códigos: I=INSERT, U=UPDATE, D=SOFT DELETE, X=DELETE FÍSICO'
PRINT ''

-- 1. Crear un socio de prueba para asociar beneficiarios
PRINT '1. Creando socio de prueba...'
INSERT INTO tbAsociados (
    IdTipoAsociado, Nombre, Apellido, Estatus, TipoIdentificacion, 
    NumeroIdentificacion, snEliminado, UsuarioCrea, FechaCreacion
) VALUES (
    1, 'SOCIO', 'PRUEBA BENEFICIARIOS', 'A', 'CED', '111111111', 0, 1, GETDATE()
)

DECLARE @NumeroAsociadoPrueba INT = SCOPE_IDENTITY()
PRINT 'Socio creado con ID: ' + CAST(@NumeroAsociadoPrueba AS NVARCHAR(10))
PRINT ''

-- 2. Crear un beneficiario de prueba (INSERT - I)
PRINT '2. Creando beneficiario de prueba (INSERT - I)...'
INSERT INTO tbBeneficiarios (
    NumeroAsociado, Nombre, Apellido, TipoIdentificacion, NumeroIdentificacion,
    IDParentezco, Porcentaje, snEliminado, UsuarioCrea, FechaHoraCrea
) VALUES (
    @NumeroAsociadoPrueba, 'BENEFICIARIO', 'PRUEBA', 'CED', '222222222',
    1, 50.00, 0, 1, GETDATE()
)

DECLARE @IDBeneficiarioPrueba INT = SCOPE_IDENTITY()
PRINT 'Beneficiario creado con ID: ' + CAST(@IDBeneficiarioPrueba AS NVARCHAR(10))
PRINT ''

-- 3. Verificar INSERT (I)
PRINT '3. Verificando INSERT (I)...'
SELECT 
    Id, Operacion, UsuarioId, FechaHora, Comentarios
FROM tbLogsAuditoria 
WHERE TablaAfectada = 'tbBeneficiarios' 
  AND RegistroId = CAST(@IDBeneficiarioPrueba AS NVARCHAR(50))
  AND Operacion = 'I'
ORDER BY FechaHora DESC

PRINT ''

-- 4. Realizar UPDATE normal (U)
PRINT '4. Realizando UPDATE normal (U)...'
UPDATE tbBeneficiarios 
SET Nombre = 'BENEFICIARIO MODIFICADO', Porcentaje = 75.00, 
    UsuarioModifica = 1, FechaModifica = GETDATE()
WHERE IDBeneficiario = @IDBeneficiarioPrueba

-- 5. Verificar UPDATE (U)
PRINT '5. Verificando UPDATE (U)...'
SELECT 
    Id, Operacion, UsuarioId, FechaHora, Comentarios
FROM tbLogsAuditoria 
WHERE TablaAfectada = 'tbBeneficiarios' 
  AND RegistroId = CAST(@IDBeneficiarioPrueba AS NVARCHAR(50))
  AND Operacion = 'U'
ORDER BY FechaHora DESC

PRINT ''

-- 6. Realizar SOFT DELETE (D)
PRINT '6. Realizando SOFT DELETE (D)...'
UPDATE tbBeneficiarios 
SET snEliminado = 1, UsuarioElimina = 1, FechaElimina = GETDATE()
WHERE IDBeneficiario = @IDBeneficiarioPrueba

-- 7. Verificar SOFT DELETE (D)
PRINT '7. Verificando SOFT DELETE (D)...'
SELECT 
    Id, Operacion, UsuarioId, FechaHora, Comentarios
FROM tbLogsAuditoria 
WHERE TablaAfectada = 'tbBeneficiarios' 
  AND RegistroId = CAST(@IDBeneficiarioPrueba AS NVARCHAR(50))
  AND Operacion = 'D'
ORDER BY FechaHora DESC

PRINT ''

-- 8. Crear otro beneficiario para probar DELETE físico
PRINT '8. Creando segundo beneficiario para DELETE físico...'
INSERT INTO tbBeneficiarios (
    NumeroAsociado, Nombre, Apellido, TipoIdentificacion, NumeroIdentificacion,
    IDParentezco, Porcentaje, snEliminado, UsuarioCrea, FechaHoraCrea
) VALUES (
    @NumeroAsociadoPrueba, 'BENEFICIARIO', 'DELETE FISICO', 'CED', '333333333',
    2, 25.00, 0, 1, GETDATE()
)

DECLARE @IDBeneficiarioPrueba2 INT = SCOPE_IDENTITY()
PRINT 'Segundo beneficiario creado con ID: ' + CAST(@IDBeneficiarioPrueba2 AS NVARCHAR(10))
PRINT ''

-- 9. Realizar DELETE FÍSICO (X)
PRINT '9. Realizando DELETE FÍSICO (X)...'
DELETE FROM tbBeneficiarios WHERE IDBeneficiario = @IDBeneficiarioPrueba2

-- 10. Verificar DELETE FÍSICO (X)
PRINT '10. Verificando DELETE FÍSICO (X)...'
SELECT 
    Id, Operacion, UsuarioId, FechaHora, Comentarios
FROM tbLogsAuditoria 
WHERE TablaAfectada = 'tbBeneficiarios' 
  AND RegistroId = CAST(@IDBeneficiarioPrueba2 AS NVARCHAR(50))
  AND Operacion = 'X'
ORDER BY FechaHora DESC

PRINT ''

-- 11. Mostrar resumen de todos los códigos
PRINT '11. Resumen de todos los códigos de operación:'
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
WHERE TablaAfectada = 'tbBeneficiarios' 
  AND (RegistroId = CAST(@IDBeneficiarioPrueba AS NVARCHAR(50)) 
       OR RegistroId = CAST(@IDBeneficiarioPrueba2 AS NVARCHAR(50)))
GROUP BY Operacion
ORDER BY Operacion

PRINT ''

-- 12. Mostrar todos los logs de auditoría
PRINT '12. Todos los logs de auditoría generados:'
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
WHERE TablaAfectada = 'tbBeneficiarios' 
  AND (RegistroId = CAST(@IDBeneficiarioPrueba AS NVARCHAR(50)) 
       OR RegistroId = CAST(@IDBeneficiarioPrueba2 AS NVARCHAR(50)))
ORDER BY FechaHora ASC

PRINT ''

-- 13. Verificar JSON del soft delete
PRINT '13. Verificando JSON del soft delete:'
SELECT 
    Id, Operacion, 
    LEFT(JsonPrevio, 100) + '...' as JsonPrevio_Resumen,
    LEFT(JsonPosterior, 100) + '...' as JsonPosterior_Resumen
FROM tbLogsAuditoria 
WHERE TablaAfectada = 'tbBeneficiarios' 
  AND RegistroId = CAST(@IDBeneficiarioPrueba AS NVARCHAR(50))
  AND Operacion = 'D'

PRINT ''
PRINT '=== PRUEBA COMPLETADA ==='
PRINT 'Códigos esperados:'
PRINT '- I = INSERT (creación de beneficiario)'
PRINT '- U = UPDATE (modificación normal)'
PRINT '- D = SOFT DELETE (eliminación lógica)'
PRINT '- X = DELETE FÍSICO (eliminación real)'
PRINT ''

-- Limpiar datos de prueba
PRINT 'Limpiando datos de prueba...'
DELETE FROM tbLogsAuditoria WHERE TablaAfectada = 'tbBeneficiarios' 
  AND (RegistroId = CAST(@IDBeneficiarioPrueba AS NVARCHAR(50)) 
       OR RegistroId = CAST(@IDBeneficiarioPrueba2 AS NVARCHAR(50)))
DELETE FROM tbBeneficiarios WHERE IDBeneficiario = @IDBeneficiarioPrueba
DELETE FROM tbAsociados WHERE NumeroAsociado = @NumeroAsociadoPrueba
PRINT 'Datos de prueba eliminados.'

