-- =============================================
-- Script: Actualizar registros existentes para usar IDs de ocupaciones
-- Descripción: Cambiar los registros de tbAsociados para usar IDs en lugar de Codes
-- Fecha: 2024
-- =============================================

-- Verificar el estado actual
SELECT 'Estado actual de ocupaciones en tbAsociados:' as Mensaje
SELECT NumeroAsociado, Ocupacion FROM tbAsociados WHERE snEliminado = 0

-- Actualizar todos los registros para usar ID 1 (Ingeniero de Sistemas)
UPDATE tbAsociados 
SET Ocupacion = 1 
WHERE snEliminado = 0

PRINT '✅ Todos los registros actualizados para usar ID 1 (Ingeniero de Sistemas)'
GO

-- Verificar el cambio
SELECT 'Estado final de ocupaciones en tbAsociados:' as Mensaje
SELECT NumeroAsociado, Ocupacion FROM tbAsociados WHERE snEliminado = 0

-- Verificar que los JOINs funcionen correctamente
SELECT 'Verificación de JOINs:' as Mensaje
SELECT 
    a.NumeroAsociado,
    a.Ocupacion,
    o.Descripcion as OcupacionDescripcion
FROM tbAsociados a
LEFT JOIN tbOcupaciones o ON a.Ocupacion = o.ID AND o.snEliminado = 0
WHERE a.snEliminado = 0

