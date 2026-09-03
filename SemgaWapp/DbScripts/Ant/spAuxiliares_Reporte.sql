-- =============================================================================
-- spAuxiliares_Reporte
-- Reporte de auxiliares con filtros opcionales, ordenación y paginación.
--
-- Filtros (todos opcionales):
--   @CodigosRubroJson   Array JSON de CodigoRubro (ej. N'["AP","AH","CXP"]')
--   @TiposAuxiliarJson  Array JSON de TipoAuxiliar (ej. N'[1,2,5]')
--   @NumeroAsociado     Número de asociado exacto
--
-- @MesHistorial / @AnioHistorial / @VersionHistorial: consulta [dbo].[sys.HST.tbAuxiliares]
--
-- Paginación:
--   @PageSize         Tamaño de página (default 25)
--   @PageIndex        Índice 0-based (default 0)
--
-- Ordenación:
--   @SortColumn       1=ID Auxiliar, 2=Número Asociado, 3=Código Rubro, 4=Rubro,
--                     5=ID Tipo Auxiliar, 6=Tipo Auxiliar, 7=Cuota, 8=Saldo,
--                     9=Fecha Creación, 10=Fecha Modificación, 11=Monto Original,
--                     12=Fecha Otorgamiento, 13=Tasa Interés, 14=Pago Mensual,
--                     15=Fecha Último Pago, 16=Activo (snActivo)
--   @SortDirection    'ASC' | 'DESC' (default 'DESC')
--
-- Retorna TotalRegistros en cada fila (total sin paginar, según filtros).
-- =============================================================================

