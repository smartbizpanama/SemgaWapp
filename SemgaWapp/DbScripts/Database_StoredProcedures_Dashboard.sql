-- =============================================
-- STORED PROCEDURES PARA DASHBOARD
-- =============================================

-- Procedimiento para obtener datos del dashboard
CREATE PROCEDURE [dbo].[spGetDashboard]
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Obtener estadísticas del dashboard
    SELECT 
        -- Socios activos
        (SELECT COUNT(*) 
         FROM tbSocios 
         WHERE Estado = 'A') AS SociosActivos,
        
        -- Préstamos activos
        (SELECT COUNT(*) 
         FROM tbPrestamos 
         WHERE Estado = 'A') AS PrestamosActivos,
        
        -- Total ahorros
        (SELECT ISNULL(SUM(Saldo), 0) 
         FROM tbAhorros 
         WHERE Estado = 'A') AS TotalAhorros,
        
        -- Usuarios activos
        (SELECT COUNT(*) 
         FROM tbUsuarios 
         WHERE Estado = 'Activo') AS UsuariosActivos,
        
        -- JSON con conteo de tipos de asociados
        (SELECT 
            '[' + STRING_AGG(
                '{"TipoAsociado":"' + t.TipoAsociado + '","Cantidad":' + CAST(COUNT(s.Id) AS VARCHAR(10)) + '}',
                ','
            ) + ']' AS JsonTiposAsociados
         FROM tbTiposAsociado t
         LEFT JOIN tbSocios s ON t.CodTipoAsociado = s.TipoAsociado AND s.Estado = 'A'
         GROUP BY t.CodTipoAsociado, t.TipoAsociado
         FOR JSON PATH
        ) AS JsonTiposAsociados,
        
        -- JSON con movimientos de la última semana
        (SELECT 
            '[' + STRING_AGG(
                '{"Fecha":"' + CONVERT(VARCHAR(10), m.FechaMovimiento, 120) + '","Descripcion":"' + ISNULL(m.Descripcion, '') + '","Monto":' + CAST(ISNULL(m.Monto, 0) AS VARCHAR(20)) + ',"Tipo":"' + ISNULL(m.TipoMovimiento, '') + '"}',
                ','
            ) + ']' AS UltimosMovimientos
         FROM tbMovimientos m
         WHERE m.FechaMovimiento >= DATEADD(DAY, -7, GETDATE())
         ORDER BY m.FechaMovimiento DESC
         FOR JSON PATH
        ) AS UltimosMovimientos,
        
        -- Fecha de última actualización
        GETDATE() AS UltimaActualizacion;
END
GO

-- Procedimiento para obtener estadísticas de socios por tipo
CREATE PROCEDURE [dbo].[spGetEstadisticasSocios]
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        t.TipoAsociado,
        COUNT(s.Id) AS Cantidad,
        ROUND(COUNT(s.Id) * 100.0 / (SELECT COUNT(*) FROM tbSocios WHERE Estado = 'A'), 2) AS Porcentaje
    FROM tbTiposAsociado t
    LEFT JOIN tbSocios s ON t.CodTipoAsociado = s.TipoAsociado AND s.Estado = 'A'
    GROUP BY t.CodTipoAsociado, t.TipoAsociado
    ORDER BY Cantidad DESC;
END
GO

-- Procedimiento para obtener estadísticas de préstamos por estado
CREATE PROCEDURE [dbo].[spGetEstadisticasPrestamos]
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        CASE 
            WHEN Estado = 'A' THEN 'Activos'
            WHEN Estado = 'P' THEN 'Pendientes'
            WHEN Estado = 'C' THEN 'Cancelados'
            WHEN Estado = 'V' THEN 'Vencidos'
            ELSE 'Otros'
        END AS EstadoPrestamo,
        COUNT(*) AS Cantidad,
        ISNULL(SUM(Monto), 0) AS MontoTotal
    FROM tbPrestamos
    GROUP BY Estado
    ORDER BY Cantidad DESC;
END
GO

-- Procedimiento para obtener estadísticas de ahorros por tipo
CREATE PROCEDURE [dbo].[spGetEstadisticasAhorros]
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        t.TipoAhorro,
        COUNT(a.Id) AS CantidadCuentas,
        ISNULL(SUM(a.Saldo), 0) AS SaldoTotal,
        ISNULL(AVG(a.Saldo), 0) AS SaldoPromedio
    FROM tbTiposAhorro t
    LEFT JOIN tbAhorros a ON t.CodTipoAhorro = a.TipoAhorro AND a.Estado = 'A'
    GROUP BY t.CodTipoAhorro, t.TipoAhorro
    ORDER BY SaldoTotal DESC;
END
GO
