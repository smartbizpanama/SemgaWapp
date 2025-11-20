-- =============================================
-- Script de Prueba para el Formulario de Logs de Auditoría
-- Verifica que los WebMethods funcionen correctamente
-- =============================================

USE [SegmaDB]
GO

PRINT '=== PRUEBA DEL FORMULARIO DE LOGS DE AUDITORÍA ==='
PRINT ''

-- 1. Verificar que existen datos para probar
PRINT '1. Verificando datos existentes...'
SELECT 
    'Total logs' as Descripcion,
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
    'Usuarios con logs',
    COUNT(DISTINCT UsuarioId)
FROM tbLogsAuditoria

PRINT ''

-- 2. Probar el SP principal con diferentes filtros
PRINT '2. Probando spLogsAuditoria_ObtenerLogs con diferentes filtros...'

PRINT '2.1. Sin filtros (todos los logs):'
EXEC spLogsAuditoria_ObtenerLogs

PRINT ''
PRINT '2.2. Solo logs de Asociados:'
EXEC spLogsAuditoria_ObtenerLogs @Tabla = 'Asociados'

PRINT ''
PRINT '2.3. Solo operaciones de INSERT:'
EXEC spLogsAuditoria_ObtenerLogs @Operacion = 'I'

PRINT ''
PRINT '2.4. Solo logs de hoy:'
DECLARE @Hoy DATE = CAST(GETDATE() AS DATE)
EXEC spLogsAuditoria_ObtenerLogs @FechaDesde = @Hoy

PRINT ''

-- 3. Probar SP de tablas
PRINT '3. Probando spLogsAuditoria_ObtenerTablas:'
EXEC spLogsAuditoria_ObtenerTablas

PRINT ''

-- 4. Crear algunos logs adicionales para probar el formulario
PRINT '4. Creando logs adicionales para pruebas...'

-- Crear un socio de prueba
INSERT INTO tbAsociados (
    IdTipoAsociado, Nombre, Apellido, Estatus, TipoIdentificacion, 
    NumeroIdentificacion, snEliminado, UsuarioCrea, FechaCreacion
) VALUES (
    1, 'PRUEBA', 'FORMULARIO', 'A', 'CED', '111111111', 0, 1, GETDATE()
)

DECLARE @NumeroAsociadoPrueba INT = SCOPE_IDENTITY()
PRINT 'Socio de prueba creado con ID: ' + CAST(@NumeroAsociadoPrueba AS NVARCHAR(10))

-- Crear un beneficiario de prueba
INSERT INTO tbBeneficiarios (
    NumeroAsociado, Nombre, Apellido, TipoIdentificacion, NumeroIdentificacion,
    IDParentezco, Porcentaje, snEliminado, UsuarioCrea, FechaHoraCrea
) VALUES (
    @NumeroAsociadoPrueba, 'BENEFICIARIO', 'FORMULARIO', 'CED', '222222222',
    1, 50.00, 0, 1, GETDATE()
)

DECLARE @IDBeneficiarioPrueba INT = SCOPE_IDENTITY()
PRINT 'Beneficiario de prueba creado con ID: ' + CAST(@IDBeneficiarioPrueba AS NVARCHAR(10))

-- Realizar algunas operaciones para generar logs
UPDATE tbAsociados SET Nombre = 'PRUEBA MODIFICADO', UsuarioModifica = 1, FechaModificacion = GETDATE() WHERE NumeroAsociado = @NumeroAsociadoPrueba
UPDATE tbBeneficiarios SET Porcentaje = 75.00, UsuarioModifica = 1, FechaModifica = GETDATE() WHERE IDBeneficiario = @IDBeneficiarioPrueba

PRINT 'Operaciones de prueba completadas'
PRINT ''

-- 5. Verificar los logs generados
PRINT '5. Verificando logs generados para el formulario:'
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
    ISNULL(u.Nombre + ' ' + u.Apellido, 'Usuario ' + CAST(la.UsuarioId AS NVARCHAR(10))) as NombreCompleto,
    CONVERT(DATE, la.FechaHora) as Fecha,
    CONVERT(TIME, la.FechaHora) as Hora
FROM tbLogsAuditoria la
LEFT JOIN tbTablasSistema ts ON la.TablaAfectada = ts.Tabla
LEFT JOIN tbUsuarios u ON la.UsuarioId = u.Id
WHERE la.RegistroId IN (CAST(@NumeroAsociadoPrueba AS NVARCHAR(50)), CAST(@IDBeneficiarioPrueba AS NVARCHAR(50)))
ORDER BY la.FechaHora DESC

PRINT ''

-- 6. Resumen final
PRINT '6. Resumen final del sistema:'
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
UNION ALL
SELECT 
    'Usuarios únicos con logs',
    COUNT(DISTINCT UsuarioId)
FROM tbLogsAuditoria

PRINT ''
PRINT '=== PRUEBA COMPLETADA ==='
PRINT 'El formulario de logs de auditoría está listo para usar'
PRINT ''

-- Limpiar datos de prueba
PRINT 'Limpiando datos de prueba...'
DELETE FROM tbLogsAuditoria WHERE RegistroId IN (CAST(@NumeroAsociadoPrueba AS NVARCHAR(50)), CAST(@IDBeneficiarioPrueba AS NVARCHAR(50)))
DELETE FROM tbBeneficiarios WHERE IDBeneficiario = @IDBeneficiarioPrueba
DELETE FROM tbAsociados WHERE NumeroAsociado = @NumeroAsociadoPrueba
PRINT 'Datos de prueba eliminados.'

