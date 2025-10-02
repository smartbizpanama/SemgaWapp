-- =============================================
-- STORED PROCEDURES PARA DASHBOARD - VERSIÓN DE PRUEBA
-- =============================================

-- Procedimiento simplificado para obtener datos del dashboard
CREATE PROCEDURE [dbo].[spGetDashboard_Test]
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Obtener estadísticas del dashboard con JSON simplificado
    SELECT 
        -- Socios activos
        (SELECT COUNT(*) 
         FROM tbSocios 
         WHERE Estado = 'A') AS SociosActivos,
        
        -- JSON simplificado con tipos de asociados
        '[
            {"TipoAsociado":"Cliente","Cantidad":2},
            {"TipoAsociado":"Proveedor","Cantidad":1},
            {"TipoAsociado":"Empleado","Cantidad":3}
        ]' AS JsonTiposAsociados,
        
        -- Fecha de última actualización
        GETDATE() AS UltimaActualizacion;
END
GO




