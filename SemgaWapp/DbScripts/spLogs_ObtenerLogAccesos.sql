CREATE PROCEDURE [dbo].[spLogs_ObtenerLogAccesos]
    @Usuario NVARCHAR(50) = NULL,
    @FechaDesde DATE = NULL,
    @FechaHasta DATE = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        SELECT 
            la.Id,
            la.Usuario,
            la.FechaIntento,
            la.DireccionIP,
            la.UserAgent,
            la.Exitoso,
            la.Mensaje,
            u.Nombre + ' ' + u.Apellido AS NombreCompleto
        FROM tbLogAccesos la
        LEFT JOIN tbUsuarios u ON la.Usuario = u.Usuario
        WHERE 1=1
            AND (@Usuario IS NULL OR la.Usuario LIKE '%' + @Usuario + '%')
            AND (@FechaDesde IS NULL OR CAST(la.FechaIntento AS DATE) >= @FechaDesde)
            AND (@FechaHasta IS NULL OR CAST(la.FechaIntento AS DATE) <= @FechaHasta)
        ORDER BY la.FechaIntento DESC;
    END TRY
    BEGIN CATCH
        DECLARE @Mensaje NVARCHAR(2048);
        SET @Mensaje = ERROR_MESSAGE();
        THROW 50001, @Mensaje, 1;
    END CATCH
END;
