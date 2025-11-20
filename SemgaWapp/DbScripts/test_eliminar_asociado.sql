-- =============================================
-- Script de Prueba para Eliminación de Asociados
-- =============================================

USE [SegmaDB]
GO

PRINT '=== INICIANDO PRUEBAS DE ELIMINACIÓN DE ASOCIADOS ==='
PRINT ''

-- Verificar que el stored procedure existe
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spGestionSocios_EliminarAsociado]') AND type in (N'P', N'PC'))
    PRINT '✅ Stored Procedure spGestionSocios_EliminarAsociado existe'
ELSE
    PRINT '❌ Stored Procedure spGestionSocios_EliminarAsociado NO existe'
GO

-- Verificar que el trigger de auditoría existe
IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'tr_Auditoria_tbAsociados')
    PRINT '✅ Trigger tr_Auditoria_tbAsociados existe'
ELSE
    PRINT '❌ Trigger tr_Auditoria_tbAsociados NO existe'
GO

-- =============================================
-- PRUEBA 1: Crear asociado de prueba
-- =============================================
PRINT ''
PRINT '=== PRUEBA 1: Crear Asociado de Prueba ==='

-- Insertar un asociado de prueba
INSERT INTO tbAsociados (
    IdTipoAsociado, Nombre, Apellido, Estatus, TipoIdentificacion, 
    NumeroIdentificacion, TelefonoCelular, CorreoElectronico, Sexo,
    FechaCreacion, UsuarioCrea, snEliminado
) VALUES (
    1, 'Test', 'Eliminar', 'A', 'Cédula', 
    '999999999', '555-9999', 'test@eliminar.com', 'M',
    GETDATE(), 1, 0
)

-- Obtener el ID del asociado creado
DECLARE @AsociadoTestId INT = SCOPE_IDENTITY()
PRINT '✅ Asociado de prueba creado con ID: ' + CAST(@AsociadoTestId AS NVARCHAR(10))

-- =============================================
-- PRUEBA 2: Intentar eliminar asociado sin auxiliares
-- =============================================
PRINT ''
PRINT '=== PRUEBA 2: Eliminar Asociado Sin Auxiliares ==='

-- Ejecutar eliminación
EXEC spGestionSocios_EliminarAsociado @NumeroAsociado = @AsociadoTestId, @UsuarioElimina = 1

-- Verificar que se marcó como eliminado
IF EXISTS (SELECT 1 FROM tbAsociados WHERE NumeroAsociado = @AsociadoTestId AND snEliminado = 1)
    PRINT '✅ Asociado eliminado correctamente (soft delete)'
ELSE
    PRINT '❌ Asociado NO fue eliminado'

-- =============================================
-- PRUEBA 3: Verificar auditoría
-- =============================================
PRINT ''
PRINT '=== PRUEBA 3: Verificar Auditoría ==='

-- Verificar que se creó registro de auditoría
DECLARE @RegistrosAuditoria INT
SELECT @RegistrosAuditoria = COUNT(*) 
FROM tbLogsAuditoria 
WHERE TablaAfectada = 'tbAsociados' 
AND RegistroId = CAST(@AsociadoTestId AS NVARCHAR(50))
AND Operacion = 'D'

IF @RegistrosAuditoria > 0
    PRINT '✅ Registro de auditoría DELETE creado correctamente'
ELSE
    PRINT '❌ NO se creó registro de auditoría para DELETE'

-- Mostrar el último registro de auditoría
PRINT ''
PRINT '=== ÚLTIMO REGISTRO DE AUDITORÍA ==='
SELECT TOP 1
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

-- =============================================
-- PRUEBA 4: Intentar eliminar asociado inexistente
-- =============================================
PRINT ''
PRINT '=== PRUEBA 4: Intentar Eliminar Asociado Inexistente ==='

-- Intentar eliminar un asociado que no existe
EXEC spGestionSocios_EliminarAsociado @NumeroAsociado = 99999, @UsuarioElimina = 1

-- =============================================
-- PRUEBA 5: Intentar eliminar asociado ya eliminado
-- =============================================
PRINT ''
PRINT '=== PRUEBA 5: Intentar Eliminar Asociado Ya Eliminado ==='

-- Intentar eliminar el mismo asociado otra vez
EXEC spGestionSocios_EliminarAsociado @NumeroAsociado = @AsociadoTestId, @UsuarioElimina = 1

PRINT ''
PRINT '=== PRUEBAS COMPLETADAS ==='
GO

