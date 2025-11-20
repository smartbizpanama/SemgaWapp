-- =============================================
-- STORED PROCEDURE PARA LISTAR RESPALDOS
-- =============================================

CREATE PROCEDURE [dbo].[spRespaldos_Listar]
    @IncluirEliminados BIT = 0,
    @UsuarioGenera INT = NULL,
    @FechaDesde DATETIME = NULL,
    @FechaHasta DATETIME = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        -- Validar fechas si se proporcionan
        IF @FechaDesde IS NOT NULL AND @FechaHasta IS NOT NULL AND @FechaDesde > @FechaHasta
        BEGIN
            SELECT 'ERROR' AS Resultado, 'La fecha desde no puede ser mayor a la fecha hasta' AS Mensaje
            RETURN
        END
        
        -- Consultar respaldos
        SELECT 
            r.ID,
            r.UsuarioGenera,
            u.NombreUsuario,
            r.FechaHora,
            r.NombreRespaldo,
            r.Descripcion,
            r.Ruta,
            r.Size,
            -- Formatear tamaño en unidades legibles
            CASE 
                WHEN r.Size >= 1073741824 THEN CAST(CAST(r.Size AS FLOAT) / 1073741824 AS DECIMAL(10,2)) + ' GB'
                WHEN r.Size >= 1048576 THEN CAST(CAST(r.Size AS FLOAT) / 1048576 AS DECIMAL(10,2)) + ' MB'
                WHEN r.Size >= 1024 THEN CAST(CAST(r.Size AS FLOAT) / 1024 AS DECIMAL(10,2)) + ' KB'
                ELSE CAST(r.Size AS VARCHAR(20)) + ' bytes'
            END AS TamañoFormateado,
            r.SnEliminado,
            CASE 
                WHEN r.SnEliminado = 1 THEN 'Eliminado'
                ELSE 'Activo'
            END AS Estado,
            r.FechaCreacion,
            r.FechaModificacion,
            -- Información adicional del archivo
            CASE 
                WHEN r.Ruta IS NOT NULL AND LEN(r.Ruta) > 0 THEN
                    CASE 
                        WHEN CHARINDEX('\', REVERSE(r.Ruta)) > 0 THEN
                            RIGHT(r.Ruta, CHARINDEX('\', REVERSE(r.Ruta)) - 1)
                        ELSE r.Ruta
                    END
                ELSE r.NombreRespaldo
            END AS NombreArchivo
        FROM tbRespaldos r
        INNER JOIN tbUsuarios u ON r.UsuarioGenera = u.ID
        WHERE 
            -- Filtro de eliminados
            (@IncluirEliminados = 1 OR r.SnEliminado = 0)
            -- Filtro por usuario
            AND (@UsuarioGenera IS NULL OR r.UsuarioGenera = @UsuarioGenera)
            -- Filtro por fecha desde
            AND (@FechaDesde IS NULL OR r.FechaHora >= @FechaDesde)
            -- Filtro por fecha hasta
            AND (@FechaHasta IS NULL OR r.FechaHora <= @FechaHasta)
        ORDER BY r.FechaHora DESC
        
    END TRY
    BEGIN CATCH
        -- Retornar error en caso de excepción
        SELECT 'ERROR' AS Resultado, 'Error al listar respaldos: ' + ERROR_MESSAGE() AS Mensaje
    END CATCH
END
