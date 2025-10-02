-- Datos de ejemplo para la tabla tbAsociados
-- Ejecutar este script después de crear la tabla tbAsociados y tbTipoAsociado

USE [TuBaseDeDatos] -- Reemplazar con el nombre de tu base de datos
GO

-- Insertar socios de ejemplo
INSERT INTO tbAsociados (
    IdTipoAsociado, Nombre, SegundoNombre, Apellido, SegundoApellido,
    Estatus, TipoIdentificacion, NumeroIdentificacion, TelefonoResidencia,
    TelefonoCelular, TelefonoFamiliar, CorreoElectronico, Sexo, FechaNacimiento,
    ProvinciaResidencia, DistritoResidencia, CorregimientoResidencia, DireccionResidencia,
    ProvinciaTrabajo, DistritoTrabajo, CorregimientoTrabajo, DireccionTrabajo,
    LugarTrabajo, Ocupacion, NivelEstudio, Profesion, FechaCreacion, UsuarioCrea
) VALUES
-- Socio 1
(1, 'Juan', 'Carlos', 'Pérez', 'González', 'A', 'CEDULA', '8-123-456', '223-4567', '6123-4567', '223-4568', 'juan.perez@email.com', 'M', '1985-03-15', 
 'Panamá', 'Panamá', 'San Francisco', 'Calle 50, Edificio Plaza 2000, Apto 5B', 
 'Panamá', 'Panamá', 'San Francisco', 'Av. Balboa, Torre Global Bank, Piso 15', 
 'Global Bank', 'Gerente de Ventas', 'Universitario', 'Administración de Empresas', GETDATE(), 1),

-- Socio 2
(1, 'María', 'Elena', 'Rodríguez', 'Martínez', 'A', 'CEDULA', '8-234-567', '223-5678', '6123-5678', '223-5679', 'maria.rodriguez@email.com', 'F', '1990-07-22', 
 'Panamá', 'San Miguelito', 'Belisario Porras', 'Calle 2da, Residencial Los Pinos, Casa 15', 
 'Panamá', 'Panamá', 'Bella Vista', 'Av. Samuel Lewis, Edificio Omega, Piso 8', 
 'Banco General', 'Analista Financiera', 'Universitario', 'Contabilidad', GETDATE(), 1),

-- Socio 3
(2, 'Carlos', 'Alberto', 'García', 'López', 'A', 'CEDULA', '8-345-678', '223-6789', '6123-6789', '223-6790', 'carlos.garcia@email.com', 'M', '1978-11-08', 
 'Colón', 'Colón', 'Cristóbal', 'Calle 12, Barrio Norte, Casa 25', 
 'Colón', 'Colón', 'Cristóbal', 'Zona Libre de Colón, Edificio Comercial, Local 45', 
 'Zona Libre de Colón', 'Comerciante', 'Técnico', 'Comercio Internacional', GETDATE(), 1),

-- Socio 4
(3, 'Ana', 'Patricia', 'Hernández', 'Silva', 'A', 'CEDULA', '8-456-789', '223-7890', '6123-7890', '223-7891', 'ana.hernandez@email.com', 'F', '1995-05-12', 
 'Panamá', 'Arraiján', 'Arraiján Cabecera', 'Calle Principal, Residencial Villa Verde, Casa 8', 
 'Panamá', 'Panamá', 'Punta Paitilla', 'Av. Balboa, Edificio Oceanía, Piso 12', 
 'Hotel Marriott', 'Recepcionista', 'Bachiller', 'Turismo', GETDATE(), 1),

-- Socio 5
(1, 'Roberto', 'José', 'Morales', 'Vega', 'I', 'CEDULA', '8-567-890', '223-8901', '6123-8901', '223-8902', 'roberto.morales@email.com', 'M', '1982-09-30', 
 'Panamá', 'La Chorrera', 'La Chorrera Cabecera', 'Calle 3ra, Barrio El Progreso, Casa 12', 
 'Panamá', 'Panamá', 'Obarrio', 'Av. Justo Arosemena, Edificio Torre de las Américas, Piso 20', 
 'Copa Airlines', 'Piloto', 'Universitario', 'Aviación Comercial', GETDATE(), 1),

-- Socio 6
(4, 'Laura', 'Isabel', 'Torres', 'Jiménez', 'A', 'CEDULA', '8-678-901', '223-9012', '6123-9012', '223-9013', 'laura.torres@email.com', 'F', '1988-12-03', 
 'Panamá', 'Tocumen', 'Tocumen', 'Calle 1ra, Residencial Los Ángeles, Casa 20', 
 'Panamá', 'Panamá', 'Punta Pacífica', 'Av. Balboa, Edificio Oceanía, Piso 18', 
 'Hospital Punta Pacífica', 'Enfermera', 'Universitario', 'Enfermería', GETDATE(), 1),

-- Socio 7
(5, 'Miguel', 'Ángel', 'Castro', 'Ruiz', 'A', 'CEDULA', '8-789-012', '223-0123', '6123-0123', '223-0124', 'miguel.castro@email.com', 'M', '1975-04-18', 
 'Panamá', 'Panamá', 'El Cangrejo', 'Calle 53, Edificio Torre del Mar, Apto 10A', 
 'Panamá', 'Panamá', 'El Cangrejo', 'Calle 50, Edificio Torre Global, Piso 25', 
 'Empresa Constructora ABC', 'Ingeniero Civil', 'Universitario', 'Ingeniería Civil', GETDATE(), 1),

-- Socio 8
(6, 'Carmen', 'Rosa', 'Mendoza', 'Flores', 'A', 'CEDULA', '8-890-123', '223-1234', '6123-1234', '223-1235', 'carmen.mendoza@email.com', 'F', '1965-08-25', 
 'Panamá', 'San Miguelito', 'Rufina Alfaro', 'Calle 4ta, Residencial Villa Esperanza, Casa 30', 
 'Panamá', 'Panamá', 'San Francisco', 'Av. Samuel Lewis, Edificio Plaza 2000, Piso 5', 
 'Banco Nacional', 'Pensionada', 'Universitario', 'Administración Bancaria', GETDATE(), 1)

GO

-- Verificar que los datos se insertaron correctamente
SELECT 
    a.NumeroAsociado,
    ta.TipoAsociado,
    a.Nombre + ' ' + ISNULL(a.SegundoNombre, '') + ' ' + a.Apellido + ' ' + ISNULL(a.SegundoApellido, '') AS NombreCompleto,
    a.Estatus,
    a.TipoIdentificacion + ': ' + a.NumeroIdentificacion AS Identificacion,
    a.FechaCreacion,
    a.FechaModificacion
FROM tbAsociados a
LEFT JOIN tbTipoAsociado ta ON a.IdTipoAsociado = ta.IdTipoAsociado
WHERE a.snEliminado = 0
ORDER BY a.NumeroAsociado DESC
GO

