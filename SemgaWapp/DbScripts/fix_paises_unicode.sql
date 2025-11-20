-- =============================================
-- Script: Corregir países con tildes correctas usando Unicode
-- Descripción: Usar N' para forzar codificación Unicode correcta
-- Fecha: 2024
-- =============================================

PRINT 'Corrigiendo países con tildes correctas usando Unicode...'
GO

-- Países con tildes y acentos correctos usando N' para Unicode
UPDATE tbPaises SET Descripcion = N'Panamá' WHERE Code = 'PA';
UPDATE tbPaises SET Descripcion = N'Canadá' WHERE Code = 'CA';
UPDATE tbPaises SET Descripcion = N'México' WHERE Code = 'MX';
UPDATE tbPaises SET Descripcion = N'Perú' WHERE Code = 'PE';
UPDATE tbPaises SET Descripcion = N'Bélgica' WHERE Code = 'BE';
UPDATE tbPaises SET Descripcion = N'Suiza' WHERE Code = 'CH';
UPDATE tbPaises SET Descripcion = N'Austria' WHERE Code = 'AT';
UPDATE tbPaises SET Descripcion = N'Suecia' WHERE Code = 'SE';
UPDATE tbPaises SET Descripcion = N'Noruega' WHERE Code = 'NO';
UPDATE tbPaises SET Descripcion = N'Dinamarca' WHERE Code = 'DK';
UPDATE tbPaises SET Descripcion = N'Finlandia' WHERE Code = 'FI';
UPDATE tbPaises SET Descripcion = N'Polonia' WHERE Code = 'PL';
UPDATE tbPaises SET Descripcion = N'Rusia' WHERE Code = 'RU';
UPDATE tbPaises SET Descripcion = N'Ucrania' WHERE Code = 'UA';
UPDATE tbPaises SET Descripcion = N'Grecia' WHERE Code = 'GR';
UPDATE tbPaises SET Descripcion = N'Turquía' WHERE Code = 'TR';
UPDATE tbPaises SET Descripcion = N'China' WHERE Code = 'CN';
UPDATE tbPaises SET Descripcion = N'Japón' WHERE Code = 'JP';
UPDATE tbPaises SET Descripcion = N'Corea del Sur' WHERE Code = 'KR';
UPDATE tbPaises SET Descripcion = N'India' WHERE Code = 'IN';
UPDATE tbPaises SET Descripcion = N'Tailandia' WHERE Code = 'TH';
UPDATE tbPaises SET Descripcion = N'Singapur' WHERE Code = 'SG';
UPDATE tbPaises SET Descripcion = N'Malasia' WHERE Code = 'MY';
UPDATE tbPaises SET Descripcion = N'Indonesia' WHERE Code = 'ID';
UPDATE tbPaises SET Descripcion = N'Filipinas' WHERE Code = 'PH';
UPDATE tbPaises SET Descripcion = N'Vietnam' WHERE Code = 'VN';
UPDATE tbPaises SET Descripcion = N'Taiwán' WHERE Code = 'TW';
UPDATE tbPaises SET Descripcion = N'Hong Kong' WHERE Code = 'HK';
UPDATE tbPaises SET Descripcion = N'Israel' WHERE Code = 'IL';
UPDATE tbPaises SET Descripcion = N'Emiratos Árabes Unidos' WHERE Code = 'AE';
UPDATE tbPaises SET Descripcion = N'Arabia Saudí' WHERE Code = 'SA';
UPDATE tbPaises SET Descripcion = N'Sudáfrica' WHERE Code = 'ZA';
UPDATE tbPaises SET Descripcion = N'Egipto' WHERE Code = 'EG';
UPDATE tbPaises SET Descripcion = N'Nigeria' WHERE Code = 'NG';
UPDATE tbPaises SET Descripcion = N'Kenia' WHERE Code = 'KE';
UPDATE tbPaises SET Descripcion = N'Marruecos' WHERE Code = 'MA';
UPDATE tbPaises SET Descripcion = N'Túnez' WHERE Code = 'TN';
UPDATE tbPaises SET Descripcion = N'Argelia' WHERE Code = 'DZ';
UPDATE tbPaises SET Descripcion = N'Ghana' WHERE Code = 'GH';
UPDATE tbPaises SET Descripcion = N'Etiopía' WHERE Code = 'ET';
UPDATE tbPaises SET Descripcion = N'Australia' WHERE Code = 'AU';
UPDATE tbPaises SET Descripcion = N'Nueva Zelanda' WHERE Code = 'NZ';
UPDATE tbPaises SET Descripcion = N'Fiyi' WHERE Code = 'FJ';
UPDATE tbPaises SET Descripcion = N'Papúa Nueva Guinea' WHERE Code = 'PG';

PRINT '✅ Países corregidos con tildes correctas usando Unicode'
GO

-- Verificar los cambios
PRINT 'Verificación de países con tildes correctas:'
SELECT Code, Descripcion FROM tbPaises WHERE Code IN ('PA', 'CA', 'MX', 'PE', 'BE', 'CH', 'AT', 'SE', 'NO', 'DK', 'FI', 'PL', 'RU', 'UA', 'GR', 'TR', 'CN', 'JP', 'KR', 'IN', 'TH', 'SG', 'MY', 'ID', 'PH', 'VN', 'TW', 'HK', 'IL', 'AE', 'SA', 'ZA', 'EG', 'NG', 'KE', 'MA', 'TN', 'DZ', 'GH', 'ET', 'AU', 'NZ', 'FJ', 'PG') ORDER BY Code;
GO

