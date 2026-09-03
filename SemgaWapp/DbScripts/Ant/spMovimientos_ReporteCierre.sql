-- Reporte de cierre / impresion de Movimientos (no modifica spMovimientos_Reporte).
-- Devuelve 2 conjuntos de resultados:
--   1) Detalle por movimiento (plantilla ReporteMovimientos.html, agrupado por rubro en VB)
--   2) Resumen por rubro y tipo auxiliar (totales de cierre)
-- Mismos filtros que spMovimientos_Reporte / spMovimientos_ReporteResumen.
-- @MesHistorial / @AnioHistorial / @VersionHistorial: consulta [dbo].[sys.HST.tbMovimientos]

ALTER PROCEDURE [dbo].[spMovimientos_ReporteCierre]
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

        IF OBJECT_ID('tempdb..#MovBase') IS NOT NULL
            DROP TABLE #MovBase;

        /* Una sola definicion de #MovBase (evita error 2714 por doble SELECT INTO) */
        CREATE TABLE #MovBase (
            [IDMovimiento] INT NOT NULL,
            [NumeroAsociado] INT NULL,
            [CodigoRubro] VARCHAR(5) NULL,
            [IDAuxiliar] INT NULL,
            [CodigoTransaccion] VARCHAR(10) NULL,
            [FechaMovimiento] DATETIME NULL,
            [Monto] NUMERIC(18, 2) NULL,
            [UsuarioCrea] INT NULL,
            [tipoauxiliar] INT NULL
        );

        IF @UsarHistorial = 1
        BEGIN
            INSERT INTO #MovBase (
                [IDMovimiento], [NumeroAsociado], [CodigoRubro], [IDAuxiliar], [CodigoTransaccion],
                [FechaMovimiento], [Monto], [UsuarioCrea], [tipoauxiliar]
            )
            SELECT
                M.[IDMovimiento],
                M.[NumeroAsociado],
                M.[CodigoRubro],
                M.[IDAuxiliar],
                M.[CodigoTransaccion],
                M.[FechaMovimiento],
                M.[Monto],
                M.[UsuarioCrea],
                M.[tipoauxiliar]
            FROM [dbo].[sys.HST.tbMovimientos] M
            WHERE ISNULL(M.[snEliminado], 0) = 0
              AND ISNULL(M.[Monto], 0) <> 0
              AND M.[YearCorte] = @AnioHistorial
              AND M.[MonthCorte] = @MesHistorial
              AND M.[Version] = @VersionHistorial
              AND (@FechaDesdeDate IS NULL OR CAST(M.[FechaMovimiento] AS DATE) >= @FechaDesdeDate)
              AND (@FechaHastaDate IS NULL OR CAST(M.[FechaMovimiento] AS DATE) <= @FechaHastaDate)
              AND (@IdUsuario IS NULL OR M.[UsuarioCrea] = @IdUsuario)
              AND (@CodigoRubro IS NULL OR LTRIM(RTRIM(@CodigoRubro)) = N'' OR M.[CodigoRubro] = @CodigoRubro)
              AND (@CodigoTransaccion IS NULL OR LTRIM(RTRIM(@CodigoTransaccion)) = N'' OR M.[CodigoTransaccion] = @CodigoTransaccion)
              AND (@NumeroAsociado IS NULL OR M.[NumeroAsociado] = @NumeroAsociado);
        END
        ELSE
        BEGIN
            INSERT INTO #MovBase (
                [IDMovimiento], [NumeroAsociado], [CodigoRubro], [IDAuxiliar], [CodigoTransaccion],
                [FechaMovimiento], [Monto], [UsuarioCrea], [tipoauxiliar]
            )
            SELECT
                M.[IDMovimiento],
                M.[NumeroAsociado],
                M.[CodigoRubro],
                M.[IDAuxiliar],
                M.[CodigoTransaccion],
                M.[FechaMovimiento],
                M.[Monto],
                M.[UsuarioCrea],
                NULL
            FROM [dbo].[tbMovimientos] M
            WHERE M.[snEliminado] = 0
              AND ISNULL(M.[Monto], 0) <> 0
              AND (@FechaDesdeDate IS NULL OR CAST(M.[FechaMovimiento] AS DATE) >= @FechaDesdeDate)
              AND (@FechaHastaDate IS NULL OR CAST(M.[FechaMovimiento] AS DATE) <= @FechaHastaDate)
              AND (@IdUsuario IS NULL OR M.[UsuarioCrea] = @IdUsuario)
              AND (@CodigoRubro IS NULL OR LTRIM(RTRIM(@CodigoRubro)) = N'' OR M.[CodigoRubro] = @CodigoRubro)
              AND (@CodigoTransaccion IS NULL OR LTRIM(RTRIM(@CodigoTransaccion)) = N'' OR M.[CodigoTransaccion] = @CodigoTransaccion)
              AND (@NumeroAsociado IS NULL OR M.[NumeroAsociado] = @NumeroAsociado);
        END

        /* --- Resultado 1: detalle impresion --- */
        SELECT
            MB.[IDMovimiento] AS [NoRegistro],
            CONVERT(VARCHAR(10), MB.[FechaMovimiento], 103) + ' ' + FORMAT(MB.[FechaMovimiento], 'HH:mm:ss') AS [FTranHora],
            LTRIM(RTRIM(ISNULL(A.[Nombre], '') + ' ' + ISNULL(A.[Apellido], ''))) AS [Asociado],
            MB.[CodigoTransaccion] AS [CodigoTransaccion],
            ISNULL(T.[Descripcion], MB.[CodigoTransaccion]) AS [CodigoTran],
            ISNULL(R.[Descripcion], MB.[CodigoRubro]) AS [Auxiliar],
            ISNULL(R.[Descripcion], MB.[CodigoRubro]) AS [Rubro],
            RIGHT('000000000000' + CAST(ISNULL(AUX.[ID], ISNULL(MB.[IDAuxiliar], 0)) AS VARCHAR(12)), 12) AS [Cuenta],
            ISNULL(TA.[Descripcion], '') AS [Tipo],
            CASE WHEN T.[DebCred] = 'D' THEN ISNULL(MB.[Monto], 0) ELSE 0 END AS [MontoDR],
            CASE WHEN T.[DebCred] = 'C' THEN ISNULL(MB.[Monto], 0) ELSE 0 END AS [MontoCR],
            MB.[CodigoRubro] AS [CodigoRubro],
            MB.[FechaMovimiento] AS [FechaMovimientoOrden],
            MB.[NumeroAsociado] AS [NumeroAsociado],
            LTRIM(RTRIM(ISNULL(A.[Nombre], '') + ' ' + ISNULL(A.[Apellido], ''))) AS [NombreCompleto],
            UC.[Usuario] AS [UsuarioCrea]
        FROM #MovBase MB
        LEFT JOIN [dbo].[tbAsociados] A
            ON MB.[NumeroAsociado] = A.[NumeroAsociado]
           AND A.[snEliminado] = 0
        LEFT JOIN [dbo].[tbRubros] R
            ON MB.[CodigoRubro] = R.[CodigoRubro]
        LEFT JOIN [dbo].[tbAuxiliares] AUX
            ON MB.[IDAuxiliar] = AUX.[ID]
        LEFT JOIN [dbo].[tbCodigosTransaccion] T
            ON MB.[CodigoTransaccion] = T.[CodigoTransaccion]
           AND MB.[CodigoRubro] = T.[CodigoRubro]
           AND T.[IdTipoAuxiliar] = CASE WHEN @UsarHistorial = 1 THEN ISNULL(MB.[tipoauxiliar], AUX.[TipoAuxiliar]) ELSE AUX.[TipoAuxiliar] END
           AND ISNULL(T.[SnEliminado], 0) = 0
        LEFT JOIN [dbo].[tbTiposAuxiliares] TA
            ON (CASE WHEN @UsarHistorial = 1 THEN ISNULL(MB.[tipoauxiliar], AUX.[TipoAuxiliar]) ELSE AUX.[TipoAuxiliar] END) = TA.[TipoAuxiliar]
           AND MB.[CodigoRubro] = TA.[CodigoRubro]
           AND ISNULL(TA.[snEliminado], 0) = 0
        LEFT JOIN [dbo].[tbUsuarios] UC
            ON MB.[UsuarioCrea] = UC.[Id]
           AND UC.[snEliminado] = 0
        ORDER BY MB.[CodigoRubro], MB.[FechaMovimiento], MB.[IDMovimiento];

        /* --- Resultado 2: resumen cierre --- */
        SELECT
            MB.[CodigoRubro] AS [Codigo Rubro],
            ISNULL(R.[Descripcion], MB.[CodigoRubro]) AS [Rubro],
            ISNULL(CASE WHEN @UsarHistorial = 1 THEN ISNULL(MB.[tipoauxiliar], AUX.[TipoAuxiliar]) ELSE AUX.[TipoAuxiliar] END, 0) AS [ID Tipo Auxiliar],
            ISNULL(TA.[Descripcion], '(Sin tipo auxiliar)') AS [Tipo Auxiliar],
            COUNT(*) AS [Movimientos],
            SUM(CASE WHEN T.[DebCred] = 'D' THEN ISNULL(MB.[Monto], 0) ELSE 0 END) AS [Débito],
            SUM(CASE WHEN T.[DebCred] = 'C' THEN ISNULL(MB.[Monto], 0) ELSE 0 END) AS [Crédito],
            SUM(CASE WHEN T.[DebCred] = 'D' THEN ISNULL(MB.[Monto], 0) ELSE 0 END)
                - SUM(CASE WHEN T.[DebCred] = 'C' THEN ISNULL(MB.[Monto], 0) ELSE 0 END) AS [Balance]
        FROM #MovBase MB
        LEFT JOIN [dbo].[tbRubros] R
            ON MB.[CodigoRubro] = R.[CodigoRubro]
        LEFT JOIN [dbo].[tbAuxiliares] AUX
            ON MB.[IDAuxiliar] = AUX.[ID]
        LEFT JOIN [dbo].[tbTiposAuxiliares] TA
            ON (CASE WHEN @UsarHistorial = 1 THEN ISNULL(MB.[tipoauxiliar], AUX.[TipoAuxiliar]) ELSE AUX.[TipoAuxiliar] END) = TA.[TipoAuxiliar]
           AND MB.[CodigoRubro] = TA.[CodigoRubro]
           AND ISNULL(TA.[snEliminado], 0) = 0
        LEFT JOIN [dbo].[tbCodigosTransaccion] T
            ON MB.[CodigoTransaccion] = T.[CodigoTransaccion]
           AND MB.[CodigoRubro] = T.[CodigoRubro]
           AND T.[IdTipoAuxiliar] = CASE WHEN @UsarHistorial = 1 THEN ISNULL(MB.[tipoauxiliar], AUX.[TipoAuxiliar]) ELSE AUX.[TipoAuxiliar] END
           AND ISNULL(T.[SnEliminado], 0) = 0
        GROUP BY
            MB.[CodigoRubro],
            R.[Descripcion],
            CASE WHEN @UsarHistorial = 1 THEN ISNULL(MB.[tipoauxiliar], AUX.[TipoAuxiliar]) ELSE AUX.[TipoAuxiliar] END,
            TA.[Descripcion]
        ORDER BY
            MB.[CodigoRubro],
            ISNULL(TA.[Descripcion], ''),
            CASE WHEN @UsarHistorial = 1 THEN ISNULL(MB.[tipoauxiliar], AUX.[TipoAuxiliar]) ELSE AUX.[TipoAuxiliar] END;

        DROP TABLE #MovBase;
    END TRY
    BEGIN CATCH
        IF OBJECT_ID('tempdb..#MovBase') IS NOT NULL
            DROP TABLE #MovBase;
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();
        RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH
END
