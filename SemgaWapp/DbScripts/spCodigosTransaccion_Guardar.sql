-- =============================================
-- Author: Sistema SemgaWapp
-- Create date: 2024
-- Description: Guardar o actualizar código de transacción
-- =============================================
CREATE PROCEDURE [dbo].[spCodigosTransaccion_Guardar]
    @ID INT = NULL,
    @CodigoRubro VARCHAR(5),
    @CodigoTransaccion VARCHAR(10),
    @Descripcion NVARCHAR(150),
    @DebCred CHAR(1),
    @CuentaContable VARCHAR(50),
    @SnActivo BIT = 1
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
            SET @Mensaje = 'El código de rubro es requerido';
            ROLLBACK TRANSACTION;
            SELECT @Resultado AS Resultado, @Mensaje AS Mensaje, @NuevoID AS NuevoID;
            RETURN;
        END
        
        IF @CodigoTransaccion IS NULL OR LTRIM(RTRIM(@CodigoTransaccion)) = ''
        BEGIN
            SET @Resultado = 'ERROR';
            SET @Mensaje = 'El código de transacción es requerido';
            ROLLBACK TRANSACTION;
            SELECT @Resultado AS Resultado, @Mensaje AS Mensaje, @NuevoID AS NuevoID;
            RETURN;
        END
        
        IF @Descripcion IS NULL OR LTRIM(RTRIM(@Descripcion)) = ''
        BEGIN
            SET @Resultado = 'ERROR';
            SET @Mensaje = 'La descripción es requerida';
            ROLLBACK TRANSACTION;
            SELECT @Resultado AS Resultado, @Mensaje AS Mensaje, @NuevoID AS NuevoID;
            RETURN;
        END
        
        IF @DebCred NOT IN ('D', 'C')
        BEGIN
            SET @Resultado = 'ERROR';
            SET @Mensaje = 'El tipo de débito/crédito debe ser D o C';
            ROLLBACK TRANSACTION;
            SELECT @Resultado AS Resultado, @Mensaje AS Mensaje, @NuevoID AS NuevoID;
            RETURN;
        END
        
        -- Verificar que el rubro existe
        IF NOT EXISTS (SELECT 1 FROM tbRubros WHERE CodigoRubro = @CodigoRubro AND SnEliminado = 0)
        BEGIN
            SET @Resultado = 'ERROR';
            SET @Mensaje = 'El código de rubro especificado no existe';
            ROLLBACK TRANSACTION;
            SELECT @Resultado AS Resultado, @Mensaje AS Mensaje, @NuevoID AS NuevoID;
            RETURN;
        END
        
        -- Verificar duplicados (código de transacción único por rubro)
        IF EXISTS (
            SELECT 1 FROM tbCodigosTransaccion 
            WHERE CodigoRubro = @CodigoRubro 
                AND CodigoTransaccion = @CodigoTransaccion 
                AND SnEliminado = 0
                AND (@ID IS NULL OR ID != @ID)
        )
        BEGIN
            SET @Resultado = 'ERROR';
            SET @Mensaje = 'Ya existe un código de transacción con el mismo código para este rubro';
            ROLLBACK TRANSACTION;
            SELECT @Resultado AS Resultado, @Mensaje AS Mensaje, @NuevoID AS NuevoID;
            RETURN;
        END
        
        -- Insertar o actualizar
        IF @ID IS NULL OR @ID = 0
        BEGIN
            -- INSERTAR
            INSERT INTO tbCodigosTransaccion (
                CodigoRubro,
                CodigoTransaccion,
                Descripcion,
                DebCred,
                CuentaContable,
                SnActivo,
                SnEliminado
            )
            VALUES (
                @CodigoRubro,
                @CodigoTransaccion,
                @Descripcion,
                @DebCred,
                @CuentaContable,
                ISNULL(@SnActivo, 1),
                0
            );
            
            SET @NuevoID = SCOPE_IDENTITY();
            SET @Resultado = 'SUCCESS';
            SET @Mensaje = 'Código de transacción guardado correctamente';
        END
        ELSE
        BEGIN
            -- ACTUALIZAR
            UPDATE tbCodigosTransaccion SET
                CodigoRubro = @CodigoRubro,
                CodigoTransaccion = @CodigoTransaccion,
                Descripcion = @Descripcion,
                DebCred = @DebCred,
                CuentaContable = @CuentaContable,
                SnActivo = @SnActivo
            WHERE ID = @ID AND SnEliminado = 0;
            
            IF @@ROWCOUNT = 0
            BEGIN
                SET @Resultado = 'ERROR';
                SET @Mensaje = 'No se encontró el código de transacción para actualizar';
                ROLLBACK TRANSACTION;
                SELECT @Resultado AS Resultado, @Mensaje AS Mensaje, @NuevoID AS NuevoID;
                RETURN;
            END
            
            SET @NuevoID = @ID;
            SET @Resultado = 'SUCCESS';
            SET @Mensaje = 'Código de transacción actualizado correctamente';
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
