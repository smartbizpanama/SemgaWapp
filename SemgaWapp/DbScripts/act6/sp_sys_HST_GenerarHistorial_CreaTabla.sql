CREATE OR ALTER PROCEDURE dbo.sp_sys_HST_GenerarHistorial_CreaTabla
    @TablaNombre NVARCHAR(100),     -- ej: tbAuxiliares
    @FechaCierre DATE,              -- fecha del cierre (define yyyyMM)
    @Usuario INT = 0,

    -- OUTPUTS
    @TablaHistorialCreada NVARCHAR(200) OUTPUT,
    @VersionCreada INT OUTPUT,
    @RegistrosCopiados INT OUTPUT,
    @Resultado NVARCHAR(MAX) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE
        @Anio INT,
        @Mes INT,
        @Periodo CHAR(6),
        @TablaDestinoBase NVARCHAR(200),
        @TablaDestino NVARCHAR(200),
        @SQL NVARCHAR(MAX),
        @MaxVersion INT = -1;

    BEGIN TRY
        ---------------------------------------------------------
        -- PERIODO
        ---------------------------------------------------------
        SET @Anio = YEAR(@FechaCierre);
        SET @Mes  = MONTH(@FechaCierre);
        SET @Periodo = FORMAT(@FechaCierre, 'yyyyMM');

        ---------------------------------------------------------
        -- NOMBRE BASE DE TABLA HISTÓRICA
        ---------------------------------------------------------
        SET @TablaDestinoBase = 'sys.HST.' + @TablaNombre + '_' + @Periodo;

        ---------------------------------------------------------
        -- DETERMINAR ÚLTIMA VERSIÓN EXISTENTE
        ---------------------------------------------------------
        SELECT
            @MaxVersion = ISNULL(MAX(Version), -1)
        FROM dbo.[sys.HST.Historiales]
        WHERE Tabla = @TablaNombre
          AND Mes = @Mes
          AND Año = @Anio;

        ---------------------------------------------------------
        -- DEFINIR NUEVA VERSIÓN Y NOMBRE FINAL
        ---------------------------------------------------------
        SET @VersionCreada = @MaxVersion + 1;

        IF @VersionCreada = 0
            SET @TablaDestino = @TablaDestinoBase;
        ELSE
            SET @TablaDestino = @TablaDestinoBase + '_' + CAST(@VersionCreada AS NVARCHAR(10));

        ---------------------------------------------------------
        -- CREAR TABLA HISTÓRICA
        ---------------------------------------------------------
        SET @SQL = N'SELECT * INTO ' + QUOTENAME(@TablaDestino)
                 + N' FROM ' + QUOTENAME(@TablaNombre);

        EXEC sp_executesql @SQL;

        ---------------------------------------------------------
        -- CONTAR REGISTROS COPIADOS
        ---------------------------------------------------------
        SET @SQL = N'SELECT @Registros = COUNT(*) FROM ' + QUOTENAME(@TablaDestino);
        EXEC sp_executesql
            @SQL,
            N'@Registros INT OUTPUT',
            @Registros = @RegistrosCopiados OUTPUT;

        ---------------------------------------------------------
        -- REGISTRAR EN sys.HST.Historiales
        ---------------------------------------------------------
        INSERT INTO dbo.[sys.HST.Historiales]
            (Tabla, FechaHora, Mes, Año, TablaHistorial,
             Registros, Resultado, Version, UsuarioCrea)
        VALUES
            (@TablaNombre,
             GETDATE(),
             @Mes,
             @Anio,
             @TablaDestino,
             @RegistrosCopiados,
             'Éxito',
             @VersionCreada,
             @Usuario);

        ---------------------------------------------------------
        -- SALIDA
        ---------------------------------------------------------
        SET @TablaHistorialCreada = @TablaDestino;
        SET @Resultado = 'Éxito';
    END TRY
    BEGIN CATCH
        SET @Resultado = ERROR_MESSAGE();

        ---------------------------------------------------------
        -- REGISTRAR ERROR EN sys.HST.Historiales
        ---------------------------------------------------------
        INSERT INTO dbo.[sys.HST.Historiales]
            (Tabla, FechaHora, Mes, Año, TablaHistorial,
             Registros, Resultado, Version, UsuarioCrea)
        VALUES
            (@TablaNombre,
             GETDATE(),
             @Mes,
             @Anio,
             'N/A',
             0,
             'Error: ' + @Resultado,
             -1,
             @Usuario);

        THROW;
    END CATCH
END
GO
