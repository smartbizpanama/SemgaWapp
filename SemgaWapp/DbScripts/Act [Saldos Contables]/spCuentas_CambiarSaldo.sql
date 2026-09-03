-- ============================================================
-- spCuentas_CambiarSaldo - SemgaWapp (Cooperativa Coopsemga)
-- Cambia el saldo de una cuenta y registra el cambio en
-- tbCuentas_LogSaldos. Devuelve columnas Resultado/Mensaje.
-- Requiere: tbCuentas, tbCuentas_LogSaldos
-- ============================================================
CREATE OR ALTER PROCEDURE dbo.spCuentas_CambiarSaldo
    @ID         INT,
    @NuevoSaldo NUMERIC(18, 2),
    @UsuarioID         INT,
    @SysLastSessionID  NVARCHAR(50) = NULL,
    @Motivo            NVARCHAR(500) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- Validaciones
        IF @ID IS NULL OR @ID <= 0
        BEGIN
            SELECT 'ERROR' AS Resultado, 'La cuenta indicada no es válida.' AS Mensaje;
            RETURN;
        END

        DECLARE @SaldoAnterior NUMERIC(18, 2);
        DECLARE @Cuenta VARCHAR(50);

        SELECT @SaldoAnterior = [Saldo], @Cuenta = [Cuenta]
        FROM dbo.tbCuentas
        WHERE [ID] = @ID
          ;

        IF @@ROWCOUNT = 0
        BEGIN
            SELECT 'ERROR' AS Resultado, 'No se encontró la cuenta.' AS Mensaje;
            RETURN;
        END

        BEGIN TRANSACTION;

            -- Actualizar saldo y auditoría de la cuenta
            UPDATE dbo.tbCuentas
            SET [Saldo]             = @NuevoSaldo,
                [FechaModificacion] = GETDATE(),
                [UsuarioModifica]   = @UsuarioID,
                [SysLastSessionID]  = @SysLastSessionID
            WHERE [ID] = @ID;

            -- Registrar log del cambio
            INSERT INTO dbo.tbCuentas_LogSaldos
                ([IDCuenta], [Cuenta], [SaldoAnterior], [SaldoNuevo], [FechaHoraModificacion], [Usuario], [Motivo], [SysLastSessionID])
            VALUES
                (@ID, @Cuenta, @SaldoAnterior, @NuevoSaldo, GETDATE(), @UsuarioID, @Motivo, @SysLastSessionID);

        COMMIT TRANSACTION;

        SELECT 'SUCCESS' AS Resultado, 'Saldo actualizado correctamente.' AS Mensaje;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        SELECT 'ERROR' AS Resultado, ERROR_MESSAGE() AS Mensaje;
    END CATCH
END
GO
