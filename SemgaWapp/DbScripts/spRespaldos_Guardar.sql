-- =============================================
-- STORED PROCEDURE PARA GUARDAR INFORMACIÓN DE RESPALDO
-- =============================================

CREATE PROCEDURE [dbo].[spRespaldos_Guardar]
    @UsuarioGenera INT,
    @NombreRespaldo VARCHAR(100),
    @Descripcion VARCHAR(500) = NULL,
    @Ruta VARCHAR(500),
    @Size BIGINT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        -- Validar parámetros requeridos
        IF @UsuarioGenera IS NULL OR @UsuarioGenera <= 0
        BEGIN
            SELECT 'ERROR' AS Resultado, 'El ID del usuario es requerido' AS Mensaje, NULL AS ID
            RETURN
        END
        
        IF @NombreRespaldo IS NULL OR LTRIM(RTRIM(@NombreRespaldo)) = ''
        BEGIN
            SELECT 'ERROR' AS Resultado, 'El nombre del respaldo es requerido' AS Mensaje, NULL AS ID
            RETURN
        END
        
        IF @Ruta IS NULL OR LTRIM(RTRIM(@Ruta)) = ''
        BEGIN
            SELECT 'ERROR' AS Resultado, 'La ruta del respaldo es requerida' AS Mensaje, NULL AS ID
            RETURN
        END
        
        IF @Size IS NULL OR @Size < 0
        BEGIN
            SELECT 'ERROR' AS Resultado, 'El tamaño del respaldo debe ser mayor o igual a 0' AS Mensaje, NULL AS ID
            RETURN
        END
        
        -- Verificar que el usuario existe
        IF NOT EXISTS (SELECT 1 FROM tbUsuarios WHERE ID = @UsuarioGenera AND Estado = 'Activo')
        BEGIN
            SELECT 'ERROR' AS Resultado, 'El usuario especificado no existe o no está activo' AS Mensaje, NULL AS ID
            RETURN
        END
        
        -- Insertar el registro de respaldo
        INSERT INTO tbRespaldos (
            UsuarioGenera,
            FechaHora,
            NombreRespaldo,
            Descripcion,
            Ruta,
            Size,
            SnEliminado,
            FechaCreacion
        )
        VALUES (
            @UsuarioGenera,
            GETDATE(),
            LTRIM(RTRIM(@NombreRespaldo)),
            @Descripcion,
            LTRIM(RTRIM(@Ruta)),
            @Size,
            0,
            GETDATE()
        )
        
        -- Obtener el ID del respaldo insertado
        DECLARE @ID INT = SCOPE_IDENTITY()
        
        -- Retornar resultado exitoso
        SELECT 
            'SUCCESS' AS Resultado,
            'Respaldo guardado exitosamente' AS Mensaje,
            @ID AS ID
            
    END TRY
    BEGIN CATCH
        -- Retornar error en caso de excepción
        SELECT 
            'ERROR' AS Resultado,
            'Error al guardar el respaldo: ' + ERROR_MESSAGE() AS Mensaje,
            NULL AS ID
    END CATCH
END
