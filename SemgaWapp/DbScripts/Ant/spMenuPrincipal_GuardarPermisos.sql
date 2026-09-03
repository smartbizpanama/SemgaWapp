-- ============================================================
-- spMenuPrincipal_GuardarPermisos
-- Guarda los permisos de menú del usuario en tbMenuUsuario.
-- @IdUsuario: usuario a actualizar.
-- @IdsMenuJson: array JSON de IdMenu permitidos, ej. [1,2,3,4,9,10]
-- ============================================================
IF OBJECT_ID('dbo.spMenuPrincipal_GuardarPermisos', 'P') IS NOT NULL
    DROP PROCEDURE dbo.spMenuPrincipal_GuardarPermisos;
GO

CREATE PROCEDURE dbo.spMenuPrincipal_GuardarPermisos
    @IdUsuario   INT,
    @IdsMenuJson NVARCHAR(MAX)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        DELETE FROM dbo.tbMenuUsuario
        WHERE IDUsuario = @IdUsuario;

        IF ISNULL(LTRIM(RTRIM(@IdsMenuJson)), '') <> '' AND @IdsMenuJson <> '[]'
        BEGIN
            INSERT INTO dbo.tbMenuUsuario (IdMenu, IDUsuario)
            SELECT j.value, @IdUsuario
            FROM OPENJSON(@IdsMenuJson) j
            WHERE EXISTS (SELECT 1 FROM dbo.tbMenuPrincipal p WHERE p.IdMenu = j.value);
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
