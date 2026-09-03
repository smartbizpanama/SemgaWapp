CREATE OR ALTER PROCEDURE [dbo].[spMovimientos_ListarResumenAsociado]
    @IdUsuario INT = NULL,
    @FechaDesde VARCHAR(8) = NULL,
    @FechaHasta VARCHAR(8) = NULL,
    @CodigoRubro NVARCHAR(10) = NULL,
    @IdTipoAux INT = NULL,
    @NumeroAsociado INT = NULL
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
            M.[CodigoRubro] AS [CodigoRubro],
            R.[Descripcion] AS [Rubro],
            RIGHT('000000000000' + CAST(AUX.ID AS VARCHAR(12)), 12) AS [Cuenta],
            TA.[Descripcion] AS [TipoAuxiliar],
            SUM(CASE WHEN T.[DebCred] = 'D' THEN ISNULL(M.[Monto], 0) ELSE 0 END) AS [MontoDR],
            SUM(CASE WHEN T.[DebCred] = 'C' THEN ISNULL(M.[Monto], 0) ELSE 0 END) AS [MontoCR],
            SUM(ISNULL(M.[Monto], 0)) AS [Monto],
            M.[NumeroAsociado] AS [NumeroAsociado],
            A.[Nombre] + ' ' + A.[Apellido] AS [NombreCompleto],
            CONCAT(CAST(M.[NumeroAsociado] AS NVARCHAR(MAX)), ' - ', A.[Nombre], ' ', A.[Apellido]) AS [Asociado]
        FROM [dbo].[tbMovimientos] M
        LEFT JOIN [dbo].[tbAsociados] A ON M.[NumeroAsociado] = A.[NumeroAsociado]
        LEFT JOIN [dbo].[tbRubros] R ON M.[CodigoRubro] = R.[CodigoRubro]
        LEFT JOIN [dbo].[tbAuxiliares] AUX ON M.[IDAuxiliar] = AUX.[ID]
        LEFT JOIN [dbo].[tbTiposAuxiliares] TA
            ON AUX.[TipoAuxiliar] = TA.TipoAuxiliar AND AUX.[CodigoRubro] = TA.[CodigoRubro]
        LEFT JOIN [dbo].[tbCodigosTransaccion] T
            ON M.[CodigoTransaccion] = T.[CodigoTransaccion]
            AND M.[CodigoRubro] = T.[CodigoRubro]
            AND T.IdTipoAuxiliar = TA.TipoAuxiliar
        LEFT JOIN [dbo].[tbUsuarios] UC ON M.[UsuarioCrea] = UC.[Id]
        WHERE M.[snEliminado] = 0
            AND (@FechaDesdeDate IS NULL OR M.[FechaMovimiento] >= @FechaDesdeDate)
            AND (@FechaHastaDate IS NULL OR M.[FechaMovimiento] <= @FechaHastaDate)
            AND (@IdUsuario IS NULL OR M.[UsuarioCrea] = @IdUsuario)
            AND (@CodigoRubro IS NULL OR LTRIM(RTRIM(@CodigoRubro)) = N'' OR M.[CodigoRubro] = @CodigoRubro)
            AND (@IdTipoAux IS NULL OR TA.ID = @IdTipoAux)
            AND (@NumeroAsociado IS NULL OR M.[NumeroAsociado] = @NumeroAsociado)
            AND ISNULL(M.[Monto], 0) <> 0
        GROUP BY
            M.[CodigoRubro], R.[Descripcion], AUX.ID, TA.[Descripcion],
            M.[NumeroAsociado], A.[Nombre], A.[Apellido]
        ORDER BY
            M.[CodigoRubro], TA.[Descripcion], M.[NumeroAsociado], AUX.ID;
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();
        RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH
END
GO
