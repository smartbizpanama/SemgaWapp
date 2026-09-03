DROP TABLE IF EXISTS tbCuentas_LogSaldos
GO

BEGIN
    CREATE TABLE [dbo].[tbCuentas_LogSaldos](
        [ID]                    [int] IDENTITY(1,1) NOT NULL,
        [IDCuenta]              [int] NOT NULL,
        [Cuenta]                [varchar](50) NULL,
        [SaldoAnterior]         [numeric](18, 2) NULL,
        [SaldoNuevo]            [numeric](18, 2) NULL,
        [FechaHoraModificacion] [datetime] NOT NULL CONSTRAINT [DF_tbCuentas_LogSaldos_Fecha] DEFAULT (GETDATE()),
        [Usuario]               [int] NULL,
        [Motivo]                [nvarchar](500) NULL,
        [SysLastSessionID]      [nvarchar](50) NULL,
        CONSTRAINT [PK_tbCuentas_LogSaldos] PRIMARY KEY CLUSTERED ([ID] ASC)
    ) ON [PRIMARY];

    CREATE INDEX [IX_tbCuentas_LogSaldos_IDCuenta]
        ON [dbo].[tbCuentas_LogSaldos] ([IDCuenta]);
END
GO