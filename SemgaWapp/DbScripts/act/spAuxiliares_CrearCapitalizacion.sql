CREATE OR ALTER PROCEDURE [dbo].[spAuxiliares_CrearCapitalizacion]
    @AuxiliarOrigen INT,
    @NumeroAsociado INT,
    @CodigoRubro VARCHAR(5),
    @Monto NUMERIC(18,2) = 0,
    @UsuarioID INT,
    @IdSession NVARCHAR(50) = NULL,
    @Mensaje nvarchar(max) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    -- NULL = OK, cualquier texto = error
    SET @Mensaje = NULL;

    BEGIN TRY
        -- Parámetros de capitalización
        DECLARE 
            @CodigoRubroCap nvarchar(10),
            @CodTransCap nvarchar(10),
            @IDAuxCap int,
            @FechaCap datetime,
            @IDAuxAsociado int;

        SET @CodigoRubroCap = ISNULL(
                                (SELECT ParamValue 
                                 FROM tbParamsKeys 
                                 WHERE ParamKey='CODIGO_RUBRO_APORTE_CAP'),
                                'AP');

        SET @CodTransCap = ISNULL(
                                (SELECT ParamValue 
                                 FROM tbParamsKeys 
                                 WHERE ParamKey='CODIGO_TRANSACCION_APORTE_CAP'),
                                'APCAP');

        SET @IDAuxCap = ISNULL(
                                (SELECT ParamValue 
                                 FROM tbParamsKeys 
                                 WHERE ParamKey='ID_AUXILIAR_APORTE_CAP'),
                                0);

        SET @FechaCap = GETDATE();

        IF @IDAuxCap = 0
        BEGIN
            SET @Mensaje = 'No está configurado el ID del auxiliar de aportes de capitalización.';
            RETURN;
        END

        -- Buscar auxiliar de aportes del asociado
        SET @IDAuxAsociado = ISNULL(
            (
                SELECT top 1 ID 
                FROM tbAuxiliares 
                WHERE NumeroAsociado = @NumeroAsociado 
                  AND CodigoRubro   = @CodigoRubroCap
                  AND IsNUll(snActivo,1)      = 1 
                  AND IsNull(snEliminado,0)   = 0
            ),
            0
        );

        -- Si no existe, lo creo llamando al SP de auxiliares
        IF @IDAuxAsociado = 0
        BEGIN
            DECLARE @RespAux TABLE (
                Resultado varchar(20),
                Mensaje   nvarchar(max),
                NuevoID   int NULL
            );

            INSERT INTO @RespAux (Resultado, Mensaje, NuevoID)
            EXEC [spAuxiliares_GuardarAuxiliar]
                    @ID = 0,
                    @NumeroAsociado = @NumeroAsociado,
                    @CodigoRubro    = @CodigoRubroCap,
                    @TipoAuxiliar   = @IDAuxCap,
                    @Cuota          = 0,
                    @Saldo          = 0,
                    @MontoOriginal  = 0,
                    @MontoPignorado = 0,
                    @FechaOtorgado  = @FechaCap,
                    @TasaInteres    = 0,
                    @PagoMes        = 0,
                    @UsuarioID      = @UsuarioID,
                    @PorcManejo     = 0,
                    @PorcCap        = 0,
                    @MontoManejo    = 0,
                    @MontoCap       = 0,
                    @IdSession      = @IdSession;

            DECLARE @ResAux varchar(20), @MsgAux nvarchar(max);

            SELECT 
                @ResAux        = Resultado,
                @MsgAux        = Mensaje,
                @IDAuxAsociado = ISNULL(NuevoID,0)
            FROM @RespAux;

            IF @ResAux <> 'SUCCESS' OR @IDAuxAsociado = 0
            BEGIN
                SET @Mensaje = ISNULL(@MsgAux, 'Error al crear el auxiliar de aportes de capitalización.');
                RETURN;
            END
        END
        /*
        @MovimientoID_Capital int OUTPUT,
        @MovimientoID_Interes int OUTPUT
        */
        -- Registrar movimiento de capitalizaci�n
        DECLARE @MensajeMov nvarchar(max) = '';
        DECLARE @MovimientoID_Capital int = 0;
        DECLARE @MovimientoID_Interes int = 0;

        EXEC spMovimientos_GuardarMovimiento 
                @NumeroAsociado    = @NumeroAsociado, 
                @CodigoRubro       = @CodigoRubroCap, 
                @IDAuxiliar        = @IDAuxAsociado, 
                @CodigoTransaccion = @CodTransCap, 
                @Monto             = @Monto, 
                @UsuarioID         = @UsuarioID, 
                @Observaciones     = 'CAPITALIZACIÓN', 
                @MensajeVal        = @MensajeMov OUTPUT,
                @MovimientoID_Capital = @MovimientoID_Capital OUTPUT,
                @MovimientoID_Interes = @MovimientoID_Interes OUTPUT;

        IF @MensajeMov IS NOT NULL AND LTRIM(RTRIM(@MensajeMov)) <> ''
        BEGIN
            SET @Mensaje = @MensajeMov;
            RETURN;
        END

        --GUARDO LA REFERENCIA DEL PRESTAMO QUE GENER� EL MOVIMIENTO
        Update tbMovimientos Set Ref1 = convert(nvarchar(100),@AuxiliarOrigen)
        Where IDMovimiento =@MovimientoID_Capital;

        -- Si todo sali� bien, @Mensaje queda NULL (OK)

    END TRY
    BEGIN CATCH
        SET @Mensaje = N'Error al crear capitalización: ' + ERROR_MESSAGE();
        RETURN;
    END CATCH
END