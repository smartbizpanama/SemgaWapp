USE [SegmaDB]
GO

-- Agregar campos para auditoría de eliminación
ALTER TABLE [dbo].[tbAuxiliares] 
ADD [UsuarioElimina] NVARCHAR(50) NULL,
    [FechaElimina] DATETIME NULL,
    [EquipoElimina] NVARCHAR(MAX) NULL
GO

-- Agregar comentarios a los nuevos campos
EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description', 
    @value = N'Usuario que eliminó el auxiliar', 
    @level0type = N'SCHEMA', @level0name = N'dbo', 
    @level1type = N'TABLE', @level1name = N'tbAuxiliares', 
    @level2type = N'COLUMN', @level2name = N'UsuarioElimina'
GO

EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description', 
    @value = N'Fecha y hora de eliminación del auxiliar', 
    @level0type = N'SCHEMA', @level0name = N'dbo', 
    @level1type = N'TABLE', @level1name = N'tbAuxiliares', 
    @level2type = N'COLUMN', @level2name = N'FechaElimina'
GO

EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description', 
    @value = N'Información del equipo desde el cual se eliminó (JSON con IP, nombre, etc.)', 
    @level0type = N'SCHEMA', @level0name = N'dbo', 
    @level1type = N'TABLE', @level1name = N'tbAuxiliares', 
    @level2type = N'COLUMN', @level2name = N'EquipoElimina'
GO

