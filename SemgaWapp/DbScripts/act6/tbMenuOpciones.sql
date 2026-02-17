-- ============================================================
-- Tablas para control de acceso por opción de menú (mosaicos)
-- SemgaWapp - Cooperativa Coopsemga
-- ============================================================

-- Catálogo de opciones de menú (mosaicos)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'tbMenuOpciones')
BEGIN
    CREATE TABLE tbMenuOpciones (
        IdMenuOpcion    INT IDENTITY(1,1) PRIMARY KEY,
        Clave           VARCHAR(50)  NOT NULL UNIQUE,   -- Ej: DASH_SOCIOS, REP_REPORTES
        Nombre          NVARCHAR(150) NOT NULL,         -- Texto visible
        UrlDestino      NVARCHAR(500) NULL,             -- Ruta relativa (Forms/...)
        IdPadre         INT NULL REFERENCES tbMenuOpciones(IdMenuOpcion), -- Para agrupar (ej. opciones dentro de Reportes)
        Orden           INT NOT NULL DEFAULT 0,
        Activo          BIT NOT NULL DEFAULT 1,
        Notas           NVARCHAR(500) NULL
    );
END
GO

-- Permisos por usuario (o por rol, según tu modelo)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'tbUsuarioMenuPermiso')
BEGIN
    CREATE TABLE tbUsuarioMenuPermiso (
        Id              INT IDENTITY(1,1) PRIMARY KEY,
        IdUsuario       INT NOT NULL,                   -- FK a tu tabla de usuarios
        IdMenuOpcion    INT NOT NULL REFERENCES tbMenuOpciones(IdMenuOpcion),
        Permitido       BIT NOT NULL DEFAULT 1,
        UNIQUE (IdUsuario, IdMenuOpcion)
    );
END
GO

-- ============================================================
-- INSERTS: Todas las opciones de menú (mosaicos)
-- Solo inserta si la Clave no existe (re-ejecutable)
-- ============================================================

-- Dashboard principal (sin padre)
INSERT INTO tbMenuOpciones (Clave, Nombre, UrlDestino, IdPadre, Orden, Activo, Notas)
SELECT v.Clave, v.Nombre, v.UrlDestino, NULL, v.Orden, 1, v.Notas
FROM (VALUES
    ('DASH_SOCIOS', N'Gestión de Socios', 'Forms/Socios/GestionSocios.aspx', 1, NULL),
    ('DASH_MOVIMIENTOS', N'Movimientos de Cuentas', 'Forms/Transacciones/Transacciones.aspx', 2, NULL),
    ('DASH_AUXILIARES', N'Gestión de Auxiliares', 'Forms/Auxiliares/AuxiliaresAsociados.aspx', 3, NULL),
    ('DASH_REPORTES', N'Reportes y Estadísticas', 'Forms/Reportes/dashboardReportes.aspx', 4, NULL),
    ('DASH_FINANZAS', N'Finanzas', 'Forms/Finanzas/Finanzas.aspx', 5, N'Solo Gerente/Admin'),
    ('DASH_LOGS', N'Logs y Auditorías', 'Forms/Logs/DetalleLogs.aspx', 6, N'Nivel ≤1'),
    ('DASH_SISTEMAS', N'Configuraciones del Sistema', 'Forms/Mantenimientos/dashboardSistemas.aspx', 7, N'Solo Administrador'),
    ('DASH_AYUDA', N'Ayuda', 'Forms/Help/helpDashboard.aspx', 8, NULL)
) AS v(Clave, Nombre, UrlDestino, Orden, Notas)
WHERE NOT EXISTS (SELECT 1 FROM tbMenuOpciones m WHERE m.Clave = v.Clave);

-- Dashboard Reportes (padre = DASH_REPORTES)
INSERT INTO tbMenuOpciones (Clave, Nombre, UrlDestino, IdPadre, Orden, Activo, Notas)
SELECT v.Clave, v.Nombre, v.UrlDestino, (SELECT IdMenuOpcion FROM tbMenuOpciones WHERE Clave = 'DASH_REPORTES'), v.Orden, 1, NULL
FROM (VALUES
    ('REP_REPORTES', N'Reportes del Sistema', 'Forms/Reportes/Reportes.aspx', 1),
    ('REP_HISTORIAL', N'Tablas Históricas', 'Forms/Logs/historialTablas.aspx', 2),
    ('REP_MOVIMIENTOS', N'Movimientos', 'Forms/Reportes/Movimientos.aspx', 3)
) AS v(Clave, Nombre, UrlDestino, Orden)
WHERE NOT EXISTS (SELECT 1 FROM tbMenuOpciones m WHERE m.Clave = v.Clave);

-- Dashboard Ayuda (padre = DASH_AYUDA)
INSERT INTO tbMenuOpciones (Clave, Nombre, UrlDestino, IdPadre, Orden, Activo, Notas)
SELECT v.Clave, v.Nombre, v.UrlDestino, (SELECT IdMenuOpcion FROM tbMenuOpciones WHERE Clave = 'DASH_AYUDA'), v.Orden, 1, NULL
FROM (VALUES
    ('AYUDA_DOC', N'Documentación de Aplicación', 'Forms/Help/Documentacion.aspx', 1),
    ('AYUDA_PROCESOS', N'Manual de Procesos Técnicos', 'Forms/Help/procesosTecnicos.aspx', 2)
) AS v(Clave, Nombre, UrlDestino, Orden)
WHERE NOT EXISTS (SELECT 1 FROM tbMenuOpciones m WHERE m.Clave = v.Clave);

