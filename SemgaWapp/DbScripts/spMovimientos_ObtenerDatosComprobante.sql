CREATE OR ALTER PROCEDURE [dbo].[spMovimientos_ObtenerDatosComprobante]
    @MovimientoID INT
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        right('000000000000' + cast(IDMovimiento as varchar(12)),12) AS ID,
        m.NumeroAsociado,
        s.Nombre + ' ' + s.Apellido AS NombreAsociado,
        m.CodigoRubro,
        r.Descripcion AS DescripcionRubro,
        m.IDAuxiliar,
        ta.Descripcion AS DescripcionTipoAuxiliar,
        right('000000000000' + cast(a.ID as varchar(12)),12) Cuenta,
        m.CodigoTransaccion,
        ct.Descripcion AS DescripcionTransaccion,
        m.FechaMovimiento,
        m.Monto,
        m.Saldo,
        m.Observaciones,
        u.Nombre AS UsuarioNombre,
        m.snImpreso
    FROM tbMovimientos m
    INNER JOIN tbAsociados s ON m.NumeroAsociado = s.NumeroAsociado
    INNER JOIN tbRubros r ON m.CodigoRubro = r.CodigoRubro
    INNER JOIN tbAuxiliares a ON m.IDAuxiliar = a.ID
    INNER JOIN tbTiposAuxiliares ta ON a.TipoAuxiliar = ta.TipoAuxiliar AND a.CodigoRubro = ta.CodigoRubro
    INNER JOIN tbCodigosTransaccion ct ON m.CodigoTransaccion = ct.CodigoTransaccion AND m.CodigoRubro = ct.CodigoRubro
    INNER JOIN tbUsuarios u ON m.UsuarioCrea = u.Id
    WHERE m.IDMovimiento = @MovimientoID
      AND m.snEliminado = 0;
END;
