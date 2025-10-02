-- =============================================
-- STORED PROCEDURES PARA GESTIÓN DE USUARIOS
-- =============================================

-- Procedimiento para obtener usuarios con filtros
CREATE PROCEDURE [dbo].[sp_ObtenerUsuarios]
    @FiltroNombre NVARCHAR(100) = NULL,
    @FiltroUsuario NVARCHAR(50) = NULL,
    @FiltroEstado NVARCHAR(20) = NULL,
    @FiltroRol INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        u.Id,
        u.Nombre,
        u.Apellido,
        u.Usuario,
        u.Email,
        u.Telefono,
        u.Rol,
        r.Nombre AS RolNombre,
        u.Departamento,
        d.Nombre AS DepartamentoNombre,
        u.Estado,
        u.UltimoAcceso,
        u.IntentosFallidos,
        u.BloqueadoHasta,
        u.FechaCreacion,
        u.FechaModificacion
    FROM tbUsuarios u
    LEFT JOIN tbRoles r ON u.Rol = r.Id
    LEFT JOIN tbDepartamentos d ON u.Departamento = d.Id
    WHERE (@FiltroNombre IS NULL OR 
           u.Nombre LIKE '%' + @FiltroNombre + '%' OR 
           u.Apellido LIKE '%' + @FiltroNombre + '%')
      AND (@FiltroUsuario IS NULL OR u.Usuario LIKE '%' + @FiltroUsuario + '%')
      AND (@FiltroEstado IS NULL OR u.Estado = @FiltroEstado)
      AND (@FiltroRol IS NULL OR u.Rol = @FiltroRol)
    ORDER BY u.Nombre, u.Apellido;
END
GO

-- Procedimiento para obtener un usuario por ID
CREATE PROCEDURE [dbo].[sp_ObtenerUsuarioPorId]
    @UsuarioId INT
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        u.Id,
        u.Nombre,
        u.Apellido,
        u.Usuario,
        u.Email,
        u.Telefono,
        u.Rol,
        r.Nombre AS RolNombre,
        u.Departamento,
        d.Nombre AS DepartamentoNombre,
        u.Estado,
        u.UltimoAcceso,
        u.IntentosFallidos,
        u.BloqueadoHasta,
        u.FechaCreacion,
        u.FechaModificacion
    FROM tbUsuarios u
    LEFT JOIN tbRoles r ON u.Rol = r.Id
    LEFT JOIN tbDepartamentos d ON u.Departamento = d.Id
    WHERE u.Id = @UsuarioId;
END
GO

-- Procedimiento para guardar usuario (INSERT/UPDATE)
CREATE PROCEDURE [dbo].[sp_GuardarUsuario]
    @UsuarioId INT = 0,
    @Nombre NVARCHAR(100),
    @Apellido NVARCHAR(100),
    @Usuario NVARCHAR(50),
    @Clave NVARCHAR(255) = NULL,
    @Email NVARCHAR(100),
    @Telefono NVARCHAR(20) = NULL,
    @Rol INT,
    @Departamento INT = NULL,
    @Estado NVARCHAR(20),
    @UsuarioActual INT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION;
        
        IF @UsuarioId = 0
        BEGIN
            -- INSERT
            IF @Clave IS NULL OR @Clave = ''
            BEGIN
                RAISERROR('La contraseña es requerida para nuevos usuarios', 16, 1);
                RETURN;
            END
            
            INSERT INTO tbUsuarios (
                Nombre, Apellido, Usuario, Clave, Email, Telefono, 
                Rol, Departamento, Estado, FechaCreacion, CreadoPor
            )
            VALUES (
                @Nombre, @Apellido, @Usuario, @Clave, @Email, @Telefono,
                @Rol, @Departamento, @Estado, GETDATE(), @UsuarioActual
            );
            
            SELECT 'Usuario creado exitosamente' AS Mensaje;
        END
        ELSE
        BEGIN
            -- UPDATE
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
                ModificadoPor = @UsuarioActual
            WHERE Id = @UsuarioId;
            
            -- Actualizar contraseña solo si se proporciona
            IF @Clave IS NOT NULL AND @Clave <> ''
            BEGIN
                UPDATE tbUsuarios SET
                    Clave = @Clave
                WHERE Id = @UsuarioId;
            END
            
            SELECT 'Usuario actualizado exitosamente' AS Mensaje;
        END
        
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();
        
        RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH
END
GO

-- Procedimiento para eliminar usuario
CREATE PROCEDURE [dbo].[sp_EliminarUsuario]
    @UsuarioId INT,
    @UsuarioActual INT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        -- Verificar que no sea el usuario actual
        IF @UsuarioId = @UsuarioActual
        BEGIN
            RAISERROR('No puede eliminar su propio usuario', 16, 1);
            RETURN;
        END
        
        -- Verificar que el usuario existe
        IF NOT EXISTS (SELECT 1 FROM tbUsuarios WHERE Id = @UsuarioId)
        BEGIN
            RAISERROR('El usuario especificado no existe', 16, 1);
            RETURN;
        END
        
        -- Eliminar usuario
        DELETE FROM tbUsuarios WHERE Id = @UsuarioId;
        
        SELECT 'Usuario eliminado exitosamente' AS Mensaje;
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();
        
        RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH
