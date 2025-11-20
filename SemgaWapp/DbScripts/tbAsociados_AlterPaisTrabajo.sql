-- =============================================
-- Script: Agregar campo PaisTrabajo a tbAsociados
-- Descripción: Agregar campo para almacenar código de país de trabajo
-- Fecha: 2024
-- =============================================

PRINT 'Iniciando alteración de la tabla tbAsociados para el campo PaisTrabajo...'
GO

-- Verificar el estado actual de la tabla
PRINT '🔍 Estado actual de la tabla tbAsociados:'
SELECT COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH, IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'tbAsociados' AND COLUMN_NAME IN ('PaisTrabajo', 'ProvinciaTrabajo', 'DistritoTrabajo', 'CorregimientoTrabajo');
GO

-- 1. Agregar el campo PaisTrabajo si no existe
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('tbAsociados') AND name = 'PaisTrabajo')
BEGIN
    ALTER TABLE tbAsociados ADD PaisTrabajo NVARCHAR(3) NULL;
    PRINT '✅ Campo PaisTrabajo agregado a tbAsociados'
END
ELSE
BEGIN
    PRINT '⚠️ Campo PaisTrabajo ya existe en tbAsociados'
END
GO

-- 2. Actualizar todos los registros existentes con el código de Panamá (PA)
UPDATE tbAsociados 
SET PaisTrabajo = 'PA'
WHERE PaisTrabajo IS NULL;

PRINT '✅ Todos los registros actualizados con código de país PA (Panamá)'
GO

-- 3. Verificar la actualización
PRINT 'Verificación de registros actualizados:'
SELECT COUNT(*) as TotalRegistros, 
       COUNT(CASE WHEN PaisTrabajo = 'PA' THEN 1 END) as RegistrosConPA,
       COUNT(CASE WHEN PaisTrabajo IS NULL THEN 1 END) as RegistrosSinPais
FROM tbAsociados;
GO

-- 4. Mostrar muestra de registros actualizados
PRINT 'Muestra de registros actualizados:'
SELECT TOP 5 NumeroAsociado, Nombre, Apellido, PaisTrabajo, ProvinciaTrabajo, DistritoTrabajo 
FROM tbAsociados 
WHERE PaisTrabajo IS NOT NULL;
GO

PRINT '✅ Alteración de la tabla tbAsociados para el campo PaisTrabajo completada.'
GO

