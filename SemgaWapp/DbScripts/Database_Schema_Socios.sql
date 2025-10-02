-- =============================================
-- ESQUEMA DE BASE DE DATOS PARA GESTIÓN DE SOCIOS
-- =============================================

USE SemgaBankDB;
GO

-- Tabla de tipos de asociado
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbTipoAsociado]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[tbTipoAsociado] (
        [IdTipoAsociado] INT IDENTITY(1,1) PRIMARY KEY,
        [TipoAsociado] NVARCHAR(100) NOT NULL,
        [Descripcion] NVARCHAR(255) NULL,
        [Activo] BIT NOT NULL DEFAULT 1,
        [FechaCreacion] DATETIME NOT NULL DEFAULT GETDATE(),
        [UsuarioCrea] NVARCHAR(50) NULL,
        [FechaModificacion] DATETIME NULL,
        [UsuarioModifica] NVARCHAR(50) NULL
    );
END
GO

-- Tabla de asociados/socios
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbAsociados]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[tbAsociados] (
        [NumeroAsociado] INT IDENTITY(1,1) PRIMARY KEY,
        [IdTipoAsociado] INT NULL,
        [Nombre] NVARCHAR(100) NULL,
        [SegundoNombre] NVARCHAR(100) NULL,
        [Apellido] NVARCHAR(100) NULL,
        [SegundoApellido] NVARCHAR(100) NULL,
        [Estatus] CHAR(1) NOT NULL DEFAULT 'A', -- A=Activo, I=Inactivo
        [TipoIdentificacion] NVARCHAR(20) NULL,
        [NumeroIdentificacion] NVARCHAR(50) NULL,
        [TelefonoResidencia] NVARCHAR(20) NULL,
        [TelefonoCelular] NVARCHAR(20) NULL,
        [TelefonoFamiliar] NVARCHAR(20) NULL,
        [CorreoElectronico] NVARCHAR(100) NULL,
        [Sexo] CHAR(1) NULL, -- M=Masculino, F=Femenino
        [FechaNacimiento] DATE NULL,
        [ProvinciaResidencia] NVARCHAR(50) NULL,
        [DistritoResidencia] NVARCHAR(50) NULL,
        [CorregimientoResidencia] NVARCHAR(50) NULL,
        [DireccionResidencia] NVARCHAR(200) NULL,
        [ProvinciaTrabajo] NVARCHAR(50) NULL,
        [DistritoTrabajo] NVARCHAR(50) NULL,
        [CorregimientoTrabajo] NVARCHAR(50) NULL,
        [DireccionTrabajo] NVARCHAR(200) NULL,
        [LugarTrabajo] NVARCHAR(100) NULL,
        [Ocupacion] NVARCHAR(100) NULL,
        [NivelEstudio] NVARCHAR(50) NULL,
        [Profesion] NVARCHAR(100) NULL,
        [FechaCreacion] DATETIME NOT NULL DEFAULT GETDATE(),
        [UsuarioCrea] NVARCHAR(50) NULL,
        [FechaModificacion] DATETIME NULL,
        [UsuarioModifica] NVARCHAR(50) NULL,
        [snEliminado] BIT NOT NULL DEFAULT 0,
        
        -- Índices y restricciones
        CONSTRAINT [FK_tbAsociados_tbTipoAsociado] FOREIGN KEY ([IdTipoAsociado]) 
            REFERENCES [dbo].[tbTipoAsociado] ([IdTipoAsociado]),
        CONSTRAINT [UK_tbAsociados_NumeroIdentificacion] UNIQUE ([NumeroIdentificacion])
    );
END
GO

-- Crear índices para mejorar el rendimiento
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[tbAsociados]') AND name = 'IX_tbAsociados_Estatus')
BEGIN
    CREATE INDEX [IX_tbAsociados_Estatus] ON [dbo].[tbAsociados] ([Estatus]);
END
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[tbAsociados]') AND name = 'IX_tbAsociados_IdTipoAsociado')
BEGIN
    CREATE INDEX [IX_tbAsociados_IdTipoAsociado] ON [dbo].[tbAsociados] ([IdTipoAsociado]);
END
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[tbAsociados]') AND name = 'IX_tbAsociados_snEliminado')
BEGIN
    CREATE INDEX [IX_tbAsociados_snEliminado] ON [dbo].[tbAsociados] ([snEliminado]);
END
GO

-- Insertar datos de ejemplo para tipos de asociado
IF NOT EXISTS (SELECT 1 FROM [dbo].[tbTipoAsociado])
BEGIN
    INSERT INTO [dbo].[tbTipoAsociado] ([TipoAsociado], [Descripcion], [UsuarioCrea])
    VALUES 
        ('Socio Ordinario', 'Socio con derechos básicos de la cooperativa', 'SISTEMA'),
        ('Socio Ahorrador', 'Socio que mantiene cuentas de ahorro', 'SISTEMA'),
        ('Socio Prestatario', 'Socio que tiene préstamos activos', 'SISTEMA'),
        ('Socio Honorario', 'Socio con reconocimiento especial', 'SISTEMA'),
        ('Socio Fundador', 'Socio que participó en la fundación', 'SISTEMA');
END
GO

