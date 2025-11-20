-- =============================================
-- Script: Crear tabla tbPaises con datos de países reconocidos internacionalmente
-- Descripción: Tabla para almacenar países con códigos ISO
-- Fecha: 2024
-- =============================================

PRINT 'Creando tabla tbPaises...'
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbPaises]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[tbPaises](
        [ID] [int] IDENTITY(1,1) NOT NULL,
        [Code] [nvarchar](3) NOT NULL,
        [Descripcion] [nvarchar](100) NOT NULL,
        [snEliminado] [bit] NOT NULL CONSTRAINT [DF_tbPaises_snEliminado] DEFAULT ((0)),
     CONSTRAINT [PK_tbPaises] PRIMARY KEY CLUSTERED 
    (
        [ID] ASC
    )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
    ) ON [PRIMARY]
END
PRINT '✅ Tabla tbPaises creada exitosamente'
GO

PRINT 'Insertando datos de países reconocidos internacionalmente...'

-- Países de América
IF NOT EXISTS (SELECT 1 FROM tbPaises WHERE Code = 'PA') INSERT INTO tbPaises (Code, Descripcion) VALUES ('PA', 'Panamá');
IF NOT EXISTS (SELECT 1 FROM tbPaises WHERE Code = 'US') INSERT INTO tbPaises (Code, Descripcion) VALUES ('US', 'Estados Unidos');
IF NOT EXISTS (SELECT 1 FROM tbPaises WHERE Code = 'CA') INSERT INTO tbPaises (Code, Descripcion) VALUES ('CA', 'Canadá');
IF NOT EXISTS (SELECT 1 FROM tbPaises WHERE Code = 'MX') INSERT INTO tbPaises (Code, Descripcion) VALUES ('MX', 'México');
IF NOT EXISTS (SELECT 1 FROM tbPaises WHERE Code = 'BR') INSERT INTO tbPaises (Code, Descripcion) VALUES ('BR', 'Brasil');
IF NOT EXISTS (SELECT 1 FROM tbPaises WHERE Code = 'AR') INSERT INTO tbPaises (Code, Descripcion) VALUES ('AR', 'Argentina');
IF NOT EXISTS (SELECT 1 FROM tbPaises WHERE Code = 'CL') INSERT INTO tbPaises (Code, Descripcion) VALUES ('CL', 'Chile');
IF NOT EXISTS (SELECT 1 FROM tbPaises WHERE Code = 'CO') INSERT INTO tbPaises (Code, Descripcion) VALUES ('CO', 'Colombia');
IF NOT EXISTS (SELECT 1 FROM tbPaises WHERE Code = 'PE') INSERT INTO tbPaises (Code, Descripcion) VALUES ('PE', 'Perú');
IF NOT EXISTS (SELECT 1 FROM tbPaises WHERE Code = 'VE') INSERT INTO tbPaises (Code, Descripcion) VALUES ('VE', 'Venezuela');
IF NOT EXISTS (SELECT 1 FROM tbPaises WHERE Code = 'EC') INSERT INTO tbPaises (Code, Descripcion) VALUES ('EC', 'Ecuador');
IF NOT EXISTS (SELECT 1 FROM tbPaises WHERE Code = 'UY') INSERT INTO tbPaises (Code, Descripcion) VALUES ('UY', 'Uruguay');
IF NOT EXISTS (SELECT 1 FROM tbPaises WHERE Code = 'PY') INSERT INTO tbPaises (Code, Descripcion) VALUES ('PY', 'Paraguay');
IF NOT EXISTS (SELECT 1 FROM tbPaises WHERE Code = 'BO') INSERT INTO tbPaises (Code, Descripcion) VALUES ('BO', 'Bolivia');
IF NOT EXISTS (SELECT 1 FROM tbPaises WHERE Code = 'GY') INSERT INTO tbPaises (Code, Descripcion) VALUES ('GY', 'Guyana');
IF NOT EXISTS (SELECT 1 FROM tbPaises WHERE Code = 'SR') INSERT INTO tbPaises (Code, Descripcion) VALUES ('SR', 'Surinam');
IF NOT EXISTS (SELECT 1 FROM tbPaises WHERE Code = 'GF') INSERT INTO tbPaises (Code, Descripcion) VALUES ('GF', 'Guayana Francesa');
IF NOT EXISTS (SELECT 1 FROM tbPaises WHERE Code = 'CU') INSERT INTO tbPaises (Code, Descripcion) VALUES ('CU', 'Cuba');
IF NOT EXISTS (SELECT 1 FROM tbPaises WHERE Code = 'JM') INSERT INTO tbPaises (Code, Descripcion) VALUES ('JM', 'Jamaica');
IF NOT EXISTS (SELECT 1 FROM tbPaises WHERE Code = 'HT') INSERT INTO tbPaises (Code, Descripcion) VALUES ('HT', 'Haití');
IF NOT EXISTS (SELECT 1 FROM tbPaises WHERE Code = 'DO') INSERT INTO tbPaises (Code, Descripcion) VALUES ('DO', 'República Dominicana');
IF NOT EXISTS (SELECT 1 FROM tbPaises WHERE Code = 'PR') INSERT INTO tbPaises (Code, Descripcion) VALUES ('PR', 'Puerto Rico');
IF NOT EXISTS (SELECT 1 FROM tbPaises WHERE Code = 'CR') INSERT INTO tbPaises (Code, Descripcion) VALUES ('CR', 'Costa Rica');
IF NOT EXISTS (SELECT 1 FROM tbPaises WHERE Code = 'NI') INSERT INTO tbPaises (Code, Descripcion) VALUES ('NI', 'Nicaragua');
IF NOT EXISTS (SELECT 1 FROM tbPaises WHERE Code = 'HN') INSERT INTO tbPaises (Code, Descripcion) VALUES ('HN', 'Honduras');
IF NOT EXISTS (SELECT 1 FROM tbPaises WHERE Code = 'GT') INSERT INTO tbPaises (Code, Descripcion) VALUES ('GT', 'Guatemala');
IF NOT EXISTS (SELECT 1 FROM tbPaises WHERE Code = 'BZ') INSERT INTO tbPaises (Code, Descripcion) VALUES ('BZ', 'Belice');
IF NOT EXISTS (SELECT 1 FROM tbPaises WHERE Code = 'SV') INSERT INTO tbPaises (Code, Descripcion) VALUES ('SV', 'El Salvador');

