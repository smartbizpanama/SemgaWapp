-- Script para insertar parámetros de monitoreo de inactividad
-- Ejecutar después de crear la tabla tbParamsKeys

-- Parámetro para habilitar/deshabilitar el monitoreo de inactividad
INSERT INTO [dbo].[tbParamsKeys] ([ParamKey], [ParamDescription], [ParamGroup], [ParamValue])
VALUES ('MONITOREAR_INACTIVIDAD', 'Habilita o deshabilita el monitoreo de inactividad del usuario. 1=Habilitado, 0=Deshabilitado', 'SEGURIDAD', '1');

-- Parámetro para configurar el tiempo de monitoreo en minutos
INSERT INTO [dbo].[tbParamsKeys] ([ParamKey], [ParamDescription], [ParamGroup], [ParamValue])
VALUES ('TIEMPO_MONITOREAR_INACTIVIDAD', 'Tiempo en minutos antes de mostrar la alerta de inactividad. Valor por defecto: 5 minutos', 'SEGURIDAD', '5');

-- Verificar que los parámetros se insertaron correctamente
SELECT 
    ParamKey,
    ParamDescription,
    ParamGroup,
    ParamValue
FROM [dbo].[tbParamsKeys]
WHERE ParamKey IN ('MONITOREAR_INACTIVIDAD', 'TIEMPO_MONITOREAR_INACTIVIDAD')
ORDER BY ParamKey;




