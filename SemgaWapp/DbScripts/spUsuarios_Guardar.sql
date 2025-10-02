CREATE PROCEDURE [dbo].[spUsuarios_Guardar]
    @ID INT = NULL,
    @Nombre NVARCHAR(100),
    @Apellido NVARCHAR(100),
    @Usuario NVARCHAR(50),
    @Clave NVARCHAR(255) = NULL,
    @Email NVARCHAR(100),
    @Telefono NVARCHAR(20) = NULL,
    @Rol INT,
    @Departamento INT = NULL,
    @Estado NVARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @Resultado VARCHAR(20) = 'ERROR';
    DECLARE @Mensaje VARCHAR(500) = '';
    DECLARE @NuevoID INT = NULL;
    
    BEGIN TRY
        -- Validaciones
        IF @Nombre IS NULL OR @Nombre = ''
        BEGIN
            SET @Mensaje = 'El nombre es obligatorio';
            GOTO FINAL;
        END
        
        IF @Apellido IS NULL OR @Apellido = ''
        BEGIN
            SET @Mensaje = 'El apellido es obligatorio';
            GOTO FINAL;
        END
        
        IF @Usuario IS NULL OR @Usuario = ''
        BEGIN
            SET @Mensaje = 'El usuario es obligatorio';
            GOTO FINAL;
        END
        
        IF @Email IS NULL OR @Email = ''
        BEGIN
            SET @Mensaje = 'El email es obligatorio';
            GOTO FINAL;
        END
        
        IF @Rol IS NULL
        BEGIN
            SET @Mensaje = 'El rol es obligatorio';
            GOTO FINAL;
        END
        
        IF @Estado IS NULL OR @Estado = ''
        BEGIN
            SET @Mensaje = 'El estado es obligatorio';
            GOTO FINAL;
        END
        
        -- Verificar que el rol existe
        IF NOT EXISTS (SELECT 1 FROM tbRoles WHERE Id = @Rol AND snEliminado = 0)
        BEGIN
            SET @Mensaje = 'El rol especificado no existe';
            GOTO FINAL;
        END
        
        -- Verificar que el departamento existe (si se proporciona)
        IF @Departamento IS NOT NULL AND NOT EXISTS (SELECT 1 FROM tbDepartamentos WHERE Id = @Departamento AND snEliminado = 0)
        BEGIN
            SET @Mensaje = 'El departamento especificado no existe';
            GOTO FINAL;
        END
        
        -- Verificar que el estado existe
        IF NOT EXISTS (SELECT 1 FROM tbStatusAsociado WHERE CodStatusAsociado = @Estado AND snEliminado = 0)
        BEGIN
            SET @Mensaje = 'El estado especificado no existe';
            GOTO FINAL;
        END
        
        -- Verificar usuario único
        IF EXISTS (SELECT 1 FROM tbUsuarios WHERE Usuario = @Usuario AND snEliminado = 0 AND (@ID IS NULL OR Id != @ID))
        BEGIN
            SET @Mensaje = 'El nombre de usuario ya existe';
            GOTO FINAL;
        END
        
        -- Verificar email único
        IF EXISTS (SELECT 1 FROM tbUsuarios WHERE Email = @Email AND snEliminado = 0 AND (@ID IS NULL OR Id != @ID))
        BEGIN
            SET @Mensaje = 'El email ya existe';
            GOTO FINAL;
        END
        
        -- Insertar o actualizar
        IF @ID IS NULL
        BEGIN
            -- Validar que se proporcione clave para nuevo usuario
            IF @Clave IS NULL OR @Clave = ''
            BEGIN
                SET @Mensaje = 'La clave es obligatoria para nuevos usuarios';
                GOTO FINAL;
            END
            
            INSERT INTO tbUsuarios (
                Nombre, Apellido, Usuario, Clave, Email, Telefono, 
                Rol, Departamento, Estado, UltimoAcceso, IntentosFallidos, 
                BloqueadoHasta, FechaCreacion, CreadoPor, snEliminado
            )
            VALUES (
                @Nombre, @Apellido, @Usuario, @Clave, @Email, @Telefono,
                @Rol, @Departamento, @Estado, NULL, 0,
                NULL, GETDATE(), NULL, 0
            );
            
            SET @NuevoID = SCOPE_IDENTITY();
            SET @Resultado = 'SUCCESS';
            SET @Mensaje = 'Usuario creado exitosamente';
        END
        ELSE
        BEGIN
            -- Actualizar usuario existente
            UPDATE tbUsuarios SET
                Nombre = @Nombre,
                Apellido = @Apellido,
                Usuario = @Usuario,
                Email = @Email,
                Telefono = @Telefono,
                Rol = @Rol,
                Departamento = @Departamento,
                Estado = @Estado,
                FechaModificacion = GETDATE(),
                ModificadoPor = NULL
            WHERE Id = @ID;
            
            -- Actualizar clave solo si se proporciona
            IF @Clave IS NOT NULL AND @Clave != ''
            BEGIN
                UPDATE tbUsuarios SET
                    Clave = @Clave
                WHERE Id = @ID;
            END
            
            SET @Resultado = 'SUCCESS';
            SET @Mensaje = 'Usuario actualizado exitosamente';
        END
        
    END TRY
    BEGIN CATCH
        SET @Mensaje = 'Error en la base de datos: ' + ERROR_MESSAGE();
    END CATCH
    
    FINAL:
    SELECT @Resultado AS Resultado, @Mensaje AS Mensaje, @NuevoID AS NuevoID;
END

