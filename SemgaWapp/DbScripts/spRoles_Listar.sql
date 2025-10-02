-- =============================================
-- Author: Sistema SemgaWapp
-- Create date: 2024
-- Description: Listar roles con filtros opcionales
-- =============================================
CREATE PROCEDURE [dbo].[spRoles_Listar]
    @Nombre NVARCHAR(50) = NULL,
    @NivelAcceso INT = NULL,
    @Activo BIT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT
        r.Id,
        r.Nombre,
        r.Descripcion,
        r.NivelAcceso,
        CASE 
            WHEN r.NivelAcceso = 0 THEN 'Super Usuario'
            WHEN r.NivelAcceso = 1 THEN 'Administrador'
            WHEN r.NivelAcceso = 2 THEN 'Agente'
            ELSE 'Desconocido'
        END AS DescripcionNivelAcceso,
        r.Activo,
        CASE 
            WHEN r.Activo = 1 THEN 'Activo'
            ELSE 'Inactivo'
        END AS DescripcionEstado,
        r.FechaCreacion,
        r.FechaModificacion,
        r.snEliminado
    FROM
        tbRoles r
    WHERE
        r.snEliminado = 0
        AND (@Nombre IS NULL OR r.Nombre LIKE '%' + @Nombre + '%')
        AND (@NivelAcceso IS NULL OR r.NivelAcceso = @NivelAcceso)
        AND (@Activo IS NULL OR r.Activo = @Activo)
    ORDER BY
        r.NivelAcceso, r.Nombre;
END


