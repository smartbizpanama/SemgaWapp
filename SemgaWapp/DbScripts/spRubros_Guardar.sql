-- =============================================
-- Author: Sistema SemgaWapp
-- Create date: 2024
-- Description: Guardar o actualizar rubro
-- =============================================
CREATE PROCEDURE [dbo].[spRubros_Guardar]
    @IDRubro INT = NULL,
    @CodigoRubro VARCHAR(5),
    @Descripcion NVARCHAR(100)
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
        IF @CodigoRubro IS NULL OR LTRIM(RTRIM(@CodigoRubro)) = ''
        BEGIN
            SET @Resultado = 'ERROR';
            SET @Mensaje = 'El código del rubro es requerido';
            ROLLBACK TRANSACTION;
            SELECT @Resultado AS Resultado, @Mensaje AS Mensaje, @NuevoID AS NuevoID;
            RETURN;
        END
        
        IF @Descripcion IS NULL OR LTRIM(RTRIM(@Descripcion)) = ''
        BEGIN
            SET @Resultado = 'ERROR';
            SET @Mensaje = 'La descripción del rubro es requerida';
            ROLLBACK TRANSACTION;
            SELECT @Resultado AS Resultado, @Mensaje AS Mensaje, @NuevoID AS NuevoID;
            RETURN;
        END
        
        -- Verificar duplicados (código único)
        IF EXISTS (
            SELECT 1 FROM tbRubros 
            WHERE CodigoRubro = @CodigoRubro 
                AND snEliminado = 0
                AND (@IDRubro IS NULL OR IDRubro != @IDRubro)
        )
        BEGIN
            SET @Resultado = 'ERROR';
            SET @Mensaje = 'Ya existe un rubro con el mismo código';
            ROLLBACK TRANSACTION;
            SELECT @Resultado AS Resultado, @Mensaje AS Mensaje, @NuevoID AS NuevoID;
            RETURN;
        END
        
        -- Insertar o actualizar
        IF @IDRubro IS NULL OR @IDRubro = 0
        BEGIN
            -- INSERTAR
            INSERT INTO tbRubros (
                CodigoRubro,
                Descripcion,
                snEliminado
            )
            VALUES (
                @CodigoRubro,
                @Descripcion,
                0
            );
            
            SET @NuevoID = SCOPE_IDENTITY();
            SET @Resultado = 'SUCCESS';
            SET @Mensaje = 'Rubro guardado correctamente';
        END
        ELSE
        BEGIN
            -- ACTUALIZAR
            UPDATE tbRubros SET
                CodigoRubro = @CodigoRubro,
                Descripcion = @Descripcion
            WHERE IDRubro = @IDRubro AND snEliminado = 0;
            
            IF @@ROWCOUNT = 0
            BEGIN
                SET @Resultado = 'ERROR';
                SET @Mensaje = 'No se encontró el rubro para actualizar';
                ROLLBACK TRANSACTION;
                SELECT @Resultado AS Resultado, @Mensaje AS Mensaje, @NuevoID AS NuevoID;
                RETURN;
            END
            
            SET @NuevoID = @IDRubro;
            SET @Resultado = 'SUCCESS';
            SET @Mensaje = 'Rubro actualizado correctamente';
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