END
GO

-- Procedimiento para cambiar estado de usuario
CREATE PROCEDURE [dbo].[sp_CambiarEstadoUsuario]
    @UsuarioId INT,
    @NuevoEstado NVARCHAR(20),
    @UsuarioActual INT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        -- Verificar que no sea el usuario actual
        IF @UsuarioId = @UsuarioActual
        BEGIN
            RAISERROR('No puede cambiar el estado de su propio usuario', 16, 1);
            RETURN;
        END
        
        -- Verificar que el usuario existe
        IF NOT EXISTS (SELECT 1 FROM tbUsuarios WHERE Id = @UsuarioId)
        BEGIN
            RAISERROR('El usuario especificado no existe', 16, 1);
            RETURN;
        END
        
        -- Actualizar estado
        UPDATE tbUsuarios SET
            Estado = @NuevoEstado,
            FechaModificacion = GETDATE(),
            ModificadoPor = @UsuarioActual
        WHERE Id = @UsuarioId;
        
        SELECT 'Estado de usuario actualizado exitosamente' AS Mensaje;
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();
        
        RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH
END
GO

-- Procedimiento para actualizar último acceso
CREATE PROCEDURE [dbo].[sp_ActualizarUltimoAcceso]
    @UsuarioId INT
AS
BEGIN
    SET NOCOUNT ON;
    
    UPDATE tbUsuarios SET
        UltimoAcceso = GETDATE()
    WHERE Id = @UsuarioId;
END
GO

-- Procedimiento para registrar intento fallido de login
CREATE PROCEDURE [dbo].[sp_RegistrarIntentoFallido]
    @Usuario NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    
    UPDATE tbUsuarios SET
        IntentosFallidos = IntentosFallidos + 1,
        BloqueadoHasta = CASE 
            WHEN IntentosFallidos >= 4 THEN DATEADD(MINUTE, 30, GETDATE())
            ELSE BloqueadoHasta
        END
    WHERE Usuario = @Usuario;
END
GO

-- Procedimiento para resetear intentos fallidos
CREATE PROCEDURE [dbo].[sp_ResetearIntentosFallidos]
    @Usuario NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    
    UPDATE tbUsuarios SET
        IntentosFallidos = 0,
        BloqueadoHasta = NULL
    WHERE Usuario = @Usuario;
END
GO

-- Procedimiento para verificar si usuario está bloqueado
CREATE PROCEDURE [dbo].[sp_VerificarUsuarioBloqueado]
    @Usuario NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        IntentosFallidos,
        BloqueadoHasta,
        CASE 
            WHEN BloqueadoHasta IS NOT NULL AND BloqueadoHasta > GETDATE() 
            THEN 'BLOQUEADO'
            ELSE 'ACTIVO'
        END AS EstadoBloqueo
    FROM tbUsuarios 
    WHERE Usuario = @Usuario;
END
GO

-- Procedimiento para obtener estadísticas de usuarios
CREATE PROCEDURE [dbo].[sp_ObtenerEstadisticasUsuarios]
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        COUNT(*) AS TotalUsuarios,
        SUM(CASE WHEN Estado = 'Activo' THEN 1 ELSE 0 END) AS UsuariosActivos,
        SUM(CASE WHEN Estado = 'Inactivo' THEN 1 ELSE 0 END) AS UsuariosInactivos,
        SUM(CASE WHEN UltimoAcceso IS NULL THEN 1 ELSE 0 END) AS UsuariosSinAcceso,
        SUM(CASE WHEN BloqueadoHasta IS NOT NULL AND BloqueadoHasta > GETDATE() THEN 1 ELSE 0 END) AS UsuariosBloqueados
    FROM tbUsuarios;
END
GO

-- Procedimiento para obtener usuarios por departamento
CREATE PROCEDURE [dbo].[sp_ObtenerUsuariosPorDepartamento]
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        d.Nombre AS Departamento,
        COUNT(u.Id) AS CantidadUsuarios,
        SUM(CASE WHEN u.Estado = 'Activo' THEN 1 ELSE 0 END) AS UsuariosActivos
    FROM tbDepartamentos d
    LEFT JOIN tbUsuarios u ON d.Id = u.Departamento
    WHERE d.Activo = 1
    GROUP BY d.Id, d.Nombre
    ORDER BY d.Nombre;
END
GO

-- Procedimiento para obtener usuarios por rol
CREATE PROCEDURE [dbo].[sp_ObtenerUsuariosPorRol]
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        r.Nombre AS Rol,
        COUNT(u.Id) AS CantidadUsuarios,
        SUM(CASE WHEN u.Estado = 'Activo' THEN 1 ELSE 0 END) AS UsuariosActivos
    FROM tbRoles r
    LEFT JOIN tbUsuarios u ON r.Id = u.Rol
    WHERE r.Activo = 1
    GROUP BY r.Id, r.Nombre
    ORDER BY r.Nombre;
END
GO


