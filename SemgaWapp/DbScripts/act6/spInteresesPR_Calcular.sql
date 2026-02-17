CREATE OR ALTER PROCEDURE [dbo].[spInteresesPR_Calcular]
    @NumeroAsociado INT = NULL,
    @IdAuxiliar INT = NULL,
    @UsuarioID INT = 0,
    @FechaProceso DATE,                 -- fecha sobre la que se calcula
    @snBat BIT = 0,                     -- 0 = maneja transacción | 1 = participa en transacción global
    @ReturnMessage VARCHAR(MAX) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @ErrorMessages VARCHAR(MAX) = '';

    ---------------------------------------------------------
    -- 1. Llenar tabla temporal con préstamos pendientes
    ---------------------------------------------------------
    SELECT 
        a.ID,
        a.NumeroAsociado,
        ISNULL(a.Saldo,0) AS Saldo,
        ISNULL(a.TasaInteres,0) AS TasaInteres,
        a.FechaUltCalculoInteres,
        a.InteresCalculado,
        a.InteresPagado,
        ROW_NUMBER() OVER (ORDER BY a.ID) AS RowNumber
    INTO #Pendientes
    FROM dbo.tbAuxiliares AS a
    WHERE a.snEliminado = 0
      AND a.CodigoRubro = 'PR'
      AND (a.FechaUltCalculoInteres IS NULL
           OR DATEDIFF(day, a.FechaUltCalculoInteres, @FechaProceso) > 0)
      AND (@IdAuxiliar IS NULL OR a.ID = @IdAuxiliar)
      AND (@NumeroAsociado IS NULL OR a.NumeroAsociado = @NumeroAsociado);

    DECLARE 
        @TotalRows INT = (SELECT COUNT(*) FROM #Pendientes),
        @CurrentRowNumber INT = 1;

    ---------------------------------------------------------
    -- 2. Recorrer auxiliares
    ---------------------------------------------------------
    WHILE @CurrentRowNumber <= @TotalRows
    BEGIN
        BEGIN TRY
            -------------------------------------------------
            -- CONTROL TRANSACCIONAL
            -------------------------------------------------
            IF @snBat = 0
                BEGIN TRANSACTION;

            DECLARE 
                @AuxiliarID INT, 
                @Saldo NUMERIC(19,6), 
                @Tasa NUMERIC(19,6), 
                @FechaUlt DATE,
                @InteresAcumulado NUMERIC(19,6),
                @InteresPagado NUMERIC(19,6);

            SELECT 
                @AuxiliarID = ID, 
                @Saldo = Saldo, 
                @Tasa = TasaInteres, 
                @FechaUlt = FechaUltCalculoInteres,
                @InteresAcumulado = InteresCalculado,
                @InteresPagado = InteresPagado
            FROM #Pendientes 
            WHERE RowNumber = @CurrentRowNumber;

            -------------------------------------------------
            -- Calcular días e interés generado
            -------------------------------------------------
            DECLARE @DiasTranscurridos INT =
                DATEDIFF(
                    day,
                    ISNULL(@FechaUlt, @FechaProceso),
                    @FechaProceso
                );

            DECLARE @InteresGenerado NUMERIC(19,6) =
                (@Saldo * @Tasa / 100) * @DiasTranscurridos / 3000;

            -------------------------------------------------
            -- Actualizar auxiliar
            -------------------------------------------------
            UPDATE dbo.tbAuxiliares
            SET InteresCalculado = ISNULL(InteresCalculado,0) + @InteresGenerado,
                FechaUltCalculoInteres = @FechaProceso,
                FechaModificacion = GETDATE(),
                UsuarioModifica = @UsuarioID
            WHERE ID = @AuxiliarID;

            -------------------------------------------------
            -- Insertar histórico
            -------------------------------------------------
            INSERT INTO dbo.tbAuxiliares_Intereses
                (IDAuxiliar, FechaCalculo, FechaUltCalculo, SaldoAFecha, 
                 InteresCalculadoAFecha, InteresPagadoAFecha, DiasIntereses, 
                 Tasa, InteresCalculado, Usuario)
            VALUES
                (@AuxiliarID, 
                 GETDATE(),                -- fecha real de ejecución
                 @FechaUlt,                -- fecha anterior de cálculo
                 @Saldo, 
                 ISNULL(@InteresAcumulado,0),
                 ISNULL(@InteresPagado,0), 
                 @DiasTranscurridos, 
                 @Tasa, 
                 @InteresGenerado, 
                 @UsuarioID);

            -------------------------------------------------
            -- COMMIT SOLO SI NO ES BAT
            -------------------------------------------------
            IF @snBat = 0
                COMMIT TRANSACTION;
        END TRY
        BEGIN CATCH
            -------------------------------------------------
            -- ROLLBACK SOLO SI NO ES BAT
            -------------------------------------------------
            IF @snBat = 0 AND @@TRANCOUNT > 0
                ROLLBACK TRANSACTION;

            SET @ErrorMessages += CONCAT(
                'Error en auxiliar ',
                ISNULL(@AuxiliarID,'?'),
                ': ',
                ERROR_MESSAGE(),
                CHAR(13)
            );
        END CATCH

        SET @CurrentRowNumber += 1;
    END

    DROP TABLE #Pendientes;

    ---------------------------------------------------------
    -- Resultado final
    ---------------------------------------------------------
    SET @ReturnMessage = @ErrorMessages;
END
GO
