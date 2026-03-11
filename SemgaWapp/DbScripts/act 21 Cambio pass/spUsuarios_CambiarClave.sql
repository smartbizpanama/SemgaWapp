-- =============================================
-- spUsuarios_CambiarClave


CREATE or alter PROCEDURE dbo.spUsuarios_CambiarClave
    @IdUsuario INT,
    @Clave    NVARCHAR(max)
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
