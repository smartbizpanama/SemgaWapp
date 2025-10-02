-- Datos de ejemplo para la tabla tbTipoAsociado
-- Ejecutar este script después de crear la tabla tbTipoAsociado

USE [TuBaseDeDatos] -- Reemplazar con el nombre de tu base de datos
GO

-- Insertar tipos de asociado de ejemplo
INSERT INTO tbTipoAsociado (CodTipoAsociado, TipoAsociado) VALUES
('ORD', 'Asociado Ordinario'),
('HON', 'Asociado Honorario'),
('JUV', 'Asociado Juvenil'),
('FAM', 'Asociado Familiar'),
('CORP', 'Asociado Corporativo'),
('PEN', 'Asociado Pensionado'),
('EST', 'Asociado Estudiante'),
('VIP', 'Asociado VIP')

GO

-- Verificar que los datos se insertaron correctamente
SELECT * FROM tbTipoAsociado ORDER BY TipoAsociado
GO

