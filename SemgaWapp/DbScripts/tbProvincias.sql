-- =============================================
-- Script: Crear tabla tbProvincias con datos de provincias de Panamá
-- Descripción: Tabla para almacenar provincias de Panamá
-- Fecha: 2024
-- =============================================

PRINT 'Creando tabla tbProvincias...'
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbProvincias]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[tbProvincias](
        [ID] [int] IDENTITY(1,1) NOT NULL,
        [Code] [int] NOT NULL,
        [CodePais] [nvarchar](3) NOT NULL,
        [Descripcion] [nvarchar](100) NOT NULL,
        [snEliminado] [bit] NOT NULL CONSTRAINT [DF_tbProvincias_snEliminado] DEFAULT ((0)),
     CONSTRAINT [PK_tbProvincias] PRIMARY KEY CLUSTERED 
    (
        [ID] ASC
    )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
    ) ON [PRIMARY]
END
PRINT '✅ Tabla tbProvincias creada exitosamente'
GO

PRINT 'Insertando datos de provincias de Panamá...'

-- Insertar provincias de Panamá
INSERT INTO tbProvincias (Code, CodePais, Descripcion) VALUES (1, 'PA', 'Bocas del Toro');
INSERT INTO tbProvincias (Code, CodePais, Descripcion) VALUES (2, 'PA', 'Cocle');
INSERT INTO tbProvincias (Code, CodePais, Descripcion) VALUES (3, 'PA', 'Colon');
INSERT INTO tbProvincias (Code, CodePais, Descripcion) VALUES (4, 'PA', 'Chiriqui');
INSERT INTO tbProvincias (Code, CodePais, Descripcion) VALUES (5, 'PA', 'Darien');
INSERT INTO tbProvincias (Code, CodePais, Descripcion) VALUES (6, 'PA', 'Herrera');
INSERT INTO tbProvincias (Code, CodePais, Descripcion) VALUES (7, 'PA', 'Los Santos');
INSERT INTO tbProvincias (Code, CodePais, Descripcion) VALUES (8, 'PA', 'Panama');
INSERT INTO tbProvincias (Code, CodePais, Descripcion) VALUES (9, 'PA', 'Panama Oeste');
INSERT INTO tbProvincias (Code, CodePais, Descripcion) VALUES (10, 'PA', 'Veraguas');

PRINT '✅ Datos de provincias insertados exitosamente'
GO

PRINT 'Verificación de datos insertados:'
SELECT COUNT(*) as TotalProvincias FROM tbProvincias;
SELECT Code, CodePais, Descripcion, snEliminado FROM tbProvincias ORDER BY Code;
GO