-- Países de Europa
IF NOT EXISTS (SELECT 1 FROM tbPaises WHERE Code = 'ES') INSERT INTO tbPaises (Code, Descripcion) VALUES ('ES', 'España');
IF NOT EXISTS (SELECT 1 FROM tbPaises WHERE Code = 'FR') INSERT INTO tbPaises (Code, Descripcion) VALUES ('FR', 'Francia');
IF NOT EXISTS (SELECT 1 FROM tbPaises WHERE Code = 'DE') INSERT INTO tbPaises (Code, Descripcion) VALUES ('DE', 'Alemania');
IF NOT EXISTS (SELECT 1 FROM tbPaises WHERE Code = 'IT') INSERT INTO tbPaises (Code, Descripcion) VALUES ('IT', 'Italia');
IF NOT EXISTS (SELECT 1 FROM tbPaises WHERE Code = 'GB') INSERT INTO tbPaises (Code, Descripcion) VALUES ('GB', 'Reino Unido');
IF NOT EXISTS (SELECT 1 FROM tbPaises WHERE Code = 'PT') INSERT INTO tbPaises (Code, Descripcion) VALUES ('PT', 'Portugal');
IF NOT EXISTS (SELECT 1 FROM tbPaises WHERE Code = 'NL') INSERT INTO tbPaises (Code, Descripcion) VALUES ('NL', 'Países Bajos');
IF NOT EXISTS (SELECT 1 FROM tbPaises WHERE Code = 'BE') INSERT INTO tbPaises (Code, Descripcion) VALUES ('BE', 'Bélgica');
IF NOT EXISTS (SELECT 1 FROM tbPaises WHERE Code = 'CH') INSERT INTO tbPaises (Code, Descripcion) VALUES ('CH', 'Suiza');
IF NOT EXISTS (SELECT 1 FROM tbPaises WHERE Code = 'AT') INSERT INTO tbPaises (Code, Descripcion) VALUES ('AT', 'Austria');
IF NOT EXISTS (SELECT 1 FROM tbPaises WHERE Code = 'SE') INSERT INTO tbPaises (Code, Descripcion) VALUES ('SE', 'Suecia');
IF NOT EXISTS (SELECT 1 FROM tbPaises WHERE Code = 'NO') INSERT INTO tbPaises (Code, Descripcion) VALUES ('NO', 'Noruega');
IF NOT EXISTS (SELECT 1 FROM tbPaises WHERE Code = 'DK') INSERT INTO tbPaises (Code, Descripcion) VALUES ('DK', 'Dinamarca');
IF NOT EXISTS (SELECT 1 FROM tbPaises WHERE Code = 'FI') INSERT INTO tbPaises (Code, Descripcion) VALUES ('FI', 'Finlandia');
IF NOT EXISTS (SELECT 1 FROM tbPaises WHERE Code = 'PL') INSERT INTO tbPaises (Code, Descripcion) VALUES ('PL', 'Polonia');
IF NOT EXISTS (SELECT 1 FROM tbPaises WHERE Code = 'RU') INSERT INTO tbPaises (Code, Descripcion) VALUES ('RU', 'Rusia');
IF NOT EXISTS (SELECT 1 FROM tbPaises WHERE Code = 'UA') INSERT INTO tbPaises (Code, Descripcion) VALUES ('UA', 'Ucrania');
IF NOT EXISTS (SELECT 1 FROM tbPaises WHERE Code = 'GR') INSERT INTO tbPaises (Code, Descripcion) VALUES ('GR', 'Grecia');
IF NOT EXISTS (SELECT 1 FROM tbPaises WHERE Code = 'TR') INSERT INTO tbPaises (Code, Descripcion) VALUES ('TR', 'Turquía');

