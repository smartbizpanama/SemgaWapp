
CREATE or alter PROCEDURE dbo.spMenu_PermisosGuardar
    @IdUsuario   INT,
    @PermisosJson NVARCHAR(MAX)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        DELETE FROM tbUsuarioMenuPermiso
        WHERE IdUsuario = @IdUsuario;

        IF ISNULL(LTRIM(RTRIM(@PermisosJson)), '') <> '' AND @PermisosJson <> '[]'
        BEGIN
            INSERT INTO tbUsuarioMenuPermiso (IdUsuario, IdMenuOpcion, Permitido)
            SELECT
                @IdUsuario,
                j.IdMenuOpcion,
                ISNULL(j.Permitido, 1)
            FROM OPENJSON(@PermisosJson) WITH (
                IdMenuOpcion INT '$.IdMenuOpcion',
                Permitido    BIT '$.Permitido'
            ) j;
        END

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        DECLARE @Msg NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@Msg, 16, 1);
    END CATCH
END
GO
