CREATE OR ALTER PROCEDURE [dbo].[spMovimientos_MarcarImpreso]
    @MovimientoID INT
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @FilasAfectadas INT = 0;
    
    UPDATE tbMovimientos 
    SET snImpreso = 1
    WHERE IDMovimiento = @MovimientoID;
    
    SET @FilasAfectadas = @@ROWCOUNT;
    
    -- Retornar el resultado en una tabla
    SELECT @FilasAfectadas AS FilasAfectadas;
END;
