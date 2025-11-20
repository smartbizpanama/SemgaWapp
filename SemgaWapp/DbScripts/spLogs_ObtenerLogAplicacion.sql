ALTER PROCEDURE [dbo].[spLogs_ObtenerLogAplicacion]
    @IdSesion NVARCHAR(50) = NULL,
    @Usuario NVARCHAR(50) = NULL,
    @FechaDesde DATE = NULL,
    @FechaHasta DATE = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        SELECT 
            h.IDSesion,
            h.FechaHora,
            h.Hora,
            h.Usuario,
            u.Nombre + ' ' + u.Apellido AS NombreCompleto
        FROM tbLogSesionHdr h
        LEFT JOIN tbUsuarios u ON h.Usuario = u.Usuario
        WHERE 1=1
            AND (@IdSesion IS NULL OR h.IDSesion LIKE '%' + @IdSesion + '%')
            AND (@Usuario IS NULL OR h.Usuario LIKE '%' + @Usuario + '%')
            AND (@FechaDesde IS NULL OR CAST(h.FechaHora AS DATE) >= @FechaDesde)
            AND (@FechaHasta IS NULL OR CAST(h.FechaHora AS DATE) <= @FechaHasta)
        ORDER BY h.FechaHora DESC;
    END TRY
    BEGIN CATCH
        DECLARE @Mensaje NVARCHAR(2048);
        SET @Mensaje = ERROR_MESSAGE();
        THROW 50001, @Mensaje, 1;
    END CATCH
END;
