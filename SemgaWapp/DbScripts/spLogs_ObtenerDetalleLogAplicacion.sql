ALTER PROCEDURE [dbo].[spLogs_ObtenerDetalleLogAplicacion]
    @IDSesion NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        SELECT 
            d.IDSesion,
            d.LineSec,
            d.FechaHora,
            d.Hora,
            d.Accion
        FROM tbLogSesionDet d
        WHERE d.IDSesion = @IDSesion
        ORDER BY d.LineSec;
    END TRY
    BEGIN CATCH
        DECLARE @Mensaje NVARCHAR(2048);
        SET @Mensaje = ERROR_MESSAGE();
        THROW 50001, @Mensaje, 1;
    END CATCH
END;
