USE [SegmaDB]
GO

-- Verificar si hay auxiliares eliminados con informacion de auditoria
SELECT 
    ID,
    NumeroAsociado,
    snEliminado,
    UsuarioElimina,
    FechaElimina,
    EquipoElimina,
    FechaModificacion,
    UsuarioModifica
FROM tbAuxiliares 
WHERE snEliminado = 1
ORDER BY FechaElimina DESC
GO

-- Verificar la estructura de la tabla
SELECT 
    COLUMN_NAME,
    DATA_TYPE,
    IS_NULLABLE,
    CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'tbAuxiliares' 
AND COLUMN_NAME LIKE '%Elimina%'
ORDER BY ORDINAL_POSITION
GO

