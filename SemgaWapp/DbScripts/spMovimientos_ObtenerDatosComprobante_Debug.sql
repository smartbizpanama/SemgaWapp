-- Versión de debug del stored procedure para identificar el problema
CREATE OR ALTER PROCEDURE [dbo].[spMovimientos_ObtenerDatosComprobante_Debug]
    @MovimientoID INT
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Primero verificar si el movimiento existe
    IF NOT EXISTS (SELECT 1 FROM tbMovimientos WHERE IDMovimiento = @MovimientoID AND snEliminado = 0)
    BEGIN
        SELECT 'ERROR' AS Resultado, 'El movimiento no existe o está eliminado' AS Mensaje
        RETURN
    END
    
    -- Verificar cada relación paso a paso
    DECLARE @NumeroAsociado INT, @CodigoRubro VARCHAR(10), @IDAuxiliar INT, @CodigoTransaccion VARCHAR(10), @UsuarioCrea INT
    
    SELECT @NumeroAsociado = NumeroAsociado, 
           @CodigoRubro = CodigoRubro, 
           @IDAuxiliar = IDAuxiliar, 
           @CodigoTransaccion = CodigoTransaccion,
           @UsuarioCrea = UsuarioCrea
    FROM tbMovimientos 
    WHERE IDMovimiento = @MovimientoID
    
    -- Verificar asociado
    IF NOT EXISTS (SELECT 1 FROM tbAsociados WHERE NumeroAsociado = @NumeroAsociado)
    BEGIN
        SELECT 'ERROR' AS Resultado, 'No se encontró el asociado: ' + CAST(@NumeroAsociado AS VARCHAR) AS Mensaje
        RETURN
    END
    
    -- Verificar rubro
    IF NOT EXISTS (SELECT 1 FROM tbRubros WHERE CodigoRubro = @CodigoRubro)
    BEGIN
        SELECT 'ERROR' AS Resultado, 'No se encontró el rubro: ' + @CodigoRubro AS Mensaje
        RETURN
    END
    
    -- Verificar auxiliar
    IF NOT EXISTS (SELECT 1 FROM tbAuxiliares WHERE ID = @IDAuxiliar)
    BEGIN
        SELECT 'ERROR' AS Resultado, 'No se encontró el auxiliar: ' + CAST(@IDAuxiliar AS VARCHAR) AS Mensaje
        RETURN
    END
    
    -- Verificar tipo auxiliar
    DECLARE @TipoAuxiliar VARCHAR(10)
    SELECT @TipoAuxiliar = TipoAuxiliar FROM tbAuxiliares WHERE ID = @IDAuxiliar
    
    IF NOT EXISTS (SELECT 1 FROM tbTiposAuxiliares WHERE TipoAuxiliar = @TipoAuxiliar AND CodigoRubro = @CodigoRubro)
    BEGIN
        SELECT 'ERROR' AS Resultado, 'No se encontró el tipo auxiliar: ' + @TipoAuxiliar + ' para rubro: ' + @CodigoRubro AS Mensaje
        RETURN
    END
    
    -- Verificar código transacción
    IF NOT EXISTS (SELECT 1 FROM tbCodigosTransaccion WHERE CodigoTransaccion = @CodigoTransaccion AND CodigoRubro = @CodigoRubro)
    BEGIN
        SELECT 'ERROR' AS Resultado, 'No se encontró el código transacción: ' + @CodigoTransaccion + ' para rubro: ' + @CodigoRubro AS Mensaje
        RETURN
    END
    
    -- Verificar usuario
    IF NOT EXISTS (SELECT 1 FROM tbUsuarios WHERE Id = @UsuarioCrea)
    BEGIN
        SELECT 'ERROR' AS Resultado, 'No se encontró el usuario: ' + CAST(@UsuarioCrea AS VARCHAR) AS Mensaje
        RETURN
    END
    
    -- Si llegamos aquí, todos los datos existen, hacer la consulta completa
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












