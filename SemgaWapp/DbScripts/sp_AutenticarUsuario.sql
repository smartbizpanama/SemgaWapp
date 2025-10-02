
-- =============================================
-- Procedimiento para autenticación de usuarios
-- =============================================
ALTER PROCEDURE dbo.sp_AutenticarUsuario
    @Usuario NVARCHAR(50),
    @Clave NVARCHAR(255),
    @DireccionIP NVARCHAR(45) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @UsuarioId INT = NULL;
    DECLARE @IntentosFallidos INT = 0;
    DECLARE @Estado NVARCHAR(20) = '';
    DECLARE @MaxIntentos INT = 3;
    DECLARE @ClaveAlmacenada NVARCHAR(255) = '';
    DECLARE @ClaveCorrecta BIT = 0;
    DECLARE @Ahora DATETIME = GETDATE();
    
    -- Obtener configuración de intentos máximos
    SELECT @MaxIntentos = CAST(Valor AS INT) 
    FROM tbConfiguraciones 
    WHERE Clave = 'Seguridad.IntentosMaximos';
    
    IF @MaxIntentos IS NULL
        SET @MaxIntentos = 3;
    
    -- Verificar si el usuario existe y obtener información
    SELECT 
        @UsuarioId = Id,
        @IntentosFallidos = IntentosFallidos,
        @Estado = Estado,
        @ClaveAlmacenada = Clave
    FROM tbUsuarios 
    WHERE Usuario = @Usuario;
    
    -- Si el usuario no existe, retornar error
    IF @UsuarioId IS NULL
    BEGIN
        -- Registrar intento fallido (usuario no existe)
        EXEC dbo.sp_RegistrarIntentoLogin 
            @Usuario = @Usuario,
            @Exitoso = 0,
            @Mensaje = 'Usuario no existe',
            @DireccionIP = @DireccionIP;
        
        SELECT 
            'Error' AS Resultado,
            'Usuario o contraseña incorrecto' AS Mensaje,
            NULL AS UsuarioId,
            NULL AS Nombre,
            NULL AS Apellido,
            NULL AS NombreUsuario,
            NULL AS Email,
            NULL AS Rol,
            NULL AS Departamento,
            NULL AS NivelAcceso,
            NULL AS RolNombre,
            NULL AS DepartamentoNombre;
        RETURN;
    END
    
    -- Verificar si el usuario está bloqueado
    IF @IntentosFallidos >= @MaxIntentos
    BEGIN
        -- Registrar intento fallido (usuario bloqueado)
        EXEC dbo.sp_RegistrarIntentoLogin 
            @Usuario = @Usuario,
            @Exitoso = 0,
            @Mensaje = 'Usuario bloqueado',
            @DireccionIP = @DireccionIP;
        
        SELECT 
            'Error' AS Resultado,
            'Usuario bloqueado por intentos fallidos' AS Mensaje,
            NULL AS UsuarioId,
            NULL AS Nombre,
            NULL AS Apellido,
            NULL AS NombreUsuario,
            NULL AS Email,
            NULL AS Rol,
            NULL AS Departamento,
            NULL AS NivelAcceso,
            NULL AS RolNombre,
            NULL AS DepartamentoNombre;
        RETURN;
    END
    
    -- Verificar si el usuario está activo
    IF @Estado <> 'Activo'
    BEGIN
        -- Registrar intento fallido (usuario inactivo)
        EXEC dbo.sp_RegistrarIntentoLogin 
            @Usuario = @Usuario,
            @Exitoso = 0,
            @Mensaje = 'Usuario inactivo',
            @DireccionIP = @DireccionIP;
        
        SELECT 
            'Error' AS Resultado,
            'Usuario inactivo' AS Mensaje,
            NULL AS UsuarioId,
            NULL AS Nombre,
            NULL AS Apellido,
            NULL AS NombreUsuario,
            NULL AS Email,
            NULL AS Rol,
            NULL AS Departamento,
            NULL AS NivelAcceso,
            NULL AS RolNombre,
            NULL AS DepartamentoNombre;
        RETURN;
    END
    
    -- Verificar contraseña (aquí debes implementar tu lógica de comparación)
    -- EJEMPLO: Si usas hash, deberías comparar el hash de @Clave con @ClaveAlmacenada
    SET @ClaveCorrecta = CASE 
        WHEN @ClaveAlmacenada = @Clave THEN 1 
        ELSE 0 
    END;
    
    -- Si la contraseña es incorrecta
    IF @ClaveCorrecta = 0
    BEGIN
        -- Incrementar intentos fallidos
        UPDATE tbUsuarios 
        SET IntentosFallidos = IntentosFallidos + 1,
            FechaModificacion = @Ahora
        WHERE Id = @UsuarioId;
        
        -- Registrar intento fallido
        EXEC dbo.sp_RegistrarIntentoLogin 
            @Usuario = @Usuario,
            @Exitoso = 0,
            @Mensaje = 'Contraseña incorrecta',
            @DireccionIP = @DireccionIP;
        
        SELECT 
            'Error' AS Resultado,
            'Usuario o contraseña incorrecto' AS Mensaje,
            NULL AS UsuarioId,
            NULL AS Nombre,
            NULL AS Apellido,
            NULL AS NombreUsuario,
            NULL AS Email,
            NULL AS Rol,
            NULL AS Departamento,
            NULL AS NivelAcceso,
            NULL AS RolNombre,
            NULL AS DepartamentoNombre;
        RETURN;
    END
    
    -- Si la contraseña es correcta
    BEGIN
        -- Reiniciar intentos fallidos y actualizar último acceso
        UPDATE tbUsuarios 
        SET IntentosFallidos = 0,
            UltimoAcceso = @Ahora,
            FechaModificacion = @Ahora
        WHERE Id = @UsuarioId;
        
        -- Registrar acceso exitoso
        EXEC dbo.sp_RegistrarIntentoLogin 
            @Usuario = @Usuario,
            @Exitoso = 1,
            @Mensaje = 'Acceso exitoso',
            @DireccionIP = @DireccionIP;
        
        -- Retornar datos del usuario (SIN LA CONTRASEÑA)
        SELECT 
            'Exito' AS Resultado,
            'Usuario autenticado correctamente' AS Mensaje,
            u.Id AS UsuarioId,
            u.Nombre,
            u.Apellido,
            u.Usuario AS NombreUsuario,
            u.Email,
            u.Rol,
            u.Departamento,
            r.NivelAcceso,
            r.Nombre AS RolNombre,
            d.Nombre AS DepartamentoNombre
        FROM tbUsuarios u
        INNER JOIN tbRoles r ON u.Rol = r.Id
        LEFT JOIN tbDepartamentos d ON u.Departamento = d.Id
        WHERE u.Id = @UsuarioId;
    END
END
GO