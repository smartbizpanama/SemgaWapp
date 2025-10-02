CREATE PROCEDURE [dbo].[spUsuarios_Obtener]
    @ID INT
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        u.Id,
        u.Nombre,
        u.Apellido,
        u.Usuario,
        u.Email,
        u.Telefono,
        u.Rol,
        u.Departamento,
        u.Estado,
        u.UltimoAcceso,
        u.IntentosFallidos,
        u.BloqueadoHasta,
        u.FechaCreacion,
        u.FechaModificacion,
        u.snEliminado
    FROM tbUsuarios u
    WHERE u.Id = @ID
        AND u.snEliminado = 0;
END

