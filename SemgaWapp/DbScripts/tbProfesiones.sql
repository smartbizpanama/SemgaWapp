-- =============================================
-- CREACIÓN DE TABLA tbProfesiones
-- =============================================

USE SegmaDB;
GO

-- Crear tabla tbProfesiones con la misma estructura que tbNivelesEstudio
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbProfesiones]') AND type in (N'U'))
BEGIN
    CREATE TABLE dbo.tbProfesiones (
        ID INT IDENTITY(1,1) PRIMARY KEY,
        Code INT UNIQUE NOT NULL,
        Descripcion NVARCHAR(100) NOT NULL,
        snEliminado BIT NOT NULL DEFAULT 0
    );
    
    PRINT 'Tabla tbProfesiones creada exitosamente';
END
ELSE
BEGIN
    PRINT 'La tabla tbProfesiones ya existe';
END
GO

-- Insertar datos de ejemplo para profesiones
INSERT INTO dbo.tbProfesiones (Code, Descripcion) VALUES
(1, 'Ingeniero'),
(2, 'Médico'),
(3, 'Abogado'),
(4, 'Contador'),
(5, 'Profesor'),
(6, 'Enfermero'),
(7, 'Arquitecto'),
(8, 'Psicólogo'),
(9, 'Economista'),
(10, 'Administrador'),
(11, 'Técnico'),
(12, 'Comerciante'),
(13, 'Agricultor'),
(14, 'Obrero'),
(15, 'Estudiante'),
(16, 'Ama de Casa'),
(17, 'Jubilado'),
(18, 'Desempleado'),
(19, 'Otro');

PRINT 'Datos de profesiones insertados exitosamente';
GO

-- Verificar datos insertados
SELECT ID, Code, Descripcion, snEliminado FROM tbProfesiones ORDER BY Code;


