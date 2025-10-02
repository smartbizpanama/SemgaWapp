-- Script para insertar datos de prueba en tbTiposAuxiliares
-- Asegúrate de que la tabla tbRubros tenga datos primero

-- Verificar que existan rubros
IF NOT EXISTS (SELECT 1 FROM tbRubros WHERE CodigoRubro = 'AH')
BEGIN
    INSERT INTO tbRubros (CodigoRubro, Descripcion, snEliminado) 
    VALUES ('AH', 'AHORRO', 0)
END

IF NOT EXISTS (SELECT 1 FROM tbRubros WHERE CodigoRubro = 'AP')
BEGIN
    INSERT INTO tbRubros (CodigoRubro, Descripcion, snEliminado) 
    VALUES ('AP', 'APORTE', 0)
END

-- Insertar datos de prueba en tbTiposAuxiliares
IF NOT EXISTS (SELECT 1 FROM tbTiposAuxiliares WHERE CodigoRubro = 'AH' AND TipoAuxiliar = 1)
BEGIN
    INSERT INTO tbTiposAuxiliares (
        CodigoRubro, TipoAuxiliar, Descripcion, Tasa, Plazo, 
        MontoMaximo, MontoMinimo, PorManejo, PorCapitalizacion, PorProteccion, snEliminado
    ) VALUES (
        'AH', 1, 'Ahorro Corriente', 5.00, 12, 
        100.00, 10.00, 0.50, 0.25, 0.10, 0
    )
END

IF NOT EXISTS (SELECT 1 FROM tbTiposAuxiliares WHERE CodigoRubro = 'AH' AND TipoAuxiliar = 2)
BEGIN
    INSERT INTO tbTiposAuxiliares (
        CodigoRubro, TipoAuxiliar, Descripcion, Tasa, Plazo, 
        MontoMaximo, MontoMinimo, PorManejo, PorCapitalizacion, PorProteccion, snEliminado
    ) VALUES (
        'AH', 2, 'Ahorro a Plazo Fijo', 7.50, 24, 
        500.00, 50.00, 0.75, 0.50, 0.15, 0
    )
END

IF NOT EXISTS (SELECT 1 FROM tbTiposAuxiliares WHERE CodigoRubro = 'AP' AND TipoAuxiliar = 1)
BEGIN
    INSERT INTO tbTiposAuxiliares (
        CodigoRubro, TipoAuxiliar, Descripcion, Tasa, Plazo, 
        MontoMaximo, MontoMinimo, PorManejo, PorCapitalizacion, PorProteccion, snEliminado
    ) VALUES (
        'AP', 1, 'Aporte Social', 0.00, 0, 
        1000.00, 100.00, 0.00, 0.00, 0.00, 0
    )
END

-- Mostrar los datos insertados
SELECT 
    ta.ID,
    ta.CodigoRubro,
    r.Descripcion AS RubroDescripcion,
    ta.TipoAuxiliar,
    ta.Descripcion,
    ta.Tasa,
    ta.Plazo,
    ta.MontoMaximo,
    ta.MontoMinimo,
    ta.PorManejo,
    ta.PorCapitalizacion,
    ta.PorProteccion,
    ta.snEliminado
FROM tbTiposAuxiliares ta
INNER JOIN tbRubros r ON ta.CodigoRubro = r.CodigoRubro
WHERE ta.snEliminado = 0
ORDER BY ta.CodigoRubro, ta.TipoAuxiliar;

