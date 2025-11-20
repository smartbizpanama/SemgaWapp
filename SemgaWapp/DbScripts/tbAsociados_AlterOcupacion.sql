-- =============================================
-- Script: Modificar campo Ocupacion en tbAsociados
-- Descripción: Cambiar Ocupacion de VARCHAR a INT para guardar Code de tbOcupaciones
-- Fecha: 2024
-- =============================================

-- Verificar el tipo actual del campo Ocupacion
SELECT 
    COLUMN_NAME,
    DATA_TYPE,
    CHARACTER_MAXIMUM_LENGTH,
    IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'tbAsociados' AND COLUMN_NAME = 'Ocupacion'

PRINT '📋 Estado actual del campo Ocupacion:'
GO

-- Agregar nueva columna temporal como INT
ALTER TABLE tbAsociados 
ADD OcupacionNew INT NULL

PRINT '✅ Columna temporal OcupacionNew agregada'
GO

-- Actualizar la nueva columna con el Code 1 para todos los registros existentes
UPDATE tbAsociados 
SET OcupacionNew = 1
WHERE OcupacionNew IS NULL

PRINT '✅ Todos los registros actualizados con Code 1'
GO

-- Eliminar la columna original
ALTER TABLE tbAsociados 
DROP COLUMN Ocupacion

PRINT '✅ Columna original Ocupacion eliminada'
GO

-- Renombrar la nueva columna
EXEC sp_rename 'tbAsociados.OcupacionNew', 'Ocupacion', 'COLUMN'

PRINT '✅ Columna renombrada a Ocupacion'
GO

-- Verificar el cambio
SELECT 
    COLUMN_NAME,
    DATA_TYPE,
    IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'tbAsociados' AND COLUMN_NAME = 'Ocupacion'

PRINT '📋 Estado final del campo Ocupacion:'
GO

-- Verificar algunos registros
SELECT TOP 5 
    NumeroAsociado,
    Nombre,
    Apellido,
    Ocupacion
FROM tbAsociados

PRINT '📋 Muestra de registros actualizados:'
GO

