USE SegmaDB;
GO

PRINT 'Iniciando conversión de LugarTrabajo de VARCHAR a INT...';

-- Paso 1: Crear columna temporal
ALTER TABLE dbo.tbAsociados ADD LugarTrabajoNew INT NULL;
PRINT 'Columna temporal LugarTrabajoNew creada';

-- Paso 2: Actualizar todos los registros existentes a Code = 1
UPDATE dbo.tbAsociados 
SET LugarTrabajoNew = 1 
WHERE LugarTrabajo IS NOT NULL AND LugarTrabajo != '';
PRINT 'Registros existentes actualizados a Code = 1';

-- Paso 3: Eliminar la columna original
ALTER TABLE dbo.tbAsociados DROP COLUMN LugarTrabajo;
PRINT 'Columna original LugarTrabajo eliminada';

-- Paso 4: Renombrar la columna temporal
EXEC sp_rename 'dbo.tbAsociados.LugarTrabajoNew', 'LugarTrabajo', 'COLUMN';
PRINT 'Columna renombrada exitosamente';

-- Paso 5: Agregar restricción de clave foránea
ALTER TABLE dbo.tbAsociados 
ADD CONSTRAINT FK_tbAsociados_tbEmpresas 
FOREIGN KEY (LugarTrabajo) REFERENCES dbo.tbEmpresas(Code);
PRINT 'Restricción de clave foránea agregada';

-- Verificación final
SELECT COLUMN_NAME, DATA_TYPE 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'tbAsociados' AND COLUMN_NAME = 'LugarTrabajo';

PRINT 'Conversión completada exitosamente';

