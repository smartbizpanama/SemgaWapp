-- =============================================
-- Script de Prueba para Auditoría de tbAsociados
-- =============================================

USE [SegmaDB]
GO

PRINT '=== INICIANDO PRUEBAS DE AUDITORÍA PARA tbAsociados ==='
PRINT ''

-- Verificar que el trigger existe
IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'tr_Auditoria_tbAsociados')
    PRINT '✅ Trigger tr_Auditoria_tbAsociados existe'
ELSE
    PRINT '❌ Trigger tr_Auditoria_tbAsociados NO existe'
GO

-- Verificar que la tabla de auditoría existe
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'tbLogsAuditoria')
    PRINT '✅ Tabla tbLogsAuditoria existe'
ELSE
    PRINT '❌ Tabla tbLogsAuditoria NO existe'
GO

-- Contar registros de auditoría antes de las pruebas
DECLARE @RegistrosAntes INT
SELECT @RegistrosAntes = COUNT(*) FROM tbLogsAuditoria WHERE TablaAfectada = 'tbAsociados'
PRINT '📊 Registros de auditoría antes de las pruebas: ' + CAST(@RegistrosAntes AS NVARCHAR(10))
GO

-- =============================================
-- PRUEBA 1: INSERT (Crear nuevo asociado)
-- =============================================
PRINT ''
PRINT '=== PRUEBA 1: INSERT ==='

-- Insertar un asociado de prueba
INSERT INTO tbAsociados (
    IdTipoAsociado, Nombre, Apellido, Estatus, TipoIdentificacion, 
    NumeroIdentificacion, TelefonoCelular, CorreoElectronico, Sexo,
    FechaCreacion, UsuarioCrea, snEliminado
) VALUES (
    1, 'Juan', 'Pérez', 'A', 'Cédula', 
    '123456789', '555-1234', 'juan@test.com', 'M',
    GETDATE(), 1, 0
)

-- Obtener el ID del asociado creado
DECLARE @AsociadoId INT = SCOPE_IDENTITY()
PRINT '✅ Asociado creado con ID: ' + CAST(@AsociadoId AS NVARCHAR(10))

-- Verificar que se creó el registro de auditoría
DECLARE @RegistrosDespuesInsert INT
SELECT @RegistrosDespuesInsert = COUNT(*) 
FROM tbLogsAuditoria 
WHERE TablaAfectada = 'tbAsociados' AND Operacion = 'I' AND RegistroId = CAST(@AsociadoId AS NVARCHAR(50))

IF @RegistrosDespuesInsert > 0
    PRINT '✅ Registro de auditoría INSERT creado correctamente'
ELSE
    PRINT '❌ NO se creó registro de auditoría para INSERT'
GO

-- =============================================
-- PRUEBA 2: UPDATE (Modificar asociado)
-- =============================================
PRINT ''
PRINT '=== PRUEBA 2: UPDATE ==='

-- Obtener el ID del último asociado creado
DECLARE @AsociadoUpdateId INT
SELECT @AsociadoUpdateId = MAX(NumeroAsociado) FROM tbAsociados WHERE Nombre = 'Juan'

-- Actualizar el asociado
UPDATE tbAsociados 
SET 
    Apellido = 'Pérez López',
    TelefonoCelular = '555-5678',
    FechaModificacion = GETDATE(),
    UsuarioModifica = 1
WHERE NumeroAsociado = @AsociadoUpdateId

PRINT '✅ Asociado actualizado con ID: ' + CAST(@AsociadoUpdateId AS NVARCHAR(10))

-- Verificar que se creó el registro de auditoría
DECLARE @RegistrosDespuesUpdate INT
SELECT @RegistrosDespuesUpdate = COUNT(*) 
FROM tbLogsAuditoria 
WHERE TablaAfectada = 'tbAsociados' AND Operacion = 'U' AND RegistroId = CAST(@AsociadoUpdateId AS NVARCHAR(50))

IF @RegistrosDespuesUpdate > 0
    PRINT '✅ Registro de auditoría UPDATE creado correctamente'
ELSE
    PRINT '❌ NO se creó registro de auditoría para UPDATE'
GO

-- =============================================
-- PRUEBA 3: DELETE (Soft delete)
-- =============================================
PRINT ''
PRINT '=== PRUEBA 3: DELETE (Soft Delete) ==='

-- Obtener el ID del último asociado creado
DECLARE @AsociadoDeleteId INT
SELECT @AsociadoDeleteId = MAX(NumeroAsociado) FROM tbAsociados WHERE Nombre = 'Juan'

-- Soft delete del asociado
UPDATE tbAsociados 
SET 
    snEliminado = 1,
    FechaModificacion = GETDATE(),
    UsuarioModifica = 1
WHERE NumeroAsociado = @AsociadoDeleteId

PRINT '✅ Asociado eliminado (soft delete) con ID: ' + CAST(@AsociadoDeleteId AS NVARCHAR(10))

-- Verificar que se creó el registro de auditoría
DECLARE @RegistrosDespuesDelete INT
SELECT @RegistrosDespuesDelete = COUNT(*) 
FROM tbLogsAuditoria 
WHERE TablaAfectada = 'tbAsociados' AND Operacion = 'D' AND RegistroId = CAST(@AsociadoDeleteId AS NVARCHAR(50))

IF @RegistrosDespuesDelete > 0
    PRINT '✅ Registro de auditoría DELETE creado correctamente'
ELSE
    PRINT '❌ NO se creó registro de auditoría para DELETE'
GO

-- =============================================
-- RESUMEN DE PRUEBAS
-- =============================================
PRINT ''
PRINT '=== RESUMEN DE PRUEBAS ==='

-- Contar registros de auditoría después de las pruebas
DECLARE @RegistrosDespues INT
SELECT @RegistrosDespues = COUNT(*) FROM tbLogsAuditoria WHERE TablaAfectada = 'tbAsociados'
PRINT '📊 Registros de auditoría después de las pruebas: ' + CAST(@RegistrosDespues AS NVARCHAR(10))
PRINT '📈 Nuevos registros creados: ' + CAST(@RegistrosDespues - @RegistrosAntes AS NVARCHAR(10))

-- Mostrar los últimos registros de auditoría
PRINT ''
PRINT '=== ÚLTIMOS REGISTROS DE AUDITORÍA ==='
SELECT TOP 5
    Id,
    TablaAfectada,
    RegistroId,
    Operacion,
    UsuarioId,
    FechaHora,
    Comentarios
FROM tbLogsAuditoria 
WHERE TablaAfectada = 'tbAsociados'
ORDER BY Id DESC

-- Mostrar un ejemplo de JSON capturado
PRINT ''
PRINT '=== EJEMPLO DE JSON CAPTURADO (Último INSERT) ==='
SELECT TOP 1
    JsonPosterior
FROM tbLogsAuditoria 
WHERE TablaAfectada = 'tbAsociados' AND Operacion = 'I'
ORDER BY Id DESC

PRINT ''
PRINT '=== PRUEBAS COMPLETADAS ==='
GO

