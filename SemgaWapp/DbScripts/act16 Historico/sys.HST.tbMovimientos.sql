CREATE TABLE [dbo].[sys.HST.tbMovimientos](
    
    -- PK HISTORICO
    [IDHst] INT IDENTITY(1,1) NOT NULL,

    -- CAMPOS DE CONTROL HISTORICO
    [FechaProceso] DATETIME NOT NULL DEFAULT(GETDATE()),
    [YearCorte] INT NOT NULL,
    [MonthCorte] INT NOT NULL,
    [Version] INT NOT NULL,
    [UsuarioProceso] INT NULL,

    -- CAMPOS ORIGINALES (IDMovimiento ya no es PK exclusivo)
    [IDMovimiento] INT NOT NULL,
    [NumeroAsociado] INT NULL,
    [CodigoRubro] VARCHAR(5) NULL,
    [IDAuxiliar] INT NULL,
    [CodigoTransaccion] VARCHAR(10) NULL,
    [FechaMovimiento] DATETIME NULL,
    [Monto] NUMERIC(18, 2) NULL,
    [Saldo] NUMERIC(18, 2) NULL,
    [Observaciones] NVARCHAR(MAX) NULL,
    [FechaCreacion] DATETIME NULL,
    [IDMovIntereses] INT NULL,
    [UsuarioCrea] INT NULL,
    [FechaActualizado] DATETIME NULL,
    [UsuarioActualiza] INT NULL,
    [snEliminado] BIT NULL,
    [snImpreso] BIT NULL,
    [Ref1] NVARCHAR(100) NULL,
    [Ref2] NVARCHAR(100) NULL,
    [tipoauxiliar] INT NULL,
    [IDTransaccion] INT NULL,

    CONSTRAINT PK_sys_HST_tbMovimientos
        PRIMARY KEY CLUSTERED ([IDHst])
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO


CREATE NONCLUSTERED INDEX IX_HST_tbMovimientos_PeriodoVersion
ON [dbo].[sys.HST.tbMovimientos] (YearCorte, MonthCorte, Version);

CREATE NONCLUSTERED INDEX IX_HST_tbMovimientos_IDMovimiento
ON [dbo].[sys.HST.tbMovimientos] (IDMovimiento);

CREATE NONCLUSTERED INDEX IX_HST_tbMovimientos_IDAuxiliar
ON [dbo].[sys.HST.tbMovimientos] (IDAuxiliar);

CREATE NONCLUSTERED INDEX IX_HST_tbMovimientos_NumeroAsociado
ON [dbo].[sys.HST.tbMovimientos] (NumeroAsociado);