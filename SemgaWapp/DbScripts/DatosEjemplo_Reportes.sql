-- Datos de ejemplo para la tabla tbReportesComandos
-- Insertar reportes de ejemplo para pruebas

INSERT INTO [dbo].[tbReportesComandos] ([Nombre], [Tipo], [Comando], [SnActivo], [SnEliminado])
VALUES 
('Reporte de Movimientos Diarios', 'Financiero', 'SELECT * FROM Movimientos WHERE Fecha = GETDATE()', 1, 0),
('Balance General', 'Contable', 'SELECT * FROM BalanceGeneral WHERE Periodo = YEAR(GETDATE())', 1, 0),
('Estados de Cuenta', 'Operativo', 'SELECT * FROM EstadosCuenta WHERE Activo = 1', 1, 0),
('Estadísticas de Asociados', 'Estadístico', 'SELECT COUNT(*) as TotalAsociados FROM Asociados WHERE Activo = 1', 1, 0),
('Reporte de Transacciones', 'Financiero', 'SELECT * FROM Transacciones WHERE Fecha >= DATEADD(day, -30, GETDATE())', 1, 0),
('Listado de Socios', 'Administrativo', 'SELECT * FROM Socios ORDER BY Nombre', 1, 0),
('Reporte de Ingresos', 'Financiero', 'SELECT SUM(Monto) as TotalIngresos FROM Movimientos WHERE Tipo = ''Ingreso''', 1, 0),
('Reporte de Egresos', 'Financiero', 'SELECT SUM(Monto) as TotalEgresos FROM Movimientos WHERE Tipo = ''Egreso''', 1, 0),
('Estadísticas Mensuales', 'Estadístico', 'SELECT MONTH(Fecha) as Mes, COUNT(*) as Transacciones FROM Movimientos GROUP BY MONTH(Fecha)', 1, 0),
('Reporte de Auditoría', 'Administrativo', 'SELECT * FROM LogAuditoria ORDER BY Fecha DESC', 1, 0);



