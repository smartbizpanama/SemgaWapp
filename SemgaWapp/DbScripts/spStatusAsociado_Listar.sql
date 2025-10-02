-- =============================================
-- Author: Sistema SemgaWapp
-- Create date: 2024
-- Description: Listar estatus de asociados con filtros opcionales
-- =============================================
CREATE PROCEDURE [dbo].[spStatusAsociado_Listar]
    @CodStatusAsociado CHAR(1) = NULL,
    @StatusAsociado NVARCHAR(50) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT
        s.IDStatus,
        s.CodStatusAsociado,
        s.StatusAsociado,
        s.snEliminado
    FROM
        tbStatusAsociado s
    WHERE
        s.snEliminado = 0
        AND (@CodStatusAsociado IS NULL OR s.CodStatusAsociado = @CodStatusAsociado)
        AND (@StatusAsociado IS NULL OR s.StatusAsociado LIKE '%' + @StatusAsociado + '%')
    ORDER BY
        s.CodStatusAsociado;
END


