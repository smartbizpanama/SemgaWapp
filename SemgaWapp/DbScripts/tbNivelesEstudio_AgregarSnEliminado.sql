-- Script para agregar el campo snEliminado a la tabla tbNivelesEstudio
-- Este campo es necesario para el sistema de eliminación lógica

-- Agregar el campo snEliminado si no existe
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('dbo.tbNivelesEstudio') AND name = 'snEliminado')
BEGIN
    ALTER TABLE dbo.tbNivelesEstudio 
    ADD snEliminado BIT NOT NULL DEFAULT 0;
    
    PRINT 'Campo snEliminado agregado a tbNivelesEstudio';
END
ELSE
BEGIN
    PRINT 'El campo snEliminado ya existe en tbNivelesEstudio';
END

-- Verificar que el campo se agregó correctamente
SELECT 
    COLUMN_NAME,
    DATA_TYPE,
    IS_NULLABLE,
    COLUMN_DEFAULT
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'tbNivelesEstudio' 
AND COLUMN_NAME = 'snEliminado';