-- Países de Asia
IF NOT EXISTS (SELECT 1 FROM tbPaises WHERE Code = 'CN') INSERT INTO tbPaises (Code, Descripcion) VALUES ('CN', 'China');
IF NOT EXISTS (SELECT 1 FROM tbPaises WHERE Code = 'JP') INSERT INTO tbPaises (Code, Descripcion) VALUES ('JP', 'Japón');
IF NOT EXISTS (SELECT 1 FROM tbPaises WHERE Code = 'KR') INSERT INTO tbPaises (Code, Descripcion) VALUES ('KR', 'Corea del Sur');
IF NOT EXISTS (SELECT 1 FROM tbPaises WHERE Code = 'IN') INSERT INTO tbPaises (Code, Descripcion) VALUES ('IN', 'India');
IF NOT EXISTS (SELECT 1 FROM tbPaises WHERE Code = 'TH') INSERT INTO tbPaises (Code, Descripcion) VALUES ('TH', 'Tailandia');
IF NOT EXISTS (SELECT 1 FROM tbPaises WHERE Code = 'SG') INSERT INTO tbPaises (Code, Descripcion) VALUES ('SG', 'Singapur');
IF NOT EXISTS (SELECT 1 FROM tbPaises WHERE Code = 'MY') INSERT INTO tbPaises (Code, Descripcion) VALUES ('MY', 'Malasia');
IF NOT EXISTS (SELECT 1 FROM tbPaises WHERE Code = 'ID') INSERT INTO tbPaises (Code, Descripcion) VALUES ('ID', 'Indonesia');
IF NOT EXISTS (SELECT 1 FROM tbPaises WHERE Code = 'PH') INSERT INTO tbPaises (Code, Descripcion) VALUES ('PH', 'Filipinas');
IF NOT EXISTS (SELECT 1 FROM tbPaises WHERE Code = 'VN') INSERT INTO tbPaises (Code, Descripcion) VALUES ('VN', 'Vietnam');
IF NOT EXISTS (SELECT 1 FROM tbPaises WHERE Code = 'TW') INSERT INTO tbPaises (Code, Descripcion) VALUES ('TW', 'Taiwán');
IF NOT EXISTS (SELECT 1 FROM tbPaises WHERE Code = 'HK') INSERT INTO tbPaises (Code, Descripcion) VALUES ('HK', 'Hong Kong');
IF NOT EXISTS (SELECT 1 FROM tbPaises WHERE Code = 'IL') INSERT INTO tbPaises (Code, Descripcion) VALUES ('IL', 'Israel');
IF NOT EXISTS (SELECT 1 FROM tbPaises WHERE Code = 'AE') INSERT INTO tbPaises (Code, Descripcion) VALUES ('AE', 'Emiratos Árabes Unidos');
IF NOT EXISTS (SELECT 1 FROM tbPaises WHERE Code = 'SA') INSERT INTO tbPaises (Code, Descripcion) VALUES ('SA', 'Arabia Saudí');

