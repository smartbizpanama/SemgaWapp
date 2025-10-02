USE [SegmaDB]
GO

/****** Object:  Table [dbo].[tbAsociados]    Script Date: 24/sept/2025 06:01:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tbAsociados](
	[NumeroAsociado] [int] IDENTITY(1,1) NOT NULL,
	[IdTipoAsociado] [int] NOT NULL,
	[Nombre] [nvarchar](max) NULL,
	[SegundoNombre] [nvarchar](max) NULL,
	[Apellido] [nvarchar](max) NULL,
	[SegundoApellido] [nvarchar](max) NULL,
	[Estatus] [char](1) NULL,
	[TipoIdentificacion] [varchar](10) NULL,
	[NumeroIdentificacion] [nvarchar](200) NULL,
	[TelefonoResidencia] [varchar](50) NULL,
	[TelefonoCelular] [varchar](50) NULL,
	[TelefonoFamiliar] [varchar](50) NULL,
	[CorreoElectronico] [nvarchar](max) NULL,
	[Sexo] [char](1) NULL,
	[FechaNacimiento] [date] NULL,
	[ProvinciaResidencia] [varchar](150) NULL,
	[DistritoResidencia] [varchar](150) NULL,
	[CorregimientoResidencia] [varchar](150) NULL,
	[DireccionResidencia] [varchar](max) NULL,
	[ProvinciaTrabajo] [varchar](150) NULL,
	[DistritoTrabajo] [varchar](150) NULL,
	[CorregimientoTrabajo] [varchar](150) NULL,
	[DireccionTrabajo] [varchar](max) NULL,
	[LugarTrabajo] [varchar](50) NULL,
	[Ocupacion] [varchar](max) NULL,
	[NivelEstudio] [varchar](50) NULL,
	[Profesion] [varchar](50) NULL,
	[FechaCreacion] [datetime] NULL,
	[UsuarioCrea] [int] NULL,
	[FechaModificacion] [datetime] NULL,
	[UsuarioModifica] [int] NULL,
	[snEliminado] [bit] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

/****** Object:  Table [dbo].[tbAuxiliares]    Script Date: 24/sept/2025 06:01:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tbAuxiliares](
	[ID] [int] NOT NULL,
	[NumeroAsociado] [int] NOT NULL,
	[CodigoRubro] [varchar](5) NULL,
	[TipoAuxiliar] [int] NULL,
	[Cuota] [numeric](18, 2) NULL,
	[Saldo] [numeric](18, 2) NULL,
	[FechaCreacion] [datetime] NULL,
	[FechaModificacion] [datetime] NULL,
	[UsuarioCrea] [int] NULL,
	[UsuarioModifica] [int] NULL,
	[MontoOriginal] [numeric](18, 2) NULL,
	[FechaOtorgado] [datetime] NULL,
	[TasaInteres] [numeric](18, 2) NULL,
	[PagoMes] [numeric](18, 2) NULL,
	[InteresCalculado] [numeric](18, 2) NULL,
	[InteresPagado] [numeric](18, 2) NULL,
	[FechaUltimoPago] [datetime] NULL,
	[FechaUltimoRetiro] [datetime] NULL,
	[snEliminado] [bit] NULL,
 CONSTRAINT [PK_tbAuxiliares] PRIMARY KEY CLUSTERED 
(
	[ID] ASC,
	[NumeroAsociado] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[tbCodigosTransaccion]    Script Date: 24/sept/2025 06:01:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tbCodigosTransaccion](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[CodigoRubro] [varchar](5) NULL,
	[CodigoTransaccion] [varchar](10) NULL,
	[Descripcion] [nvarchar](150) NULL,
	[DebCred] [char](1) NULL,
	[CuentaContable] [varchar](50) NULL,
	[SnActivo] [bit] NULL,
	[SnEliminado] [bit] NULL,
 CONSTRAINT [PK_tbCodigosTransaccion] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[tbRubros]    Script Date: 24/sept/2025 06:01:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tbRubros](
	[IDRubro] [int] IDENTITY(1,1) NOT NULL,
	[CodigoRubro] [varchar](5) NOT NULL,
	[Descripcion] [nvarchar](100) NULL,
	[snEliminado] [bit] NULL,
 CONSTRAINT [PK_tbRubros] PRIMARY KEY CLUSTERED 
(
	[IDRubro] ASC,
	[CodigoRubro] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[tbTiposAuxiliares]    Script Date: 24/sept/2025 06:01:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tbTiposAuxiliares](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[CodigoRubro] [varchar](5) NULL,
	[TipoAuxiliar] [int] NULL,
	[Descripcion] [nvarchar](150) NULL,
	[Tasa] [numeric](18, 2) NULL,
	[Plazo] [int] NULL,
	[MontoMaximo] [numeric](18, 2) NULL,
	[MontoMinimo] [numeric](18, 2) NULL,
	[PorManejo] [numeric](18, 2) NULL,
	[PorCapitalizacion] [numeric](18, 2) NULL,
	[PorProteccion] [numeric](18, 2) NULL,
	[snEliminado] [bit] NULL,
 CONSTRAINT [PK_tbTiposAuxiliares] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[tbAsociados] ADD  DEFAULT ((0)) FOR [snEliminado]
GO


