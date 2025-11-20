-- =============================================
-- MODIFICAR TABLA tbAsociados - CAMPO PROFESION
-- =============================================

USE SegmaDB;
GO

-- Verificar datos actuales en Profesion
PRINT 'Datos actuales en campo Profesion:'
SELECT DISTINCT Profesion, COUNT(*) as Cantidad 
FROM tbAsociados 
WHERE Profesion IS NOT NULL AND Profesion != ''
GROUP BY Profesion
ORDER BY Cantidad DESC;

-- Actualizar todos los registros existentes a profesión por defecto (1 = Ingeniero)
PRINT 'Actualizando registros existentes a profesión por defecto (1 = Ingeniero)...'
UPDATE tbAsociados 
SET Profesion = '1' 
WHERE Profesion IS NOT NULL AND Profesion != '';

-- Cambiar el tipo de columna de NVARCHAR a INT
PRINT 'Cambiando tipo de columna Profesion de NVARCHAR a INT...'
ALTER TABLE tbAsociados 
ALTER COLUMN Profesion INT NULL;

PRINT 'Modificación completada exitosamente';

-- Verificar la nueva estructura
SELECT 
    COLUMN_NAME,
    DATA_TYPE,
    IS_NULLABLE,
    CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'tbAsociados' 
AND COLUMN_NAME = 'Profesion';

-- Verificar datos actualizados
PRINT 'Datos actualizados:'
SELECT Profesion, COUNT(*) as Cantidad 
FROM tbAsociados 
WHERE Profesion IS NOT NULL
GROUP BY Profesion
ORDER BY Profesion;


