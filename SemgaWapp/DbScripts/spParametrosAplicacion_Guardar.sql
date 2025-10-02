CREATE PROCEDURE [dbo].[spParametrosAplicacion_Guardar]
    @ParamKey VARCHAR(200),
    @ParamValue NVARCHAR(MAX)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @Resultado VARCHAR(20) = 'ERROR';
    DECLARE @Mensaje VARCHAR(500) = '';
    
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM tbParamsKeys WHERE ParamKey = @ParamKey)
        BEGIN
            SET @Mensaje = 'El parámetro especificado no existe.';
            GOTO FINAL;
        END
        
        UPDATE tbParamsKeys
        SET ParamValue = @ParamValue
        WHERE ParamKey = @ParamKey;
        
        SET @Resultado = 'SUCCESS';
        SET @Mensaje = 'Parámetro actualizado exitosamente.';
        
    END TRY
    BEGIN CATCH
        SET @Mensaje = 'Error en la base de datos: ' + ERROR_MESSAGE();
    END CATCH
    
    FINAL:
    SELECT @Resultado AS Resultado, @Mensaje AS Mensaje;
END