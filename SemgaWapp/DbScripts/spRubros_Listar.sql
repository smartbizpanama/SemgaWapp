-- =============================================
-- Author: Sistema SemgaWapp
-- Create date: 2024
-- Description: Listar rubros con filtros opcionales
-- =============================================
CREATE PROCEDURE [dbo].[spRubros_Listar]
    @CodigoRubro VARCHAR(5) = NULL,
    @Descripcion NVARCHAR(100) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT
        r.IDRubro,
        r.CodigoRubro,
        r.Descripcion,
        r.snEliminado
    FROM
        tbRubros r
    WHERE
        r.snEliminado = 0
        AND (@CodigoRubro IS NULL OR r.CodigoRubro LIKE '%' + @CodigoRubro + '%')
        AND (@Descripcion IS NULL OR r.Descripcion LIKE '%' + @Descripcion + '%')
    ORDER BY
        r.CodigoRubro;
END


