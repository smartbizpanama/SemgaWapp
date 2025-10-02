-- =============================================
-- Author: Sistema SemgaWapp
-- Create date: 2024
-- Description: Listar departamentos con filtros opcionales
-- =============================================
CREATE PROCEDURE [dbo].[spDepartamentos_Listar]
    @Nombre NVARCHAR(100) = NULL,
    @Responsable NVARCHAR(100) = NULL,
    @Activo BIT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT
        d.Id,
        d.Nombre,
        d.Descripcion,
        d.Responsable,
        d.Telefono,
        d.Email,
        d.Activo,
        CASE 
            WHEN d.Activo = 1 THEN 'Activo'
            ELSE 'Inactivo'
        END AS DescripcionEstado,
        d.FechaCreacion,
        d.FechaModificacion,
        d.snEliminado
    FROM
        tbDepartamentos d
    WHERE
        d.snEliminado = 0
        AND (@Nombre IS NULL OR d.Nombre LIKE '%' + @Nombre + '%')
        AND (@Responsable IS NULL OR d.Responsable LIKE '%' + @Responsable + '%')
        AND (@Activo IS NULL OR d.Activo = @Activo)
    ORDER BY
        d.Nombre;
END


