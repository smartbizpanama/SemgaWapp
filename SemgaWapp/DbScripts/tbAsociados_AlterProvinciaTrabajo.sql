-- =============================================
-- Script: Agregar campo ProvinciaTrabajo a tbAsociados
-- Descripción: Agregar campo para almacenar código de provincia de trabajo
-- Fecha: 2024
-- =============================================

PRINT 'Iniciando alteración de la tabla tbAsociados para el campo ProvinciaTrabajo...'
GO

-- Verificar el estado actual de la tabla
PRINT '🔍 Estado actual de la tabla tbAsociados:'
SELECT COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH, IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'tbAsociados' AND COLUMN_NAME IN ('ProvinciaTrabajo', 'DistritoTrabajo', 'CorregimientoTrabajo');
GO

-- 1. Agregar el campo ProvinciaTrabajo si no existe
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('tbAsociados') AND name = 'ProvinciaTrabajo')
BEGIN
    ALTER TABLE tbAsociados ADD ProvinciaTrabajo INT NULL;
    PRINT '✅ Campo ProvinciaTrabajo agregado a tbAsociados'
END
ELSE
BEGIN
    PRINT '⚠️ Campo ProvinciaTrabajo ya existe en tbAsociados'
END
GO

-- 2. Actualizar todos los registros existentes con el código de Panamá (8)
UPDATE tbAsociados 
SET ProvinciaTrabajo = 8
WHERE ProvinciaTrabajo IS NULL;

PRINT '✅ Todos los registros actualizados con código de provincia 8 (Panamá)'
GO

-- 3. Verificar la actualización
PRINT 'Verificación de registros actualizados:'
SELECT COUNT(*) as TotalRegistros, 
       COUNT(CASE WHEN ProvinciaTrabajo = 8 THEN 1 END) as RegistrosConPanama,
       COUNT(CASE WHEN ProvinciaTrabajo IS NULL THEN 1 END) as RegistrosSinProvincia
FROM tbAsociados;
GO

-- 4. Mostrar muestra de registros actualizados
PRINT 'Muestra de registros actualizados:'
SELECT TOP 5 NumeroAsociado, Nombre, Apellido, ProvinciaTrabajo, DistritoTrabajo 
FROM tbAsociados 
WHERE ProvinciaTrabajo IS NOT NULL;
GO

PRINT '✅ Alteración de la tabla tbAsociados para el campo ProvinciaTrabajo completada.'
GO

