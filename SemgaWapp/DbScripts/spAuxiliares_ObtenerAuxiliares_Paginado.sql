-- spAuxiliares_ObtenerAuxiliares: versión final con paginación, ordenación y opción de un auxiliar por ID
-- Parámetros: @IDAuxiliar (opcional), @Busqueda, @CodigoRubro, @IdTipoAuxiliar, @PageSize, @PageIndex, @SortColumn, @SortDirection
-- SortColumn: 1=ID, 2=NumeroIdentificacion, 3=NombreAsociado, 4=Rubro, 5=TipoAuxiliar, 6=Cuota, 7=Saldo, 8=MontoOriginal, 9=TasaInteres, 10=PagoMes, 11=FechaCreacion

CREATE OR ALTER PROCEDURE [dbo].[spAuxiliares_ObtenerAuxiliares]
    @IDAuxiliar INT = NULL,
    @Busqueda NVARCHAR(255) = NULL,
    @FiltroAsoc NVARCHAR(MAX) = NULL,
    @CodigoRubro VARCHAR(10) = NULL,
    @IdTipoAuxiliar INT = NULL,
    @PageSize INT = 25,
    @PageIndex INT = 0,
    @SortColumn INT = 1,
    @SortDirection VARCHAR(4) = 'desc'
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        DECLARE @TotalRegistros INT;

        -- 1. Calcular total con el mismo WHERE (incluyendo filtros y opcionalmente IDAuxiliar)
        SELECT @TotalRegistros = COUNT(*)
        FROM tbAuxiliares a
        INNER JOIN tbAsociados s ON a.NumeroAsociado = s.NumeroAsociado
        LEFT JOIN tbTipoDocumentos td ON td.CodTipoDoc = s.TipoIdentificacion
        LEFT JOIN tbRubros r ON a.CodigoRubro = r.CodigoRubro
        LEFT JOIN tbTiposAuxiliares ta ON a.TipoAuxiliar = ta.TipoAuxiliar AND a.CodigoRubro = ta.CodigoRubro
        WHERE IsNull(a.snEliminado, 0) = 0
          AND (@IDAuxiliar IS NULL OR a.ID = @IDAuxiliar)
          AND (
              @Busqueda IS NULL
              OR s.Nombre LIKE '%' + @Busqueda + '%'
              OR s.Apellido LIKE '%' + @Busqueda + '%'
              OR (right('000000000000' + cast(a.ID as varchar(12)), 15) LIKE '%' + @Busqueda + '%')
              OR s.NumeroIdentificacion LIKE '%' + @Busqueda + '%'
              OR ISNULL(r.Descripcion, '') LIKE '%' + @Busqueda + '%'
              OR ISNULL(ta.Descripcion, '') LIKE '%' + @Busqueda + '%'
          )
          AND (
              @FiltroAsoc IS NULL
              OR s.Nombre LIKE '%' + @FiltroAsoc + '%'
              OR s.Apellido LIKE '%' + @FiltroAsoc + '%'
              OR cast(s.NumeroAsociado AS NVARCHAR(20)) LIKE '%' + @FiltroAsoc + '%'
              OR ISNULL(s.NumeroIdentificacion, '') LIKE '%' + @FiltroAsoc + '%'
          )
          AND (@CodigoRubro IS NULL OR a.CodigoRubro = @CodigoRubro)
          AND (@IdTipoAuxiliar IS NULL OR ta.ID = @IdTipoAuxiliar);

        -- 2. Consulta principal con paginación OFFSET/FETCH
        SELECT
            a.ID,
            right('000000000000' + cast(a.ID as varchar(12)), 15) AS Cuenta,
            a.NumeroAsociado,
            a.CodigoRubro,
            ta.TipoAuxiliar,
            ta.ID AS IdTipoAuxiliar,
            CONCAT('<b>[', cast(s.NumeroAsociado AS nvarchar(max)), ']</b> ', s.Nombre, ' ', s.Apellido) AS NombreAsociado,
            td.CodTipoDoc,
            s.NumeroIdentificacion,
            r.Descripcion AS DescripcionRubro,
            ta.Descripcion AS DescripcionTipoAuxiliar,
            a.Cuota,
            a.Saldo,
            IsNull(a.MontoOriginal,0) as MontoOriginal,
            IsNull(a.TasaInteres,0) as TasaInteres,
            IsNull(a.PagoMes,0) as PagoMes,
            IsNull(a.MontoPignorado,0) as MontoPignorado,
            a.snActivo,
            Format(cast(a.FechaOtorgado AS Date), 'dd/MM/yyyy') AS FechaOtorgado,
            Format(cast(a.FechaUltimoPago AS Date), 'dd/MM/yyyy') AS FechaUltimoPago,
            Format(cast(a.FechaUltCalculoInteres AS Date), 'dd/MM/yyyy') AS FechaUltCalculoInteres,
            Format(cast(a.FechaVencimiento AS Date), 'dd/MM/yyyy') AS FechaVencimiento,
            Format(cast(a.FechaCreacion AS Date), 'dd/MM/yyyy') AS FechaCreacion,
            usrCrea.Nombre AS UsuarioCrea,
            usrMod.Nombre AS UsuarioModifica,
            IsNull(a.PorcManejo, 0) AS PorcManejo,
            IsNull(a.PorcCapitalizacion, 0) AS PorcCapitalizacion,
            IsNull(a.MontoManejo, 0) AS MontoManejo,
            IsNull(a.MontoCapitalizacion, 0) AS MontoCapitalizacion,
            1 AS snComprobante,
            @TotalRegistros AS TotalRegistros
        FROM tbAuxiliares a
        INNER JOIN tbAsociados s ON a.NumeroAsociado = s.NumeroAsociado
        LEFT JOIN tbTipoDocumentos td ON td.CodTipoDoc = s.TipoIdentificacion
        LEFT JOIN tbRubros r ON a.CodigoRubro = r.CodigoRubro
        LEFT JOIN tbTiposAuxiliares ta ON a.TipoAuxiliar = ta.TipoAuxiliar AND a.CodigoRubro = ta.CodigoRubro
        LEFT JOIN tbUsuarios usrCrea ON usrCrea.Id = a.UsuarioCrea
        LEFT JOIN tbUsuarios usrMod ON usrMod.Id = a.UsuarioModifica
        WHERE IsNull(a.snEliminado, 0) = 0
          AND (@IDAuxiliar IS NULL OR a.ID = @IDAuxiliar)
          AND (
              @Busqueda IS NULL
              OR s.Nombre LIKE '%' + @Busqueda + '%'
              OR s.Apellido LIKE '%' + @Busqueda + '%'
              OR (right('000000000000' + cast(a.ID as varchar(12)), 15) LIKE '%' + @Busqueda + '%')
              OR s.NumeroIdentificacion LIKE '%' + @Busqueda + '%'
              OR ISNULL(r.Descripcion, '') LIKE '%' + @Busqueda + '%'
              OR ISNULL(ta.Descripcion, '') LIKE '%' + @Busqueda + '%'
          )
          AND (
              @FiltroAsoc IS NULL
              OR s.Nombre LIKE '%' + @FiltroAsoc + '%'
              OR s.Apellido LIKE '%' + @FiltroAsoc + '%'
              OR cast(s.NumeroAsociado AS NVARCHAR(20)) LIKE '%' + @FiltroAsoc + '%'
              OR ISNULL(s.NumeroIdentificacion, '') LIKE '%' + @FiltroAsoc + '%'
          )
          AND (@CodigoRubro IS NULL OR a.CodigoRubro = @CodigoRubro)
          AND (@IdTipoAuxiliar IS NULL OR ta.ID = @IdTipoAuxiliar)
        ORDER BY
            CASE WHEN @SortColumn = 1 AND UPPER(@SortDirection) = 'ASC'  THEN a.ID END ASC,
            CASE WHEN @SortColumn = 1 AND UPPER(@SortDirection) = 'DESC' THEN a.ID END DESC,
            CASE WHEN @SortColumn = 2 AND UPPER(@SortDirection) = 'ASC'  THEN ISNULL(s.NumeroIdentificacion, '') END ASC,
            CASE WHEN @SortColumn = 2 AND UPPER(@SortDirection) = 'DESC' THEN ISNULL(s.NumeroIdentificacion, '') END DESC,
            CASE WHEN @SortColumn = 3 AND UPPER(@SortDirection) = 'ASC'  THEN (ISNULL(s.Nombre,'') + ' ' + ISNULL(s.Apellido,'')) END ASC,
            CASE WHEN @SortColumn = 3 AND UPPER(@SortDirection) = 'DESC' THEN (ISNULL(s.Nombre,'') + ' ' + ISNULL(s.Apellido,'')) END DESC,
            CASE WHEN @SortColumn = 4 AND UPPER(@SortDirection) = 'ASC'  THEN ISNULL(r.Descripcion, '') END ASC,
            CASE WHEN @SortColumn = 4 AND UPPER(@SortDirection) = 'DESC' THEN ISNULL(r.Descripcion, '') END DESC,
            CASE WHEN @SortColumn = 5 AND UPPER(@SortDirection) = 'ASC'  THEN ISNULL(ta.Descripcion, '') END ASC,
            CASE WHEN @SortColumn = 5 AND UPPER(@SortDirection) = 'DESC' THEN ISNULL(ta.Descripcion, '') END DESC,
            CASE WHEN @SortColumn = 6 AND UPPER(@SortDirection) = 'ASC'  THEN a.Cuota END ASC,
            CASE WHEN @SortColumn = 6 AND UPPER(@SortDirection) = 'DESC' THEN a.Cuota END DESC,
            CASE WHEN @SortColumn = 7 AND UPPER(@SortDirection) = 'ASC'  THEN a.Saldo END ASC,
            CASE WHEN @SortColumn = 7 AND UPPER(@SortDirection) = 'DESC' THEN a.Saldo END DESC,
            CASE WHEN @SortColumn = 8 AND UPPER(@SortDirection) = 'ASC'  THEN a.MontoOriginal END ASC,
            CASE WHEN @SortColumn = 8 AND UPPER(@SortDirection) = 'DESC' THEN a.MontoOriginal END DESC,
            CASE WHEN @SortColumn = 9 AND UPPER(@SortDirection) = 'ASC'  THEN a.TasaInteres END ASC,
            CASE WHEN @SortColumn = 9 AND UPPER(@SortDirection) = 'DESC' THEN a.TasaInteres END DESC,
            CASE WHEN @SortColumn = 10 AND UPPER(@SortDirection) = 'ASC'  THEN a.PagoMes END ASC,
            CASE WHEN @SortColumn = 10 AND UPPER(@SortDirection) = 'DESC' THEN a.PagoMes END DESC,
            CASE WHEN @SortColumn = 11 AND UPPER(@SortDirection) = 'ASC'  THEN a.FechaCreacion END ASC,
            CASE WHEN @SortColumn = 11 AND UPPER(@SortDirection) = 'DESC' THEN a.FechaCreacion END DESC,
            a.ID DESC
        OFFSET (CASE WHEN @IDAuxiliar IS NOT NULL THEN 0 ELSE @PageIndex * @PageSize END) ROWS
        FETCH NEXT (CASE WHEN @IDAuxiliar IS NOT NULL THEN 1 ELSE @PageSize END) ROWS ONLY;
    END TRY
    BEGIN CATCH
        DECLARE @Mensaje NVARCHAR(2048);
        SET @Mensaje = ERROR_MESSAGE();
        THROW 50001, @Mensaje, 1;
    END CATCH
END
GO
