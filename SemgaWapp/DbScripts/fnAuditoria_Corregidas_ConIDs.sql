-- =============================================
-- Funciones de Auditoría Corregidas con IDs entre paréntesis
-- Formato: "Descripción (ID)"
-- =============================================

USE [SegmaDB]
GO

-- Función para obtener descripción de tipo de asociado con ID
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fnAuditoria_ObtenerTipoAsociado]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
    DROP FUNCTION [dbo].[fnAuditoria_ObtenerTipoAsociado]
GO

CREATE FUNCTION [dbo].[fnAuditoria_ObtenerTipoAsociado](@IdTipoAsociado INT)
RETURNS NVARCHAR(200)
AS
BEGIN
    DECLARE @Descripcion NVARCHAR(200)
    
    SELECT @Descripcion = TipoAsociado + ' (' + CAST(IdTipoAsociado AS NVARCHAR(10)) + ')'
    FROM tbTipoAsociado 
    WHERE IdTipoAsociado = @IdTipoAsociado
    
    RETURN ISNULL(@Descripcion, 'N/A (' + CAST(ISNULL(@IdTipoAsociado, 0) AS NVARCHAR(10)) + ')')
END
GO

-- Función para obtener descripción de tipo de documento con ID
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fnAuditoria_ObtenerTipoDocumento]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
    DROP FUNCTION [dbo].[fnAuditoria_ObtenerTipoDocumento]
GO

CREATE FUNCTION [dbo].[fnAuditoria_ObtenerTipoDocumento](@TipoIdentificacion VARCHAR(10))
RETURNS NVARCHAR(200)
AS
BEGIN
    DECLARE @Descripcion NVARCHAR(200)
    
    SELECT @Descripcion = TipoDocumento + ' (' + CodTipoDoc + ')'
    FROM tbTipoDocumentos 
    WHERE CodTipoDoc = @TipoIdentificacion
    
    RETURN ISNULL(@Descripcion, 'N/A (' + ISNULL(@TipoIdentificacion, '') + ')')
END
GO

-- Función para obtener descripción de país con ID
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fnAuditoria_ObtenerPais]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
    DROP FUNCTION [dbo].[fnAuditoria_ObtenerPais]
GO

CREATE FUNCTION [dbo].[fnAuditoria_ObtenerPais](@CodePais VARCHAR(10))
RETURNS NVARCHAR(200)
AS
BEGIN
    DECLARE @Descripcion NVARCHAR(200)
    
    SELECT @Descripcion = Descripcion + ' (' + Code + ')'
    FROM tbPaises 
    WHERE Code = @CodePais
    
    RETURN ISNULL(@Descripcion, 'N/A (' + ISNULL(@CodePais, '') + ')')
END
GO

-- Función para obtener descripción de provincia con ID
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fnAuditoria_ObtenerProvincia]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
    DROP FUNCTION [dbo].[fnAuditoria_ObtenerProvincia]
GO

CREATE FUNCTION [dbo].[fnAuditoria_ObtenerProvincia](@CodeProvincia INT)
RETURNS NVARCHAR(200)
AS
BEGIN
    DECLARE @Descripcion NVARCHAR(200)
    
    SELECT @Descripcion = Descripcion + ' (' + CAST(Code AS NVARCHAR(10)) + ')'
    FROM tbProvincias 
    WHERE Code = @CodeProvincia
    
    RETURN ISNULL(@Descripcion, 'N/A (' + CAST(ISNULL(@CodeProvincia, 0) AS NVARCHAR(10)) + ')')
END
GO

-- Función para obtener descripción de distrito con ID
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fnAuditoria_ObtenerDistrito]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
    DROP FUNCTION [dbo].[fnAuditoria_ObtenerDistrito]
GO

CREATE FUNCTION [dbo].[fnAuditoria_ObtenerDistrito](@CodeDistrito INT)
RETURNS NVARCHAR(200)
AS
BEGIN
    DECLARE @Descripcion NVARCHAR(200)
    
    SELECT @Descripcion = Descripcion + ' (' + CAST(Code AS NVARCHAR(10)) + ')'
    FROM tbDistritos 
    WHERE Code = @CodeDistrito
    
    RETURN ISNULL(@Descripcion, 'N/A (' + CAST(ISNULL(@CodeDistrito, 0) AS NVARCHAR(10)) + ')')
END
GO

-- Función para obtener descripción de corregimiento con ID
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fnAuditoria_ObtenerCorregimiento]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
    DROP FUNCTION [dbo].[fnAuditoria_ObtenerCorregimiento]
GO

CREATE FUNCTION [dbo].[fnAuditoria_ObtenerCorregimiento](@CodeCorregimiento INT)
RETURNS NVARCHAR(200)
AS
BEGIN
    DECLARE @Descripcion NVARCHAR(200)
    
    SELECT @Descripcion = Descripcion + ' (' + CAST(Code AS NVARCHAR(10)) + ')'
    FROM tbCorregimientos 
    WHERE Code = @CodeCorregimiento
    
    RETURN ISNULL(@Descripcion, 'N/A (' + CAST(ISNULL(@CodeCorregimiento, 0) AS NVARCHAR(10)) + ')')
