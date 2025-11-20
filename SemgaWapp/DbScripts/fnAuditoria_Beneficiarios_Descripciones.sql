-- =============================================
-- Funciones auxiliares para obtener descripciones de IDs en tbBeneficiarios
-- =============================================

USE [SegmaDB]
GO

-- Función para obtener descripción de tipo de documento
CREATE OR ALTER FUNCTION [dbo].[fnAuditoria_ObtenerTipoDocumento](@TipoDocumento VARCHAR(10))
RETURNS NVARCHAR(200)
AS
BEGIN
    DECLARE @Descripcion NVARCHAR(200)
    
    SELECT @Descripcion = TipoDocumento 
    FROM tbTipoDocumentos 
    WHERE CodTipoDoc = @TipoDocumento AND snEliminado = 0
    
    RETURN ISNULL(@Descripcion, 'N/A')
END
GO

-- Función para obtener descripción de asociado (para NumeroAsociado)
CREATE OR ALTER FUNCTION [dbo].[fnAuditoria_ObtenerAsociado](@NumeroAsociado INT)
RETURNS NVARCHAR(200)
AS
BEGIN
    DECLARE @Descripcion NVARCHAR(200)
    
    SELECT @Descripcion = Nombre + ' ' + Apellido 
    FROM tbAsociados 
    WHERE NumeroAsociado = @NumeroAsociado
    
    RETURN ISNULL(@Descripcion, 'N/A')
END
GO

-- Función para obtener descripción de parentesco
CREATE OR ALTER FUNCTION [dbo].[fnAuditoria_ObtenerParentesco](@Parentesco INT)
RETURNS NVARCHAR(200)
AS
BEGIN
    DECLARE @Descripcion NVARCHAR(200)
    
    SELECT @Descripcion = Parentezco 
    FROM tbParentezcos 
    WHERE IDParentezco = @Parentesco AND snEliminado = 0
    
    RETURN ISNULL(@Descripcion, 'N/A')
END
GO

PRINT 'Funciones auxiliares para tbBeneficiarios creadas exitosamente'
PRINT 'Incluye: TipoDocumento, Asociado, Parentesco'
GO
