-- ============================================================
-- tbMenuPrincipal - Menú dinámico para mosaicos del Dashboard
-- SemgaWapp - Cooperativa Coopsemga
-- Icon: clases Font Awesome (ej. fa-solid fa-laptop-file o fas fa-users)
-- ============================================================

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'tbMenuPrincipal')
BEGIN
    CREATE TABLE [dbo].[tbMenuPrincipal](
        [IdMenu] [int] NOT NULL,
        [IdParent] [int] NULL,
        [TextoMenu] [nvarchar](100) NULL,
        [Url] [nvarchar](100) NULL,
        [snActivo] [bit] NULL,
        [Orden] [int] NULL,
        [Icon] [nvarchar](100) NULL,
        CONSTRAINT [PK_tbMenuPrincipal] PRIMARY KEY CLUSTERED ([IdMenu] ASC)
        WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF,
              ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
    ) ON [PRIMARY];

    -- FK opcional: referenciar padre en la misma tabla
    ALTER TABLE [dbo].[tbMenuPrincipal]
    ADD CONSTRAINT [FK_tbMenuPrincipal_Parent] FOREIGN KEY ([IdParent])
    REFERENCES [dbo].[tbMenuPrincipal] ([IdMenu]);
END
GO

-- ============================================================
-- INSERTS: Mosaicos del Dashboard principal y submenús
-- Basado en Dashboard.aspx, dashboardReportes, helpDashboard, dashboardSistemas
-- ============================================================

-- Limpiar datos iniciales si se re-ejecuta (opcional; quitar si ya hay permisos por usuario)
-- DELETE FROM tbMenuPrincipal;

-- Dashboard principal (IdParent NULL) - Orden según aparición en Dashboard.aspx
INSERT INTO [dbo].[tbMenuPrincipal] ([IdMenu], [IdParent], [TextoMenu], [Url], [snActivo], [Orden], [Icon])
VALUES
    (1, NULL, N'Gestión de Socios', N'Forms/Socios/GestionSocios.aspx', 1, 1, N'fas fa-users'),
    (2, NULL, N'Movimientos de Cuentas', N'Forms/Transacciones/Transacciones.aspx', 1, 2, N'fas fa-exchange-alt'),
    (3, NULL, N'Gestión de Auxiliares', N'Forms/Auxiliares/AuxiliaresAsociados.aspx', 1, 3, N'fas fa-users-cog'),
    (4, NULL, N'Reportes y Estadísticas', N'Forms/Reportes/dashboardReportes.aspx', 1, 4, N'fas fa-chart-bar'),
    (5, NULL, N'Finanzas', N'Forms/Finanzas/Finanzas.aspx', 1, 5, N'fas fa-dollar-sign'),
    (6, NULL, N'Logs y Auditorías', N'Forms/Logs/DetalleLogs.aspx', 1, 6, N'fas fa-clipboard-list'),
    (7, NULL, N'Configuraciones del Sistema', N'Forms/Mantenimientos/dashboardSistemas.aspx', 1, 7, N'fas fa-cogs'),
    (8, NULL, N'Ayuda', N'Forms/Help/helpDashboard.aspx', 1, 8, N'fas fa-question-circle');

-- Submenú Reportes (IdParent = 4) - dashboardReportes.aspx
INSERT INTO [dbo].[tbMenuPrincipal] ([IdMenu], [IdParent], [TextoMenu], [Url], [snActivo], [Orden], [Icon])
VALUES
    (9,  4, N'Reportes del Sistema', N'Forms/Reportes/Reportes.aspx', 1, 1, N'fas fa-chart-line'),
    (10, 4, N'Tablas Históricas', N'Forms/Logs/historialTablas.aspx?origen=reportes', 1, 2, N'fas fa-database'),
    (11, 4, N'Movimientos', N'Forms/Reportes/Movimientos.aspx', 1, 3, N'fas fa-exchange-alt'),
    (12, 4, N'Asientos', N'Forms/Reportes/Asientos.aspx', 1, 4, N'fas fa-book');

-- Submenú Ayuda (IdParent = 8) - helpDashboard.aspx
INSERT INTO [dbo].[tbMenuPrincipal] ([IdMenu], [IdParent], [TextoMenu], [Url], [snActivo], [Orden], [Icon])
VALUES
    (13, 8, N'Documentación de Aplicación', N'Forms/Help/Documentacion.aspx', 1, 1, N'fas fa-book'),
    (14, 8, N'Manual de Procesos Técnicos', N'Forms/Help/procesosTecnicos.aspx', 1, 2, N'fas fa-cogs');

-- Submenú Configuraciones del Sistema (IdParent = 7) - dashboardSistemas.aspx
INSERT INTO [dbo].[tbMenuPrincipal] ([IdMenu], [IdParent], [TextoMenu], [Url], [snActivo], [Orden], [Icon])
VALUES
    (15, 7, N'Gestión de Usuarios', N'Forms/Mantenimientos/GestionUsuarios.aspx', 1, 1, N'fas fa-user-cog'),
    (16, 7, N'Tablas de Tipo', N'Forms/Mantenimientos/Mantenimientos.aspx', 1, 2, N'fas fa-table'),
    (17, 7, N'Parámetros del Sistema', N'Forms/Mantenimientos/appParams.aspx', 1, 3, N'fas fa-cogs'),
    (18, 7, N'Respaldo de Datos', N'Forms/Sistemas/Respaldos.aspx', 1, 4, N'fas fa-database'),
    (19, 7, N'Tablas Históricas', N'Forms/Logs/historialTablas.aspx?origen=sistemas', 1, 5, N'fas fa-history');

-- Submenú Tablas de Tipo / Mantenimientos (IdParent = 16) - Opciones del sidebar en Mantenimientos.aspx
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

GO

-- Resumen: 8 raíz + 4 reportes + 2 ayuda + 5 sistemas + 18 opciones Mantenimientos = 37 ítems
-- Permisos por ítem en tbMenuUsuario. El sidebar en Mantenimientos.aspx filtra por data-url (igual a Url normalizada).
