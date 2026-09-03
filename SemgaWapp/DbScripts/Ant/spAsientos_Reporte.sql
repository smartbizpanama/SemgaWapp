-- Reporte Asientos — detallado
-- @MesHistorial / @AnioHistorial / @VersionHistorial: consulta [dbo].[sys.HST.tbAsientos]

ALTER PROCEDURE [dbo].[spAsientos_Reporte]
    @FechaDesde VARCHAR(8) = NULL,
    @FechaHasta VARCHAR(8) = NULL,
    @MesHistorial INT = NULL,
    @AnioHistorial INT = NULL,
    @VersionHistorial INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        DECLARE @FechaDesdeDate DATE = NULL;
        DECLARE @FechaHastaDate DATE = NULL;
        DECLARE @UsarHistorial BIT = 0;

        IF @FechaDesde IS NOT NULL AND LEN(@FechaDesde) = 8
            SET @FechaDesdeDate = CONVERT(DATE, @FechaDesde, 112);

        IF @FechaHasta IS NOT NULL AND LEN(@FechaHasta) = 8
            SET @FechaHastaDate = CONVERT(DATE, @FechaHasta, 112);

        IF @MesHistorial IS NOT NULL AND @MesHistorial BETWEEN 1 AND 12
           AND @AnioHistorial IS NOT NULL AND @AnioHistorial >= 1980
           AND @VersionHistorial IS NOT NULL AND @VersionHistorial >= 0
            SET @UsarHistorial = 1;

        IF @UsarHistorial = 1
        BEGIN
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
            FROM [dbo].[sys.HST.tbAsientos] A
            LEFT JOIN [dbo].[tbTipoAsiento] TA ON A.[CodTipoAsiento] = TA.[CodTipoAsiento]
            LEFT JOIN [dbo].[tbCuentas] C ON A.[Cuenta] = C.[Cuenta]
            WHERE ISNULL(A.[snEliminado], 0) = 0
                AND A.[YearCorte] = @AnioHistorial
                AND A.[MonthCorte] = @MesHistorial
                AND A.[Version] = @VersionHistorial
                AND (@FechaDesdeDate IS NULL OR CAST(A.[Fecha] AS DATE) >= @FechaDesdeDate)
                AND (@FechaHastaDate IS NULL OR CAST(A.[Fecha] AS DATE) <= @FechaHastaDate)
                AND (ISNULL(A.[Debito], 0) > 0 OR ISNULL(A.[Credito], 0) > 0)
            ORDER BY A.[Fecha];
        END
        ELSE
        BEGIN
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
                AND (@FechaDesdeDate IS NULL OR CONVERT(VARCHAR(8), A.[Fecha], 112) >= @FechaDesdeDate)
                AND (@FechaHastaDate IS NULL OR CONVERT(VARCHAR(8), A.[Fecha], 112) <= @FechaHastaDate)
                AND (ISNULL(A.[Debito], 0) > 0 OR ISNULL(A.[Credito], 0) > 0)
            ORDER BY A.[Fecha];
        END
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();
        RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH
END
