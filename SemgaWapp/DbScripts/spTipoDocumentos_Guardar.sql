-- =============================================
-- Author: Sistema SemgaWapp
-- Create date: 2024
-- Description: Guardar o actualizar tipo de documento
-- =============================================
CREATE PROCEDURE [dbo].[spTipoDocumentos_Guardar]
    @IDTipoDoc INT = NULL,
    @CodTipoDoc VARCHAR(10),
    @TipoDocumento NVARCHAR(50)
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
        IF @CodTipoDoc IS NULL OR LTRIM(RTRIM(@CodTipoDoc)) = ''
        BEGIN
            SET @Resultado = 'ERROR';
            SET @Mensaje = 'El código del tipo de documento es requerido';
            ROLLBACK TRANSACTION;
            SELECT @Resultado AS Resultado, @Mensaje AS Mensaje, @NuevoID AS NuevoID;
            RETURN;
        END
        
        IF @TipoDocumento IS NULL OR LTRIM(RTRIM(@TipoDocumento)) = ''
        BEGIN
            SET @Resultado = 'ERROR';
            SET @Mensaje = 'El tipo de documento es requerido';
            ROLLBACK TRANSACTION;
            SELECT @Resultado AS Resultado, @Mensaje AS Mensaje, @NuevoID AS NuevoID;
            RETURN;
        END
        
        -- Verificar duplicados (código único)
        IF EXISTS (
            SELECT 1 FROM tbTipoDocumentos 
            WHERE CodTipoDoc = @CodTipoDoc 
                AND snEliminado = 0
                AND (@IDTipoDoc IS NULL OR IDTipoDoc != @IDTipoDoc)
        )
        BEGIN
            SET @Resultado = 'ERROR';
            SET @Mensaje = 'Ya existe un tipo de documento con el mismo código';
            ROLLBACK TRANSACTION;
            SELECT @Resultado AS Resultado, @Mensaje AS Mensaje, @NuevoID AS NuevoID;
            RETURN;
        END
        
        -- Insertar o actualizar
        IF @IDTipoDoc IS NULL OR @IDTipoDoc = 0
        BEGIN
            -- INSERTAR
            INSERT INTO tbTipoDocumentos (
                CodTipoDoc,
                TipoDocumento,
                snEliminado
            )
            VALUES (
                @CodTipoDoc,
                @TipoDocumento,
                0
            );
            
            SET @NuevoID = SCOPE_IDENTITY();
            SET @Resultado = 'SUCCESS';
            SET @Mensaje = 'Tipo de documento guardado correctamente';
        END
        ELSE
        BEGIN
            -- ACTUALIZAR
            UPDATE tbTipoDocumentos SET
                CodTipoDoc = @CodTipoDoc,
                TipoDocumento = @TipoDocumento
            WHERE IDTipoDoc = @IDTipoDoc AND snEliminado = 0;
            
            IF @@ROWCOUNT = 0
            BEGIN
                SET @Resultado = 'ERROR';
                SET @Mensaje = 'No se encontró el tipo de documento para actualizar';
                ROLLBACK TRANSACTION;
                SELECT @Resultado AS Resultado, @Mensaje AS Mensaje, @NuevoID AS NuevoID;
                RETURN;
            END
            
            SET @NuevoID = @IDTipoDoc;
            SET @Resultado = 'SUCCESS';
            SET @Mensaje = 'Tipo de documento actualizado correctamente';
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