END
GO

-- Función para obtener descripción de lugar de trabajo con ID
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fnAuditoria_ObtenerLugarTrabajo]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
    DROP FUNCTION [dbo].[fnAuditoria_ObtenerLugarTrabajo]
GO

CREATE FUNCTION [dbo].[fnAuditoria_ObtenerLugarTrabajo](@CodeEmpresa INT)
RETURNS NVARCHAR(200)
AS
BEGIN
    DECLARE @Descripcion NVARCHAR(200)
    
    SELECT @Descripcion = Descripcion + ' (' + CAST(Code AS NVARCHAR(10)) + ')'
    FROM tbEmpresas 
    WHERE Code = @CodeEmpresa
    
    RETURN ISNULL(@Descripcion, 'N/A (' + CAST(ISNULL(@CodeEmpresa, 0) AS NVARCHAR(10)) + ')')
END
GO

-- Función para obtener descripción de ocupación con ID
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fnAuditoria_ObtenerOcupacion]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
    DROP FUNCTION [dbo].[fnAuditoria_ObtenerOcupacion]
GO

CREATE FUNCTION [dbo].[fnAuditoria_ObtenerOcupacion](@CodeOcupacion INT)
RETURNS NVARCHAR(200)
AS
BEGIN
    DECLARE @Descripcion NVARCHAR(200)
    
    SELECT @Descripcion = Descripcion + ' (' + CAST(Code AS NVARCHAR(10)) + ')'
    FROM tbOcupaciones 
    WHERE Code = @CodeOcupacion
    
    RETURN ISNULL(@Descripcion, 'N/A (' + CAST(ISNULL(@CodeOcupacion, 0) AS NVARCHAR(10)) + ')')
END
GO

-- Función para obtener descripción de nivel de estudio con ID
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fnAuditoria_ObtenerNivelEstudio]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
    DROP FUNCTION [dbo].[fnAuditoria_ObtenerNivelEstudio]
GO

CREATE FUNCTION [dbo].[fnAuditoria_ObtenerNivelEstudio](@CodeNivelEstudio INT)
RETURNS NVARCHAR(200)
AS
BEGIN
    DECLARE @Descripcion NVARCHAR(200)
    
    SELECT @Descripcion = Descripcion + ' (' + CAST(Code AS NVARCHAR(10)) + ')'
    FROM tbNivelesEstudio 
    WHERE Code = @CodeNivelEstudio
    
    RETURN ISNULL(@Descripcion, 'N/A (' + CAST(ISNULL(@CodeNivelEstudio, 0) AS NVARCHAR(10)) + ')')
END
GO

-- Función para obtener descripción de profesión con ID
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fnAuditoria_ObtenerProfesion]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
    DROP FUNCTION [dbo].[fnAuditoria_ObtenerProfesion]
GO

CREATE FUNCTION [dbo].[fnAuditoria_ObtenerProfesion](@CodeProfesion INT)
RETURNS NVARCHAR(200)
AS
BEGIN
    DECLARE @Descripcion NVARCHAR(200)
    
    SELECT @Descripcion = Descripcion + ' (' + CAST(Code AS NVARCHAR(10)) + ')'
    FROM tbProfesiones 
    WHERE Code = @CodeProfesion
    
    RETURN ISNULL(@Descripcion, 'N/A (' + CAST(ISNULL(@CodeProfesion, 0) AS NVARCHAR(10)) + ')')
END
GO

-- Función para obtener descripción de parentesco con ID
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fnAuditoria_ObtenerParentesco]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
    DROP FUNCTION [dbo].[fnAuditoria_ObtenerParentesco]
GO

CREATE FUNCTION [dbo].[fnAuditoria_ObtenerParentesco](@IDParentezco INT)
RETURNS NVARCHAR(200)
AS
BEGIN
    DECLARE @Descripcion NVARCHAR(200)
    
    SELECT @Descripcion = Parentezco + ' (' + CAST(IDParentezco AS NVARCHAR(10)) + ')'
    FROM tbParentezcos 
    WHERE IDParentezco = @IDParentezco
    
    RETURN ISNULL(@Descripcion, 'N/A (' + CAST(ISNULL(@IDParentezco, 0) AS NVARCHAR(10)) + ')')
END
GO

-- Función para obtener descripción de usuario con ID
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fnAuditoria_ObtenerUsuario]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
    DROP FUNCTION [dbo].[fnAuditoria_ObtenerUsuario]
GO

CREATE FUNCTION [dbo].[fnAuditoria_ObtenerUsuario](@UsuarioId INT)
RETURNS NVARCHAR(200)
AS
BEGIN
    DECLARE @Descripcion NVARCHAR(200)
    
    SELECT @Descripcion = Usuario + ' (' + CAST(Id AS NVARCHAR(10)) + ')'
    FROM tbUsuarios 
    WHERE Id = @UsuarioId
    
    RETURN ISNULL(@Descripcion, 'N/A (' + CAST(ISNULL(@UsuarioId, 0) AS NVARCHAR(10)) + ')')
END
GO

PRINT 'Funciones de auditoría actualizadas con formato "Descripción (ID)"'
GO
