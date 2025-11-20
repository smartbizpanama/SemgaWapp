-- =============================================
-- Author: Sistema SemgaWapp
-- Create date: 2025-01-16
-- Description: Agregar campo ContraCuenta a la tabla tbCodigosTransaccion
-- =============================================

-- Verificar si la columna ya existe antes de agregarla
IF NOT EXISTS (
    SELECT 1 
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_NAME = 'tbCodigosTransaccion' 
    AND COLUMN_NAME = 'ContraCuenta'
)
BEGIN
    -- Agregar la columna ContraCuenta
    ALTER TABLE tbCodigosTransaccion 
    ADD ContraCuenta VARCHAR(50) NULL;
    
    PRINT 'Campo ContraCuenta agregado exitosamente a tbCodigosTransaccion';
END
ELSE
BEGIN
    PRINT 'El campo ContraCuenta ya existe en tbCodigosTransaccion';
END







