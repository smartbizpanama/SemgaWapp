USE [SegmaDB]
GO

-- =============================================
-- Datos de prueba para el módulo de Auxiliares
-- =============================================

-- Insertar rubros de prueba si no existen
IF NOT EXISTS (SELECT 1 FROM tbRubros WHERE CodigoRubro = 'AHOR')
BEGIN
    INSERT INTO tbRubros (CodigoRubro, Descripcion, snEliminado)
    VALUES ('AHOR', 'Ahorros', 0)
END

IF NOT EXISTS (SELECT 1 FROM tbRubros WHERE CodigoRubro = 'PERS')
BEGIN
    INSERT INTO tbRubros (CodigoRubro, Descripcion, snEliminado)
    VALUES ('PERS', 'Préstamos Personales', 0)
END

IF NOT EXISTS (SELECT 1 FROM tbRubros WHERE CodigoRubro = 'VIVI')
BEGIN
    INSERT INTO tbRubros (CodigoRubro, Descripcion, snEliminado)
    VALUES ('VIVI', 'Préstamos de Vivienda', 0)
END

IF NOT EXISTS (SELECT 1 FROM tbRubros WHERE CodigoRubro = 'AUTO')
BEGIN
    INSERT INTO tbRubros (CodigoRubro, Descripcion, snEliminado)
    VALUES ('AUTO', 'Préstamos de Vehículos', 0)
END

-- Insertar tipos de auxiliares de prueba si no existen
IF NOT EXISTS (SELECT 1 FROM tbTiposAuxiliares WHERE CodigoRubro = 'AHOR' AND TipoAuxiliar = 1)
BEGIN
    INSERT INTO tbTiposAuxiliares (CodigoRubro, TipoAuxiliar, Descripcion, Tasa, Plazo, MontoMaximo, MontoMinimo, PorManejo, PorCapitalizacion, PorProteccion, snEliminado)
    VALUES ('AHOR', 1, 'Ahorro Regular', 0.50, 0, 999999999.99, 10.00, 0.00, 0.00, 0.00, 0)
END

IF NOT EXISTS (SELECT 1 FROM tbTiposAuxiliares WHERE CodigoRubro = 'AHOR' AND TipoAuxiliar = 2)
BEGIN
    INSERT INTO tbTiposAuxiliares (CodigoRubro, TipoAuxiliar, Descripcion, Tasa, Plazo, MontoMaximo, MontoMinimo, PorManejo, PorCapitalizacion, PorProteccion, snEliminado)
    VALUES ('AHOR', 2, 'Ahorro a Plazo Fijo', 2.50, 12, 999999999.99, 100.00, 0.00, 0.00, 0.00, 0)
END

IF NOT EXISTS (SELECT 1 FROM tbTiposAuxiliares WHERE CodigoRubro = 'PERS' AND TipoAuxiliar = 1)
BEGIN
    INSERT INTO tbTiposAuxiliares (CodigoRubro, TipoAuxiliar, Descripcion, Tasa, Plazo, MontoMaximo, MontoMinimo, PorManejo, PorCapitalizacion, PorProteccion, snEliminado)
    VALUES ('PERS', 1, 'Préstamo Personal Estándar', 12.00, 24, 50000.00, 1000.00, 2.00, 0.00, 1.00, 0)
END

IF NOT EXISTS (SELECT 1 FROM tbTiposAuxiliares WHERE CodigoRubro = 'PERS' AND TipoAuxiliar = 2)
BEGIN
    INSERT INTO tbTiposAuxiliares (CodigoRubro, TipoAuxiliar, Descripcion, Tasa, Plazo, MontoMaximo, MontoMinimo, PorManejo, PorCapitalizacion, PorProteccion, snEliminado)
    VALUES ('PERS', 2, 'Préstamo Personal Express', 15.00, 12, 25000.00, 500.00, 3.00, 0.00, 1.50, 0)
END

IF NOT EXISTS (SELECT 1 FROM tbTiposAuxiliares WHERE CodigoRubro = 'VIVI' AND TipoAuxiliar = 1)
BEGIN
    INSERT INTO tbTiposAuxiliares (CodigoRubro, TipoAuxiliar, Descripcion, Tasa, Plazo, MontoMaximo, MontoMinimo, PorManejo, PorCapitalizacion, PorProteccion, snEliminado)
    VALUES ('VIVI', 1, 'Préstamo de Vivienda Social', 8.50, 180, 80000.00, 10000.00, 1.50, 0.00, 2.00, 0)
END

IF NOT EXISTS (SELECT 1 FROM tbTiposAuxiliares WHERE CodigoRubro = 'VIVI' AND TipoAuxiliar = 2)
BEGIN
    INSERT INTO tbTiposAuxiliares (CodigoRubro, TipoAuxiliar, Descripcion, Tasa, Plazo, MontoMaximo, MontoMinimo, PorManejo, PorCapitalizacion, PorProteccion, snEliminado)
    VALUES ('VIVI', 2, 'Préstamo de Vivienda Comercial', 10.00, 240, 150000.00, 20000.00, 2.00, 0.00, 2.50, 0)
END

IF NOT EXISTS (SELECT 1 FROM tbTiposAuxiliares WHERE CodigoRubro = 'AUTO' AND TipoAuxiliar = 1)
BEGIN
    INSERT INTO tbTiposAuxiliares (CodigoRubro, TipoAuxiliar, Descripcion, Tasa, Plazo, MontoMaximo, MontoMinimo, PorManejo, PorCapitalizacion, PorProteccion, snEliminado)
    VALUES ('AUTO', 1, 'Préstamo de Vehículo Nuevo', 9.50, 60, 30000.00, 5000.00, 1.00, 0.00, 1.50, 0)
