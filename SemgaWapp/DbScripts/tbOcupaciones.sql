-- =============================================
-- Script: Crear tabla tbOcupaciones
-- Descripción: Tabla para gestionar las ocupaciones de los asociados
-- Fecha: 2024
-- =============================================

-- Crear tabla tbOcupaciones
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbOcupaciones]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[tbOcupaciones](
        [ID] [int] IDENTITY(1,1) NOT NULL,
        [Code] [int] NOT NULL,
        [Descripcion] [nvarchar](100) NOT NULL,
        [snEliminado] [bit] NOT NULL DEFAULT(0),
        CONSTRAINT [PK_tbOcupaciones] PRIMARY KEY CLUSTERED ([ID] ASC)
    )
    
    PRINT '✅ Tabla tbOcupaciones creada exitosamente'
END
ELSE
BEGIN
    PRINT '⚠️ La tabla tbOcupaciones ya existe'
END
GO

-- Insertar datos ficticios
INSERT INTO tbOcupaciones (Code, Descripcion, snEliminado) VALUES
(1, 'Ingeniero de Sistemas', 0),
(2, 'Contador Público', 0),
(3, 'Médico General', 0),
(4, 'Abogado', 0),
(5, 'Profesor', 0);

PRINT '✅ Datos de prueba insertados en tbOcupaciones'
GO

-- Verificar datos insertados
SELECT 'Verificación de datos insertados:' as Mensaje
SELECT ID, Code, Descripcion, snEliminado FROM tbOcupaciones ORDER BY Code
GO

