-- Referencia: definición del SP spMovimientos_GuardarMovimiento.
-- Ya no se invoca desde la aplicación; el guardado se hace solo vía spMovimientos_GuardarLote.
-- Este SP sigue siendo usado internamente por spMovimientos_GuardarLote desde la base de datos.

ALTER PROCEDURE [dbo].[spMovimientos_GuardarMovimiento]
    @NumeroAsociado INT,
    @CodigoRubro VARCHAR(10),
    @IDAuxiliar INT,
    @CodigoTransaccion VARCHAR(10),
    @Monto DECIMAL(18,2),
    @UsuarioID INT,
    @Observaciones VARCHAR(500) = NULL,
    @BaseID int = NULL,
    @BaseType nvarchar(100) = NULL,
    @MensajeVal NVARCHAR(MAX) OUTPUT,
    @MovimientoID_Capital int OUTPUT,
    @MovimientoID_Interes int OUTPUT
    
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    ---------------------------------------------------------
    -- CONTROL DE TRANSACCIÓN
    ---------------------------------------------------------
    DECLARE @TransaccionPropia BIT = 0;

    IF @@TRANCOUNT = 0
    BEGIN
        SET @TransaccionPropia = 1;
        BEGIN TRANSACTION;
    END

    ---------------------------------------------------------
    -- VARIABLES GENERALES
    ---------------------------------------------------------
    DECLARE @EsValido BIT;
    DECLARE @MensajeAsiento VARCHAR(500) = '';
    DECLARE @ReturnMessage VARCHAR(MAX) = '';
    DECLARE @InteresPendiente NUMERIC(19,6) = 0;
    DECLARE @SaldoActual NUMERIC(19,6);
    DECLARE @NuevoSaldo NUMERIC(19,6);
    DECLARE @MontoInteres NUMERIC(19,6) = 0; 
    DECLARE @MontoCapital NUMERIC(19,6) = 0;
    DECLARE @DebCred VARCHAR(1) = '';

    DECLARE @Resultado VARCHAR(20) = 'SUCCESS';
    DECLARE @Mensaje   NVARCHAR(MAX) = '';
    DECLARE @Tipoauxiliar BIT = 0; --javier
    SET @MensajeVal = NULL;
    SET @Observaciones = ISNULL(@Observaciones,'');
    SET @MovimientoID_Interes = 0;
    SET @MovimientoID_Capital = 0;

    BEGIN TRY
        -------------------------------------------------------------------
        -- PASO 1: Validación del movimiento
        -------------------------------------------------------------------
        EXEC [dbo].[spMovimiento_Validar]
            @NumeroAsociado     = @NumeroAsociado,
            @CodigoRubro        = @CodigoRubro,
            @IDAuxiliar         = @IDAuxiliar,
            @CodigoTransaccion  = @CodigoTransaccion,
            @Monto              = @Monto,
            @Resultado          = @EsValido OUTPUT,
            @Mensaje            = @MensajeVal OUTPUT,
            @DebCred            = @DebCred OUTPUT; --javier;

        IF (@EsValido = 0)
        BEGIN
            SET @Resultado = 'ERROR';
            SET @Mensaje   = @MensajeVal;

            IF @TransaccionPropia = 1 AND @@TRANCOUNT > 0 ROLLBACK;

            IF @TransaccionPropia = 1
            BEGIN

                SELECT @Resultado AS Resultado,
                       @Mensaje   AS Mensaje,
                       NULL       AS CapitalMovimientoID,
                       NULL       AS InteresesMovimientoID;
            END;
            RETURN;
        END

        -------------------------------------------------------------------
        -- PASO 2: Si es préstamo, calcular intereses
        -------------------------------------------------------------------
        IF @CodigoRubro = 'PR'
        BEGIN
            EXEC [dbo].[spAuxiliares_CalcularIntereses]
                @NumeroAsociado = @NumeroAsociado,
                @UsuarioID      = @UsuarioID,
                @IdAuxiliar     = @IDAuxiliar,
                @ReturnMessage  = @ReturnMessage OUTPUT;

            IF (@ReturnMessage IS NOT NULL AND @ReturnMessage <> '')
            BEGIN
                SET @Resultado   = 'ERROR';
                SET @Mensaje     = @ReturnMessage;
                SET @MensajeVal  = @ReturnMessage;

                IF @TransaccionPropia = 1 AND @@TRANCOUNT > 0 ROLLBACK;
                
                IF @TransaccionPropia = 1
                BEGIN
                    SELECT @Resultado AS Resultado,
                           @Mensaje   AS Mensaje,
                           NULL       AS CapitalMovimientoID,
                           NULL       AS InteresesMovimientoID;
                END;

                RETURN;
            END

            SELECT @InteresPendiente = ISNULL(InteresCalculado,0) - ISNULL(InteresPagado,0),
                   @SaldoActual      = Saldo,
                   @Tipoauxiliar     = TipoAuxiliar
            FROM dbo.tbAuxiliares
            WHERE ID = @IDAuxiliar;
        END
        ELSE
        BEGIN
            SELECT @SaldoActual = Saldo,
            @Tipoauxiliar = tipoauxiliar
            FROM dbo.tbAuxiliares
            WHERE ID = @IDAuxiliar;
        END

        -------------------------------------------------------------------
        -- PASO 3: LÓGICA DE MOVIMIENTOS (DENTRO DE LA TRANSACCIÓN)
        -------------------------------------------------------------------
        IF @CodigoRubro = 'PR' AND @InteresPendiente > 0
        BEGIN
            -- Pago a intereses
            SET @MontoInteres = IIF(@Monto >= @InteresPendiente, @InteresPendiente, @Monto);
            SET @MontoCapital = @Monto - isnull(@MontoInteres,0);

            -- Nuevo saldo (no cambia por intereses)
            SET @NuevoSaldo = @SaldoActual;

            -- Consecutivo e inserción movimiento intereses
            UPDATE dbo.tbControlConsecutivos
            SET @MovimientoID_Interes = UltimoConsecutivo + 1,
                UltimoConsecutivo    = UltimoConsecutivo + 1
            WHERE Tabla = 'tbMovimientos';

            INSERT INTO dbo.tbMovimientos (
                IDMovimiento, NumeroAsociado, CodigoRubro, IDAuxiliar, CodigoTransaccion,
                FechaMovimiento, FechaCreacion, Monto, Saldo, Observaciones,
                UsuarioCrea, snEliminado, Tipoauxiliar, Ref1, Ref2
            )
            VALUES (
                @MovimientoID_Interes, @NumeroAsociado, @CodigoRubro, @IDAuxiliar, 'PRPIN',
                GETDATE(), GETDATE(), @MontoInteres, @NuevoSaldo, ISNULL(@Observaciones,'Pago de intereses'),
                @UsuarioID, 0,@Tipoauxiliar, convert(nvarchar(max),@BaseID), @BaseType
            );

            EXEC spMovimientos_GuardarAsiento 
                    @CodigoTransaccion = 'PRPIN', 
                    @Monto             = @MontoInteres,
                    @Observaciones     = 'Pago de intereses', 
                    @CodTipoAsiento    = 'TRA',
                    @MovimientoID      = @MovimientoID_Interes,
                    @BaseID            = @BaseID,
                    @BaseType          = @BaseType,
                    @Mensaje           = @MensajeAsiento OUTPUT;

            IF @MensajeAsiento <> ''
            BEGIN
                SET @Resultado  = 'ERROR';
                SET @Mensaje    = 'Error al contabilizar: ' + @MensajeAsiento;
                SET @MensajeVal = @MensajeAsiento;

                IF @TransaccionPropia = 1 AND @@TRANCOUNT > 0 ROLLBACK;
                
                IF @TransaccionPropia = 1
                BEGIN
                    SELECT @Resultado AS Resultado,
                           @Mensaje   AS Mensaje,
                           NULL       AS CapitalMovimientoID,
                           NULL       AS InteresesMovimientoID;
                END;

                RETURN;
            END

            -- Actualizar auxiliar: intereses pagados
            UPDATE dbo.tbAuxiliares WITH (UPDLOCK, HOLDLOCK)
            SET InteresPagado  = ISNULL(InteresPagado,0) + @MontoInteres,
                FechaUltimoPago = GETDATE()
            WHERE ID = @IDAuxiliar;

            -- Si sobra dinero, pago a capital
            IF isnull(@MontoCapital,0) > 0
            BEGIN
                SET @NuevoSaldo = @SaldoActual + (isnull(@MontoCapital,0) * IIF(@DebCred='C',-1,1));

                UPDATE dbo.tbControlConsecutivos
                SET @MovimientoID_Capital = UltimoConsecutivo + 1,
                    UltimoConsecutivo    = UltimoConsecutivo + 1
                WHERE Tabla = 'tbMovimientos';

                INSERT INTO dbo.tbMovimientos (
                    IDMovimiento, NumeroAsociado, CodigoRubro, IDAuxiliar, CodigoTransaccion,
                    FechaMovimiento, FechaCreacion, IDMovIntereses, Monto, Saldo, Observaciones,
                    UsuarioCrea, snEliminado,Tipoauxiliar, Ref1, Ref2
                )
                VALUES (
                    @MovimientoID_Capital, @NumeroAsociado, @CodigoRubro, @IDAuxiliar, @CodigoTransaccion,
                    GETDATE(), GETDATE(), @MovimientoID_Interes, @MontoCapital, @NuevoSaldo, ISNULL(@Observaciones,'Pago a capital'),
                    @UsuarioID, 0,@Tipoauxiliar, convert(nvarchar(max),@BaseID), @BaseType
                );

                EXEC spMovimientos_GuardarAsiento 
                        @CodigoTransaccion = @CodigoTransaccion, 
                        @Monto             = @MontoCapital,
                        @Observaciones     = @Observaciones, 
                        @CodTipoAsiento    = 'TRA',
                        @MovimientoID      = @MovimientoID_Capital, 
                        @Mensaje           = @MensajeAsiento OUTPUT;

                IF @MensajeAsiento <> ''
                BEGIN
                    SET @Resultado  = 'ERROR';
                    SET @Mensaje    = 'Error al contabilizar: ' + @MensajeAsiento;
                    SET @MensajeVal = @MensajeAsiento;

                    IF @TransaccionPropia = 1 AND @@TRANCOUNT > 0 ROLLBACK;

                    IF @TransaccionPropia = 1
                    BEGIN
                        SELECT @Resultado AS Resultado,
                               @Mensaje   AS Mensaje,
                               NULL       AS CapitalMovimientoID,
                               NULL       AS InteresesMovimientoID;
                    END;

                    RETURN;
                END

                UPDATE dbo.tbAuxiliares
                SET Saldo          = @NuevoSaldo,
                    FechaUltimoPago = GETDATE()
                WHERE ID = @IDAuxiliar;
            END
        END
        ELSE
        BEGIN
            -- Movimiento normal
            begin --javier
                if @CodigoRubro = 'CP' 
                  BEGIN
                  --  SET @NuevoSaldo   = @SaldoActual + (@Monto * IIF(@CodigoTransaccion='C',1,-1));--JAVIER
                  SET @NuevoSaldo   = @SaldoActual + (@Monto * IIF(@DebCred='C',1,-1));
                  END;
                else if  @CodigoRubro = 'PR'
                   begin
                      SET @NuevoSaldo   = @SaldoActual + (@Monto * IIF(@DebCred='D',1,-1));
                   END
                else
                  BEGIN
                    --SET @NuevoSaldo   = @SaldoActual + (@Monto * IIF(@CodigoTransaccion='D',-1,1));--JAVIER
                    SET @NuevoSaldo   = @SaldoActual + (@Monto * IIF(@DebCred='D',-1,1));
                END;
            end; --javier
            SET @MontoCapital = @Monto;

            UPDATE dbo.tbControlConsecutivos
            SET @MovimientoID_Capital = UltimoConsecutivo + 1,
                UltimoConsecutivo    = UltimoConsecutivo + 1
            WHERE Tabla = 'tbMovimientos';

            INSERT INTO dbo.tbMovimientos (
                IDMovimiento, NumeroAsociado, CodigoRubro, IDAuxiliar, CodigoTransaccion,
                FechaMovimiento, FechaCreacion, Monto, Saldo, Observaciones,
                UsuarioCrea, snEliminado, tipoauxiliar, Ref1, Ref2
            )
            VALUES (
                @MovimientoID_Capital, @NumeroAsociado, @CodigoRubro, @IDAuxiliar, @CodigoTransaccion,
                GETDATE(), GETDATE(), @Monto, @NuevoSaldo, @Observaciones,
                @UsuarioID, 0, @tipoauxiliar, convert(nvarchar(max),@BaseID), @BaseType
            );

            EXEC spMovimientos_GuardarAsiento 
                    @CodigoTransaccion = @CodigoTransaccion, 
                    @Monto             = @Monto,
                    @Observaciones     = @Observaciones, 
                    @CodTipoAsiento    = 'TRA',
                    @MovimientoID      = @MovimientoID_Capital, 
                    @Mensaje           = @MensajeAsiento OUTPUT;

            IF @MensajeAsiento <> ''
            BEGIN
                SET @Resultado  = 'ERROR';
                SET @Mensaje    = 'Error al contabilizar: ' + @MensajeAsiento;
                SET @MensajeVal = @MensajeAsiento;

                IF @TransaccionPropia = 1 AND @@TRANCOUNT > 0 ROLLBACK;

                IF @TransaccionPropia = 1
                BEGIN
                    SELECT @Resultado AS Resultado,
                           @Mensaje   AS Mensaje,
                           NULL       AS CapitalMovimientoID,
                           NULL       AS InteresesMovimientoID;
                END;
                RETURN;
            END

            UPDATE dbo.tbAuxiliares
            SET Saldo          = @NuevoSaldo,
                FechaUltimoPago = GETDATE()
            WHERE ID = @IDAuxiliar;
        END

        ---------------------------------------------------------
        -- COMMIT SOLO SI LA TRANSACCIÓN ES PROPIA
        ---------------------------------------------------------
        IF @TransaccionPropia = 1 AND @@TRANCOUNT > 0 COMMIT;

        -------------------------------------------------------------------
        -- PASO 4: Mensaje único (éxito)
        -------------------------------------------------------------------
        SET @Resultado  = 'SUCCESS';
        SET @Mensaje    = 'Movimiento guardado exitosamente';
        SET @MensajeVal = NULL; -- éxito => NULL

        IF @TransaccionPropia = 1
        BEGIN
            SELECT @Resultado AS Resultado,
                   @Mensaje   AS Mensaje,
                   @MovimientoID_Capital  AS CapitalMovimientoID,
                   @MovimientoID_Interes  AS InteresesMovimientoID;
        END;

    END TRY
    BEGIN CATCH
        IF @TransaccionPropia = 1 AND @@TRANCOUNT > 0 ROLLBACK;

        SET @Resultado  = 'ERROR';
        SET @Mensaje    = ERROR_MESSAGE();
        SET @MensajeVal = @Mensaje;

        IF @TransaccionPropia = 1
        BEGIN
            SELECT @Resultado AS Resultado,
                   @Mensaje   AS Mensaje,
                   NULL       AS CapitalMovimientoID,
                   NULL       AS InteresesMovimientoID;
        END;

        RETURN;
    END CATCH
END
