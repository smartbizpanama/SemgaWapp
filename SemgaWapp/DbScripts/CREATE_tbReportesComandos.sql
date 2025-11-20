CREATE TABLE [dbo].[tbReportesComandos](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Nombre] [nvarchar](150) NULL,
	[Tipo] [varchar](100) NULL,
	[Comando] [nvarchar](max) NULL,
	[SnActivo] [bit] NULL,
	[SnEliminado] [bit] NULL,
 CONSTRAINT [PK_tbReportesComandos] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

-- Insertar algunos datos de ejemplo
INSERT INTO [dbo].[tbReportesComandos] ([Nombre], [Tipo], [Comando], [Descripcion], [SnActivo], [SnEliminado])
VALUES 
('Reporte de Movimientos Diarios', 'Financiero', 'SELECT * FROM Movimientos WHERE Fecha = GETDATE()', 'Muestra todos los movimientos del día actual', 1, 0),
('Balance General', 'Contable', 'SELECT * FROM BalanceGeneral WHERE Periodo = YEAR(GETDATE())', 'Balance general del año en curso', 1, 0),
('Estados de Cuenta', 'Operativo', 'SELECT * FROM EstadosCuenta WHERE Activo = 1', 'Lista de estados de cuenta activos', 1, 0),
('Estadísticas de Asociados', 'Estadístico', 'SELECT COUNT(*) as TotalAsociados FROM Asociados WHERE Activo = 1', 'Conteo total de asociados activos', 1, 0),
('Reporte de Transacciones', 'Financiero', 'SELECT * FROM Transacciones WHERE Fecha >= DATEADD(day, -30, GETDATE())', 'Transacciones de los últimos 30 días', 1, 0),
('Listado de Socios', 'Administrativo', 'SELECT * FROM Socios ORDER BY Nombre', 'Lista completa de socios ordenada por nombre', 1, 0),
('Reporte de Ingresos', 'Financiero', 'SELECT SUM(Monto) as TotalIngresos FROM Movimientos WHERE Tipo = ''Ingreso''', 'Total de ingresos registrados', 1, 0),
('Reporte de Egresos', 'Financiero', 'SELECT SUM(Monto) as TotalEgresos FROM Movimientos WHERE Tipo = ''Egreso''', 'Total de egresos registrados', 1, 0),
('Estadísticas Mensuales', 'Estadístico', 'SELECT MONTH(Fecha) as Mes, COUNT(*) as Transacciones FROM Movimientos GROUP BY MONTH(Fecha)', 'Estadísticas de transacciones por mes', 1, 0),
('Reporte de Auditoría', 'Administrativo', 'SELECT * FROM LogAuditoria ORDER BY Fecha DESC', 'Registro de auditoría ordenado por fecha', 1, 0);
