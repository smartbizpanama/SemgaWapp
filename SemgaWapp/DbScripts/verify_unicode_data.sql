-- =============================================
-- Script: Verificar que los datos Unicode se guardaron correctamente
-- Descripción: Consultar los datos para verificar la codificación
-- Fecha: 2024
-- =============================================

PRINT 'Verificando datos Unicode en tbPaises...'
GO

-- Verificar algunos países específicos
SELECT 
    Code,
    Descripcion,
    LEN(Descripcion) as Longitud,
    ASCII(SUBSTRING(Descripcion, 1, 1)) as ASCII_Primer_Caracter
FROM tbPaises 
WHERE Code IN ('PA', 'CA', 'MX', 'PE', 'BE', 'TR', 'JP', 'SA', 'AE', 'ZA')
ORDER BY Code;
GO

-- Verificar que no hay caracteres de reemplazo ()
SELECT Code, Descripcion 
FROM tbPaises 
WHERE Descripcion LIKE '%%'
ORDER BY Code;
GO

-- Contar países con caracteres especiales
SELECT 
    COUNT(*) as TotalPaises,
    COUNT(CASE WHEN Descripcion LIKE '%á%' OR Descripcion LIKE '%é%' OR Descripcion LIKE '%í%' OR Descripcion LIKE '%ó%' OR Descripcion LIKE '%ú%' THEN 1 END) as ConTildes,
    COUNT(CASE WHEN Descripcion LIKE '%ñ%' THEN 1 END) as ConN,
    COUNT(CASE WHEN Descripcion LIKE '%ü%' THEN 1 END) as ConUmlaut
FROM tbPaises 
WHERE snEliminado = 0;
GO

