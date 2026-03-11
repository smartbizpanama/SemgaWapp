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
            WHEN r.NivelAcceso = 0 THEN 1
            WHEN u.IdMenu IS NOT NULL THEN 1
            ELSE 0
        END AS BIT) AS Permitido
    FROM dbo.tbMenuPrincipal m
    LEFT JOIN dbo.tbMenuUsuario u ON u.IdMenu = m.IdMenu AND u.IDUsuario = @IdUsuario
    LEFT JOIN dbo.tbUsuarios us ON us.Id = @IdUsuario
    LEFT JOIN tbRoles r ON r.Id = us.Rol
    WHERE ISNULL(m.snActivo, 1) = 1
    ORDER BY m.IdParent, m.Orden, m.IdMenu;
END
GO