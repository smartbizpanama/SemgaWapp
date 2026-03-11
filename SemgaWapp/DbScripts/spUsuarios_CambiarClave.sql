-- =============================================
-- spUsuarios_CambiarClave
-- Actualiza la contraseña del usuario indicado.
-- La contraseña debe llegar ya encriptada (mismo criterio que en login).
-- =============================================
IF OBJECT_ID('dbo.spUsuarios_CambiarClave', 'P') IS NOT NULL
    DROP PROCEDURE dbo.spUsuarios_CambiarClave;
GO

CREATE PROCEDURE dbo.spUsuarios_CambiarClave
    @IdUsuario INT,
    @Clave    NVARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;

    IF @IdUsuario IS NULL OR @Clave IS NULL OR LTRIM(RTRIM(@Clave)) = ''
    BEGIN
        RAISERROR('IdUsuario y Clave son obligatorios.', 16, 1);
        RETURN;
    END

    IF NOT EXISTS (SELECT 1 FROM dbo.tbUsuarios WHERE Id = @IdUsuario AND (snEliminado = 0 OR snEliminado IS NULL))
    BEGIN
        RAISERROR('Usuario no encontrado.', 16, 1);
        RETURN;
    END

    UPDATE dbo.tbUsuarios
    SET Clave = @Clave
    WHERE Id = @IdUsuario;
END
GO
