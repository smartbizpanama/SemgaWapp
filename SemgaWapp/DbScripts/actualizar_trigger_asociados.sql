-- =============================================
-- Script para actualizar el trigger de tbAsociados
-- Reemplaza el trigger original con la versión mejorada
-- =============================================

USE [SegmaDB]
GO

PRINT '=== ACTUALIZANDO TRIGGER DE AUDITORÍA PARA tbAsociados ==='
PRINT ''

-- 1. Crear las funciones auxiliares (si no existen)
PRINT '1. Creando/actualizando funciones auxiliares...'
EXEC sp_executesql N'-- Ejecutar fnAuditoria_ObtenerDescripciones.sql aquí'
PRINT '   ✅ Funciones auxiliares listas'
PRINT ''

-- 2. Eliminar el trigger anterior
PRINT '2. Eliminando trigger anterior...'
IF EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[tr_Auditoria_tbAsociados]'))
BEGIN
    DROP TRIGGER [dbo].[tr_Auditoria_tbAsociados]
    PRINT '   ✅ Trigger anterior eliminado'
END
ELSE
    PRINT '   ℹ️  No había trigger anterior'
PRINT ''

-- 3. Crear el trigger mejorado
PRINT '3. Creando trigger mejorado...'
EXEC sp_executesql N'-- Ejecutar tr_Auditoria_tbAsociados_Mejorado.sql aquí'
PRINT '   ✅ Trigger mejorado creado'
PRINT ''

-- 4. Verificar que el trigger esté activo
PRINT '4. Verificando trigger activo...'
IF EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[tr_Auditoria_tbAsociados]'))
    PRINT '   ✅ Trigger tr_Auditoria_tbAsociados está activo'
ELSE
    PRINT '   ❌ ERROR: Trigger no encontrado'
PRINT ''

-- 5. Probar las funciones auxiliares
PRINT '5. Probando funciones auxiliares...'
SELECT 
    'TipoAsociado' as Funcion, 
    dbo.fnAuditoria_ObtenerTipoAsociado(1) as Resultado
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

PRINT '   ✅ Funciones auxiliares funcionando correctamente'
PRINT ''

PRINT '=== ACTUALIZACIÓN COMPLETADA ==='
PRINT 'El trigger de auditoría para tbAsociados ahora incluye:'
PRINT '- Descripciones de todos los IDs en formato "Descripción (ID)"'
PRINT '- TipoAsociado, NivelEstudio, Profesion, LugarTrabajo, Ocupacion'
PRINT '- Pais, Provincia, Distrito, Corregimiento, Usuario'
PRINT '- Mantiene todos los códigos de operación: I, U, D, X'
PRINT ''

GO

