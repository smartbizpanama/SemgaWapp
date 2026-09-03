-- spGestionSocios_ObtenerSocios con paginación server-side
-- Parámetros nuevos: @PageSize, @PageIndex (0-based)
-- TotalRegistros se devuelve como columna en cada fila (mismo valor) para no usar OUTPUT
-- Uso: PageIndex 0 = primera página, PageIndex 1 = segunda página, etc.

CREATE OR ALTER PROCEDURE [dbo].[spGestionSocios_ObtenerSocios]
    @FiltroNombre NVARCHAR(100) = NULL,
    @FiltroTipo INT = NULL,
    @FiltroEstatus CHAR(1) = NULL,
    @FiltroTipoDocumento VARCHAR(10) = NULL,
    @FiltroIdentificacion NVARCHAR(50) = NULL,
    @PageSize INT = 25,
    @PageIndex INT = 0,
    @SortColumn INT = 1,
    @SortDirection VARCHAR(4) = 'desc'
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        DECLARE @TotalRegistros INT;

        -- 1. Calcular total de registros (mismo WHERE que la consulta principal)
        SELECT @TotalRegistros = COUNT(*)
        FROM tbAsociados a
        WHERE a.snEliminado = 0
            AND (
                    @FiltroNombre IS NULL
                    OR a.Nombre LIKE '%' + @FiltroNombre + '%'
                    OR a.Apellido LIKE '%' + @FiltroNombre + '%'
                    OR a.SegundoNombre LIKE '%' + @FiltroNombre + '%'
                    OR a.SegundoApellido LIKE '%' + @FiltroNombre + '%'
                    OR (
                        TRY_CONVERT(INT, @FiltroNombre) IS NOT NULL
                        AND a.NumeroAsociado = TRY_CONVERT(INT, @FiltroNombre)
                    )
                )
            AND (@FiltroTipo IS NULL OR a.IdTipoAsociado = @FiltroTipo)
            AND (@FiltroEstatus IS NULL OR a.Estatus = @FiltroEstatus)
            AND (@FiltroTipoDocumento IS NULL OR a.TipoIdentificacion = @FiltroTipoDocumento)
            AND (@FiltroIdentificacion IS NULL OR a.NumeroIdentificacion LIKE '%' + @FiltroIdentificacion + '%');

        -- 2. Consulta principal con paginación OFFSET/FETCH
        -- TotalRegistros se incluye en cada fila; el backend lo lee de la primera
        SELECT
            a.NumeroAsociado,
            a.IdTipoAsociado,
            ta.TipoAsociado,
            a.Nombre,
            a.SegundoNombre,
            a.Apellido,
            a.SegundoApellido,
            a.Estatus,
            a.TipoIdentificacion,
            a.NumeroIdentificacion,
            a.TelefonoResidencia,
            a.TelefonoCelular,
            a.TelefonoFamiliar,
            a.TelefonoTrabajo,
            a.CorreoElectronico,
            a.Sexo,
            a.FechaNacimiento,
            a.ProvinciaResidencia,
            pr.Descripcion AS ProvinciaResidenciaDescripcion,
            a.DistritoResidencia,
            dr.Descripcion AS DistritoResidenciaDescripcion,
            a.CorregimientoResidencia,
            cr.Descripcion AS CorregimientoResidenciaDescripcion,
            a.DireccionResidencia,
            a.ProvinciaTrabajo,
            p.Descripcion AS ProvinciaTrabajoDescripcion,
            a.DistritoTrabajo,
            d.Descripcion AS DistritoTrabajoDescripcion,
            a.CorregimientoTrabajo,
            c.Descripcion AS CorregimientoTrabajoDescripcion,
            a.DireccionTrabajo,
            a.LugarTrabajo,
            e.Descripcion AS LugarTrabajoDescripcion,
            a.Ocupacion,
            o.Descripcion AS OcupacionDescripcion,
            a.NivelEstudio,
            a.Profesion,
            a.PaisTrabajo,
            pais.Descripcion AS PaisTrabajoDescripcion,
            a.PaisResidencia,
            paisRes.Descripcion AS PaisResidenciaDescripcion,
            a.FechaCreacion,
            Usr.Usuario AS UsuarioCrea,
            a.FechaModificacion,
            UsrM.Usuario AS UsuarioModifica,
            a.snEliminado,
            ISNULL((SELECT COUNT(aux.ID) FROM tbAuxiliares aux WHERE aux.NumeroAsociado = a.NumeroAsociado AND aux.snEliminado = 0 AND aux.snActivo = 1), 0) AS CantAuxiliares,
            @TotalRegistros AS TotalRegistros
        FROM tbAsociados a
        LEFT JOIN tbTipoAsociado ta ON a.IdTipoAsociado = ta.IdTipoAsociado
        LEFT JOIN tbUsuarios Usr ON Usr.Id = a.UsuarioCrea
        LEFT JOIN tbUsuarios UsrM ON UsrM.Id = a.UsuarioModifica
        LEFT JOIN tbEmpresas e ON a.LugarTrabajo = e.Code AND e.snEliminado = 0
        LEFT JOIN tbOcupaciones o ON a.Ocupacion = o.Code AND o.snEliminado = 0
        LEFT JOIN tbPaises pais ON a.PaisTrabajo = pais.Code AND pais.snEliminado = 0
        LEFT JOIN tbPaises paisRes ON a.PaisResidencia = paisRes.Code AND paisRes.snEliminado = 0
        LEFT JOIN tbProvincias p ON a.ProvinciaTrabajo = p.Code AND p.snEliminado = 0
        LEFT JOIN tbDistritos d ON a.DistritoTrabajo = d.Code AND d.snEliminado = 0
        LEFT JOIN tbCorregimientos c ON a.CorregimientoTrabajo = c.Code AND c.snEliminado = 0
        LEFT JOIN tbProvincias pr ON a.ProvinciaResidencia = pr.Code AND pr.snEliminado = 0
        LEFT JOIN tbDistritos dr ON a.DistritoResidencia = dr.Code AND dr.snEliminado = 0
        LEFT JOIN tbCorregimientos cr ON a.CorregimientoResidencia = cr.Code AND cr.snEliminado = 0
        WHERE a.snEliminado = 0
            AND (
                    @FiltroNombre IS NULL
                    OR a.Nombre LIKE '%' + @FiltroNombre + '%'
                    OR a.Apellido LIKE '%' + @FiltroNombre + '%'
                    OR a.SegundoNombre LIKE '%' + @FiltroNombre + '%'
                    OR a.SegundoApellido LIKE '%' + @FiltroNombre + '%'
                    OR (
                        TRY_CONVERT(INT, @FiltroNombre) IS NOT NULL
                        AND a.NumeroAsociado = TRY_CONVERT(INT, @FiltroNombre)
                    )
                )
            AND (@FiltroTipo IS NULL OR a.IdTipoAsociado = @FiltroTipo)
            AND (@FiltroEstatus IS NULL OR a.Estatus = @FiltroEstatus)
            AND (@FiltroTipoDocumento IS NULL OR a.TipoIdentificacion = @FiltroTipoDocumento)
            AND (@FiltroIdentificacion IS NULL OR a.NumeroIdentificacion LIKE '%' + @FiltroIdentificacion + '%')
        ORDER BY
            CASE WHEN @SortColumn = 1 AND UPPER(@SortDirection) = 'ASC' THEN a.NumeroAsociado END ASC,
            CASE WHEN @SortColumn = 1 AND UPPER(@SortDirection) = 'DESC' THEN a.NumeroAsociado END DESC,
            CASE WHEN @SortColumn = 2 AND UPPER(@SortDirection) = 'ASC' THEN ta.TipoAsociado END ASC,
            CASE WHEN @SortColumn = 2 AND UPPER(@SortDirection) = 'DESC' THEN ta.TipoAsociado END DESC,
            CASE WHEN @SortColumn = 3 AND UPPER(@SortDirection) = 'ASC' THEN (ISNULL(a.Nombre,'') + ' ' + ISNULL(a.Apellido,'')) END ASC,
            CASE WHEN @SortColumn = 3 AND UPPER(@SortDirection) = 'DESC' THEN (ISNULL(a.Nombre,'') + ' ' + ISNULL(a.Apellido,'')) END DESC,
            CASE WHEN @SortColumn = 4 AND UPPER(@SortDirection) = 'ASC' THEN a.Estatus END ASC,
            CASE WHEN @SortColumn = 4 AND UPPER(@SortDirection) = 'DESC' THEN a.Estatus END DESC,
            CASE WHEN @SortColumn = 5 AND UPPER(@SortDirection) = 'ASC' THEN ISNULL(a.NumeroIdentificacion,'') END ASC,
            CASE WHEN @SortColumn = 5 AND UPPER(@SortDirection) = 'DESC' THEN ISNULL(a.NumeroIdentificacion,'') END DESC,
            CASE WHEN @SortColumn = 6 AND UPPER(@SortDirection) = 'ASC' THEN a.FechaCreacion END ASC,
            CASE WHEN @SortColumn = 6 AND UPPER(@SortDirection) = 'DESC' THEN a.FechaCreacion END DESC,
            CASE WHEN @SortColumn = 7 AND UPPER(@SortDirection) = 'ASC' THEN ISNULL(Usr.Usuario,'') END ASC,
            CASE WHEN @SortColumn = 7 AND UPPER(@SortDirection) = 'DESC' THEN ISNULL(Usr.Usuario,'') END DESC,
            CASE WHEN @SortColumn = 8 AND UPPER(@SortDirection) = 'ASC' THEN a.FechaModificacion END ASC,
            CASE WHEN @SortColumn = 8 AND UPPER(@SortDirection) = 'DESC' THEN a.FechaModificacion END DESC,
            CASE WHEN @SortColumn = 9 AND UPPER(@SortDirection) = 'ASC' THEN ISNULL(UsrM.Usuario,'') END ASC,
            CASE WHEN @SortColumn = 9 AND UPPER(@SortDirection) = 'DESC' THEN ISNULL(UsrM.Usuario,'') END DESC,
            a.NumeroAsociado DESC
        OFFSET (@PageIndex * @PageSize) ROWS
        FETCH NEXT @PageSize ROWS ONLY;
    END TRY
    BEGIN CATCH
        DECLARE @Mensaje NVARCHAR(2048);
        SET @Mensaje = ERROR_MESSAGE();
        THROW 50001, @Mensaje, 1;
    END CATCH
END
GO
