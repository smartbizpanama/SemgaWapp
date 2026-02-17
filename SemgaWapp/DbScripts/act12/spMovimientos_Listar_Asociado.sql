-- act12: Agregar columna [Asociado] al spMovimientos_Listar (para reporte de Movimientos)
-- Ejecutar contra la base de datos SegmaDB

CREATE OR ALTER PROCEDURE [dbo].[spMovimientos_Listar]
    @IdUsuario INT = NULL,
    @FechaDesde VARCHAR(8) = NULL,
    @FechaHasta VARCHAR(8) = NULL,
    @CodigoRubro NVARCHAR(10) = NULL,
    @CodigoTransaccion NVARCHAR(10) = NULL,
    @NumeroAsociado INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -- Convertir fechas de formato yyyyMMdd a DATE
        DECLARE @FechaDesdeDate DATE = NULL;
        DECLARE @FechaHastaDate DATE = NULL;

        IF @FechaDesde IS NOT NULL AND LEN(@FechaDesde) = 8
        BEGIN
            SET @FechaDesdeDate = CONVERT(DATE, @FechaDesde, 112);
        END

        IF @FechaHasta IS NOT NULL AND LEN(@FechaHasta) = 8
        BEGIN
            SET @FechaHastaDate = CONVERT(DATE, @FechaHasta, 112);
        END

        SELECT 
            -- Datos del movimiento para reporte
            M.[IDMovimiento] AS [NoRegistro],
            CONVERT(VARCHAR(10), M.[FechaMovimiento], 103) + ' ' + FORMAT(M.[FechaMovimiento], 'HH:mm:ss') AS [FTranHora],
            ISNULL(A.[Nombre],'') + ' ' + ISNULL(A.[Apellido],'') AS [Asociado],
            T.[Descripcion] AS [CodigoTran],
            R.[Descripcion] AS [Auxiliar],
            RIGHT('000000000000' + CAST(AUX.ID AS VARCHAR(12)), 12) AS [Cuenta],
            TA.[Descripcion] AS [Tipo],
            CASE WHEN T.[DebCred] = 'D' THEN M.[Monto] ELSE 0 END AS [MontoDR],
            CASE WHEN T.[DebCred] = 'C' THEN M.[Monto] ELSE 0 END AS [MontoCR],
            -- Campos adicionales para agrupación y ordenamiento
            M.[CodigoRubro] AS [CodigoRubro],
            R.[Descripcion] AS [Rubro],
            M.[FechaMovimiento] AS [FechaMovimientoOrden],
            -- Datos adicionales para el reporte
            M.[NumeroAsociado] AS [NumeroAsociado],
            ISNULL(A.[Nombre],'') + ' ' + ISNULL(A.[Apellido],'') AS [NombreCompleto],
            UC.[Usuario] AS [UsuarioCrea]
        FROM [dbo].[tbMovimientos] M
        LEFT JOIN [dbo].[tbAsociados] A ON M.[NumeroAsociado] = A.[NumeroAsociado]
        LEFT JOIN [dbo].[tbRubros] R ON M.[CodigoRubro] = R.[CodigoRubro]
        LEFT JOIN [dbo].[tbCodigosTransaccion] T ON M.[CodigoTransaccion] = T.[CodigoTransaccion] AND M.[CodigoRubro] = T.[CodigoRubro]
        LEFT JOIN [dbo].[tbAuxiliares] AUX ON M.[IDAuxiliar] = AUX.[ID]
        LEFT JOIN [dbo].[tbTiposAuxiliares] TA ON AUX.[TipoAuxiliar] = TA.ID AND AUX.[CodigoRubro] = TA.[CodigoRubro]
        LEFT JOIN [dbo].[tbUsuarios] UC ON M.[UsuarioCrea] = UC.[Id]
        WHERE M.[snEliminado] = 0
            -- Filtro por FechaMovimiento (opcional)
            AND (@FechaDesdeDate IS NULL OR M.[FechaMovimiento] >= @FechaDesdeDate)
            AND (@FechaHastaDate IS NULL OR M.[FechaMovimiento] <= @FechaHastaDate)
            -- Filtro por UsuarioCrea
            AND (@IdUsuario IS NULL OR M.[UsuarioCrea] = @IdUsuario)
            -- Filtro por Código Rubro
            AND (@CodigoRubro IS NULL OR LTRIM(RTRIM(@CodigoRubro)) = N'' OR M.[CodigoRubro] = @CodigoRubro)
            -- Filtro por Código Transacción
            AND (@CodigoTransaccion IS NULL OR LTRIM(RTRIM(@CodigoTransaccion)) = N'' OR M.[CodigoTransaccion] = @CodigoTransaccion)
            -- Filtro por Número de Asociado
            AND (@NumeroAsociado IS NULL OR M.[NumeroAsociado] = @NumeroAsociado)
        ORDER BY M.[CodigoRubro], M.[FechaMovimiento], M.[IDMovimiento]
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();
        RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH
END
GO
