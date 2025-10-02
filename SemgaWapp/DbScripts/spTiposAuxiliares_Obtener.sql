CREATE PROCEDURE [dbo].[spTiposAuxiliares_Obtener]
    @ID INT
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        ta.ID,
        ta.CodigoRubro,
        r.Descripcion AS RubroDescripcion,
        ta.TipoAuxiliar,
        ta.Descripcion,
        ta.Tasa,
        ta.Plazo,
        ta.MontoMaximo,
        ta.MontoMinimo,
        ta.PorManejo,
        ta.PorCapitalizacion,
        ta.PorProteccion,
        ta.snEliminado
    FROM tbTiposAuxiliares ta
    INNER JOIN tbRubros r ON ta.CodigoRubro = r.CodigoRubro
    WHERE ta.ID = @ID
        AND ta.snEliminado = 0;
END

