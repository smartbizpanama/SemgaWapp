-- Estado de cuenta regular por asociado (detalle de movimientos por auxiliar/cuenta)
CREATE OR ALTER PROCEDURE [dbo].[spAsociados_EstadoCuentaRegular]
    @NumeroAsociado INT,
    @FechaDesde VARCHAR(8) = NULL,
    @FechaHasta VARCHAR(8) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        IF @NumeroAsociado IS NULL
        BEGIN
            RAISERROR('El número de asociado es obligatorio.', 16, 1);
            RETURN;
        END

        DECLARE @FechaDesdeDate DATE = NULL;
        DECLARE @FechaHastaDate DATE = NULL;

        IF @FechaDesde IS NOT NULL AND LEN(LTRIM(RTRIM(@FechaDesde))) = 8
            SET @FechaDesdeDate = CONVERT(DATE, @FechaDesde, 112);

        IF @FechaHasta IS NOT NULL AND LEN(LTRIM(RTRIM(@FechaHasta))) = 8
            SET @FechaHastaDate = CONVERT(DATE, @FechaHasta, 112);

        SELECT
            A_SOC.[NumeroAsociado],
            LTRIM(RTRIM(
                ISNULL(A_SOC.[Nombre], '') + ' ' +
                ISNULL(A_SOC.[SegundoNombre], '') + ' ' +
                ISNULL(A_SOC.[Apellido], '') + ' ' +
                ISNULL(A_SOC.[SegundoApellido], '')
            )) AS [NombreCompleto],
            ISNULL(A_SOC.[TipoIdentificacion], '') AS [TipoIdentificacion],
            ISNULL(A_SOC.[NumeroIdentificacion], '') AS [NumeroIdentificacion],
            M.[CodigoRubro],
            ISNULL(R.[Descripcion], M.[CodigoRubro]) AS [Rubro],
            AUX.[ID] AS [IDAuxiliar],
            RIGHT('000000000000' + CAST(AUX.[ID] AS VARCHAR(12)), 12) AS [Cuenta],
            CONCAT(
                RIGHT('00' + CAST(ISNULL(TA.[TipoAuxiliar], 0) AS VARCHAR(3)), 2),
                ' - ',
                ISNULL(TA.[Descripcion], ISNULL(R.[Descripcion], M.[CodigoRubro]))
            ) AS [AuxiliarEtiqueta],
            CONVERT(VARCHAR(10), M.[FechaMovimiento], 103) AS [FechaTransaccion],
            M.[CodigoTransaccion],
            ISNULL(T.[Descripcion], M.[CodigoTransaccion]) AS [DescripcionTransaccion],
            CASE WHEN T.[DebCred] = 'D' THEN ISNULL(M.[Monto], 0) ELSE 0 END AS [MontoDebito],
            CASE WHEN T.[DebCred] = 'C' THEN ISNULL(M.[Monto], 0) ELSE 0 END AS [MontoCredito],
            ISNULL(M.[Saldo], 0) AS [Saldo],
            M.[FechaMovimiento] AS [FechaMovimientoOrden],
            M.[IDMovimiento]
        FROM [dbo].[tbMovimientos] M
        INNER JOIN [dbo].[tbAsociados] A_SOC
            ON M.[NumeroAsociado] = A_SOC.[NumeroAsociado]
           AND ISNULL(A_SOC.[snEliminado], 0) = 0
        LEFT JOIN [dbo].[tbRubros] R
            ON M.[CodigoRubro] = R.[CodigoRubro]
        LEFT JOIN [dbo].[tbAuxiliares] AUX
            ON M.[IDAuxiliar] = AUX.[ID]
           AND ISNULL(AUX.[snEliminado], 0) = 0
        LEFT JOIN [dbo].[tbTiposAuxiliares] TA
            ON AUX.[TipoAuxiliar] = TA.[TipoAuxiliar]
           AND AUX.[CodigoRubro] = TA.[CodigoRubro]
           AND ISNULL(TA.[snEliminado], 0) = 0
        LEFT JOIN [dbo].[tbCodigosTransaccion] T
            ON M.[CodigoTransaccion] = T.[CodigoTransaccion]
           AND M.[CodigoRubro] = T.[CodigoRubro]
           AND T.[IdTipoAuxiliar] = TA.[TipoAuxiliar]
        WHERE M.[snEliminado] = 0
          AND M.[NumeroAsociado] = @NumeroAsociado
          AND ISNULL(M.[Monto], 0) <> 0
          AND (@FechaDesdeDate IS NULL OR M.[FechaMovimiento] >= @FechaDesdeDate)
          AND (@FechaHastaDate IS NULL OR M.[FechaMovimiento] <= @FechaHastaDate)
        ORDER BY
            M.[CodigoRubro],
            AUX.[ID],
            M.[FechaMovimiento],
            M.[IDMovimiento];
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();
        RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH
END
GO
