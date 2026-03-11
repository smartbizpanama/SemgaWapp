-- ============================================================
-- tbMenuUsuario - Permisos de menú por usuario
-- SemgaWapp - Cooperativa Coopsemga
-- Admin (NivelAcceso=0) tiene acceso a todos sin registrar aquí.
-- ============================================================

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'tbMenuUsuario')
BEGIN
    CREATE TABLE [dbo].[tbMenuUsuario](
        [IdMenu] [int] NOT NULL,
        [IDUsuario] [int] NOT NULL,
        CONSTRAINT [PK_tbMenuUsuario] PRIMARY KEY CLUSTERED ([IdMenu] ASC, [IDUsuario] ASC),
        CONSTRAINT [FK_tbMenuUsuario_Menu] FOREIGN KEY ([IdMenu]) REFERENCES [dbo].[tbMenuPrincipal] ([IdMenu])
    ) ON [PRIMARY];
END
GO
