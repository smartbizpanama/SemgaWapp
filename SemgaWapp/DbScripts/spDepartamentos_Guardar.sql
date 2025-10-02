-- =============================================
-- Author: Sistema SemgaWapp
-- Create date: 2024
-- Description: Guardar o actualizar departamento
-- =============================================
CREATE PROCEDURE [dbo].[spDepartamentos_Guardar]
    @Id INT = NULL,
    @Nombre NVARCHAR(100),
    @Descripcion NVARCHAR(500) = NULL,
    @Responsable NVARCHAR(100) = NULL,
    @Telefono NVARCHAR(20) = NULL,
    @Email NVARCHAR(100) = NULL,
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
            SET @Mensaje = 'El nombre del departamento es requerido';
            ROLLBACK TRANSACTION;
            SELECT @Resultado AS Resultado, @Mensaje AS Mensaje, @NuevoID AS NuevoID;
            RETURN;
        END
        
        -- Verificar duplicados (nombre único)
        IF EXISTS (
            SELECT 1 FROM tbDepartamentos 
            WHERE Nombre = @Nombre 
                AND snEliminado = 0
                AND (@Id IS NULL OR Id != @Id)
        )
        BEGIN
            SET @Resultado = 'ERROR';
            SET @Mensaje = 'Ya existe un departamento con el mismo nombre';
            ROLLBACK TRANSACTION;
            SELECT @Resultado AS Resultado, @Mensaje AS Mensaje, @NuevoID AS NuevoID;
            RETURN;
        END
        
        -- Insertar o actualizar
        IF @Id IS NULL OR @Id = 0
        BEGIN
            -- INSERTAR
            INSERT INTO tbDepartamentos (
                Nombre,
                Descripcion,
                Responsable,
                Telefono,
                Email,
                Activo,
                FechaCreacion,
                snEliminado
            )
            VALUES (
                @Nombre,
                @Descripcion,
                @Responsable,
                @Telefono,
                @Email,
                ISNULL(@Activo, 1),
                GETDATE(),
                0
            );
            
            SET @NuevoID = SCOPE_IDENTITY();
            SET @Resultado = 'SUCCESS';
            SET @Mensaje = 'Departamento guardado correctamente';
        END
        ELSE
        BEGIN
            -- ACTUALIZAR
            UPDATE tbDepartamentos SET
                Nombre = @Nombre,
                Descripcion = @Descripcion,
                Responsable = @Responsable,
                Telefono = @Telefono,
                Email = @Email,
                Activo = @Activo,
                FechaModificacion = GETDATE()
            WHERE Id = @Id AND snEliminado = 0;
            
            IF @@ROWCOUNT = 0
            BEGIN
                SET @Resultado = 'ERROR';
                SET @Mensaje = 'No se encontró el departamento para actualizar';
                ROLLBACK TRANSACTION;
                SELECT @Resultado AS Resultado, @Mensaje AS Mensaje, @NuevoID AS NuevoID;
                RETURN;
            END
            
            SET @NuevoID = @Id;
            SET @Resultado = 'SUCCESS';
            SET @Mensaje = 'Departamento actualizado correctamente';
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


