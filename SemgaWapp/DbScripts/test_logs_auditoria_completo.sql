-- =============================================
-- Script de Prueba Completo para Logs de Auditoría
-- Verifica que el sistema funcione correctamente
-- =============================================

USE [SegmaDB]
GO

PRINT '=== PRUEBA COMPLETA DEL SISTEMA DE LOGS DE AUDITORÍA ==='
PRINT ''

-- 1. Verificar que existen datos de auditoría
PRINT '1. Verificando datos existentes en tbLogsAuditoria...'
SELECT COUNT(*) as TotalLogs FROM tbLogsAuditoria
PRINT ''

-- 2. Probar el SP de obtener logs
PRINT '2. Probando spLogsAuditoria_ObtenerLogs...'
EXEC spLogsAuditoria_ObtenerLogs
PRINT ''

-- 3. Probar filtros específicos
PRINT '3. Probando filtros específicos...'
PRINT '3.1. Solo logs de tbAsociados:'
EXEC spLogsAuditoria_ObtenerLogs @Tabla = 'Asociados'
PRINT ''

PRINT '3.2. Solo operaciones de INSERT:'
EXEC spLogsAuditoria_ObtenerLogs @Operacion = 'I'
PRINT ''

PRINT '3.3. Solo logs de hoy:'
DECLARE @Hoy DATE = CAST(GETDATE() AS DATE)
EXEC spLogsAuditoria_ObtenerLogs @FechaDesde = @Hoy
PRINT ''

-- 4. Probar SP de obtener tablas
PRINT '4. Probando spLogsAuditoria_ObtenerTablas...'
EXEC spLogsAuditoria_ObtenerTablas
PRINT ''

-- 5. Crear algunos logs de prueba para verificar el sistema
PRINT '5. Creando logs de prueba...'

-- Crear un socio de prueba
INSERT INTO tbAsociados (
    IdTipoAsociado, Nombre, Apellido, Estatus, TipoIdentificacion, 
    NumeroIdentificacion, snEliminado, UsuarioCrea, FechaCreacion
) VALUES (
    1, 'PRUEBA', 'AUDITORIA', 'A', 'CED', '999999999', 0, 1, GETDATE()
)

DECLARE @NumeroAsociadoPrueba INT = SCOPE_IDENTITY()
PRINT 'Socio de prueba creado con ID: ' + CAST(@NumeroAsociadoPrueba AS NVARCHAR(10))

-- Crear un beneficiario de prueba
INSERT INTO tbBeneficiarios (
    NumeroAsociado, Nombre, Apellido, TipoIdentificacion, NumeroIdentificacion,
    IDParentezco, Porcentaje, snEliminado, UsuarioCrea, FechaHoraCrea
) VALUES (
    @NumeroAsociadoPrueba, 'BENEFICIARIO', 'PRUEBA', 'CED', '888888888',
    1, 50.00, 0, 1, GETDATE()
)

DECLARE @IDBeneficiarioPrueba INT = SCOPE_IDENTITY()
PRINT 'Beneficiario de prueba creado con ID: ' + CAST(@IDBeneficiarioPrueba AS NVARCHAR(10))

-- Realizar algunas operaciones para generar logs
UPDATE tbAsociados SET Nombre = 'PRUEBA MODIFICADO', UsuarioModifica = 1, FechaModificacion = GETDATE() WHERE NumeroAsociado = @NumeroAsociadoPrueba
UPDATE tbBeneficiarios SET Porcentaje = 75.00, UsuarioModifica = 1, FechaModifica = GETDATE() WHERE IDBeneficiario = @IDBeneficiarioPrueba

PRINT 'Operaciones de prueba completadas'
PRINT ''

-- 6. Verificar los nuevos logs generados
PRINT '6. Verificando logs generados...'
SELECT 
    la.Id,
    ISNULL(ts.NombreDescriptivo, la.TablaAfectada) as TablaDescriptiva,
    CASE 
        WHEN la.Operacion = 'I' THEN 'Crear'
        WHEN la.Operacion = 'U' THEN 'Actualizar'
        WHEN la.Operacion = 'D' THEN 'Eliminar (Soft)'
        WHEN la.Operacion = 'X' THEN 'Eliminar (Físico)'
        ELSE la.Operacion
    END as TipoOperacion,
    la.RegistroId,
    ISNULL(u.Usuario, 'Sistema') as Usuario,
    CONVERT(DATE, la.FechaHora) as Fecha,
    CONVERT(TIME, la.FechaHora) as Hora
FROM tbLogsAuditoria la
LEFT JOIN tbTablasSistema ts ON la.TablaAfectada = ts.Tabla
LEFT JOIN tbUsuarios u ON la.UsuarioId = u.Id
WHERE la.RegistroId IN (CAST(@NumeroAsociadoPrueba AS NVARCHAR(50)), CAST(@IDBeneficiarioPrueba AS NVARCHAR(50)))
ORDER BY la.FechaHora DESC

PRINT ''

-- 7. Resumen final
PRINT '7. Resumen del sistema:'
SELECT 
    'Total de logs en el sistema' as Descripcion,
    COUNT(*) as Cantidad
FROM tbLogsAuditoria
UNION ALL
SELECT 
    'Logs de Asociados',
    COUNT(*)
FROM tbLogsAuditoria WHERE TablaAfectada = 'tbAsociados'
UNION ALL
SELECT 
    'Logs de Beneficiarios',
    COUNT(*)
FROM tbLogsAuditoria WHERE TablaAfectada = 'tbBeneficiarios'
UNION ALL
SELECT 
    'Logs de hoy',
    COUNT(*)
FROM tbLogsAuditoria WHERE CONVERT(DATE, FechaHora) = CAST(GETDATE() AS DATE)

PRINT ''
PRINT '=== PRUEBA COMPLETADA ==='
PRINT 'El sistema de logs de auditoría está funcionando correctamente'
PRINT ''

-- Limpiar datos de prueba
PRINT 'Limpiando datos de prueba...'
DELETE FROM tbLogsAuditoria WHERE RegistroId IN (CAST(@NumeroAsociadoPrueba AS NVARCHAR(50)), CAST(@IDBeneficiarioPrueba AS NVARCHAR(50)))
DELETE FROM tbBeneficiarios WHERE IDBeneficiario = @IDBeneficiarioPrueba
DELETE FROM tbAsociados WHERE NumeroAsociado = @NumeroAsociadoPrueba
PRINT 'Datos de prueba eliminados.'
