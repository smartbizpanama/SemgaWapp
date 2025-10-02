CREATE PROCEDURE [dbo].[spTiposAuxiliares_Guardar]
    @ID INT = NULL,
    @CodigoRubro VARCHAR(5),
    @Descripcion NVARCHAR(150),
    @Tasa NUMERIC(18,2) = NULL,
    @Plazo INT = NULL,
    @MontoMaximo NUMERIC(18,2) = NULL,
    @MontoMinimo NUMERIC(18,2) = NULL,
    @PorManejo NUMERIC(18,2) = NULL,
    @PorCapitalizacion NUMERIC(18,2) = NULL,
    @PorProteccion NUMERIC(18,2) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @Resultado VARCHAR(20) = 'ERROR';
    DECLARE @Mensaje VARCHAR(500) = '';
    DECLARE @NuevoID INT = NULL;
    
    BEGIN TRY
        -- Validaciones
        IF @CodigoRubro IS NULL OR @CodigoRubro = ''
        BEGIN
            SET @Mensaje = 'El código de rubro es obligatorio';
            GOTO FINAL;
        END
        
        -- Calcular automáticamente el siguiente TipoAuxiliar para el rubro
        DECLARE @TipoAuxiliar INT;
        SELECT @TipoAuxiliar = ISNULL(MAX(TipoAuxiliar), 0) + 1 
        FROM tbTiposAuxiliares 
        WHERE CodigoRubro = @CodigoRubro AND snEliminado = 0;
        
        IF @Descripcion IS NULL OR @Descripcion = ''
        BEGIN
            SET @Mensaje = 'La descripción es obligatoria';
            GOTO FINAL;
        END
        
        -- Verificar que el rubro existe
        IF NOT EXISTS (SELECT 1 FROM tbRubros WHERE CodigoRubro = @CodigoRubro AND snEliminado = 0)
        BEGIN
            SET @Mensaje = 'El rubro especificado no existe';
            GOTO FINAL;
        END
        
        -- TipoAuxiliar se calcula automáticamente, no necesita validación de duplicados
        
        -- Validar montos
        IF @MontoMinimo IS NOT NULL AND @MontoMaximo IS NOT NULL AND @MontoMinimo > @MontoMaximo
        BEGIN
            SET @Mensaje = 'El monto mínimo no puede ser mayor al monto máximo';
            GOTO FINAL;
        END
        
        -- Validar porcentajes (0-100)
        IF @PorManejo IS NOT NULL AND (@PorManejo < 0 OR @PorManejo > 100)
        BEGIN
            SET @Mensaje = 'El porcentaje de manejo debe estar entre 0 y 100';
            GOTO FINAL;
        END
        
        IF @PorCapitalizacion IS NOT NULL AND (@PorCapitalizacion < 0 OR @PorCapitalizacion > 100)
        BEGIN
            SET @Mensaje = 'El porcentaje de capitalización debe estar entre 0 y 100';
            GOTO FINAL;
        END
        
        IF @PorProteccion IS NOT NULL AND (@PorProteccion < 0 OR @PorProteccion > 100)
        BEGIN
            SET @Mensaje = 'El porcentaje de protección debe estar entre 0 y 100';
            GOTO FINAL;
        END
        
        -- Insertar o actualizar
        IF @ID IS NULL
        BEGIN
            INSERT INTO tbTiposAuxiliares (
                CodigoRubro, TipoAuxiliar, Descripcion, Tasa, Plazo,
                MontoMaximo, MontoMinimo, PorManejo, PorCapitalizacion, PorProteccion, snEliminado
            )
            VALUES (
                @CodigoRubro, @TipoAuxiliar, @Descripcion, @Tasa, @Plazo,
                @MontoMaximo, @MontoMinimo, @PorManejo, @PorCapitalizacion, @PorProteccion, 0
            );
            
            SET @NuevoID = SCOPE_IDENTITY();
            SET @Resultado = 'SUCCESS';
            SET @Mensaje = 'Tipo auxiliar creado exitosamente';
        END
        ELSE
        BEGIN
            UPDATE tbTiposAuxiliares SET
                CodigoRubro = @CodigoRubro,
                TipoAuxiliar = @TipoAuxiliar,
                Descripcion = @Descripcion,
                Tasa = @Tasa,
                Plazo = @Plazo,
                MontoMaximo = @MontoMaximo,
                MontoMinimo = @MontoMinimo,
                PorManejo = @PorManejo,
                PorCapitalizacion = @PorCapitalizacion,
                PorProteccion = @PorProteccion
            WHERE ID = @ID;
            
            SET @Resultado = 'SUCCESS';
            SET @Mensaje = 'Tipo auxiliar actualizado exitosamente';
        END
        
    END TRY
    BEGIN CATCH
        SET @Mensaje = 'Error en la base de datos: ' + ERROR_MESSAGE();
    END CATCH
    
    FINAL:
    SELECT @Resultado AS Resultado, @Mensaje AS Mensaje, @NuevoID AS NuevoID;
END
