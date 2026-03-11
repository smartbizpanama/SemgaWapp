-- ============================================================
-- INSERT: Opciones del sidebar de Mantenimientos.aspx como ítems
-- de menú (permiso individual por cada tipo de tabla).
-- Ejecutar en BD que ya tiene tbMenuPrincipal con IdMenu 1-19.
--
-- Sin este script, "Tablas de Tipo" no mostrará hijos al expandir
-- en la pantalla de Permisos de menú (Cuentas, Roles, etc.).
-- ============================================================

-- Evitar duplicados si se re-ejecuta
IF NOT EXISTS (SELECT 1 FROM dbo.tbMenuPrincipal WHERE IdMenu = 20)
BEGIN
    INSERT INTO [dbo].[tbMenuPrincipal] ([IdMenu], [IdParent], [TextoMenu], [Url], [snActivo], [Orden], [Icon])
    VALUES
        (20, 16, N'Cuentas', N'Forms/Mantenimientos/Mantenimientos.aspx#cuentas', 1, 1, N'fas fa-wallet'),
        (21, 16, N'Roles de Usuario', N'Forms/Mantenimientos/Mantenimientos.aspx#roles', 1, 2, N'fas fa-user-tag'),
        (22, 16, N'Departamentos', N'Forms/Mantenimientos/Mantenimientos.aspx#departamentos', 1, 3, N'fas fa-building'),
        (23, 16, N'Tipo Identificación', N'Forms/Mantenimientos/Mantenimientos.aspx#tipo-identificacion', 1, 4, N'fas fa-id-card'),
        (24, 16, N'Tipo Asociados', N'Forms/Mantenimientos/Mantenimientos.aspx#tipo-asociados', 1, 5, N'fas fa-user-friends'),
        (25, 16, N'Parentezcos', N'Forms/Mantenimientos/Mantenimientos.aspx#parentezcos', 1, 6, N'fas fa-users'),
        (26, 16, N'Estatus Asociados', N'Forms/Mantenimientos/Mantenimientos.aspx#estatus-asociados', 1, 7, N'fas fa-user-check'),
        (27, 16, N'Códigos Transacción', N'Forms/Mantenimientos/Mantenimientos.aspx#codigos-transacciones', 1, 8, N'fas fa-exchange-alt'),
        (28, 16, N'Rubros', N'Forms/Mantenimientos/Mantenimientos.aspx#rubros', 1, 9, N'fas fa-list-alt'),
        (29, 16, N'Tipos Auxiliares', N'Forms/Mantenimientos/Mantenimientos.aspx#tipos-auxiliares', 1, 10, N'fas fa-tools'),
        (30, 16, N'Niveles de Estudio', N'Forms/Mantenimientos/Mantenimientos.aspx#niveles-estudio', 1, 11, N'fas fa-graduation-cap'),
        (31, 16, N'Profesiones', N'Forms/Mantenimientos/Mantenimientos.aspx#profesiones', 1, 12, N'fas fa-briefcase'),
        (32, 16, N'Ocupaciones', N'Forms/Mantenimientos/Mantenimientos.aspx#ocupaciones', 1, 13, N'fas fa-user-tie'),
        (33, 16, N'Empresas', N'Forms/Mantenimientos/Mantenimientos.aspx#empresas', 1, 14, N'fas fa-building'),
        (34, 16, N'Países', N'Forms/Mantenimientos/Mantenimientos.aspx#paises', 1, 15, N'fas fa-globe'),
        (35, 16, N'Provincias', N'Forms/Mantenimientos/Mantenimientos.aspx#provincias', 1, 16, N'fas fa-map'),
        (36, 16, N'Distritos', N'Forms/Mantenimientos/Mantenimientos.aspx#distritos', 1, 17, N'fas fa-map-marked-alt'),
        (37, 16, N'Corregimientos', N'Forms/Mantenimientos/Mantenimientos.aspx#corregimientos', 1, 18, N'fas fa-map-pin');
END
GO
