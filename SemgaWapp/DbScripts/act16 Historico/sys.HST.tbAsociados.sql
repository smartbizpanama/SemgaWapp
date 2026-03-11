CREATE TABLE [dbo].[sys.HST.tbAsociados](
    
    -- PK HISTORICO
    [IDHst] INT IDENTITY(1,1) NOT NULL,

    -- CAMPOS DE CONTROL HISTORICO
    [FechaProceso] DATETIME NOT NULL DEFAULT(GETDATE()),
    [YearCorte] INT NOT NULL,
    [MonthCorte] INT NOT NULL,
    [Version] INT NOT NULL,
    [UsuarioProceso] INT NULL,

    -- CAMPOS ORIGINALES
    [NumeroAsociado] INT NOT NULL,
    [IdTipoAsociado] INT NOT NULL,
    [Nombre] NVARCHAR(MAX) NULL,
    [SegundoNombre] NVARCHAR(MAX) NULL,
    [Apellido] NVARCHAR(MAX) NULL,
    [SegundoApellido] NVARCHAR(MAX) NULL,
    [Estatus] CHAR(1) NULL,
    [TipoIdentificacion] VARCHAR(10) NULL,
    [NumeroIdentificacion] NVARCHAR(200) NULL,
    [TelefonoResidencia] VARCHAR(50) NULL,
    [TelefonoCelular] VARCHAR(50) NULL,
    [TelefonoFamiliar] VARCHAR(50) NULL,
    [CorreoElectronico] NVARCHAR(MAX) NULL,
    [Sexo] CHAR(1) NULL,
    [FechaNacimiento] DATE NULL,
    [DireccionResidencia] VARCHAR(MAX) NULL,
    [DireccionTrabajo] VARCHAR(MAX) NULL,
    [LugarTrabajo] INT NULL,
    [Ocupacion] INT NULL,
    [PaisTrabajo] NVARCHAR(3) NULL,
    [ProvinciaTrabajo] INT NULL,
    [DistritoTrabajo] INT NULL,
    [CorregimientoTrabajo] INT NULL,
    [PaisResidencia] NVARCHAR(3) NULL,
    [ProvinciaResidencia] INT NULL,
    [DistritoResidencia] INT NULL,
    [CorregimientoResidencia] INT NULL,
    [NivelEstudio] INT NULL,
    [Profesion] INT NULL,
    [FechaCreacion] DATETIME NULL,
    [UsuarioCrea] INT NULL,
    [FechaModificacion] DATETIME NULL,
    [UsuarioModifica] INT NULL,
    [UsuarioElimina] INT NULL,
    [FechaElimina] DATETIME NULL,
    [snEliminado] BIT NOT NULL,
    [SysLastSessionID] VARCHAR(50) NULL,
    [TelefonoTrabajo] NVARCHAR(20) NULL,
    [numaso] INT NULL,

    CONSTRAINT PK_sys_HST_tbAsociados
        PRIMARY KEY CLUSTERED ([IDHst])
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX IX_HST_tbAsociados_PeriodoVersion
ON [dbo].[sys.HST.tbAsociados] (YearCorte, MonthCorte, Version);

CREATE NONCLUSTERED INDEX IX_HST_tbAsociados_NumeroAsociado
ON [dbo].[sys.HST.tbAsociados] (NumeroAsociado);