-- Resumen de asientos agrupado por cuenta (débito, crédito, balance).
-- Parámetros en formato yyyyMMdd.

CREATE OR ALTER PROCEDURE [dbo].[spAsientos_ListarResumen]
    @FechaDesde VARCHAR(8) = NULL,
    @FechaHasta VARCHAR(8) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        DECLARE @FechaDesdeDate DATE = NULL;
        DECLARE @FechaHastaDate DATE = NULL;

        IF @FechaDesde IS NOT NULL AND LEN(@FechaDesde) = 8
            SET @FechaDesdeDate = CONVERT(DATE, @FechaDesde, 112);

        IF @FechaHasta IS NOT NULL AND LEN(@FechaHasta) = 8
            SET @FechaHastaDate = CONVERT(DATE, @FechaHasta, 112);

        SELECT
            A.[Cuenta] AS [Código de Cuenta],
            ISNULL(C.[Nombre], '-') AS [Nombre de la Cuenta],
            FORMAT(SUM(ISNULL(A.[Debito], 0)), 'N2') AS [Débito],
            FORMAT(SUM(ISNULL(A.[Credito], 0)), 'N2') AS [Crédito],
            FORMAT(SUM(ISNULL(A.[Debito], 0)) - SUM(ISNULL(A.[Credito], 0)), 'N2') AS [Balance]
        FROM [dbo].[tbAsientos] A
        LEFT JOIN [dbo].[tbTipoAsiento] TA ON A.[CodTipoAsiento] = TA.[CodTipoAsiento]
        LEFT JOIN [dbo].[tbCuentas] C ON A.[Cuenta] = C.[Cuenta]
        WHERE A.[snEliminado] = 0
            AND (@FechaDesdeDate IS NULL OR A.[Fecha] >= @FechaDesdeDate)
            AND (@FechaHastaDate IS NULL OR A.[Fecha] <= @FechaHastaDate)
            AND (ISNULL(A.[Debito], 0) > 0 OR ISNULL(A.[Credito], 0) > 0)
        GROUP BY A.[Cuenta], C.[Nombre]
        ORDER BY A.[Cuenta];
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();
        RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH
END
GO
