CREATE OR ALTER PROCEDURE dbo.spMovimientos_GuardarLote
(
    @NumeroAsociado INT,
    @UsuarioID INT,
    @JsonLote NVARCHAR(MAX)
)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @ResultadoGlobal NVARCHAR(20) = 'SUCCESS';
    DECLARE @MensajeGlobal NVARCHAR(MAX) = 'Lote procesado correctamente';
    DECLARE @IDTransaccion INT = NULL;
    DECLARE @JsonResponse NVARCHAR(MAX);

    ------------------------------------------------------------
    -- Validación básica
    ------------------------------------------------------------
    IF @JsonLote IS NULL OR LTRIM(RTRIM(@JsonLote)) = ''
    BEGIN
        SELECT 
            'ERROR' AS Resultado,
            'El JSON del lote está vacío' AS Mensaje,
            NULL AS IDTransaccion,
            NULL AS Detalles
        FOR JSON PATH, WITHOUT_ARRAY_WRAPPER;
        RETURN;
    END

    ------------------------------------------------------------
    -- Tabla movimientos desde JSON
    ------------------------------------------------------------
    DECLARE @Movimientos TABLE
    (
        NumeroLinea INT,
        CodigoRubro VARCHAR(10),
        IDAuxiliar INT,
        CodigoTransaccion VARCHAR(10),
        Monto DECIMAL(18,2),
        Observaciones VARCHAR(500)
    );

    INSERT INTO @Movimientos
    SELECT
        NumeroLinea,
        CodigoRubro,
        IDAuxiliar,
        CodigoTransaccion,
        Monto,
        Observaciones
    FROM OPENJSON(@JsonLote)
    WITH
    (
        NumeroLinea INT,
        NumeroAsociado INT,
        CodigoRubro VARCHAR(10),
        IDAuxiliar INT,
        CodigoTransaccion VARCHAR(10),
        Monto DECIMAL(18,2),
        Observaciones VARCHAR(500)
    );

    ------------------------------------------------------------
    -- Tabla resultados
    ------------------------------------------------------------
    DECLARE @Resultados TABLE
    (
        NumeroLinea INT,
        CodigoRubro VARCHAR(10),
        IDAuxiliar INT,
        CodigoTransaccion VARCHAR(10),
        Monto DECIMAL(18,2),
        Mensaje NVARCHAR(MAX),
        MovimientoID_Capital INT,
        MovimientoID_Interes INT
    );

    INSERT INTO @Resultados
    SELECT 
        NumeroLinea,
        CodigoRubro,
        IDAuxiliar,
        CodigoTransaccion,
        Monto,
        'no procesado',
        NULL,
        NULL
    FROM @Movimientos;

    ------------------------------------------------------------
    -- Procesamiento
    ------------------------------------------------------------
    BEGIN TRY

        BEGIN TRANSACTION;

        --------------------------------------------------------
        -- Insertar cabecera (participa en rollback)
        --------------------------------------------------------
        INSERT INTO dbo.tbTransacciones
        (
            FechaHora,
            Usuario,
            NumeroAsociado,
            jsonRequest
        )
        VALUES
        (
            GETDATE(),
            @UsuarioID,
            @NumeroAsociado,
            @JsonLote
        );

        SET @IDTransaccion = SCOPE_IDENTITY();

        --------------------------------------------------------
        -- Cursor procesamiento secuencial
        --------------------------------------------------------
        DECLARE 
            @NumeroLinea INT,
            @CodigoRubro VARCHAR(10),
            @IDAuxiliar INT,
            @CodigoTransaccion VARCHAR(10),
            @Monto DECIMAL(18,2),
            @Observaciones VARCHAR(500),
            @MensajeVal NVARCHAR(MAX),
            @MovimientoID_Capital INT,
            @MovimientoID_Interes INT;

        DECLARE cur CURSOR FOR
        SELECT NumeroLinea, CodigoRubro, IDAuxiliar, CodigoTransaccion, Monto, Observaciones
        FROM @Movimientos
        ORDER BY NumeroLinea;

        OPEN cur;

        FETCH NEXT FROM cur INTO 
            @NumeroLinea, @CodigoRubro, @IDAuxiliar, @CodigoTransaccion, @Monto, @Observaciones;

        WHILE @@FETCH_STATUS = 0
        BEGIN

            SET @MensajeVal = NULL;
            SET @MovimientoID_Capital = NULL;
            SET @MovimientoID_Interes = NULL;

            EXEC dbo.spMovimientos_GuardarMovimiento
                @NumeroAsociado = @NumeroAsociado,
                @CodigoRubro = @CodigoRubro,
                @IDAuxiliar = @IDAuxiliar,
                @CodigoTransaccion = @CodigoTransaccion,
                @Monto = @Monto,
                @UsuarioID = @UsuarioID,
                @Observaciones = @Observaciones,
                @BaseID = NULL,
                @BaseType = NULL,
                @MensajeVal = @MensajeVal OUTPUT,
                @MovimientoID_Capital = @MovimientoID_Capital OUTPUT,
                @MovimientoID_Interes = @MovimientoID_Interes OUTPUT;

            ----------------------------------------------------
            -- Si falla
            ----------------------------------------------------
            IF @MensajeVal IS NOT NULL AND @MensajeVal <> ''
            BEGIN
                UPDATE @Resultados
                SET Mensaje = @MensajeVal
                WHERE NumeroLinea = @NumeroLinea;

                SET @ResultadoGlobal = 'ERROR';
                SET @MensajeGlobal = @MensajeVal;

                THROW 50001, @MensajeVal, 1;
            END

            ----------------------------------------------------
            -- Si OK
            ----------------------------------------------------
            UPDATE @Resultados
            SET Mensaje = 'OK',
                MovimientoID_Capital = @MovimientoID_Capital,
                MovimientoID_Interes = @MovimientoID_Interes
            WHERE NumeroLinea = @NumeroLinea;

            FETCH NEXT FROM cur INTO 
                @NumeroLinea, @CodigoRubro, @IDAuxiliar, @CodigoTransaccion, @Monto, @Observaciones;
        END

        CLOSE cur;
        DEALLOCATE cur;

        --------------------------------------------------------
        -- Actualizar movimientos con IDTransaccion
        --------------------------------------------------------
        UPDATE m
        SET m.IDTransaccion = @IDTransaccion
        FROM dbo.tbMovimientos m
        INNER JOIN @Resultados r
            ON m.IDMovimiento = r.MovimientoID_Capital
            OR m.IDMovimiento = r.MovimientoID_Interes;

        --------------------------------------------------------
        -- Construir JSON final
        --------------------------------------------------------
        SET @JsonResponse = (
            SELECT
                @ResultadoGlobal AS Resultado,
                @MensajeGlobal AS Mensaje,
                @IDTransaccion AS IDTransaccion,
                (
                    SELECT 
                        NumeroLinea,
                        CodigoRubro,
                        IDAuxiliar,
                        CodigoTransaccion,
                        Monto,
                        Mensaje,
                        MovimientoID_Capital,
                        MovimientoID_Interes
                    FROM @Resultados
                    ORDER BY NumeroLinea
                    FOR JSON PATH
                ) AS Detalles
            FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
        );

        --------------------------------------------------------
        -- Guardar respuesta en cabecera
        --------------------------------------------------------
        UPDATE dbo.tbTransacciones
        SET jsonResponse = @JsonResponse
        WHERE IDTransaccion = @IDTransaccion;

        COMMIT TRANSACTION;

        SELECT @JsonResponse;

    END TRY
    BEGIN CATCH

        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        SELECT 
            'ERROR' AS Resultado,
            ERROR_MESSAGE() AS Mensaje,
            NULL AS IDTransaccion,
            (
                SELECT 
                    NumeroLinea,
                    CodigoRubro,
                    IDAuxiliar,
                    CodigoTransaccion,
                    Monto,
                    Mensaje,
                    MovimientoID_Capital,
                    MovimientoID_Interes
                FROM @Resultados
                ORDER BY NumeroLinea
                FOR JSON PATH
            ) AS Detalles
        FOR JSON PATH, WITHOUT_ARRAY_WRAPPER;

    END CATCH;

END
GO
