-- =============================================
-- Script para insertar parámetros de inactividad
-- =============================================

-- Verificar si la tabla tbParamsKeys existe
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'tbParamsKeys')
BEGIN
    PRINT 'ERROR: La tabla tbParamsKeys no existe. Ejecute primero el script de creación de esquema.';
    RETURN;
END

-- Insertar parámetro MONITOREAR_INACTIVIDAD
IF NOT EXISTS (SELECT 1 FROM [dbo].[tbParamsKeys] WHERE [ParamKey] = 'MONITOREAR_INACTIVIDAD')
BEGIN
    INSERT INTO [dbo].[tbParamsKeys] ([ParamKey], [ParamDescription], [ParamCategory], [ParamValue])
    VALUES ('MONITOREAR_INACTIVIDAD', 'Habilita o deshabilita el monitoreo de inactividad del usuario. 1=Habilitado, 0=Deshabilitado', 'SEGURIDAD', '1');
    PRINT 'Parámetro MONITOREAR_INACTIVIDAD insertado exitosamente';
END
ELSE
BEGIN
    PRINT 'Parámetro MONITOREAR_INACTIVIDAD ya existe';
END

-- Insertar parámetro TIEMPO_MONITOREAR_INACTIVIDAD
IF NOT EXISTS (SELECT 1 FROM [dbo].[tbParamsKeys] WHERE [ParamKey] = 'TIEMPO_MONITOREAR_INACTIVIDAD')
BEGIN
    INSERT INTO [dbo].[tbParamsKeys] ([ParamKey], [ParamDescription], [ParamCategory], [ParamValue])
    VALUES ('TIEMPO_MONITOREAR_INACTIVIDAD', 'Tiempo en minutos antes de mostrar la alerta de inactividad. Valor por defecto: 5 minutos', 'SEGURIDAD', '5');
    PRINT 'Parámetro TIEMPO_MONITOREAR_INACTIVIDAD insertado exitosamente';
END
ELSE
BEGIN
    PRINT 'Parámetro TIEMPO_MONITOREAR_INACTIVIDAD ya existe';
END

-- Mostrar los parámetros insertados
SELECT 
    ParamKey,
    ParamValue,
    ParamDescription,
    ParamCategory
FROM [dbo].[tbParamsKeys]
WHERE ParamKey IN ('MONITOREAR_INACTIVIDAD', 'TIEMPO_MONITOREAR_INACTIVIDAD')
ORDER BY ParamKey;

PRINT 'Script ejecutado exitosamente. Los parámetros de inactividad están configurados.';













