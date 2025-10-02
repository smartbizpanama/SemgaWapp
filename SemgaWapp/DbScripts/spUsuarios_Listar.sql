CREATE PROCEDURE [dbo].[spUsuarios_Listar]
    @Rol INT = NULL,
    @Departamento INT = NULL,
    @Estado VARCHAR(20) = NULL,
    @Buscar VARCHAR(100) = NULL
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
        r.Nombre AS RolNombre,
        u.Departamento,
        d.Nombre AS DepartamentoNombre,
        u.Estado,
        u.UltimoAcceso,
        u.IntentosFallidos,
        u.BloqueadoHasta,
        u.FechaCreacion,
        u.FechaModificacion,
        u.snEliminado
    FROM tbUsuarios u
    LEFT JOIN tbRoles r ON u.Rol = r.Id
    LEFT JOIN tbDepartamentos d ON u.Departamento = d.Id
    WHERE u.snEliminado = 0
        AND (@Rol IS NULL OR u.Rol = @Rol)
        AND (@Departamento IS NULL OR u.Departamento = @Departamento)
        AND (@Estado IS NULL OR u.Estado = @Estado)
        AND (@Buscar IS NULL OR 
             u.Nombre LIKE '%' + @Buscar + '%' OR 
             u.Apellido LIKE '%' + @Buscar + '%' OR 
             u.Usuario LIKE '%' + @Buscar + '%' OR 
             u.Email LIKE '%' + @Buscar + '%')
    ORDER BY u.Nombre, u.Apellido;
END