-- Países de África
IF NOT EXISTS (SELECT 1 FROM tbPaises WHERE Code = 'ZA') INSERT INTO tbPaises (Code, Descripcion) VALUES ('ZA', 'Sudáfrica');
IF NOT EXISTS (SELECT 1 FROM tbPaises WHERE Code = 'EG') INSERT INTO tbPaises (Code, Descripcion) VALUES ('EG', 'Egipto');
IF NOT EXISTS (SELECT 1 FROM tbPaises WHERE Code = 'NG') INSERT INTO tbPaises (Code, Descripcion) VALUES ('NG', 'Nigeria');
IF NOT EXISTS (SELECT 1 FROM tbPaises WHERE Code = 'KE') INSERT INTO tbPaises (Code, Descripcion) VALUES ('KE', 'Kenia');
IF NOT EXISTS (SELECT 1 FROM tbPaises WHERE Code = 'MA') INSERT INTO tbPaises (Code, Descripcion) VALUES ('MA', 'Marruecos');
IF NOT EXISTS (SELECT 1 FROM tbPaises WHERE Code = 'TN') INSERT INTO tbPaises (Code, Descripcion) VALUES ('TN', 'Túnez');
IF NOT EXISTS (SELECT 1 FROM tbPaises WHERE Code = 'DZ') INSERT INTO tbPaises (Code, Descripcion) VALUES ('DZ', 'Argelia');
IF NOT EXISTS (SELECT 1 FROM tbPaises WHERE Code = 'GH') INSERT INTO tbPaises (Code, Descripcion) VALUES ('GH', 'Ghana');
IF NOT EXISTS (SELECT 1 FROM tbPaises WHERE Code = 'ET') INSERT INTO tbPaises (Code, Descripcion) VALUES ('ET', 'Etiopía');

-- Países de Oceanía
IF NOT EXISTS (SELECT 1 FROM tbPaises WHERE Code = 'AU') INSERT INTO tbPaises (Code, Descripcion) VALUES ('AU', 'Australia');
IF NOT EXISTS (SELECT 1 FROM tbPaises WHERE Code = 'NZ') INSERT INTO tbPaises (Code, Descripcion) VALUES ('NZ', 'Nueva Zelanda');
IF NOT EXISTS (SELECT 1 FROM tbPaises WHERE Code = 'FJ') INSERT INTO tbPaises (Code, Descripcion) VALUES ('FJ', 'Fiyi');
IF NOT EXISTS (SELECT 1 FROM tbPaises WHERE Code = 'PG') INSERT INTO tbPaises (Code, Descripcion) VALUES ('PG', 'Papúa Nueva Guinea');

PRINT '✅ Datos de países insertados exitosamente'
GO

PRINT 'Verificación de datos insertados:'
SELECT COUNT(*) as TotalPaises FROM tbPaises;
SELECT TOP 10 ID, Code, Descripcion, snEliminado FROM tbPaises ORDER BY Code;
GO

