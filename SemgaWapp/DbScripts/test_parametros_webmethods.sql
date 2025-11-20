-- =============================================
-- SCRIPT DE PRUEBA PARA VERIFICAR PARÁMETROS
-- =============================================

USE [SegmaDB]
GO

PRINT '=== VERIFICACIÓN DE PARÁMETROS DE STORED PROCEDURES ==='
PRINT ''

-- Verificar parámetros de spGestionSocios_CrearSocio
PRINT '1. Parámetros de spGestionSocios_CrearSocio:'
SELECT 
    p.name as parameter_name,
    t.name as data_type,
    p.max_length,
    p.is_output
FROM sys.parameters p
INNER JOIN sys.objects o ON p.object_id = o.object_id
INNER JOIN sys.types t ON p.user_type_id = t.user_type_id
WHERE o.name = 'spGestionSocios_CrearSocio'
ORDER BY p.parameter_id

PRINT ''

-- Verificar parámetros de spGestionSocios_ActualizarSocio
PRINT '2. Parámetros de spGestionSocios_ActualizarSocio:'
SELECT 
    p.name as parameter_name,
    t.name as data_type,
    p.max_length,
    p.is_output
FROM sys.parameters p
INNER JOIN sys.objects o ON p.object_id = o.object_id
INNER JOIN sys.types t ON p.user_type_id = t.user_type_id
WHERE o.name = 'spGestionSocios_ActualizarSocio'
ORDER BY p.parameter_id

PRINT ''

-- Verificar parámetros de spGestionSocios_EliminarAsociado
PRINT '3. Parámetros de spGestionSocios_EliminarAsociado:'
SELECT 
    p.name as parameter_name,
    t.name as data_type,
    p.max_length,
    p.is_output
FROM sys.parameters p
INNER JOIN sys.objects o ON p.object_id = o.object_id
INNER JOIN sys.types t ON p.user_type_id = t.user_type_id
WHERE o.name = 'spGestionSocios_EliminarAsociado'
ORDER BY p.parameter_id

PRINT ''
PRINT '=== VERIFICACIÓN COMPLETADA ==='
GO

