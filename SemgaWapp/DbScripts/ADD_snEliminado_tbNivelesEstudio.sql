-- =============================================
-- Script: Agregar campo snEliminado a tbNivelesEstudio
-- Descripción: Agrega el campo snEliminado (soft delete) a la tabla tbNivelesEstudio
-- Fecha: $(date)
-- Autor: Sistema Coopsemga
-- =============================================

-- Agregar campo snEliminado a la tabla tbNivelesEstudio
ALTER TABLE tbNivelesEstudio 
ADD snEliminado bit NOT NULL DEFAULT 0;

-- Verificar que el campo se agregó correctamente
SELECT 
    COLUMN_NAME, 
    DATA_TYPE, 
    IS_NULLABLE, 
    COLUMN_DEFAULT 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'tbNivelesEstudio' 
ORDER BY ORDINAL_POSITION;

-- Verificar que todos los registros existentes tienen snEliminado = 0
SELECT * FROM tbNivelesEstudio;

-- =============================================
-- NOTA: Buenas Prácticas
-- =============================================
-- 1. Todas las tablas deben tener el campo snEliminado bit NOT NULL DEFAULT 0
-- 2. Los stored procedures deben filtrar WHERE snEliminado = 0
-- 3. Los JOINs deben incluir AND tabla.snEliminado = 0
-- 4. Para "eliminar" un registro, se actualiza snEliminado = 1 (soft delete)
-- 5. Esto permite mantener integridad referencial y auditoría
-- =============================================


