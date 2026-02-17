DROP TABLE IF EXISTS [dbo].[tbCodigosTransaccion]


CREATE TABLE [dbo].[tbCodigosTransaccion](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[CodigoRubro] [varchar](5) NULL,
	[IdTipoAuxiliar] [int] NULL,
	[CodigoTransaccion] [varchar](10) NULL,
	[Descripcion] [nvarchar](150) NULL,
	[DebCred] [char](1) NULL,
	[CuentaContable] [varchar](50) NULL,
	[SnActivo] [bit] NULL,
	[SnEliminado] [bit] NULL,
	[ContraCuenta] [varchar](50) NULL,
 CONSTRAINT [PK_tbCodigosTransaccion] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_tbCodigosTransaccion_Codigo] UNIQUE NONCLUSTERED 
(
	[CodigoTransaccion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO


