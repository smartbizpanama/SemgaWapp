-- =============================================
-- Author: Sistema SemgaWapp
-- Create date: 2024
-- Description: Listar códigos de transacción con filtros
-- =============================================
CREATE PROCEDURE [dbo].[spCodigosTransaccion_Listar]
    @CodigoRubro VARCHAR(5) = NULL,
    @CodigoTransaccion VARCHAR(10) = NULL,
    @Descripcion NVARCHAR(150) = NULL,
    @SnActivo BIT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        ct.ID,
        ct.CodigoRubro,
        r.Descripcion AS DescripcionRubro,
        ct.CodigoTransaccion,
        ct.Descripcion,
        ct.DebCred,
        CASE 
            WHEN ct.DebCred = 'D' THEN 'Débito'
            WHEN ct.DebCred = 'C' THEN 'Crédito'
            ELSE 'N/A'
        END AS DescripcionDebCred,
        ct.CuentaContable,
        ct.ContraCuenta,
        ct.SnActivo,
        CASE 
            WHEN ct.SnActivo = 1 THEN 'Activo'
            ELSE 'Inactivo'
        END AS DescripcionEstado,
        ct.SnEliminado
    FROM tbCodigosTransaccion ct
    LEFT JOIN tbRubros r ON ct.CodigoRubro = r.CodigoRubro
    WHERE ct.SnEliminado = 0
        AND (@CodigoRubro IS NULL OR ct.CodigoRubro LIKE '%' + @CodigoRubro + '%')
        AND (@CodigoTransaccion IS NULL OR ct.CodigoTransaccion LIKE '%' + @CodigoTransaccion + '%')
        AND (@Descripcion IS NULL OR ct.Descripcion LIKE '%' + @Descripcion + '%')
        AND (@SnActivo IS NULL OR ct.SnActivo = @SnActivo)
    ORDER BY ct.CodigoRubro, ct.CodigoTransaccion;
END


