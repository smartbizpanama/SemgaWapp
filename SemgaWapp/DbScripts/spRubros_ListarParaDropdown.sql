-- =============================================
-- Author: Sistema SemgaWapp
-- Create date: 2024
-- Description: Listar rubros para dropdown
-- =============================================
CREATE PROCEDURE [dbo].[spRubros_ListarParaDropdown]
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        CodigoRubro,
        Descripcion
    FROM tbRubros
    WHERE SnEliminado = 0 AND SnActivo = 1
    ORDER BY CodigoRubro;
END


