-- =============================================
-- Author: Sistema SemgaWapp
-- Create date: 2024
-- Description: Guardar o actualizar parentezco
-- =============================================
CREATE PROCEDURE [dbo].[spParentezcos_Guardar]
    @IDParentezco INT = NULL,
    @Parentezco NVARCHAR(50)
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
        IF @Parentezco IS NULL OR LTRIM(RTRIM(@Parentezco)) = ''
        BEGIN
            SET @Resultado = 'ERROR';
            SET @Mensaje = 'El parentezco es requerido';
            ROLLBACK TRANSACTION;
            SELECT @Resultado AS Resultado, @Mensaje AS Mensaje, @NuevoID AS NuevoID;
            RETURN;
        END
        
        -- Verificar duplicados (parentezco único)
        IF EXISTS (
            SELECT 1 FROM tbParentezcos 
            WHERE Parentezco = @Parentezco 
                AND snEliminado = 0
                AND (@IDParentezco IS NULL OR IDParentezco != @IDParentezco)
        )
        BEGIN
            SET @Resultado = 'ERROR';
            SET @Mensaje = 'Ya existe un parentezco con el mismo nombre';
            ROLLBACK TRANSACTION;
            SELECT @Resultado AS Resultado, @Mensaje AS Mensaje, @NuevoID AS NuevoID;
            RETURN;
        END
        
        -- Insertar o actualizar
        IF @IDParentezco IS NULL OR @IDParentezco = 0
        BEGIN
            -- INSERTAR
            INSERT INTO tbParentezcos (
                Parentezco,
                snEliminado
            )
            VALUES (
                @Parentezco,
                0
            );
            
            SET @NuevoID = SCOPE_IDENTITY();
            SET @Resultado = 'SUCCESS';
            SET @Mensaje = 'Parentezco guardado correctamente';
        END
        ELSE
        BEGIN
            -- ACTUALIZAR
            UPDATE tbParentezcos SET
                Parentezco = @Parentezco
            WHERE IDParentezco = @IDParentezco AND snEliminado = 0;
            
            IF @@ROWCOUNT = 0
            BEGIN
                SET @Resultado = 'ERROR';
                SET @Mensaje = 'No se encontró el parentezco para actualizar';
                ROLLBACK TRANSACTION;
                SELECT @Resultado AS Resultado, @Mensaje AS Mensaje, @NuevoID AS NuevoID;
                RETURN;
            END
            
            SET @NuevoID = @IDParentezco;
            SET @Resultado = 'SUCCESS';
            SET @Mensaje = 'Parentezco actualizado correctamente';
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


