-- =============================================
-- Author: Sistema SemgaWapp
-- Create date: 2024
-- Description: Listar tipos de asociado con filtros opcionales
-- =============================================
CREATE PROCEDURE [dbo].[spTipoAsociado_Listar]
    @CodTipoAsociado VARCHAR(50) = NULL,
    @TipoAsociado VARCHAR(50) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT
        t.IdTipoAsociado,
        t.CodTipoAsociado,
        t.TipoAsociado,
        t.snEliminado
    FROM
        tbTipoAsociado t
    WHERE
        t.snEliminado = 0
        AND (@CodTipoAsociado IS NULL OR t.CodTipoAsociado LIKE '%' + @CodTipoAsociado + '%')
        AND (@TipoAsociado IS NULL OR t.TipoAsociado LIKE '%' + @TipoAsociado + '%')
    ORDER BY
        t.CodTipoAsociado;
END


