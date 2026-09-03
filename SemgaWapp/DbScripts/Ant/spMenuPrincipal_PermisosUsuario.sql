-- ============================================================
-- spMenuPrincipal_PermisosUsuario
-- Devuelve todos los ítems de tbMenuPrincipal activos y si el
-- usuario tiene permiso (1 = está en tbMenuUsuario). Admin no usa
-- este SP (en login se marca MenuPermisosAdmin y no se consulta).
-- ============================================================
IF OBJECT_ID('dbo.spMenuPrincipal_PermisosUsuario', 'P') IS NOT NULL
    DROP PROCEDURE dbo.spMenuPrincipal_PermisosUsuario;
GO

CREATE PROCEDURE dbo.spMenuPrincipal_PermisosUsuario
    @IdUsuario INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        m.IdMenu,
        ISNULL(m.IdParent, 0) AS IdParent,
        m.TextoMenu,
        m.Url,
        m.Orden,
        m.Icon,
        CAST(CASE
            WHEN us.NivelAcceso = 0 THEN 1
            WHEN u.IdMenu IS NOT NULL THEN 1
            ELSE 0
        END AS BIT) AS Permitido
    FROM dbo.tbMenuPrincipal m
    LEFT JOIN dbo.tbMenuUsuario u ON u.IdMenu = m.IdMenu AND u.IDUsuario = @IdUsuario
    LEFT JOIN dbo.tbUsuarios us ON us.Id = @IdUsuario
    WHERE ISNULL(m.snActivo, 1) = 1
    ORDER BY m.IdParent, m.Orden, m.IdMenu;
END
GO
