-- =============================================
-- CREACIÓN DE TABLA tbEmpresas
-- =============================================

USE SegmaDB;
GO

-- Crear tabla tbEmpresas
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbEmpresas]') AND type in (N'U'))
BEGIN
    CREATE TABLE dbo.tbEmpresas (
        ID INT IDENTITY(1,1) PRIMARY KEY,
        Code INT UNIQUE NOT NULL,
        Descripcion NVARCHAR(100) NOT NULL,
        snEliminado BIT NOT NULL DEFAULT 0
    );
    
    PRINT 'Tabla tbEmpresas creada exitosamente';
END
ELSE
BEGIN
    PRINT 'La tabla tbEmpresas ya existe';
END
GO

-- Insertar datos ficticios de empresas
INSERT INTO dbo.tbEmpresas (Code, Descripcion) VALUES
(1, 'Cooperativa Coopsemga'),
(2, 'Banco Nacional de Panamá'),
(3, 'Caja de Ahorros'),
(4, 'Banco General'),
(5, 'Banistmo');

PRINT 'Datos de empresas insertados exitosamente';
GO

-- Verificar datos insertados
SELECT ID, Code, Descripcion, snEliminado FROM tbEmpresas ORDER BY Code;


