-- Reporte Movimientos — detallado
-- @MesHistorial / @AnioHistorial / @VersionHistorial: consulta [dbo].[sys.HST.tbMovimientos]

ALTER PROCEDURE [dbo].[spMovimientos_Reporte]
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
                M.[IDMovimiento] AS [NoRegistro],
                CONVERT(VARCHAR(10), M.[FechaMovimiento], 103) + ' ' + FORMAT(M.[FechaMovimiento], 'HH:mm:ss') AS [FTranHora],
                LTRIM(RTRIM(ISNULL(A.[Nombre], '') + ' ' + ISNULL(A.[Apellido], ''))) AS [Asociado],
                M.[CodigoTransaccion] AS [CodigoTransaccion],
                ISNULL(T.[Descripcion], M.[CodigoTransaccion]) AS [CodigoTran],
                ISNULL(R.[Descripcion], M.[CodigoRubro]) AS [Auxiliar],
                ISNULL(R.[Descripcion], M.[CodigoRubro]) AS [Rubro],
                RIGHT('000000000000' + CAST(ISNULL(AUX.[ID], ISNULL(M.[IDAuxiliar], 0)) AS VARCHAR(12)), 12) AS [Cuenta],
                ISNULL(TA.[Descripcion], '') AS [Tipo],
                CASE WHEN T.[DebCred] = 'D' THEN ISNULL(M.[Monto], 0) ELSE 0 END AS [MontoDR],
                CASE WHEN T.[DebCred] = 'C' THEN ISNULL(M.[Monto], 0) ELSE 0 END AS [MontoCR],
                M.[CodigoRubro] AS [CodigoRubro],
                M.[FechaMovimiento] AS [FechaMovimientoOrden],
                M.[NumeroAsociado] AS [NumeroAsociado],
                LTRIM(RTRIM(ISNULL(A.[Nombre], '') + ' ' + ISNULL(A.[Apellido], ''))) AS [NombreCompleto],
                UC.[Usuario] AS [UsuarioCrea]
            FROM [dbo].[sys.HST.tbMovimientos] M
            LEFT JOIN [dbo].[tbAsociados] A
                ON M.[NumeroAsociado] = A.[NumeroAsociado]
               AND A.[snEliminado] = 0
            LEFT JOIN [dbo].[tbRubros] R
                ON M.[CodigoRubro] = R.[CodigoRubro]
            LEFT JOIN [dbo].[tbAuxiliares] AUX
                ON M.[IDAuxiliar] = AUX.[ID]
            LEFT JOIN [dbo].[tbCodigosTransaccion] T
                ON M.[CodigoTransaccion] = T.[CodigoTransaccion]
               AND M.[CodigoRubro] = T.[CodigoRubro]
               AND T.[IdTipoAuxiliar] = ISNULL(M.[tipoauxiliar], AUX.[TipoAuxiliar])
               AND ISNULL(T.[SnEliminado], 0) = 0
            LEFT JOIN [dbo].[tbTiposAuxiliares] TA
                ON ISNULL(M.[tipoauxiliar], AUX.[TipoAuxiliar]) = TA.[TipoAuxiliar]
               AND M.[CodigoRubro] = TA.[CodigoRubro]
               AND ISNULL(TA.[snEliminado], 0) = 0
            LEFT JOIN [dbo].[tbUsuarios] UC
                ON M.[UsuarioCrea] = UC.[Id]
               AND UC.[snEliminado] = 0
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
            ORDER BY M.[CodigoRubro], M.[FechaMovimiento], M.[IDMovimiento];
        END
        ELSE
        BEGIN
            SELECT
                M.[IDMovimiento] AS [NoRegistro],
                CONVERT(VARCHAR(10), M.[FechaMovimiento], 103) + ' ' + FORMAT(M.[FechaMovimiento], 'HH:mm:ss') AS [FTranHora],
                LTRIM(RTRIM(ISNULL(A.[Nombre], '') + ' ' + ISNULL(A.[Apellido], ''))) AS [Asociado],
                M.[CodigoTransaccion] AS [CodigoTransaccion],
                ISNULL(T.[Descripcion], M.[CodigoTransaccion]) AS [CodigoTran],
                ISNULL(R.[Descripcion], M.[CodigoRubro]) AS [Auxiliar],
                ISNULL(R.[Descripcion], M.[CodigoRubro]) AS [Rubro],
                RIGHT('000000000000' + CAST(ISNULL(AUX.[ID], 0) AS VARCHAR(12)), 12) AS [Cuenta],
                ISNULL(TA.[Descripcion], '') AS [Tipo],
                CASE WHEN T.[DebCred] = 'D' THEN ISNULL(M.[Monto], 0) ELSE 0 END AS [MontoDR],
                CASE WHEN T.[DebCred] = 'C' THEN ISNULL(M.[Monto], 0) ELSE 0 END AS [MontoCR],
                M.[CodigoRubro] AS [CodigoRubro],
                M.[FechaMovimiento] AS [FechaMovimientoOrden],
                M.[NumeroAsociado] AS [NumeroAsociado],
                LTRIM(RTRIM(ISNULL(A.[Nombre], '') + ' ' + ISNULL(A.[Apellido], ''))) AS [NombreCompleto],
                UC.[Usuario] AS [UsuarioCrea]
            FROM [dbo].[tbMovimientos] M
            LEFT JOIN [dbo].[tbAsociados] A
                ON M.[NumeroAsociado] = A.[NumeroAsociado]
               AND A.[snEliminado] = 0
            LEFT JOIN [dbo].[tbRubros] R
                ON M.[CodigoRubro] = R.[CodigoRubro]
            LEFT JOIN [dbo].[tbAuxiliares] AUX
                ON M.[IDAuxiliar] = AUX.[ID]
            LEFT JOIN [dbo].[tbCodigosTransaccion] T
                ON M.[CodigoTransaccion] = T.[CodigoTransaccion]
               AND M.[CodigoRubro] = T.[CodigoRubro]
               AND T.[IdTipoAuxiliar] = ISNULL(M.[tipoauxiliar], AUX.[TipoAuxiliar])
               AND ISNULL(T.[SnEliminado], 0) = 0
            LEFT JOIN [dbo].[tbTiposAuxiliares] TA
                ON ISNULL(M.[tipoauxiliar], AUX.[TipoAuxiliar]) = TA.[TipoAuxiliar]
               AND M.[CodigoRubro] = TA.[CodigoRubro]
               AND ISNULL(TA.[snEliminado], 0) = 0
            LEFT JOIN [dbo].[tbUsuarios] UC
                ON M.[UsuarioCrea] = UC.[Id]
               AND UC.[snEliminado] = 0
            WHERE ISNULL(M.[snEliminado], 0) = 0
                AND (@FechaDesdeDate IS NULL OR CAST(M.[FechaMovimiento] AS DATE) >= @FechaDesdeDate)
                AND (@FechaHastaDate IS NULL OR CAST(M.[FechaMovimiento] AS DATE) <= @FechaHastaDate)
                AND (@IdUsuario IS NULL OR M.[UsuarioCrea] = @IdUsuario)
                AND (@CodigoRubro IS NULL OR LTRIM(RTRIM(@CodigoRubro)) = N'' OR M.[CodigoRubro] = @CodigoRubro)
                AND (@CodigoTransaccion IS NULL OR LTRIM(RTRIM(@CodigoTransaccion)) = N'' OR M.[CodigoTransaccion] = @CodigoTransaccion)
                AND (@NumeroAsociado IS NULL OR M.[NumeroAsociado] = @NumeroAsociado)
                AND ISNULL(M.[Monto], 0) <> 0
            ORDER BY M.[CodigoRubro], M.[FechaMovimiento], M.[IDMovimiento];
        END
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();
        RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH
END