END

IF NOT EXISTS (SELECT 1 FROM tbTiposAuxiliares WHERE CodigoRubro = 'AUTO' AND TipoAuxiliar = 2)
BEGIN
    INSERT INTO tbTiposAuxiliares (CodigoRubro, TipoAuxiliar, Descripcion, Tasa, Plazo, MontoMaximo, MontoMinimo, PorManejo, PorCapitalizacion, PorProteccion, snEliminado)
    VALUES ('AUTO', 2, 'Préstamo de Vehículo Usado', 11.00, 48, 20000.00, 3000.00, 1.50, 0.00, 2.00, 0)
END

-- Insertar tipos de asociado si no existen
IF NOT EXISTS (SELECT 1 FROM tbTipoAsociado WHERE IdTipoAsociado = 1)
BEGIN
    INSERT INTO tbTipoAsociado (IdTipoAsociado, TipoAsociado)
    VALUES (1, 'Cliente')
END

IF NOT EXISTS (SELECT 1 FROM tbTipoAsociado WHERE IdTipoAsociado = 2)
BEGIN
    INSERT INTO tbTipoAsociado (IdTipoAsociado, TipoAsociado)
    VALUES (2, 'Proveedor')
END

-- Insertar algunos asociados de prueba si no existen
IF NOT EXISTS (SELECT 1 FROM tbAsociados WHERE NumeroAsociado = 1001)
BEGIN
    INSERT INTO tbAsociados (
        IdTipoAsociado, Nombre, Apellido, Estatus, TipoIdentificacion, NumeroIdentificacion,
        TelefonoCelular, CorreoElectronico, Sexo, FechaNacimiento, 
        ProvinciaResidencia, DireccionResidencia, FechaCreacion, UsuarioCrea, snEliminado
    )
    VALUES (
        1, 'Juan Carlos', 'Pérez González', 'A', 'CED', '123456789',
        '5555-1234', 'juan.perez@email.com', 'M', '1985-03-15',
        'Panamá', 'Av. Central 123', GETDATE(), 1, 0
    )
END

IF NOT EXISTS (SELECT 1 FROM tbAsociados WHERE NumeroAsociado = 1002)
BEGIN
    INSERT INTO tbAsociados (
        IdTipoAsociado, Nombre, Apellido, Estatus, TipoIdentificacion, NumeroIdentificacion,
        TelefonoCelular, CorreoElectronico, Sexo, FechaNacimiento, 
        ProvinciaResidencia, DireccionResidencia, FechaCreacion, UsuarioCrea, snEliminado
    )
    VALUES (
        1, 'María Elena', 'Rodríguez López', 'A', 'CED', '987654321',
        '5555-5678', 'maria.rodriguez@email.com', 'F', '1990-07-22',
        'Panamá', 'Calle 50 456', GETDATE(), 1, 0
    )
END

IF NOT EXISTS (SELECT 1 FROM tbAsociados WHERE NumeroAsociado = 1003)
BEGIN
    INSERT INTO tbAsociados (
        IdTipoAsociado, Nombre, Apellido, Estatus, TipoIdentificacion, NumeroIdentificacion,
        TelefonoCelular, CorreoElectronico, Sexo, FechaNacimiento, 
        ProvinciaResidencia, DireccionResidencia, FechaCreacion, UsuarioCrea, snEliminado
    )
    VALUES (
        2, 'Carlos Alberto', 'García Morales', 'A', 'CED', '456789123',
        '5555-9012', 'carlos.garcia@email.com', 'M', '1988-11-10',
        'Colón', 'Av. Bolívar 789', GETDATE(), 1, 0
    )
END

-- Insertar algunos auxiliares de prueba si no existen
IF NOT EXISTS (SELECT 1 FROM tbAuxiliares WHERE ID = 1 AND NumeroAsociado = 1001)
BEGIN
    INSERT INTO tbAuxiliares (
        ID, NumeroAsociado, CodigoRubro, TipoAuxiliar, Cuota, Saldo, MontoOriginal,
        FechaOtorgado, TasaInteres, PagoMes, FechaCreacion, UsuarioCrea, snEliminado
    )
    VALUES (
        1, 1001, 'AHOR', 1, 0.00, 2500.00, 2500.00,
        '2024-01-15', 0.50, 0.00, GETDATE(), 1, 0
    )
END

IF NOT EXISTS (SELECT 1 FROM tbAuxiliares WHERE ID = 2 AND NumeroAsociado = 1002)
BEGIN
    INSERT INTO tbAuxiliares (
        ID, NumeroAsociado, CodigoRubro, TipoAuxiliar, Cuota, Saldo, MontoOriginal,
        FechaOtorgado, TasaInteres, PagoMes, FechaCreacion, UsuarioCrea, snEliminado
    )
    VALUES (
        2, 1002, 'PERS', 1, 450.00, 8500.00, 10000.00,
        '2024-02-01', 12.00, 450.00, GETDATE(), 1, 0
    )
END

IF NOT EXISTS (SELECT 1 FROM tbAuxiliares WHERE ID = 3 AND NumeroAsociado = 1003)
BEGIN
    INSERT INTO tbAuxiliares (
        ID, NumeroAsociado, CodigoRubro, TipoAuxiliar, Cuota, Saldo, MontoOriginal,
        FechaOtorgado, TasaInteres, PagoMes, FechaCreacion, UsuarioCrea, snEliminado
    )
    VALUES (
        3, 1003, 'VIVI', 1, 1200.00, 65000.00, 70000.00,
        '2024-03-10', 8.50, 1200.00, GETDATE(), 1, 0
    )
END

PRINT 'Datos de prueba para auxiliares insertados correctamente'
GO

