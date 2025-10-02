-- =============================================
-- Author: Sistema SemgaWapp
-- Create date: 2024
-- Description: Listar parentezcos con filtros opcionales
-- =============================================
CREATE PROCEDURE [dbo].[spParentezcos_Listar]
    @Parentezco NVARCHAR(50) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT
        p.IDParentezco,
        p.Parentezco,
        p.snEliminado
    FROM
        tbParentezcos p
    WHERE
        p.snEliminado = 0
        AND (@Parentezco IS NULL OR p.Parentezco LIKE '%' + @Parentezco + '%')
    ORDER BY
        p.Parentezco;
END


