-- =============================================
-- CREAR TABLA PARA ALMACENAR INFORMACIÓN DE RESPALDOS
-- =============================================

CREATE TABLE [dbo].[tbRespaldos](
    [ID] [int] IDENTITY(1,1) NOT NULL,
    [UsuarioGenera] [int] NOT NULL,
    [FechaHora] [datetime] NOT NULL,
    [NombreRespaldo] [varchar](100) NOT NULL,
    [Descripcion] [varchar](500) NULL,
    [Ruta] [varchar](500) NOT NULL,
    [Tamaño] [bigint] NOT NULL,
    [SnEliminado] [bit] NOT NULL DEFAULT(0),
    [FechaCreacion] [datetime] NOT NULL DEFAULT(GETDATE()),
    [FechaModificacion] [datetime] NULL,
    CONSTRAINT [PK_tbRespaldos] PRIMARY KEY CLUSTERED ([ID] ASC)
)

-- Crear índices para optimizar consultas
CREATE NONCLUSTERED INDEX [IX_tbRespaldos_UsuarioGenera] ON [dbo].[tbRespaldos] ([UsuarioGenera])
CREATE NONCLUSTERED INDEX [IX_tbRespaldos_FechaHora] ON [dbo].[tbRespaldos] ([FechaHora] DESC)
CREATE NONCLUSTERED INDEX [IX_tbRespaldos_SnEliminado] ON [dbo].[tbRespaldos] ([SnEliminado])

-- Agregar comentarios a la tabla y columnas
EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description', 
    @value = N'Tabla para almacenar información de respaldos de la base de datos', 
    @level0type = N'SCHEMA', @level0name = N'dbo', 
    @level1type = N'TABLE', @level1name = N'tbRespaldos'

EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description', 
    @value = N'ID único del respaldo', 
    @level0type = N'SCHEMA', @level0name = N'dbo', 
    @level1type = N'TABLE', @level1name = N'tbRespaldos', 
    @level2type = N'COLUMN', @level2name = N'ID'

EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description', 
    @value = N'ID del usuario que generó el respaldo', 
    @level0type = N'SCHEMA', @level0name = N'dbo', 
    @level1type = N'TABLE', @level1name = N'tbRespaldos', 
    @level2type = N'COLUMN', @level2name = N'UsuarioGenera'

EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description', 
    @value = N'Fecha y hora en que se generó el respaldo', 
    @level0type = N'SCHEMA', @level0name = N'dbo', 
    @level1type = N'TABLE', @level1name = N'tbRespaldos', 
    @level2type = N'COLUMN', @level2name = N'FechaHora'

EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description', 
    @value = N'Nombre del archivo de respaldo', 
    @level0type = N'SCHEMA', @level0name = N'dbo', 
    @level1type = N'TABLE', @level1name = N'tbRespaldos', 
    @level2type = N'COLUMN', @level2name = N'NombreRespaldo'

EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description', 
    @value = N'Descripción opcional del respaldo', 
    @level0type = N'SCHEMA', @level0name = N'dbo', 
    @level1type = N'TABLE', @level1name = N'tbRespaldos', 
    @level2type = N'COLUMN', @level2name = N'Descripcion'

EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description', 
    @value = N'Ruta completa donde se almacenó el respaldo', 
    @level0type = N'SCHEMA', @level0name = N'dbo', 
    @level1type = N'TABLE', @level1name = N'tbRespaldos', 
    @level2type = N'COLUMN', @level2name = N'RCta'

EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description', 
    @value = N'Tamaño del archivo de respaldo en bytes', 
    @level0type = N'SCHEMA', @level0name = N'dbo', 
    @level1type = N'TABLE', @level1name = N'tbRespaldos', 
    @level2type = N'COLUMN', @level2name = N'Tamaño'

EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description', 
    @value = N'Indica si el respaldo está marcado como eliminado (soft delete)', 
    @level0type = N'SCHEMA', @level0name = N'dbo', 
    @level1type = N'TABLE', @level1name = N'tbRespaldos', 
    @level2type = N'COLUMN', @level2name = N'SnEliminado'

EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description', 
    @value = N'Fecha de creación del registro', 
    @level0type = N'SCHEMA', @level0name = N'dbo', 
    @level1type = N'TABLE', @level1name = N'tbRespaldos', 
    @level2type = N'COLUMN', @level2name = N'FechaCreacion'

EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description', 
    @value = N'Fecha de última modificación del registro', 
    @level0type = N'SCHEMA', @level0name = N'dbo', 
    @level1type = N'TABLE', @level1name = N'tbRespaldos', 
    @level2type = N'COLUMN', @level2name = N'FechaModificacion'






