-- =============================================
-- Script: Corregir codificación de caracteres en tbPaises
-- Descripción: Actualizar nombres de países con tildes y acentos correctos
-- Fecha: 2024
-- =============================================

PRINT 'Corrigiendo codificación de caracteres en tbPaises...'
GO

-- Países con tildes y acentos
UPDATE tbPaises SET Descripcion = 'Panamá' WHERE Code = 'PA';
UPDATE tbPaises SET Descripcion = 'Canadá' WHERE Code = 'CA';
UPDATE tbPaises SET Descripcion = 'México' WHERE Code = 'MX';
UPDATE tbPaises SET Descripcion = 'Perú' WHERE Code = 'PE';
UPDATE tbPaises SET Descripcion = 'Bélgica' WHERE Code = 'BE';
UPDATE tbPaises SET Descripcion = 'Suiza' WHERE Code = 'CH';
UPDATE tbPaises SET Descripcion = 'Austria' WHERE Code = 'AT';
UPDATE tbPaises SET Descripcion = 'Suecia' WHERE Code = 'SE';
UPDATE tbPaises SET Descripcion = 'Noruega' WHERE Code = 'NO';
UPDATE tbPaises SET Descripcion = 'Dinamarca' WHERE Code = 'DK';
UPDATE tbPaises SET Descripcion = 'Finlandia' WHERE Code = 'FI';
UPDATE tbPaises SET Descripcion = 'Polonia' WHERE Code = 'PL';
UPDATE tbPaises SET Descripcion = 'Rusia' WHERE Code = 'RU';
UPDATE tbPaises SET Descripcion = 'Ucrania' WHERE Code = 'UA';
UPDATE tbPaises SET Descripcion = 'Grecia' WHERE Code = 'GR';
UPDATE tbPaises SET Descripcion = 'Turquía' WHERE Code = 'TR';
UPDATE tbPaises SET Descripcion = 'China' WHERE Code = 'CN';
UPDATE tbPaises SET Descripcion = 'Japón' WHERE Code = 'JP';
UPDATE tbPaises SET Descripcion = 'Corea del Sur' WHERE Code = 'KR';
UPDATE tbPaises SET Descripcion = 'India' WHERE Code = 'IN';
UPDATE tbPaises SET Descripcion = 'Tailandia' WHERE Code = 'TH';
UPDATE tbPaises SET Descripcion = 'Singapur' WHERE Code = 'SG';
UPDATE tbPaises SET Descripcion = 'Malasia' WHERE Code = 'MY';
UPDATE tbPaises SET Descripcion = 'Indonesia' WHERE Code = 'ID';
UPDATE tbPaises SET Descripcion = 'Filipinas' WHERE Code = 'PH';
UPDATE tbPaises SET Descripcion = 'Vietnam' WHERE Code = 'VN';
UPDATE tbPaises SET Descripcion = 'Taiwán' WHERE Code = 'TW';
UPDATE tbPaises SET Descripcion = 'Hong Kong' WHERE Code = 'HK';
UPDATE tbPaises SET Descripcion = 'Israel' WHERE Code = 'IL';
UPDATE tbPaises SET Descripcion = 'Emiratos Árabes Unidos' WHERE Code = 'AE';
UPDATE tbPaises SET Descripcion = 'Arabia Saudí' WHERE Code = 'SA';
UPDATE tbPaises SET Descripcion = 'Sudáfrica' WHERE Code = 'ZA';
UPDATE tbPaises SET Descripcion = 'Egipto' WHERE Code = 'EG';
UPDATE tbPaises SET Descripcion = 'Nigeria' WHERE Code = 'NG';
UPDATE tbPaises SET Descripcion = 'Kenia' WHERE Code = 'KE';
UPDATE tbPaises SET Descripcion = 'Marruecos' WHERE Code = 'MA';
UPDATE tbPaises SET Descripcion = 'Túnez' WHERE Code = 'TN';
UPDATE tbPaises SET Descripcion = 'Argelia' WHERE Code = 'DZ';
UPDATE tbPaises SET Descripcion = 'Ghana' WHERE Code = 'GH';
UPDATE tbPaises SET Descripcion = 'Etiopía' WHERE Code = 'ET';
UPDATE tbPaises SET Descripcion = 'Australia' WHERE Code = 'AU';
UPDATE tbPaises SET Descripcion = 'Nueva Zelanda' WHERE Code = 'NZ';
UPDATE tbPaises SET Descripcion = 'Fiyi' WHERE Code = 'FJ';
UPDATE tbPaises SET Descripcion = 'Papúa Nueva Guinea' WHERE Code = 'PG';

PRINT '✅ Codificación de caracteres corregida'
GO

-- Verificar los cambios
PRINT 'Verificación de países corregidos:'
SELECT TOP 20 Code, Descripcion FROM tbPaises WHERE snEliminado = 0 ORDER BY Descripcion;
GO

