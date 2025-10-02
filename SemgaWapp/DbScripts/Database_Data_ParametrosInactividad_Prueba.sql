-- Script para insertar parámetros de monitoreo de inactividad para PRUEBAS
-- Ejecutar después de crear la tabla tbParamsKeys

-- Verificar si los parámetros ya existen
IF NOT EXISTS (SELECT 1 FROM [dbo].[tbParamsKeys] WHERE [ParamKey] = 'MONITOREAR_INACTIVIDAD')
BEGIN
    -- Parámetro para habilitar/deshabilitar el monitoreo de inactividad
    INSERT INTO [dbo].[tbParamsKeys] ([ParamKey], [ParamDescription], [ParamGroup], [ParamValue])
    VALUES ('MONITOREAR_INACTIVIDAD', 'Habilita o deshabilita el monitoreo de inactividad del usuario. 1=Habilitado, 0=Deshabilitado', 'SEGURIDAD', '1');
    PRINT 'Parámetro MONITOREAR_INACTIVIDAD insertado';
END
ELSE
BEGIN
    PRINT 'Parámetro MONITOREAR_INACTIVIDAD ya existe';
END

IF NOT EXISTS (SELECT 1 FROM [dbo].[tbParamsKeys] WHERE [ParamKey] = 'TIEMPO_MONITOREAR_INACTIVIDAD')
BEGIN
    -- Parámetro para configurar el tiempo de monitoreo en minutos (1 minuto para pruebas)
    INSERT INTO [dbo].[tbParamsKeys] ([ParamKey], [ParamDescription], [ParamGroup], [ParamValue])
    VALUES ('TIEMPO_MONITOREAR_INACTIVIDAD', 'Tiempo en minutos antes de mostrar la alerta de inactividad. Valor por defecto: 5 minutos', 'SEGURIDAD', '1');
    PRINT 'Parámetro TIEMPO_MONITOREAR_INACTIVIDAD insertado';
END
ELSE
BEGIN
    PRINT 'Parámetro TIEMPO_MONITOREAR_INACTIVIDAD ya existe';
END

-- Verificar que los parámetros se insertaron correctamente
SELECT 
    ParamKey,
    ParamDescription,
    ParamGroup,
    ParamValue
FROM [dbo].[tbParamsKeys]
WHERE ParamKey IN ('MONITOREAR_INACTIVIDAD', 'TIEMPO_MONITOREAR_INACTIVIDAD')
ORDER BY ParamKey;

-- Mostrar mensaje de configuración
PRINT '========================================';
PRINT 'CONFIGURACIÓN DE PRUEBA:';
PRINT 'MONITOREAR_INACTIVIDAD = 1 (Habilitado)';
PRINT 'TIEMPO_MONITOREAR_INACTIVIDAD = 1 (1 minuto)';
PRINT '========================================';
PRINT 'IMPORTANTE: Después de ejecutar este script,';
PRINT 'reinicia la aplicación para que los parámetros';
PRINT 'se carguen en la sesión del usuario.';
PRINT '========================================';




