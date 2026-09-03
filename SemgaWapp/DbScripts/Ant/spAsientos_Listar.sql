-- OBSOLETO: usar spAsientos_Reporte.sql (la app ejecuta spAsientos_Reporte).
-- Reporte de Asientos: listado con filtro por rango de fechas.
-- Parámetros en formato yyyyMMdd (ej: 20260303).

CREATE OR ALTER PROCEDURE [dbo].[spAsientos_Listar]
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
            A.[ID] AS [ID Asiento],
            CONVERT(VARCHAR(10), A.[Fecha], 103) AS [Fecha del Asiento],
            FORMAT(A.[Fecha], 'hh:mm:ss tt') AS [Hora del Asiento],
            A.[CodTipoAsiento] AS [Código Tipo Asiento],
            TA.[TipoAsiento] AS [Tipo de Asiento],
            A.[BaseID] AS [ID Base],
            A.[Cuenta] AS [Código de Cuenta],
            ISNULL(C.[Nombre], '-') AS [Nombre de la Cuenta],
            FORMAT(ISNULL(A.[Debito], 0), 'N2') AS [Débito],
            FORMAT(ISNULL(A.[Credito], 0), 'N2') AS [Crédito],
            FORMAT(ISNULL(A.[Debito], 0) - ISNULL(A.[Credito], 0), 'N2') AS [Balance],
            A.[Memo] AS [Comentario],
            CASE WHEN A.[snEliminado] = 1 THEN 'SI' ELSE 'NO' END AS [¿Eliminado?]
        FROM [dbo].[tbAsientos] A
        LEFT JOIN [dbo].[tbTipoAsiento] TA ON A.[CodTipoAsiento] = TA.[CodTipoAsiento]
        LEFT JOIN [dbo].[tbCuentas] C ON A.[Cuenta] = C.[Cuenta]
        WHERE A.[snEliminado] = 0
            AND (@FechaDesdeDate IS NULL OR A.[Fecha] >= @FechaDesdeDate)
            AND (@FechaHastaDate IS NULL OR A.[Fecha] <= @FechaHastaDate)
        ORDER BY A.[Fecha];
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();
        RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH
END
GO
