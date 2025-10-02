-- =============================================
-- ESQUEMA PARA TIPOS DE DOCUMENTO
-- =============================================

USE SemgaBankDB;
GO

-- Tabla de tipos de documento
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbTipoDocumentos]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[tbTipoDocumentos] (
        [CodTipoDoc] CHAR(1) NOT NULL PRIMARY KEY,
        [TipoDocumento] NVARCHAR(50) NOT NULL
    );
END
GO

-- Insertar datos de ejemplo para tipos de documento
IF NOT EXISTS (SELECT 1 FROM [dbo].[tbTipoDocumentos])
BEGIN
    INSERT INTO [dbo].[tbTipoDocumentos] ([CodTipoDoc], [TipoDocumento])
    VALUES 
        ('C', 'Cédula'),
        ('P', 'Pasaporte'),
        ('E', 'Cédula de Extranjería'),
        ('R', 'RUC'),
        ('O', 'Otro');
END
GO

