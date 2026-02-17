

CREATE OR ALTER PROCEDURE [dbo].[spGestionSocios_CrearCxCSostenibilidad]
    @NumeroAsociado INT,
    @UsuarioID int,
    @IdSession nvarchar(Max),
    @Mensaje nvarchar(max) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    -- NULL = OK, cualquier texto = error
    SET @Mensaje = '';

    BEGIN TRY
        -- Parámetros de capitalización
        DECLARE 
            @CodigoRubroSos nvarchar(10),
            @CodTransSos nvarchar(10),
            @IDAuxSos int,
            @FechaSos datetime,
            @IDAuxAsociado int,
            @MontoSostenibilidad numeric(19,6);



        SET @MontoSostenibilidad = ISNULL(
                                    (
                                        SELECT TRY_CAST(ParamValue AS numeric(19,6))
                                        FROM tbParamsKeys
                                        WHERE ParamKey = 'MONTO_SOSTENIBILIDAD_MENSUAL'),
                                    1);



        SET @CodigoRubroSos = ISNULL(
                                (SELECT ParamValue 
                                 FROM tbParamsKeys 
                                 WHERE ParamKey='CODIGO_RUBRO_SOSTENIBILIDAD'),
                                'CXC');

        SET @CodTransSos = ISNULL(
                                (SELECT ParamValue 
                                 FROM tbParamsKeys 
                                 WHERE ParamKey='CODIGO_TRANSACCION_SOSTENIBILIDAD_MENSUAL'),
                                'CXCSOS');

        SET @IDAuxSos = ISNULL(
                                (SELECT ParamValue 
                                 FROM tbParamsKeys 
                                 WHERE ParamKey='ID_AUXILIAR_CXC_SOSTENIBILIDAD'),
                                0);

        SET @FechaSos = GETDATE();

        IF @IDAuxSos = 0
        BEGIN
            SET @Mensaje = 'No está configurado el ID tipo auxiliar para CxC Sostenibilidad.';
            RETURN;
        END

        -- Buscar auxiliar de sostenibilidad del asociado
        SET @IDAuxAsociado = ISNULL(
            (
                SELECT top 1 ID 
                FROM tbAuxiliares 
                WHERE NumeroAsociado = @NumeroAsociado 
                  AND CodigoRubro   = @CodigoRubroSos
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
                    @CodigoRubro    = @CodigoRubroSos,
                    @TipoAuxiliar   = @IDAuxSos,
                    @Cuota          = 0,
                    @Saldo          = 0,
                    @MontoOriginal  = 0,
                    @MontoPignorado = 0,
                    @FechaOtorgado  = @FechaSos,
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
                SET @Mensaje = ISNULL(@MsgAux, 'Error al crear el auxiliar de sostenibilidad.');
                RETURN;
            END
        END
        /*
        @MovimientoID_Capital int OUTPUT,
        @MovimientoID_Interes int OUTPUT
        */
        -- Registrar movimiento de sostenibilidad
        DECLARE @MensajeMov nvarchar(max) = '';
        DECLARE @MovimientoID_Capital int = 0;
        DECLARE @MovimientoID_Interes int = 0;

        EXEC spMovimientos_GuardarMovimiento 
                @NumeroAsociado    = @NumeroAsociado, 
                @CodigoRubro       = @CodigoRubroSos, 
                @IDAuxiliar        = @IDAuxAsociado, 
                @CodigoTransaccion = @CodTransSos, 
                @Monto             = @MontoSostenibilidad, 
                @UsuarioID         = @UsuarioID, 
                @Observaciones     = 'SOSTENIBILIDAD', 
                @MensajeVal        = @MensajeMov OUTPUT,
                @MovimientoID_Capital = @MovimientoID_Capital OUTPUT,
                @MovimientoID_Interes = @MovimientoID_Interes OUTPUT;

        IF @MensajeMov IS NOT NULL AND LTRIM(RTRIM(@MensajeMov)) <> ''
        BEGIN
            SET @Mensaje = @MensajeMov;
            RETURN;
        END

        -- Si todo salió bien, @Mensaje queda NULL (OK)

    END TRY
    BEGIN CATCH
        SET @Mensaje = N'Error al crear sostenibilidad: ' + ERROR_MESSAGE();
        RETURN;
    END CATCH
END