-- =============================================
-- Author: Sistema SemgaWapp
-- Create date: 2024
-- Description: Listar tipos de documentos con filtros opcionales
-- =============================================
CREATE PROCEDURE [dbo].[spTipoDocumentos_Listar]
    @CodTipoDoc VARCHAR(10) = NULL,
    @TipoDocumento NVARCHAR(50) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT
        t.IDTipoDoc,
        t.CodTipoDoc,
        t.TipoDocumento,
        t.snEliminado
    FROM
        tbTipoDocumentos t
    WHERE
        t.snEliminado = 0
        AND (@CodTipoDoc IS NULL OR t.CodTipoDoc LIKE '%' + @CodTipoDoc + '%')
        AND (@TipoDocumento IS NULL OR t.TipoDocumento LIKE '%' + @TipoDocumento + '%')
    ORDER BY
        t.CodTipoDoc;
END


