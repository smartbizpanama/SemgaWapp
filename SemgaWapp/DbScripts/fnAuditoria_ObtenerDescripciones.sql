-- =============================================
-- Funciones auxiliares para obtener descripciones de IDs
-- =============================================

USE [SegmaDB]
GO

-- Función para obtener descripción de tipo de asociado
CREATE OR ALTER FUNCTION [dbo].[fnAuditoria_ObtenerTipoAsociado](@IdTipoAsociado INT)
RETURNS NVARCHAR(200)
AS
BEGIN
    DECLARE @Descripcion NVARCHAR(200)
    
    SELECT @Descripcion = TipoAsociado 
    FROM tbTipoAsociado 
    WHERE IdTipoAsociado = @IdTipoAsociado
    
    RETURN ISNULL(@Descripcion, 'N/A')
END
GO

-- Función para obtener descripción de nivel de estudio
CREATE OR ALTER FUNCTION [dbo].[fnAuditoria_ObtenerNivelEstudio](@NivelEstudio INT)
RETURNS NVARCHAR(200)
AS
BEGIN
    DECLARE @Descripcion NVARCHAR(200)
    
    SELECT @Descripcion = Descripcion 
    FROM tbNivelesEstudio 
    WHERE Code = @NivelEstudio AND snEliminado = 0
    
    RETURN ISNULL(@Descripcion, 'N/A')
END
GO

-- Función para obtener descripción de profesión
CREATE OR ALTER FUNCTION [dbo].[fnAuditoria_ObtenerProfesion](@Profesion INT)
RETURNS NVARCHAR(200)
AS
BEGIN
    DECLARE @Descripcion NVARCHAR(200)
    
    SELECT @Descripcion = Descripcion 
    FROM tbProfesiones 
    WHERE Code = @Profesion AND snEliminado = 0
    
    RETURN ISNULL(@Descripcion, 'N/A')
END
GO

-- Función para obtener descripción de lugar de trabajo
CREATE OR ALTER FUNCTION [dbo].[fnAuditoria_ObtenerLugarTrabajo](@LugarTrabajo INT)
RETURNS NVARCHAR(200)
AS
BEGIN
    DECLARE @Descripcion NVARCHAR(200)
    
    SELECT @Descripcion = Descripcion 
    FROM tbEmpresas 
    WHERE Code = @LugarTrabajo AND snEliminado = 0
    
    RETURN ISNULL(@Descripcion, 'N/A')
END
GO

-- Función para obtener descripción de ocupación
CREATE OR ALTER FUNCTION [dbo].[fnAuditoria_ObtenerOcupacion](@Ocupacion INT)
RETURNS NVARCHAR(200)
AS
BEGIN
    DECLARE @Descripcion NVARCHAR(200)
    
    SELECT @Descripcion = Descripcion 
    FROM tbOcupaciones 
    WHERE Code = @Ocupacion AND snEliminado = 0
    
    RETURN ISNULL(@Descripcion, 'N/A')
END
GO

-- Función para obtener descripción de país
CREATE OR ALTER FUNCTION [dbo].[fnAuditoria_ObtenerPais](@Pais VARCHAR(10))
RETURNS NVARCHAR(200)
AS
BEGIN
    DECLARE @Descripcion NVARCHAR(200)
    
    SELECT @Descripcion = Descripcion 
    FROM tbPaises 
    WHERE Code = @Pais AND snEliminado = 0
    
    RETURN ISNULL(@Descripcion, 'N/A')
END
GO

-- Función para obtener descripción de provincia
CREATE OR ALTER FUNCTION [dbo].[fnAuditoria_ObtenerProvincia](@Provincia INT)
RETURNS NVARCHAR(200)
AS
BEGIN
    DECLARE @Descripcion NVARCHAR(200)
    
    SELECT @Descripcion = Descripcion 
    FROM tbProvincias 
    WHERE Code = @Provincia AND snEliminado = 0
    
    RETURN ISNULL(@Descripcion, 'N/A')
END
GO

-- Función para obtener descripción de distrito
CREATE OR ALTER FUNCTION [dbo].[fnAuditoria_ObtenerDistrito](@Distrito INT)
RETURNS NVARCHAR(200)
AS
BEGIN
    DECLARE @Descripcion NVARCHAR(200)
    
    SELECT @Descripcion = Descripcion 
    FROM tbDistritos 
    WHERE Code = @Distrito AND snEliminado = 0
    
    RETURN ISNULL(@Descripcion, 'N/A')
END
GO

-- Función para obtener descripción de corregimiento
CREATE OR ALTER FUNCTION [dbo].[fnAuditoria_ObtenerCorregimiento](@Corregimiento INT)
RETURNS NVARCHAR(200)
AS
BEGIN
    DECLARE @Descripcion NVARCHAR(200)
    
    SELECT @Descripcion = Descripcion 
    FROM tbCorregimientos 
    WHERE Code = @Corregimiento AND snEliminado = 0
    
    RETURN ISNULL(@Descripcion, 'N/A')
END
GO

-- Función para obtener descripción de usuario
CREATE OR ALTER FUNCTION [dbo].[fnAuditoria_ObtenerUsuario](@UsuarioId INT)
RETURNS NVARCHAR(200)
AS
BEGIN
    DECLARE @Descripcion NVARCHAR(200)
    
    SELECT @Descripcion = Nombre + ' ' + Apellido 
    FROM tbUsuarios 
    WHERE Id = @UsuarioId
    
    RETURN ISNULL(@Descripcion, 'N/A')
END
GO

PRINT 'Funciones auxiliares para descripciones creadas exitosamente'
GO
