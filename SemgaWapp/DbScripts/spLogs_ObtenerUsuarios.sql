CREATE PROCEDURE [dbo].[spLogs_ObtenerUsuarios]
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        SELECT DISTINCT 
            u.Usuario,
            u.Nombre + ' ' + u.Apellido AS NombreCompleto
        FROM tbUsuarios u
        WHERE u.snEliminado = 0
        ORDER BY u.Nombre + ' ' + u.Apellido;
    END TRY
    BEGIN CATCH
        DECLARE @Mensaje NVARCHAR(2048);
        SET @Mensaje = ERROR_MESSAGE();
        THROW 50001, @Mensaje, 1;
    END CATCH
END;
