-- =============================================
-- Stored Procedure para obtener usuarios usados en los logs
-- Permite manejar usuarios almacenados como texto (#sa#, etc.)
-- =============================================

USE [SegmaDB]
GO

IF EXISTS (
    SELECT *
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[spLogsAuditoria_ObtenerUsuarios]')
      AND type IN (N'P', N'PC')
)
    DROP PROCEDURE [dbo].[spLogsAuditoria_ObtenerUsuarios];
GO

CREATE PROCEDURE [dbo].[spLogsAuditoria_ObtenerUsuarios]
AS
BEGIN
    SET NOCOUNT ON;

    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

    ;WITH UsuariosAplicacion AS (
        SELECT DISTINCT
            u.Id,
            u.Usuario,
            u.Nombre,
            u.Apellido,
            u.Nombre + ' ' + u.Apellido AS NombreCompleto
        FROM tbUsuarios u
        INNER JOIN tbLogsAuditoria la
            ON CAST(u.Id AS NVARCHAR(50)) = la.UsuarioId
        WHERE la.Operacion <> 'X'
    ),
    UsuariosDirectos AS (
        SELECT DISTINCT
            0 AS Id,
            la.UsuarioId AS Usuario,
            'dbUser' AS Nombre,
            'dbUser' AS Apellido,
            la.UsuarioId AS NombreCompleto
        FROM tbLogsAuditoria la
        WHERE la.Operacion = 'X'
    )
    SELECT *
    FROM UsuariosAplicacion
    UNION ALL
    SELECT *
    FROM UsuariosDirectos
    ORDER BY NombreCompleto;
END
GO

PRINT 'Stored Procedure spLogsAuditoria_ObtenerUsuarios creado/actualizado exitosamente'
GO





