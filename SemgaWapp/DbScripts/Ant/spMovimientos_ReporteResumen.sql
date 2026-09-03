-- Resumen Movimientos por Rubro y Tipo Auxiliar (mismos filtros que spMovimientos_Reporte)
-- @MesHistorial / @AnioHistorial / @VersionHistorial: consulta [dbo].[sys.HST.tbMovimientos]

ALTER PROCEDURE [dbo].[spMovimientos_ReporteResumen]
    @IdUsuario INT = NULL,
    @FechaDesde VARCHAR(8) = NULL,
    @FechaHasta VARCHAR(8) = NULL,
    @CodigoRubro NVARCHAR(10) = NULL,
    @CodigoTransaccion NVARCHAR(10) = NULL,
    @NumeroAsociado INT = NULL,
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
                M.[CodigoRubro] AS [Código Rubro],
                ISNULL(R.[Descripcion], M.[CodigoRubro]) AS [Rubro],
                ISNULL(ISNULL(M.[tipoauxiliar], AUX.[TipoAuxiliar]), 0) AS [ID Tipo Auxiliar],
                ISNULL(TA.[Descripcion], '(Sin tipo auxiliar)') AS [Tipo Auxiliar],
                COUNT(*) AS [Movimientos],
                SUM(CASE WHEN T.[DebCred] = 'D' THEN ISNULL(M.[Monto], 0) ELSE 0 END) AS [Débito],
                SUM(CASE WHEN T.[DebCred] = 'C' THEN ISNULL(M.[Monto], 0) ELSE 0 END) AS [Crédito],
                SUM(CASE WHEN T.[DebCred] = 'D' THEN ISNULL(M.[Monto], 0) ELSE 0 END)
                    - SUM(CASE WHEN T.[DebCred] = 'C' THEN ISNULL(M.[Monto], 0) ELSE 0 END) AS [Balance]
            FROM [dbo].[sys.HST.tbMovimientos] M
            LEFT JOIN [dbo].[tbRubros] R
                ON M.[CodigoRubro] = R.[CodigoRubro]
            LEFT JOIN [dbo].[tbAuxiliares] AUX
                ON M.[IDAuxiliar] = AUX.[ID]
            LEFT JOIN [dbo].[tbTiposAuxiliares] TA
                ON ISNULL(M.[tipoauxiliar], AUX.[TipoAuxiliar]) = TA.[TipoAuxiliar]
               AND M.[CodigoRubro] = TA.[CodigoRubro]
               AND ISNULL(TA.[snEliminado], 0) = 0
            LEFT JOIN [dbo].[tbCodigosTransaccion] T
                ON M.[CodigoTransaccion] = T.[CodigoTransaccion]
               AND M.[CodigoRubro] = T.[CodigoRubro]
               AND T.[IdTipoAuxiliar] = ISNULL(M.[tipoauxiliar], AUX.[TipoAuxiliar])
            WHERE ISNULL(M.[snEliminado], 0) = 0
                AND M.[YearCorte] = @AnioHistorial
                AND M.[MonthCorte] = @MesHistorial
                AND M.[Version] = @VersionHistorial
                AND (@FechaDesdeDate IS NULL OR CAST(M.[FechaMovimiento] AS DATE) >= @FechaDesdeDate)
                AND (@FechaHastaDate IS NULL OR CAST(M.[FechaMovimiento] AS DATE) <= @FechaHastaDate)
                AND (@IdUsuario IS NULL OR M.[UsuarioCrea] = @IdUsuario)
                AND (@CodigoRubro IS NULL OR LTRIM(RTRIM(@CodigoRubro)) = N'' OR M.[CodigoRubro] = @CodigoRubro)
                AND (@CodigoTransaccion IS NULL OR LTRIM(RTRIM(@CodigoTransaccion)) = N'' OR M.[CodigoTransaccion] = @CodigoTransaccion)
                AND (@NumeroAsociado IS NULL OR M.[NumeroAsociado] = @NumeroAsociado)
                AND ISNULL(M.[Monto], 0) <> 0
            GROUP BY
                M.[CodigoRubro],
                R.[Descripcion],
                ISNULL(M.[tipoauxiliar], AUX.[TipoAuxiliar]),
                TA.[Descripcion]
            ORDER BY
                M.[CodigoRubro],
                ISNULL(TA.[Descripcion], ''),
                ISNULL(M.[tipoauxiliar], AUX.[TipoAuxiliar]);
        END
        ELSE
        BEGIN
            SELECT
                M.[CodigoRubro] AS [Código Rubro],
                ISNULL(R.[Descripcion], M.[CodigoRubro]) AS [Rubro],
                ISNULL(ISNULL(M.[tipoauxiliar], AUX.[TipoAuxiliar]), 0) AS [ID Tipo Auxiliar],
                ISNULL(TA.[Descripcion], '(Sin tipo auxiliar)') AS [Tipo Auxiliar],
                COUNT(*) AS [Movimientos],
                SUM(CASE WHEN T.[DebCred] = 'D' THEN ISNULL(M.[Monto], 0) ELSE 0 END) AS [Débito],
                SUM(CASE WHEN T.[DebCred] = 'C' THEN ISNULL(M.[Monto], 0) ELSE 0 END) AS [Crédito],
                SUM(CASE WHEN T.[DebCred] = 'D' THEN ISNULL(M.[Monto], 0) ELSE 0 END)
                    - SUM(CASE WHEN T.[DebCred] = 'C' THEN ISNULL(M.[Monto], 0) ELSE 0 END) AS [Balance]
            FROM [dbo].[tbMovimientos] M
            LEFT JOIN [dbo].[tbRubros] R
                ON M.[CodigoRubro] = R.[CodigoRubro]
            LEFT JOIN [dbo].[tbAuxiliares] AUX
                ON M.[IDAuxiliar] = AUX.[ID]
            LEFT JOIN [dbo].[tbTiposAuxiliares] TA
                ON ISNULL(M.[tipoauxiliar], AUX.[TipoAuxiliar]) = TA.[TipoAuxiliar]
               AND M.[CodigoRubro] = TA.[CodigoRubro]
               AND ISNULL(TA.[snEliminado], 0) = 0
            LEFT JOIN [dbo].[tbCodigosTransaccion] T
                ON M.[CodigoTransaccion] = T.[CodigoTransaccion]
               AND M.[CodigoRubro] = T.[CodigoRubro]
               AND T.[IdTipoAuxiliar] = ISNULL(M.[tipoauxiliar], AUX.[TipoAuxiliar])
            WHERE ISNULL(M.[snEliminado], 0) = 0
                AND (@FechaDesdeDate IS NULL OR CAST(M.[FechaMovimiento] AS DATE) >= @FechaDesdeDate)
                AND (@FechaHastaDate IS NULL OR CAST(M.[FechaMovimiento] AS DATE) <= @FechaHastaDate)
                AND (@IdUsuario IS NULL OR M.[UsuarioCrea] = @IdUsuario)
                AND (@CodigoRubro IS NULL OR LTRIM(RTRIM(@CodigoRubro)) = N'' OR M.[CodigoRubro] = @CodigoRubro)
                AND (@CodigoTransaccion IS NULL OR LTRIM(RTRIM(@CodigoTransaccion)) = N'' OR M.[CodigoTransaccion] = @CodigoTransaccion)
                AND (@NumeroAsociado IS NULL OR M.[NumeroAsociado] = @NumeroAsociado)
                AND ISNULL(M.[Monto], 0) <> 0
            GROUP BY
                M.[CodigoRubro],
                R.[Descripcion],
                ISNULL(M.[tipoauxiliar], AUX.[TipoAuxiliar]),
                TA.[Descripcion]
            ORDER BY
                M.[CodigoRubro],
                ISNULL(TA.[Descripcion], ''),
                ISNULL(M.[tipoauxiliar], AUX.[TipoAuxiliar]);
        END
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();
        RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH
END

