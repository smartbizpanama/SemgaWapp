-- =============================================
-- Author: Sistema SemgaWapp
-- Create date: 2024
-- Description: Guardar o actualizar estatus de asociado
-- =============================================
CREATE PROCEDURE [dbo].[spStatusAsociado_Guardar]
    @IDStatus INT = NULL,
    @CodStatusAsociado CHAR(1),
    @StatusAsociado NVARCHAR(50)
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
        IF @CodStatusAsociado IS NULL OR LTRIM(RTRIM(@CodStatusAsociado)) = ''
        BEGIN
            SET @Resultado = 'ERROR';
            SET @Mensaje = 'El código del estatus es requerido';
            ROLLBACK TRANSACTION;
            SELECT @Resultado AS Resultado, @Mensaje AS Mensaje, @NuevoID AS NuevoID;
            RETURN;
        END
        
        IF @StatusAsociado IS NULL OR LTRIM(RTRIM(@StatusAsociado)) = ''
        BEGIN
            SET @Resultado = 'ERROR';
            SET @Mensaje = 'La descripción del estatus es requerida';
            ROLLBACK TRANSACTION;
            SELECT @Resultado AS Resultado, @Mensaje AS Mensaje, @NuevoID AS NuevoID;
            RETURN;
        END
        
        -- Verificar duplicados (código único)
        IF EXISTS (
            SELECT 1 FROM tbStatusAsociado 
            WHERE CodStatusAsociado = @CodStatusAsociado 
                AND snEliminado = 0
                AND (@IDStatus IS NULL OR IDStatus != @IDStatus)
        )
        BEGIN
            SET @Resultado = 'ERROR';
            SET @Mensaje = 'Ya existe un estatus con el mismo código';
            ROLLBACK TRANSACTION;
            SELECT @Resultado AS Resultado, @Mensaje AS Mensaje, @NuevoID AS NuevoID;
            RETURN;
        END
        
        -- Insertar o actualizar
        IF @IDStatus IS NULL OR @IDStatus = 0
        BEGIN
            -- INSERTAR
            INSERT INTO tbStatusAsociado (
                CodStatusAsociado,
                StatusAsociado,
                snEliminado
            )
            VALUES (
                @CodStatusAsociado,
                @StatusAsociado,
                0
            );
            
            SET @NuevoID = SCOPE_IDENTITY();
            SET @Resultado = 'SUCCESS';
            SET @Mensaje = 'Estatus guardado correctamente';
        END
        ELSE
        BEGIN
            -- ACTUALIZAR
            UPDATE tbStatusAsociado SET
                CodStatusAsociado = @CodStatusAsociado,
                StatusAsociado = @StatusAsociado
            WHERE IDStatus = @IDStatus AND snEliminado = 0;
            
            IF @@ROWCOUNT = 0
            BEGIN
                SET @Resultado = 'ERROR';
                SET @Mensaje = 'No se encontró el estatus para actualizar';
                ROLLBACK TRANSACTION;
                SELECT @Resultado AS Resultado, @Mensaje AS Mensaje, @NuevoID AS NuevoID;
                RETURN;
            END
            
            SET @NuevoID = @IDStatus;
            SET @Resultado = 'SUCCESS';
            SET @Mensaje = 'Estatus actualizado correctamente';
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


