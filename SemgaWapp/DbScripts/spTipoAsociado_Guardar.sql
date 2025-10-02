-- =============================================
-- Author: Sistema SemgaWapp
-- Create date: 2024
-- Description: Guardar o actualizar tipo de asociado
-- =============================================
CREATE PROCEDURE [dbo].[spTipoAsociado_Guardar]
    @IdTipoAsociado INT = NULL,
    @CodTipoAsociado VARCHAR(50),
    @TipoAsociado VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION;
        
        -- Variables para resultado
        DECLARE @Resultado VARCHAR(20) = 'SUCCESS'
        DECLARE @Mensaje VARCHAR(500) = ''
        DECLARE @NuevoID INT = 0
        
        -- Validaciones
        IF @CodTipoAsociado IS NULL OR LTRIM(RTRIM(@CodTipoAsociado)) = ''
        BEGIN
            SET @Resultado = 'ERROR';
            SET @Mensaje = 'El código del tipo de asociado es requerido';
            ROLLBACK TRANSACTION;
            SELECT @Resultado AS Resultado, @Mensaje AS Mensaje, @NuevoID AS NuevoID;
            RETURN;
        END
        
        IF @TipoAsociado IS NULL OR LTRIM(RTRIM(@TipoAsociado)) = ''
        BEGIN
            SET @Resultado = 'ERROR';
            SET @Mensaje = 'El tipo de asociado es requerido';
            ROLLBACK TRANSACTION;
            SELECT @Resultado AS Resultado, @Mensaje AS Mensaje, @NuevoID AS NuevoID;
            RETURN;
        END
        
        -- Verificar duplicados (código único)
        IF EXISTS (
            SELECT 1 FROM tbTipoAsociado 
            WHERE CodTipoAsociado = @CodTipoAsociado 
                AND snEliminado = 0
                AND (@IdTipoAsociado IS NULL OR IdTipoAsociado != @IdTipoAsociado)
        )
        BEGIN
            SET @Resultado = 'ERROR';
            SET @Mensaje = 'Ya existe un tipo de asociado con el mismo código';
            ROLLBACK TRANSACTION;
            SELECT @Resultado AS Resultado, @Mensaje AS Mensaje, @NuevoID AS NuevoID;
            RETURN;
        END
        
        -- Insertar o actualizar
        IF @IdTipoAsociado IS NULL OR @IdTipoAsociado = 0
        BEGIN
            -- INSERTAR
            INSERT INTO tbTipoAsociado (
                CodTipoAsociado,
                TipoAsociado,
                snEliminado
            )
            VALUES (
                @CodTipoAsociado,
                @TipoAsociado,
                0
            );
            
            SET @NuevoID = SCOPE_IDENTITY();
            SET @Resultado = 'SUCCESS';
            SET @Mensaje = 'Tipo de asociado guardado correctamente';
        END
        ELSE
        BEGIN
            -- ACTUALIZAR
            UPDATE tbTipoAsociado SET
                CodTipoAsociado = @CodTipoAsociado,
                TipoAsociado = @TipoAsociado
            WHERE IdTipoAsociado = @IdTipoAsociado AND snEliminado = 0;
            
            IF @@ROWCOUNT = 0
            BEGIN
                SET @Resultado = 'ERROR';
                SET @Mensaje = 'No se encontró el tipo de asociado para actualizar';
                ROLLBACK TRANSACTION;
                SELECT @Resultado AS Resultado, @Mensaje AS Mensaje, @NuevoID AS NuevoID;
                RETURN;
            END
            
            SET @NuevoID = @IdTipoAsociado;
            SET @Resultado = 'SUCCESS';
            SET @Mensaje = 'Tipo de asociado actualizado correctamente';
        END
        
        COMMIT TRANSACTION;
        
        -- Devolver resultado
        SELECT @Resultado AS Resultado, @Mensaje AS Mensaje, @NuevoID AS NuevoID;
        
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SELECT 'ERROR' AS Resultado, 'Error: ' + ERROR_MESSAGE() AS Mensaje, 0 AS NuevoID;
    END CATCH
END


