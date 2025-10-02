CREATE TABLE dbo.tbTipoAsociado (
  IdTipoAsociado int IDENTITY,
  CodTipoAsociado varchar(50) NOT NULL,
  TipoAsociado varchar(50) NOT NULL
)
ON [PRIMARY]
GO


CREATE TABLE dbo.tbUsuarios (
  Id int IDENTITY,
  Nombre nvarchar(100) NOT NULL,
  Apellido nvarchar(100) NOT NULL,
  Usuario nvarchar(50) NOT NULL,
  Clave nvarchar(255) NOT NULL,
  Email nvarchar(100) NOT NULL,
  Telefono nvarchar(20) NULL,
  Rol int NOT NULL,
  Departamento int NULL,
  Estado nvarchar(20) NOT NULL DEFAULT ('Activo'),
  UltimoAcceso datetime NULL,
  IntentosFallidos int NOT NULL DEFAULT (0),
  BloqueadoHasta datetime NULL,
  FechaCreacion datetime NOT NULL DEFAULT (getdate()),
  FechaModificacion datetime NULL,
  CreadoPor int NULL,
  ModificadoPor int NULL,
  CONSTRAINT PK_tbUsuarios PRIMARY KEY CLUSTERED (Id)
)
ON [PRIMARY]
GO


CREATE TABLE dbo.tbAsociados (
  NumeroAsociado int IDENTITY, --GENERAL
  IdTipoAsociado int NOT NULL,--GENERAL
  Nombre nvarchar(max) NULL,--GENERAL
  SegundoNombre nvarchar(max) NULL,--GENERAL
  Apellido nvarchar(max) NULL,--GENERAL
  SegundoApellido nvarchar(max) NULL,--GENERAL
  Estatus char(1) NULL,--GENERAL
  TipoIdentificacion varchar(20) NULL,--GENERAL (LOS TIPOS SON: CEDULA, PASAPORTE, RUC, OTRO. DEBES LLENARLO EN EL DROPDOWN PARA ELEGIRLO)
  NumeroIdentificacion nvarchar(200) NULL,--GENERAL
  TelefonoResidencia varchar(50) NULL,--GENERAL
  TelefonoCelular varchar(50) NULL,--GENERAL
  TelefonoFamiliar varchar(50) NULL,--GENERAL
  CorreoElectronico nvarchar(max) NULL,--GENERAL
  Sexo char(1) NULL,--GENERAL (M = MASCULINO, F = FEMENINO )
  FechaNacimiento date NULL,--GENERAL
  ProvinciaResidencia varchar(150) NULL, --RESIDENCIA
  DistritoResidencia varchar(150) NULL, --RESIDENCIA
  CorregimientoResidencia varchar(150) NULL, --RESIDENCIA
  DireccionResidencia varchar(max) NULL,--RESIDENCIA
  ProvinciaTrabajo varchar(150) NULL, --TRABAJO
  DistritoTrabajo varchar(150) NULL,--TRABAJO
  CorregimientoTrabajo varchar(150) NULL,--TRABAJO
  DireccionTrabajo varchar(max) NULL,--TRABAJO
  LugarTrabajo varchar(50) NULL,--TRABAJO
  Ocupacion varchar(max) NULL,--GENERAL
  NivelEstudio varchar(50) NULL,--GENERAL
  Profesion varchar(50) NULL,--GENERAL
  FechaCreacion datetime NULL,--SISTEMA
  UsuarioCrea int NULL,--SISTEMA
  FechaModificacion datetime NULL,--SISTEMA
  UsuarioModifica int NULL,--SISTEMA
  snEliminado bit NOT NULL DEFAULT (0)
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO