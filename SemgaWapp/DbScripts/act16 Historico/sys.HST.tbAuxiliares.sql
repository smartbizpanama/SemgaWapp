CREATE TABLE [dbo].[sys.HST.tbAuxiliares](
    
    -- PK HISTORICO
    [IDHst] INT IDENTITY(1,1) NOT NULL,

    -- CAMPOS DE CONTROL HISTORICO
    [FechaProceso] DATETIME NOT NULL DEFAULT(GETDATE()),
    [YearCorte] INT NOT NULL,
    [MonthCorte] INT NOT NULL,
    [Version] INT NOT NULL,
    [UsuarioProceso] INT NULL,

    -- CAMPOS ORIGINALES (ID ya no es PK ni Identity)
    [ID] INT NOT NULL,
    [NumeroAsociado] INT NOT NULL,
    [CodigoRubro] VARCHAR(5) NULL,
    [TipoAuxiliar] INT NULL,
    [Cuota] NUMERIC(18, 2) NULL,
    [Saldo] NUMERIC(18, 2) NULL,
    [FechaCreacion] DATETIME NULL,
    [FechaModificacion] DATETIME NULL,
    [UsuarioCrea] INT NULL,
    [UsuarioModifica] INT NULL,
    [MontoOriginal] NUMERIC(18, 2) NULL,
    [FechaOtorgado] DATETIME NULL,
    [TasaInteres] NUMERIC(18, 2) NULL,
    [PagoMes] NUMERIC(18, 2) NULL,
    [InteresCalculado] NUMERIC(18, 2) NULL,
    [InteresPagado] NUMERIC(18, 2) NULL,
    [FechaUltimoPago] DATETIME NULL,
    [FechaUltimoRetiro] DATETIME NULL,
    [snEliminado] BIT NULL,
    [MontoPignorado] NUMERIC(18, 2) NULL,
    [UsuarioElimina] NVARCHAR(50) NULL,
    [FechaElimina] DATETIME NULL,
    [SysLastSessionID] VARCHAR(50) NULL,
    [FechaUltPagoInteres] DATETIME NULL,
    [FechaUltCalculoInteres] DATE NULL,
    [snActivo] BIT NULL,
    [PorcManejo] NUMERIC(19, 6) NULL,
    [MontoManejo] NUMERIC(19, 6) NULL,
    [PorcCapitalizacion] NUMERIC(19, 6) NULL,
    [MontoCapitalizacion] NUMERIC(19, 6) NULL,
    [FechaVencimiento] DATE NULL,

    CONSTRAINT PK_sys_HST_tbAuxiliares
        PRIMARY KEY CLUSTERED ([IDHst])
) ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX IX_HST_tbAuxiliares_PeriodoVersion
ON [dbo].[sys.HST.tbAuxiliares] (YearCorte, MonthCorte, Version);

CREATE NONCLUSTERED INDEX IX_HST_tbAuxiliares_ID
ON [dbo].[sys.HST.tbAuxiliares] (ID);

CREATE NONCLUSTERED INDEX IX_HST_tbAuxiliares_NumeroAsociado
ON [dbo].[sys.HST.tbAuxiliares] (NumeroAsociado);