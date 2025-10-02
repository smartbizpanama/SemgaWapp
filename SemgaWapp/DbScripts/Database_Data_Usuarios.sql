-- =============================================
-- DATOS DE EJEMPLO PARA GESTIÓN DE USUARIOS
-- =============================================

-- Insertar Roles
INSERT INTO [dbo].[tbRoles] ([Nombre], [Descripcion], [NivelAcceso], [Activo], [FechaCreacion]) VALUES
('Administrador', 'Acceso completo al sistema con todos los privilegios', 10, 1, GETDATE()),
('Supervisor', 'Acceso a la mayoría de funciones con capacidad de supervisión', 7, 1, GETDATE()),
('Operador', 'Acceso básico para operaciones diarias', 5, 1, GETDATE()),
('Consultor', 'Acceso de solo lectura para consultas', 3, 1, GETDATE()),
('Auditor', 'Acceso para auditorías y reportes', 4, 1, GETDATE());
GO

-- Insertar Departamentos
INSERT INTO [dbo].[tbDepartamentos] ([Nombre], [Descripcion], [Responsable], [Telefono], [Email], [Activo], [FechaCreacion]) VALUES
('Administración', 'Departamento de administración general', 'Juan Pérez', '555-0101', 'admin@coopsemga.com', 1, GETDATE()),
('Finanzas', 'Departamento de finanzas y contabilidad', 'María García', '555-0102', 'finanzas@coopsemga.com', 1, GETDATE()),
('Operaciones', 'Departamento de operaciones diarias', 'Carlos Rodríguez', '555-0103', 'operaciones@coopsemga.com', 1, GETDATE()),
('Atención al Cliente', 'Departamento de atención al cliente', 'Ana López', '555-0104', 'atencion@coopsemga.com', 1, GETDATE()),
('Tecnología', 'Departamento de sistemas y tecnología', 'Luis Martínez', '555-0105', 'tecnologia@coopsemga.com', 1, GETDATE()),
('Recursos Humanos', 'Departamento de recursos humanos', 'Carmen Silva', '555-0106', 'rrhh@coopsemga.com', 1, GETDATE()),
('Auditoría', 'Departamento de auditoría interna', 'Roberto Díaz', '555-0107', 'auditoria@coopsemga.com', 1, GETDATE());
GO

-- Insertar Usuarios (las contraseñas están encriptadas con SBEncryption)
-- Contraseña por defecto: "123456" (encriptada)
INSERT INTO [dbo].[tbUsuarios] ([Nombre], [Apellido], [Usuario], [Clave], [Email], [Telefono], [Rol], [Departamento], [Estado], [IntentosFallidos], [FechaCreacion], [CreadoPor]) VALUES
('Administrador', 'Sistema', 'admin', 'U2FsdGVkX1+QJ8J8J8J8J8J8J8J8J8J8J8J8J8J8=', 'admin@coopsemga.com', '555-0001', 1, 1, 'Activo', 0, GETDATE(), 1),
('Juan', 'Pérez', 'jperez', 'U2FsdGVkX1+QJ8J8J8J8J8J8J8J8J8J8J8J8J8J8=', 'juan.perez@coopsemga.com', '555-0002', 2, 1, 'Activo', 0, GETDATE(), 1),
('María', 'García', 'mgarcia', 'U2FsdGVkX1+QJ8J8J8J8J8J8J8J8J8J8J8J8J8J8=', 'maria.garcia@coopsemga.com', '555-0003', 2, 2, 'Activo', 0, GETDATE(), 1),
('Carlos', 'Rodríguez', 'crodriguez', 'U2FsdGVkX1+QJ8J8J8J8J8J8J8J8J8J8J8J8J8J8=', 'carlos.rodriguez@coopsemga.com', '555-0004', 3, 3, 'Activo', 0, GETDATE(), 1),
('Ana', 'López', 'alopez', 'U2FsdGVkX1+QJ8J8J8J8J8J8J8J8J8J8J8J8J8J8=', 'ana.lopez@coopsemga.com', '555-0005', 3, 4, 'Activo', 0, GETDATE(), 1),
('Luis', 'Martínez', 'lmartinez', 'U2FsdGVkX1+QJ8J8J8J8J8J8J8J8J8J8J8J8J8J8=', 'luis.martinez@coopsemga.com', '555-0006', 2, 5, 'Activo', 0, GETDATE(), 1),
('Carmen', 'Silva', 'csilva', 'U2FsdGVkX1+QJ8J8J8J8J8J8J8J8J8J8J8J8J8J8=', 'carmen.silva@coopsemga.com', '555-0007', 3, 6, 'Activo', 0, GETDATE(), 1),
('Roberto', 'Díaz', 'rdiaz', 'U2FsdGVkX1+QJ8J8J8J8J8J8J8J8J8J8J8J8J8J8=', 'roberto.diaz@coopsemga.com', '555-0008', 5, 7, 'Activo', 0, GETDATE(), 1),
('Patricia', 'Hernández', 'phernandez', 'U2FsdGVkX1+QJ8J8J8J8J8J8J8J8J8J8J8J8J8J8=', 'patricia.hernandez@coopsemga.com', '555-0009', 3, 4, 'Inactivo', 0, GETDATE(), 1),
('Fernando', 'González', 'fgonzalez', 'U2FsdGVkX1+QJ8J8J8J8J8J8J8J8J8J8J8J8J8J8=', 'fernando.gonzalez@coopsemga.com', '555-0010', 4, 2, 'Activo', 0, GETDATE(), 1);
GO

-- Actualizar algunos usuarios con último acceso
UPDATE [dbo].[tbUsuarios] SET [UltimoAcceso] = DATEADD(HOUR, -2, GETDATE()) WHERE [Usuario] = 'admin';
UPDATE [dbo].[tbUsuarios] SET [UltimoAcceso] = DATEADD(HOUR, -1, GETDATE()) WHERE [Usuario] = 'jperez';
UPDATE [dbo].[tbUsuarios] SET [UltimoAcceso] = DATEADD(MINUTE, -30, GETDATE()) WHERE [Usuario] = 'mgarcia';
UPDATE [dbo].[tbUsuarios] SET [UltimoAcceso] = DATEADD(DAY, -1, GETDATE()) WHERE [Usuario] = 'crodriguez';
UPDATE [dbo].[tbUsuarios] SET [UltimoAcceso] = DATEADD(DAY, -2, GETDATE()) WHERE [Usuario] = 'alopez';
UPDATE [dbo].[tbUsuarios] SET [UltimoAcceso] = DATEADD(HOUR, -4, GETDATE()) WHERE [Usuario] = 'lmartinez';
UPDATE [dbo].[tbUsuarios] SET [UltimoAcceso] = DATEADD(DAY, -3, GETDATE()) WHERE [Usuario] = 'csilva';
UPDATE [dbo].[tbUsuarios] SET [UltimoAcceso] = DATEADD(HOUR, -6, GETDATE()) WHERE [Usuario] = 'rdiaz';
UPDATE [dbo].[tbUsuarios] SET [UltimoAcceso] = DATEADD(DAY, -5, GETDATE()) WHERE [Usuario] = 'fgonzalez';
GO

-- Simular algunos intentos fallidos
UPDATE [dbo].[tbUsuarios] SET [IntentosFallidos] = 2 WHERE [Usuario] = 'phernandez';
UPDATE [dbo].[tbUsuarios] SET [IntentosFallidos] = 1 WHERE [Usuario] = 'fgonzalez';
GO


