-- ============================================================
-- spMenu_PermisosUsuarios
-- Devuelve todas las opciones de menú activas y si el usuario
-- tiene permiso (1) o no (0) para cada una.
-- ============================================================
IF OBJECT_ID('dbo.spMenu_PermisosUsuarios', 'P') IS NOT NULL
    DROP PROCEDURE dbo.spMenu_PermisosUsuarios;
GO

CREATE PROCEDURE dbo.spMenu_PermisosUsuarios
    @IdUsuario INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        m.IdMenuOpcion,
        m.Clave,
        m.Nombre,
        m.UrlDestino,
        ISNULL(m.IdPadre, 0) AS IdPadre,
        m.Orden,
        CAST(ISNULL(p.Permitido, 0) AS BIT) AS Permitido
    FROM tbMenuOpciones m
    LEFT JOIN tbUsuarioMenuPermiso p
        ON p.IdMenuOpcion = m.IdMenuOpcion
       AND p.IdUsuario = @IdUsuario
    WHERE m.Activo = 1
    ORDER BY m.IdPadre, m.Orden, m.IdMenuOpcion;
END
GO
