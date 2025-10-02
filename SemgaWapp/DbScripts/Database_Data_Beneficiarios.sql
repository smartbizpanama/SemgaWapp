-- =============================================
-- Datos de ejemplo para tablas de Beneficiarios
-- =============================================

-- =============================================
-- Insertar parentezcos de ejemplo
-- =============================================
INSERT INTO [dbo].[tbParentezcos] ([Parentezco]) VALUES 
('Cónyuge'),
('Hijo(a)'),
('Padre'),
('Madre'),
('Hermano(a)'),
('Abuelo(a)'),
('Nieto(a)'),
('Sobrino(a)'),
('Primo(a)'),
('Tío(a)'),
('Yerno/Nuera'),
('Suegro(a)'),
('Cuñado(a)'),
('Otro');

-- =============================================
-- Ejemplo de beneficiarios (opcional - para testing)
-- =============================================
-- NOTA: Estos datos son solo para testing. 
-- En producción, los beneficiarios se crearán a través de la aplicación.

/*
INSERT INTO [dbo].[tbBeneficiarios] 
([NumeroAsociado], [Nombre], [Apellido], [TipoIdentificacion], [NumeroIdentificacion], [IDParentezco], [Porcentaje], [snEliminado]) 
VALUES 
(1, 'MARIA', 'GONZALEZ', 'C', '123456789', 1, 50.00, 0),
(1, 'JUAN CARLOS', 'GONZALEZ', 'C', '987654321', 2, 30.00, 0),
(1, 'ANA LUCIA', 'GONZALEZ', 'C', '456789123', 2, 20.00, 0);
*/