CREATE OR ALTER PROCEDURE [dbo].[spAuxiliares_Reporte]
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
        DECLARE @TotalRegistros INT;

        -- Normalizar JSON de filtros (vacío, [] o JSON inválido = sin filtro)
        IF LTRIM(RTRIM(ISNULL(@CodigosRubroJson, ''))) = ''
            OR @CodigosRubroJson = '[]'
            OR ISJSON(@CodigosRubroJson) = 0
            SET @CodigosRubroJson = NULL;

        IF LTRIM(RTRIM(ISNULL(@TiposAuxiliarJson, ''))) = ''
            OR @TiposAuxiliarJson = '[]'
            OR ISJSON(@TiposAuxiliarJson) = 0
            SET @TiposAuxiliarJson = NULL;

        IF @PageSize IS NULL OR @PageSize < 1
            SET @PageSize = 25;

        IF @PageSize > 500
            SET @PageSize = 500;

        IF @PageIndex IS NULL OR @PageIndex < 0
            SET @PageIndex = 0;

        IF @SortColumn IS NULL OR @SortColumn < 1 OR @SortColumn > 16
            SET @SortColumn = 1;

        IF UPPER(LTRIM(RTRIM(ISNULL(@SortDirection, 'DESC')))) NOT IN ('ASC', 'DESC')
            SET @SortDirection = 'DESC';
        ELSE
            SET @SortDirection = UPPER(LTRIM(RTRIM(@SortDirection)));

        IF @MesHistorial IS NOT NULL AND @MesHistorial BETWEEN 1 AND 12
           AND @AnioHistorial IS NOT NULL AND @AnioHistorial >= 1980
           AND @VersionHistorial IS NOT NULL AND @VersionHistorial >= 0
            SET @UsarHistorial = 1;

        IF @UsarHistorial = 1
        BEGIN
            SELECT @TotalRegistros = COUNT(*)
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
              AND (@NumeroAsociado IS NULL OR A.[NumeroAsociado] = @NumeroAsociado);

            SELECT
                A.[ID] AS [ID Auxiliar],
                A.[NumeroAsociado] AS [Número de Asociado],
                A.[CodigoRubro] AS [Código Rubro],
                R.[Descripcion] AS [Rubro],
                A.[TipoAuxiliar] AS [ID Tipo Auxiliar],
                TA.[Descripcion] AS [Tipo Auxiliar],
                FORMAT(A.[Cuota], 'C') AS [Cuota],
                FORMAT(A.[Saldo], 'C') AS [Saldo],

                CONVERT(VARCHAR(10), A.[FechaCreacion], 103) AS [Fecha de Creación],
                FORMAT(A.[FechaCreacion], 'hh:mm:ss tt') AS [Hora de Creación],
                CONVERT(VARCHAR(10), A.[FechaModificacion], 103) AS [Fecha de Modificación],
                FORMAT(A.[FechaModificacion], 'hh:mm:ss tt') AS [Hora de Modificación],

                A.[UsuarioCrea] AS [ID Usuario Crea],
                UC.[Usuario] AS [Usuario que Crea],
                A.[UsuarioModifica] AS [ID Usuario Modifica],
                UM.[Usuario] AS [Usuario que Modifica],

                FORMAT(A.[MontoOriginal], 'C') AS [Monto Original],
                CONVERT(VARCHAR(10), A.[FechaOtorgado], 103) AS [Fecha de Otorgamiento],
                FORMAT(A.[FechaOtorgado], 'hh:mm:ss tt') AS [Hora de Otorgamiento],

                FORMAT(A.[TasaInteres], 'N2') AS [Tasa de Interés],
                FORMAT(A.[PagoMes], 'C') AS [Pago Mensual],
                FORMAT(A.[InteresCalculado], 'C') AS [Interés Calculado],
                FORMAT(A.[InteresPagado], 'C') AS [Interés Pagado],

                CONVERT(VARCHAR(10), A.[FechaUltimoPago], 103) AS [Fecha Último Pago],
                FORMAT(A.[FechaUltimoPago], 'hh:mm:ss tt') AS [Hora Último Pago],
                CONVERT(VARCHAR(10), A.[FechaUltimoRetiro], 103) AS [Fecha Último Retiro],
                FORMAT(A.[FechaUltimoRetiro], 'hh:mm:ss tt') AS [Hora Último Retiro],

                CASE WHEN A.[snActivo] = 1 THEN 'SI' ELSE 'NO' END AS [¿Activo?],
                CASE WHEN A.[snEliminado] = 1 THEN 'SI' ELSE 'NO' END AS [¿Eliminado?],
                FORMAT(A.[MontoPignorado], 'C') AS [Monto Pignorado],

                A.[UsuarioElimina] AS [ID Usuario Elimina],
                UE.[Usuario] AS [Usuario que Elimina],
                CONVERT(VARCHAR(10), A.[FechaElimina], 103) AS [Fecha de Eliminación],
                FORMAT(A.[FechaElimina], 'hh:mm:ss tt') AS [Hora de Eliminación],

                @TotalRegistros AS [TotalRegistros]
            FROM [dbo].[sys.HST.tbAuxiliares] A
            LEFT JOIN [dbo].[tbRubros] R
                ON A.[CodigoRubro] = R.[CodigoRubro]
               AND R.[snEliminado] = 0
            LEFT JOIN [dbo].[tbTiposAuxiliares] TA
                ON A.[TipoAuxiliar] = TA.[TipoAuxiliar]
               AND A.[CodigoRubro] = TA.[CodigoRubro]
               AND TA.[snEliminado] = 0
            LEFT JOIN [dbo].[tbUsuarios] UC
                ON A.[UsuarioCrea] = UC.[Id]
               AND UC.[snEliminado] = 0
            LEFT JOIN [dbo].[tbUsuarios] UM
                ON A.[UsuarioModifica] = UM.[Id]
               AND UM.[snEliminado] = 0
            LEFT JOIN [dbo].[tbUsuarios] UE
                ON A.[UsuarioElimina] = UE.[Id]
               AND UE.[snEliminado] = 0
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
            ORDER BY
                CASE WHEN @SortColumn = 1  AND @SortDirection = 'ASC'  THEN A.[ID] END ASC,
                CASE WHEN @SortColumn = 1  AND @SortDirection = 'DESC' THEN A.[ID] END DESC,
                CASE WHEN @SortColumn = 2  AND @SortDirection = 'ASC'  THEN A.[NumeroAsociado] END ASC,
                CASE WHEN @SortColumn = 2  AND @SortDirection = 'DESC' THEN A.[NumeroAsociado] END DESC,
                CASE WHEN @SortColumn = 3  AND @SortDirection = 'ASC'  THEN A.[CodigoRubro] END ASC,
                CASE WHEN @SortColumn = 3  AND @SortDirection = 'DESC' THEN A.[CodigoRubro] END DESC,
                CASE WHEN @SortColumn = 4  AND @SortDirection = 'ASC'  THEN ISNULL(R.[Descripcion], '') END ASC,
                CASE WHEN @SortColumn = 4  AND @SortDirection = 'DESC' THEN ISNULL(R.[Descripcion], '') END DESC,
                CASE WHEN @SortColumn = 5  AND @SortDirection = 'ASC'  THEN A.[TipoAuxiliar] END ASC,
                CASE WHEN @SortColumn = 5  AND @SortDirection = 'DESC' THEN A.[TipoAuxiliar] END DESC,
                CASE WHEN @SortColumn = 6  AND @SortDirection = 'ASC'  THEN ISNULL(TA.[Descripcion], '') END ASC,
                CASE WHEN @SortColumn = 6  AND @SortDirection = 'DESC' THEN ISNULL(TA.[Descripcion], '') END DESC,
                CASE WHEN @SortColumn = 7  AND @SortDirection = 'ASC'  THEN A.[Cuota] END ASC,
                CASE WHEN @SortColumn = 7  AND @SortDirection = 'DESC' THEN A.[Cuota] END DESC,
                CASE WHEN @SortColumn = 8  AND @SortDirection = 'ASC'  THEN A.[Saldo] END ASC,
                CASE WHEN @SortColumn = 8  AND @SortDirection = 'DESC' THEN A.[Saldo] END DESC,
                CASE WHEN @SortColumn = 9  AND @SortDirection = 'ASC'  THEN A.[FechaCreacion] END ASC,
                CASE WHEN @SortColumn = 9  AND @SortDirection = 'DESC' THEN A.[FechaCreacion] END DESC,
                CASE WHEN @SortColumn = 10 AND @SortDirection = 'ASC'  THEN A.[FechaModificacion] END ASC,
                CASE WHEN @SortColumn = 10 AND @SortDirection = 'DESC' THEN A.[FechaModificacion] END DESC,
                CASE WHEN @SortColumn = 11 AND @SortDirection = 'ASC'  THEN A.[MontoOriginal] END ASC,
                CASE WHEN @SortColumn = 11 AND @SortDirection = 'DESC' THEN A.[MontoOriginal] END DESC,
                CASE WHEN @SortColumn = 12 AND @SortDirection = 'ASC'  THEN A.[FechaOtorgado] END ASC,
                CASE WHEN @SortColumn = 12 AND @SortDirection = 'DESC' THEN A.[FechaOtorgado] END DESC,
                CASE WHEN @SortColumn = 13 AND @SortDirection = 'ASC'  THEN A.[TasaInteres] END ASC,
                CASE WHEN @SortColumn = 13 AND @SortDirection = 'DESC' THEN A.[TasaInteres] END DESC,
                CASE WHEN @SortColumn = 14 AND @SortDirection = 'ASC'  THEN A.[PagoMes] END ASC,
                CASE WHEN @SortColumn = 14 AND @SortDirection = 'DESC' THEN A.[PagoMes] END DESC,
                CASE WHEN @SortColumn = 15 AND @SortDirection = 'ASC'  THEN A.[FechaUltimoPago] END ASC,
                CASE WHEN @SortColumn = 15 AND @SortDirection = 'DESC' THEN A.[FechaUltimoPago] END DESC,
                CASE WHEN @SortColumn = 16 AND @SortDirection = 'ASC'  THEN A.[snActivo] END ASC,
                CASE WHEN @SortColumn = 16 AND @SortDirection = 'DESC' THEN A.[snActivo] END DESC,
                A.[ID] DESC
            OFFSET (@PageIndex * @PageSize) ROWS
            FETCH NEXT @PageSize ROWS ONLY;
        END
        ELSE
        BEGIN
            SELECT @TotalRegistros = COUNT(*)
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
              AND (@NumeroAsociado IS NULL OR A.[NumeroAsociado] = @NumeroAsociado);

            SELECT
                A.[ID] AS [ID Auxiliar],
                A.[NumeroAsociado] AS [Número de Asociado],
                A.[CodigoRubro] AS [Código Rubro],
                R.[Descripcion] AS [Rubro],
                A.[TipoAuxiliar] AS [ID Tipo Auxiliar],
                TA.[Descripcion] AS [Tipo Auxiliar],
                FORMAT(A.[Cuota], 'C') AS [Cuota],
                FORMAT(A.[Saldo], 'C') AS [Saldo],

                CONVERT(VARCHAR(10), A.[FechaCreacion], 103) AS [Fecha de Creación],
                FORMAT(A.[FechaCreacion], 'hh:mm:ss tt') AS [Hora de Creación],
                CONVERT(VARCHAR(10), A.[FechaModificacion], 103) AS [Fecha de Modificación],
                FORMAT(A.[FechaModificacion], 'hh:mm:ss tt') AS [Hora de Modificación],

                A.[UsuarioCrea] AS [ID Usuario Crea],
                UC.[Usuario] AS [Usuario que Crea],
                A.[UsuarioModifica] AS [ID Usuario Modifica],
                UM.[Usuario] AS [Usuario que Modifica],

                FORMAT(A.[MontoOriginal], 'C') AS [Monto Original],
                CONVERT(VARCHAR(10), A.[FechaOtorgado], 103) AS [Fecha de Otorgamiento],
                FORMAT(A.[FechaOtorgado], 'hh:mm:ss tt') AS [Hora de Otorgamiento],

                FORMAT(A.[TasaInteres], 'N2') AS [Tasa de Interés],
                FORMAT(A.[PagoMes], 'C') AS [Pago Mensual],
                FORMAT(A.[InteresCalculado], 'C') AS [Interés Calculado],
                FORMAT(A.[InteresPagado], 'C') AS [Interés Pagado],

                CONVERT(VARCHAR(10), A.[FechaUltimoPago], 103) AS [Fecha Último Pago],
                FORMAT(A.[FechaUltimoPago], 'hh:mm:ss tt') AS [Hora Último Pago],
                CONVERT(VARCHAR(10), A.[FechaUltimoRetiro], 103) AS [Fecha Último Retiro],
                FORMAT(A.[FechaUltimoRetiro], 'hh:mm:ss tt') AS [Hora Último Retiro],

                CASE WHEN A.[snActivo] = 1 THEN 'SI' ELSE 'NO' END AS [¿Activo?],
                CASE WHEN A.[snEliminado] = 1 THEN 'SI' ELSE 'NO' END AS [¿Eliminado?],
                FORMAT(A.[MontoPignorado], 'C') AS [Monto Pignorado],

                A.[UsuarioElimina] AS [ID Usuario Elimina],
                UE.[Usuario] AS [Usuario que Elimina],
                CONVERT(VARCHAR(10), A.[FechaElimina], 103) AS [Fecha de Eliminación],
                FORMAT(A.[FechaElimina], 'hh:mm:ss tt') AS [Hora de Eliminación],

                @TotalRegistros AS [TotalRegistros]
            FROM [dbo].[tbAuxiliares] A
            LEFT JOIN [dbo].[tbRubros] R
                ON A.[CodigoRubro] = R.[CodigoRubro]
               AND R.[snEliminado] = 0
            LEFT JOIN [dbo].[tbTiposAuxiliares] TA
                ON A.[TipoAuxiliar] = TA.[TipoAuxiliar]
               AND A.[CodigoRubro] = TA.[CodigoRubro]
               AND TA.[snEliminado] = 0
            LEFT JOIN [dbo].[tbUsuarios] UC
                ON A.[UsuarioCrea] = UC.[Id]
               AND UC.[snEliminado] = 0
            LEFT JOIN [dbo].[tbUsuarios] UM
                ON A.[UsuarioModifica] = UM.[Id]
               AND UM.[snEliminado] = 0
            LEFT JOIN [dbo].[tbUsuarios] UE
                ON A.[UsuarioElimina] = UE.[Id]
               AND UE.[snEliminado] = 0
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
            ORDER BY
                CASE WHEN @SortColumn = 1  AND @SortDirection = 'ASC'  THEN A.[ID] END ASC,
                CASE WHEN @SortColumn = 1  AND @SortDirection = 'DESC' THEN A.[ID] END DESC,
                CASE WHEN @SortColumn = 2  AND @SortDirection = 'ASC'  THEN A.[NumeroAsociado] END ASC,
                CASE WHEN @SortColumn = 2  AND @SortDirection = 'DESC' THEN A.[NumeroAsociado] END DESC,
                CASE WHEN @SortColumn = 3  AND @SortDirection = 'ASC'  THEN A.[CodigoRubro] END ASC,
                CASE WHEN @SortColumn = 3  AND @SortDirection = 'DESC' THEN A.[CodigoRubro] END DESC,
                CASE WHEN @SortColumn = 4  AND @SortDirection = 'ASC'  THEN ISNULL(R.[Descripcion], '') END ASC,
                CASE WHEN @SortColumn = 4  AND @SortDirection = 'DESC' THEN ISNULL(R.[Descripcion], '') END DESC,
                CASE WHEN @SortColumn = 5  AND @SortDirection = 'ASC'  THEN A.[TipoAuxiliar] END ASC,
                CASE WHEN @SortColumn = 5  AND @SortDirection = 'DESC' THEN A.[TipoAuxiliar] END DESC,
                CASE WHEN @SortColumn = 6  AND @SortDirection = 'ASC'  THEN ISNULL(TA.[Descripcion], '') END ASC,
                CASE WHEN @SortColumn = 6  AND @SortDirection = 'DESC' THEN ISNULL(TA.[Descripcion], '') END DESC,
                CASE WHEN @SortColumn = 7  AND @SortDirection = 'ASC'  THEN A.[Cuota] END ASC,
                CASE WHEN @SortColumn = 7  AND @SortDirection = 'DESC' THEN A.[Cuota] END DESC,
                CASE WHEN @SortColumn = 8  AND @SortDirection = 'ASC'  THEN A.[Saldo] END ASC,
                CASE WHEN @SortColumn = 8  AND @SortDirection = 'DESC' THEN A.[Saldo] END DESC,
                CASE WHEN @SortColumn = 9  AND @SortDirection = 'ASC'  THEN A.[FechaCreacion] END ASC,
                CASE WHEN @SortColumn = 9  AND @SortDirection = 'DESC' THEN A.[FechaCreacion] END DESC,
                CASE WHEN @SortColumn = 10 AND @SortDirection = 'ASC'  THEN A.[FechaModificacion] END ASC,
                CASE WHEN @SortColumn = 10 AND @SortDirection = 'DESC' THEN A.[FechaModificacion] END DESC,
                CASE WHEN @SortColumn = 11 AND @SortDirection = 'ASC'  THEN A.[MontoOriginal] END ASC,
                CASE WHEN @SortColumn = 11 AND @SortDirection = 'DESC' THEN A.[MontoOriginal] END DESC,
                CASE WHEN @SortColumn = 12 AND @SortDirection = 'ASC'  THEN A.[FechaOtorgado] END ASC,
                CASE WHEN @SortColumn = 12 AND @SortDirection = 'DESC' THEN A.[FechaOtorgado] END DESC,
                CASE WHEN @SortColumn = 13 AND @SortDirection = 'ASC'  THEN A.[TasaInteres] END ASC,
                CASE WHEN @SortColumn = 13 AND @SortDirection = 'DESC' THEN A.[TasaInteres] END DESC,
                CASE WHEN @SortColumn = 14 AND @SortDirection = 'ASC'  THEN A.[PagoMes] END ASC,
                CASE WHEN @SortColumn = 14 AND @SortDirection = 'DESC' THEN A.[PagoMes] END DESC,
                CASE WHEN @SortColumn = 15 AND @SortDirection = 'ASC'  THEN A.[FechaUltimoPago] END ASC,
                CASE WHEN @SortColumn = 15 AND @SortDirection = 'DESC' THEN A.[FechaUltimoPago] END DESC,
                CASE WHEN @SortColumn = 16 AND @SortDirection = 'ASC'  THEN A.[snActivo] END ASC,
                CASE WHEN @SortColumn = 16 AND @SortDirection = 'DESC' THEN A.[snActivo] END DESC,
                A.[ID] DESC
            OFFSET (@PageIndex * @PageSize) ROWS
            FETCH NEXT @PageSize ROWS ONLY;
        END

    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();

        RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH
END
