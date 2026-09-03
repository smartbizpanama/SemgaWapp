CREATE OR ALTER PROCEDURE dbo.spMovimientos_SimularMovimiento
(
    @NumeroAsociado INT,
    @CodigoRubro VARCHAR(10),
    @IDAuxiliar INT,
    @CodigoTransaccion VARCHAR(10),
    @Monto DECIMAL(18,2),
    @snSoloCapital BIT
)
AS
BEGIN
    SET NOCOUNT ON;

    ---------------------------------------------------------
    -- VARIABLES
    ---------------------------------------------------------
    DECLARE 
        @SaldoActual NUMERIC(19,6),
        @Tasa NUMERIC(19,6),
        @FechaUltCalculo DATE,
        @InteresCalculado NUMERIC(19,6),
        @InteresPagado NUMERIC(19,6),
        @InteresPendiente NUMERIC(19,6),
        @MontoOriginal NUMERIC(19,6),

        @DiasInteres INT = 0,
        @InteresGenerado NUMERIC(19,6) = 0,

        @MontoInteres NUMERIC(19,6) = 0,
        @MontoCapital NUMERIC(19,6) = 0,

        @FechaHoy DATE = CAST(GETDATE() AS DATE);

    ---------------------------------------------------------
    -- 1. Obtener datos del auxiliar
    ---------------------------------------------------------
    SELECT 
        @SaldoActual = Saldo,
        @Tasa = ISNULL(TasaInteres,0),
        @FechaUltCalculo = COALESCE(FechaUltCalculoInteres, FechaUltimoPago, FechaOtorgado, @FechaHoy),
        @InteresCalculado = ISNULL(InteresCalculado,0),
        @InteresPagado = ISNULL(InteresPagado,0),
        @MontoOriginal = ISNULL(MontoOriginal,0)
    FROM dbo.tbAuxiliares
    WHERE ID = @IDAuxiliar;



    IF @CodigoTransaccion = 'PRRTI' --DEVOLUCION DE INTERESES
    BEGIN
        DECLARE @NuevoInteresPagado NUMERIC(19,6);

        -- validación básica (opcional pero recomendable)
        IF @Monto > @InteresPagado
        BEGIN
            SELECT 
                'ERROR' AS Resultado,
                'Monto excede intereses pagados' AS Mensaje;
            RETURN;
        END

        SET @NuevoInteresPagado = @InteresPagado - @Monto;

        SELECT
            @SaldoActual              AS SaldoAuxiliar,
            @FechaUltCalculo          AS FechaUltCalculoIntereses,
            @InteresCalculado         AS InteresesCalculados,
            @InteresPagado            AS InteresesPagados,
            @Monto                    AS MontoADevolver,
            @NuevoInteresPagado       AS NuevoInteresPagado,
            'OK'                      AS Resultado,
            ''                        AS Mensaje;

        RETURN;
    END

    IF @CodigoTransaccion = 'PRRTR'
    BEGIN
        DECLARE @NuevoSaldo NUMERIC(19,6);

        IF @MontoOriginal=0
        BEGIN 
            SELECT 
                'ERROR' AS Resultado,
                'Imposible devolver con monto original cero (0)' AS Mensaje;
            RETURN;
        END

        -- validación (igual que SP real)
        IF (@SaldoActual + @Monto) > @MontoOriginal
        BEGIN
            SELECT 
                'ERROR' AS Resultado,
                'La devolución excede el monto original' AS Mensaje;
            RETURN;
        END

        SET @NuevoSaldo = @SaldoActual + @Monto;

        SELECT
            @SaldoActual   AS SaldoAuxiliar,
            @Monto         AS MontoADevolver,
            @NuevoSaldo    AS NuevoSaldo,
            'OK'                      AS Resultado,
            ''                        AS Mensaje;

        RETURN;
    END

    ---------------------------------------------------------
    -- 2. Calcular días de interés
    ---------------------------------------------------------
    SET @DiasInteres = DATEDIFF(DAY, @FechaUltCalculo, @FechaHoy);

    IF @DiasInteres < 0 SET @DiasInteres = 0;

    ---------------------------------------------------------
    -- 3. Calcular interés generado (SIMULADO)
    ---------------------------------------------------------
    IF @snSoloCapital = 0 AND @CodigoRubro = 'PR'
    BEGIN
        SET @InteresGenerado = (@SaldoActual * @Tasa) * @DiasInteres / 3000;
    END
    ELSE
    BEGIN
        SET @InteresGenerado = 0;
        SET @DiasInteres = 0;
    END

    ---------------------------------------------------------
    -- 4. Interés pendiente total
    ---------------------------------------------------------
    SET @InteresPendiente = (@InteresCalculado - @InteresPagado) + @InteresGenerado;

    IF @InteresPendiente < 0 SET @InteresPendiente = 0;

    ---------------------------------------------------------
    -- 5. Distribución del pago
    ---------------------------------------------------------
    IF @snSoloCapital = 1
    BEGIN
        SET @MontoInteres = 0;
        SET @MontoCapital = @Monto;
    END
    ELSE
    BEGIN
        IF @CodigoRubro = 'PR' AND @InteresPendiente > 0
        BEGIN
            SET @MontoInteres = IIF(@Monto >= @InteresPendiente, @InteresPendiente, @Monto);
            SET @MontoCapital = @Monto - @MontoInteres;
        END
        ELSE
        BEGIN
            SET @MontoInteres = 0;
            SET @MontoCapital = @Monto;
        END
    END

    ---------------------------------------------------------
    -- 6. Resultado
    ---------------------------------------------------------
    SELECT
        @SaldoActual           AS SaldoAuxiliar,            
        @Tasa                  AS TasaInteresPorcentaje,
        @DiasInteres           AS DiasInteresesAGenerar,
        @InteresGenerado       AS MontoInteresesAGenerar,
        @MontoInteres          AS MontoAAplicarIntereses,
        @MontoCapital          AS MontoAAplicarCapital,
        'OK'                   AS Resultado,
        ''                     AS Mensaje;
END
GO
