-- =============================================
-- Author: Sistema SemgaWapp
-- Create date: 2024
-- Description: Guardar o actualizar rol
-- =============================================
CREATE PROCEDURE [dbo].[spRoles_Guardar]
    @Id INT = NULL,
    @Nombre NVARCHAR(50),
    @Descripcion NVARCHAR(200) = NULL,
    @NivelAcceso INT = 1,
    @Activo BIT = 1
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
        IF @Nombre IS NULL OR LTRIM(RTRIM(@Nombre)) = ''
        BEGIN
            SET @Resultado = 'ERROR';
            SET @Mensaje = 'El nombre del rol es requerido';
            ROLLBACK TRANSACTION;
            SELECT @Resultado AS Resultado, @Mensaje AS Mensaje, @NuevoID AS NuevoID;
            RETURN;
        END
        
        -- Validar NivelAcceso
        IF @NivelAcceso NOT IN (0, 1, 2)
        BEGIN
            SET @Resultado = 'ERROR';
            SET @Mensaje = 'El nivel de acceso debe ser 0 (Super Usuario), 1 (Administrador) o 2 (Agente)';
            ROLLBACK TRANSACTION;
            SELECT @Resultado AS Resultado, @Mensaje AS Mensaje, @NuevoID AS NuevoID;
            RETURN;
        END
        
        -- Verificar duplicados (nombre único)
        IF EXISTS (
            SELECT 1 FROM tbRoles 
            WHERE Nombre = @Nombre 
                AND snEliminado = 0
                AND (@Id IS NULL OR Id != @Id)
        )
        BEGIN
            SET @Resultado = 'ERROR';
            SET @Mensaje = 'Ya existe un rol con el mismo nombre';
            ROLLBACK TRANSACTION;
            SELECT @Resultado AS Resultado, @Mensaje AS Mensaje, @NuevoID AS NuevoID;
            RETURN;
        END
        
        -- Insertar o actualizar
        IF @Id IS NULL OR @Id = 0
        BEGIN
            -- INSERTAR
            INSERT INTO tbRoles (
                Nombre,
                Descripcion,
                NivelAcceso,
                Activo,
                FechaCreacion,
                snEliminado
            )
            VALUES (
                @Nombre,
                @Descripcion,
                @NivelAcceso,
                ISNULL(@Activo, 1),
                GETDATE(),
                0
            );
            
            SET @NuevoID = SCOPE_IDENTITY();
            SET @Resultado = 'SUCCESS';
            SET @Mensaje = 'Rol guardado correctamente';
        END
        ELSE
        BEGIN
            -- ACTUALIZAR
            UPDATE tbRoles SET
                Nombre = @Nombre,
                Descripcion = @Descripcion,
                NivelAcceso = @NivelAcceso,
                Activo = @Activo,
                FechaModificacion = GETDATE()
            WHERE Id = @Id AND snEliminado = 0;
            
            IF @@ROWCOUNT = 0
            BEGIN
                SET @Resultado = 'ERROR';
                SET @Mensaje = 'No se encontró el rol para actualizar';
                ROLLBACK TRANSACTION;
                SELECT @Resultado AS Resultado, @Mensaje AS Mensaje, @NuevoID AS NuevoID;
                RETURN;
            END
            
            SET @NuevoID = @Id;
            SET @Resultado = 'SUCCESS';
            SET @Mensaje = 'Rol actualizado correctamente';
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