-- Dashboard Sistemas (padre = DASH_SISTEMAS)
INSERT INTO tbMenuOpciones (Clave, Nombre, UrlDestino, IdPadre, Orden, Activo, Notas)
SELECT v.Clave, v.Nombre, v.UrlDestino, (SELECT IdMenuOpcion FROM tbMenuOpciones WHERE Clave = 'DASH_SISTEMAS'), v.Orden, 1, NULL
FROM (VALUES
    ('SIST_USUARIOS', N'Gestión de Usuarios', 'Forms/Mantenimientos/GestionUsuarios.aspx', 1),
    ('SIST_MANTENIMIENTOS', N'Tablas de Tipo', 'Forms/Mantenimientos/Mantenimientos.aspx', 2),
    ('SIST_PARAMS', N'Parámetros del Sistema', 'Forms/Mantenimientos/appParams.aspx', 3),
    ('SIST_RESPALDOS', N'Respaldo de Datos', 'Forms/Sistemas/Respaldos.aspx', 4),
    ('SIST_HISTORIAL', N'Tablas Históricas', 'Forms/Logs/historialTablas.aspx', 5)
) AS v(Clave, Nombre, UrlDestino, Orden)
WHERE NOT EXISTS (SELECT 1 FROM tbMenuOpciones m WHERE m.Clave = v.Clave);

-- Opciones dentro de Mantenimientos (sidebar)
INSERT INTO tbMenuOpciones (Clave, Nombre, UrlDestino, IdPadre, Orden, Activo, Notas)
SELECT v.Clave, v.Nombre, v.UrlDestino, (SELECT IdMenuOpcion FROM tbMenuOpciones WHERE Clave = 'SIST_MANTENIMIENTOS'), v.Orden, 1, v.Notas
FROM (VALUES
    ('MANT_CUENTAS', N'Cuentas', 'Forms/Mantenimientos/Mantenimientos.aspx#cuentas', 1, N'Tab cuentas'),
    ('MANT_ROLES', N'Roles de Usuario', 'Forms/Mantenimientos/Mantenimientos.aspx#roles', 2, NULL),
    ('MANT_DEPARTAMENTOS', N'Departamentos', 'Forms/Mantenimientos/Mantenimientos.aspx#departamentos', 3, NULL),
    ('MANT_TIPO_IDENTIFICACION', N'Tipo Identificación', 'Forms/Mantenimientos/Mantenimientos.aspx#tipo-identificacion', 4, NULL),
    ('MANT_TIPO_ASOCIADOS', N'Tipo Asociados', 'Forms/Mantenimientos/Mantenimientos.aspx#tipo-asociados', 5, NULL),
    ('MANT_PARENTEZCOS', N'Parentezcos', 'Forms/Mantenimientos/Mantenimientos.aspx#parentezcos', 6, NULL),
    ('MANT_ESTATUS_ASOCIADOS', N'Estatus Asociados', 'Forms/Mantenimientos/Mantenimientos.aspx#estatus-asociados', 7, NULL),
    ('MANT_CODIGOS_TRANSACCION', N'Códigos Transacción', 'Forms/Mantenimientos/Mantenimientos.aspx#codigos-transacciones', 8, NULL),
    ('MANT_RUBROS', N'Rubros', 'Forms/Mantenimientos/Mantenimientos.aspx#rubros', 9, NULL),
    ('MANT_TIPOS_AUXILIARES', N'Tipos Auxiliares', 'Forms/Mantenimientos/Mantenimientos.aspx#tipos-auxiliares', 10, NULL),
    ('MANT_NIVELES_ESTUDIO', N'Niveles de Estudio', 'Forms/Mantenimientos/Mantenimientos.aspx#niveles-estudio', 11, NULL),
    ('MANT_PROFESIONES', N'Profesiones', 'Forms/Mantenimientos/Mantenimientos.aspx#profesiones', 12, NULL),
    ('MANT_OCUPACIONES', N'Ocupaciones', 'Forms/Mantenimientos/Mantenimientos.aspx#ocupaciones', 13, NULL),
    ('MANT_EMPRESAS', N'Empresas', 'Forms/Mantenimientos/Mantenimientos.aspx#empresas', 14, NULL),
    ('MANT_PAISES', N'Países', 'Forms/Mantenimientos/Mantenimientos.aspx#paises', 15, NULL),
    ('MANT_PROVINCIAS', N'Provincias', 'Forms/Mantenimientos/Mantenimientos.aspx#provincias', 16, NULL),
    ('MANT_DISTRITOS', N'Distritos', 'Forms/Mantenimientos/Mantenimientos.aspx#distritos', 17, NULL),
    ('MANT_CORREGIMIENTOS', N'Corregimientos', 'Forms/Mantenimientos/Mantenimientos.aspx#corregimientos', 18, NULL)
) AS v(Clave, Nombre, UrlDestino, Orden, Notas)
WHERE NOT EXISTS (SELECT 1 FROM tbMenuOpciones m WHERE m.Clave = v.Clave);

GO

-- Ajustar IdUsuario en tbUsuarioMenuPermiso según tu tabla de usuarios (ej: tbUsuarios).
-- Ejemplo: dar todos los permisos al usuario 1
-- INSERT INTO tbUsuarioMenuPermiso (IdUsuario, IdMenuOpcion, Permitido)
-- SELECT 1, IdMenuOpcion, 1 FROM tbMenuOpciones WHERE Activo = 1;
