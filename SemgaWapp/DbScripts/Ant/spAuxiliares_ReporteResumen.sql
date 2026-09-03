-- =============================================================================
-- spAuxiliares_ReporteResumen
-- Resumen por Rubro y Tipo Auxiliar (mismos filtros que spAuxiliares_Reporte).
--
-- Filtros (todos opcionales):
--   @CodigosRubroJson   Array JSON de CodigoRubro (ej. N'["AP","AH","CXP"]')
--   @TiposAuxiliarJson  Array JSON de TipoAuxiliar (ej. N'[1,2,5]')
--   @NumeroAsociado     Número de asociado exacto
--
-- @MesHistorial / @AnioHistorial / @VersionHistorial: consulta [dbo].[sys.HST.tbAuxiliares]
--
-- Parámetros de paginación/orden (misma firma que spAuxiliares_Reporte;
-- no aplican al resumen agrupado, se aceptan por compatibilidad).
-- =============================================================================

CREATE OR ALTER PROCEDURE [dbo].[spAuxiliares_ReporteResumen]
    @CodigosRubroJson     NVARCHAR(MAX) = NULL,
    @TiposAuxiliarJson    NVARCHAR(MAX) = NULL,
    @NumeroAsociado       INT = NULL,
    @MesHistorial         INT = NULL,
    @AnioHistorial        INT = NULL,
    @VersionHistorial     INT = NULL,
    @PageSize             INT = 25,
    @PageIndex            INT = 0,
    @SortColumn           INT = 1,
    @SortDirection        VARCHAR(4) = 'DESC'
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        DECLARE @UsarHistorial BIT = 0;

        IF LTRIM(RTRIM(ISNULL(@CodigosRubroJson, ''))) = ''
            OR @CodigosRubroJson = '[]'
            OR ISJSON(@CodigosRubroJson) = 0
            SET @CodigosRubroJson = NULL;

        IF LTRIM(RTRIM(ISNULL(@TiposAuxiliarJson, ''))) = ''
            OR @TiposAuxiliarJson = '[]'
            OR ISJSON(@TiposAuxiliarJson) = 0
            SET @TiposAuxiliarJson = NULL;

        IF @MesHistorial IS NOT NULL AND @MesHistorial BETWEEN 1 AND 12
           AND @AnioHistorial IS NOT NULL AND @AnioHistorial >= 1980
           AND @VersionHistorial IS NOT NULL AND @VersionHistorial >= 0
            SET @UsarHistorial = 1;

        IF @UsarHistorial = 1
        BEGIN
            SELECT
                A.[CodigoRubro] AS [Código Rubro],
                ISNULL(R.[Descripcion], '') AS [Rubro],
                A.[TipoAuxiliar] AS [ID Tipo Auxiliar],
                ISNULL(TA.[Descripcion], '') AS [Tipo Auxiliar],
                COUNT(DISTINCT A.[ID]) AS [Cantidad Auxiliares],
                COUNT(DISTINCT A.[NumeroAsociado]) AS [Cantidad Asociados],
                SUM(ISNULL(A.[Saldo], 0)) AS [Saldo]
            FROM [dbo].[sys.HST.tbAuxiliares] A
            LEFT JOIN [dbo].[tbRubros] R
                ON A.[CodigoRubro] = R.[CodigoRubro]
               AND R.[snEliminado] = 0
            LEFT JOIN [dbo].[tbTiposAuxiliares] TA
                ON A.[TipoAuxiliar] = TA.[TipoAuxiliar]
               AND A.[CodigoRubro] = TA.[CodigoRubro]
               AND TA.[snEliminado] = 0
            WHERE ISNULL(A.[snEliminado], 0) = 0
              AND A.[YearCorte] = @AnioHistorial
              AND A.[MonthCorte] = @MesHistorial
              AND A.[Version] = @VersionHistorial
              AND (
                    @CodigosRubroJson IS NULL
                    OR A.[CodigoRubro] IN (
                        SELECT LTRIM(RTRIM(j.[value]))
                        FROM OPENJSON(@CodigosRubroJson) j
                        WHERE LTRIM(RTRIM(j.[value])) <> ''
                    )
                  )
              AND (
                    @TiposAuxiliarJson IS NULL
                    OR A.[TipoAuxiliar] IN (
                        SELECT TRY_CAST(j.[value] AS INT)
                        FROM OPENJSON(@TiposAuxiliarJson) j
                        WHERE TRY_CAST(j.[value] AS INT) IS NOT NULL
                    )
                  )
              AND (@NumeroAsociado IS NULL OR A.[NumeroAsociado] = @NumeroAsociado)
            GROUP BY
                A.[CodigoRubro],
                R.[Descripcion],
                A.[TipoAuxiliar],
                TA.[Descripcion]
            ORDER BY
                A.[CodigoRubro],
                ISNULL(TA.[Descripcion], ''),
                A.[TipoAuxiliar];
        END
        ELSE
        BEGIN
            SELECT
                A.[CodigoRubro] AS [Código Rubro],
                ISNULL(R.[Descripcion], '') AS [Rubro],
                A.[TipoAuxiliar] AS [ID Tipo Auxiliar],
                ISNULL(TA.[Descripcion], '') AS [Tipo Auxiliar],
                COUNT(DISTINCT A.[ID]) AS [Cantidad Auxiliares],
                COUNT(DISTINCT A.[NumeroAsociado]) AS [Cantidad Asociados],
                SUM(ISNULL(A.[Saldo], 0)) AS [Saldo]
            FROM [dbo].[tbAuxiliares] A
            LEFT JOIN [dbo].[tbRubros] R
                ON A.[CodigoRubro] = R.[CodigoRubro]
               AND R.[snEliminado] = 0
            LEFT JOIN [dbo].[tbTiposAuxiliares] TA
                ON A.[TipoAuxiliar] = TA.[TipoAuxiliar]
               AND A.[CodigoRubro] = TA.[CodigoRubro]
               AND TA.[snEliminado] = 0
            WHERE ISNULL(A.[snEliminado], 0) = 0
              AND (
                    @CodigosRubroJson IS NULL
                    OR A.[CodigoRubro] IN (
                        SELECT LTRIM(RTRIM(j.[value]))
                        FROM OPENJSON(@CodigosRubroJson) j
                        WHERE LTRIM(RTRIM(j.[value])) <> ''
                    )
                  )
              AND (
                    @TiposAuxiliarJson IS NULL
                    OR A.[TipoAuxiliar] IN (
                        SELECT TRY_CAST(j.[value] AS INT)
                        FROM OPENJSON(@TiposAuxiliarJson) j
                        WHERE TRY_CAST(j.[value] AS INT) IS NOT NULL
                    )
                  )
              AND (@NumeroAsociado IS NULL OR A.[NumeroAsociado] = @NumeroAsociado)
            GROUP BY
                A.[CodigoRubro],
                R.[Descripcion],
                A.[TipoAuxiliar],
                TA.[Descripcion]
            ORDER BY
                A.[CodigoRubro],
                ISNULL(TA.[Descripcion], ''),
                A.[TipoAuxiliar];
        END

    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();

        RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH
END
