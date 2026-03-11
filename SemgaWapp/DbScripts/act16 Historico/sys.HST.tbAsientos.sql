CREATE TABLE [dbo].[sys.HST.tbAsientos](
    
    -- PK HISTORICO
    [IDHst] INT IDENTITY(1,1) NOT NULL,
    
    -- CAMPOS DE CONTROL HISTORICO
    [FechaProceso] DATETIME NOT NULL DEFAULT(GETDATE()),
    [YearCorte] INT NOT NULL,
    [MonthCorte] INT NOT NULL,
    [Version] INT NOT NULL,
    [UsuarioProceso] INT NULL,

    -- CAMPOS ORIGINALES (SIN IDENTITY)
    [ID] INT NOT NULL,
    [Fecha] DATETIME NULL,
    [CodTipoAsiento] VARCHAR(10) NULL,
    [BaseID] INT NULL,
    [Cuenta] VARCHAR(50) NULL,
    [Debito] NUMERIC(18, 2) NULL,
    [Credito] NUMERIC(18, 2) NULL,
    [Memo] NVARCHAR(MAX) NULL,
    [snEliminado] BIT NULL,
    [BaseType] NVARCHAR(100) NULL,

    CONSTRAINT PK_sys_HST_tbAsientos 
        PRIMARY KEY CLUSTERED ([IDHst])
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO