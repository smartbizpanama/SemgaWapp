-- =============================================
-- Author: Sistema SemgaWapp
-- Create date: 2024
-- Description: Guardar movimiento de transacción
-- =============================================
CREATE OR ALTER PROCEDURE spMovimientos_GuardarMovimiento
    @NumeroAsociado INT,
    @CodigoRubro VARCHAR(10),
    @IDAuxiliar INT,
    @Cuenta VARCHAR(15),
    @CodigoTransaccion VARCHAR(10),
    @FechaMovimiento DATE,
    @Monto DECIMAL(18,2),
    @DebCred CHAR(1),
    @Saldo DECIMAL(18,2),
    @Observaciones VARCHAR(500) = NULL,
    @UsuarioID INT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION;
        
        -- Insertar el movimiento
        INSERT INTO tbMovimientos (
            NumeroAsociado,
            CodigoRubro,
            IDAuxiliar,
            Cuenta,
            CodigoTransaccion,
            FechaMovimiento,
            Monto,
            DebCred,
            Saldo,
            Observaciones,
            UsuarioCrea,
            FechaCrea,
            snEliminado
        )
        VALUES (
            @NumeroAsociado,
            @CodigoRubro,
            @IDAuxiliar,
            @Cuenta,
            @CodigoTransaccion,
            @FechaMovimiento,
            @Monto,
            @DebCred,
            @Saldo,
            @Observaciones,
            @UsuarioID,
            GETDATE(),
            0
        );
        
        -- Obtener el ID del movimiento insertado
        DECLARE @MovimientoID INT = SCOPE_IDENTITY();
        
        -- Retornar resultado exitoso
        SELECT 
            'SUCCESS' AS Resultado,
            'Movimiento guardado exitosamente' AS Mensaje,
            @MovimientoID AS MovimientoID;
            
        COMMIT TRANSACTION;
        
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
            
        -- Retornar error
        SELECT 
            'ERROR' AS Resultado,
            ERROR_MESSAGE() AS Mensaje,
            NULL AS MovimientoID;
    END CATCH
END
