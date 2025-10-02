-- Script de creación de base de datos para SemgaBank
-- Aplicación bancaria segura

USE master;
GO

-- Crear la base de datos si no existe
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'SemgaBankDB')
BEGIN
    CREATE DATABASE SemgaBankDB;
END
GO

USE SemgaBankDB;
GO

-- Crear esquema de seguridad
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'Security')
BEGIN
    EXEC('CREATE SCHEMA Security');
END
GO

-- Tabla de usuarios
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Security].[Users]') AND type in (N'U'))
BEGIN
    CREATE TABLE [Security].[Users] (
        [UserID] INT IDENTITY(1,1) PRIMARY KEY,
        [Username] NVARCHAR(50) NOT NULL UNIQUE,
        [PasswordHash] NVARCHAR(256) NOT NULL,
        [Salt] NVARCHAR(128) NOT NULL,
        [IsActive] BIT NOT NULL DEFAULT 1,
        [LastPasswordChange] DATETIME NOT NULL DEFAULT GETDATE(),
        [RequirePasswordChange] BIT NOT NULL DEFAULT 0,
        [CreatedDate] DATETIME NOT NULL DEFAULT GETDATE(),
        [ModifiedDate] DATETIME NOT NULL DEFAULT GETDATE(),
        [LastLoginDate] DATETIME NULL,
        [FailedLoginCount] INT NOT NULL DEFAULT 0,
        [AccountLocked] BIT NOT NULL DEFAULT 0,
        [LockoutEndTime] DATETIME NULL,
        [Email] NVARCHAR(255) NULL,
        [PhoneNumber] NVARCHAR(20) NULL,
        [TwoFactorEnabled] BIT NOT NULL DEFAULT 0,
        [TwoFactorSecret] NVARCHAR(255) NULL
    );
END
GO

-- Tabla de intentos de login
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Security].[UserLoginAttempts]') AND type in (N'U'))
BEGIN
    CREATE TABLE [Security].[UserLoginAttempts] (
        [AttemptID] INT IDENTITY(1,1) PRIMARY KEY,
        [Username] NVARCHAR(50) NOT NULL,
        [FailedAttempts] INT NOT NULL DEFAULT 0,
        [LastAttemptTime] DATETIME NOT NULL DEFAULT GETDATE(),
        [IPAddress] NVARCHAR(45) NULL,
        [UserAgent] NVARCHAR(500) NULL,
        [IsLocked] BIT NOT NULL DEFAULT 0,
        [LockoutEndTime] DATETIME NULL
    );
END
GO

-- Tabla de bloqueos de cuenta
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Security].[UserLockouts]') AND type in (N'U'))
BEGIN
    CREATE TABLE [Security].[UserLockouts] (
        [LockoutID] INT IDENTITY(1,1) PRIMARY KEY,
        [Username] NVARCHAR(50) NOT NULL,
        [LockoutStartTime] DATETIME NOT NULL DEFAULT GETDATE(),
        [LockoutEndTime] DATETIME NOT NULL,
        [Reason] NVARCHAR(255) NULL,
        [IPAddress] NVARCHAR(45) NULL,
        [IsActive] BIT NOT NULL DEFAULT 1
    );
END
GO

-- Tabla de logs de login
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Security].[UserLoginLog]') AND type in (N'U'))
BEGIN
    CREATE TABLE [Security].[UserLoginLog] (
        [LogID] INT IDENTITY(1,1) PRIMARY KEY,
        [Username] NVARCHAR(50) NOT NULL,
        [LoginTime] DATETIME NOT NULL DEFAULT GETDATE(),
        [IPAddress] NVARCHAR(45) NULL,
        [UserAgent] NVARCHAR(500) NULL,
        [Success] BIT NOT NULL,
        [FailureReason] NVARCHAR(255) NULL,
        [SessionID] NVARCHAR(255) NULL,
        [GeographicLocation] NVARCHAR(100) NULL
    );
END
GO

-- Tabla de sesiones activas
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Security].[ActiveSessions]') AND type in (N'U'))
BEGIN
    CREATE TABLE [Security].[ActiveSessions] (
        [SessionID] NVARCHAR(255) PRIMARY KEY,
        [Username] NVARCHAR(50) NOT NULL,
        [LoginTime] DATETIME NOT NULL DEFAULT GETDATE(),
        [LastActivityTime] DATETIME NOT NULL DEFAULT GETDATE(),
        [IPAddress] NVARCHAR(45) NULL,
        [UserAgent] NVARCHAR(500) NULL,
        [IsActive] BIT NOT NULL DEFAULT 1,
        [ExpiresAt] DATETIME NOT NULL
    );
END
GO

-- Tabla de auditoría de cambios
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Security].[AuditLog]') AND type in (N'U'))
BEGIN
    CREATE TABLE [Security].[AuditLog] (
        [AuditID] INT IDENTITY(1,1) PRIMARY KEY,
        [Username] NVARCHAR(50) NOT NULL,
        [Action] NVARCHAR(100) NOT NULL,
        [TableName] NVARCHAR(100) NULL,
        [RecordID] NVARCHAR(50) NULL,
        [OldValues] NVARCHAR(MAX) NULL,
        [NewValues] NVARCHAR(MAX) NULL,
        [IPAddress] NVARCHAR(45) NULL,
        [Timestamp] DATETIME NOT NULL DEFAULT GETDATE(),
        [UserAgent] NVARCHAR(500) NULL
    );
END
GO

-- Tabla de configuración de seguridad
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Security].[SecuritySettings]') AND type in (N'U'))
BEGIN
    CREATE TABLE [Security].[SecuritySettings] (
        [SettingID] INT IDENTITY(1,1) PRIMARY KEY,
        [SettingName] NVARCHAR(100) NOT NULL UNIQUE,
        [SettingValue] NVARCHAR(500) NOT NULL,
        [Description] NVARCHAR(255) NULL,
        [IsActive] BIT NOT NULL DEFAULT 1,
        [CreatedDate] DATETIME NOT NULL DEFAULT GETDATE(),
        [ModifiedDate] DATETIME NOT NULL DEFAULT GETDATE()
    );
END
GO

-- Tabla de tokens de recuperación de contraseña
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Security].[PasswordResetTokens]') AND type in (N'U'))
BEGIN
    CREATE TABLE [Security].[PasswordResetTokens] (
        [TokenID] INT IDENTITY(1,1) PRIMARY KEY,
        [Username] NVARCHAR(50) NOT NULL,
        [Token] NVARCHAR(255) NOT NULL UNIQUE,
        [ExpiresAt] DATETIME NOT NULL,
        [IsUsed] BIT NOT NULL DEFAULT 0,
        [CreatedDate] DATETIME NOT NULL DEFAULT GETDATE(),
        [IPAddress] NVARCHAR(45) NULL
    );
END
GO

-- Crear índices para mejorar el rendimiento
CREATE INDEX IX_Users_Username ON [Security].[Users] ([Username]);
CREATE INDEX IX_UserLoginAttempts_Username ON [Security].[UserLoginAttempts] ([Username]);
CREATE INDEX IX_UserLockouts_Username ON [Security].[UserLockouts] ([Username]);
CREATE INDEX IX_UserLoginLog_Username ON [Security].[UserLoginLog] ([Username]);
CREATE INDEX IX_UserLoginLog_LoginTime ON [Security].[UserLoginLog] ([LoginTime]);
CREATE INDEX IX_ActiveSessions_SessionID ON [Security].[ActiveSessions] ([SessionID]);
CREATE INDEX IX_ActiveSessions_Username ON [Security].[ActiveSessions] ([Username]);
CREATE INDEX IX_AuditLog_Username ON [Security].[AuditLog] ([Username]);
CREATE INDEX IX_AuditLog_Timestamp ON [Security].[AuditLog] ([Timestamp]);
CREATE INDEX IX_PasswordResetTokens_Token ON [Security].[PasswordResetTokens] ([Token]);
CREATE INDEX IX_PasswordResetTokens_Username ON [Security].[PasswordResetTokens] ([Username]);

-- Insertar configuraciones de seguridad por defecto
IF NOT EXISTS (SELECT * FROM [Security].[SecuritySettings] WHERE SettingName = 'MaxLoginAttempts')
BEGIN
    INSERT INTO [Security].[SecuritySettings] (SettingName, SettingValue, Description)
    VALUES 
        ('MaxLoginAttempts', '3', 'Número máximo de intentos de login antes del bloqueo'),
        ('SessionTimeoutMinutes', '15', 'Timeout de sesión en minutos'),
        ('PasswordMinLength', '8', 'Longitud mínima de contraseña'),
        ('PasswordExpiryDays', '90', 'Días de expiración de contraseña'),
        ('LockoutDurationMinutes', '30', 'Duración del bloqueo de cuenta en minutos'),
        ('EnableTwoFactorAuth', 'true', 'Habilitar autenticación de dos factores'),
        ('RequirePasswordChange', 'false', 'Requerir cambio de contraseña en próximo login'),
        ('EnableAccountLockout', 'true', 'Habilitar bloqueo de cuenta'),
        ('LogRetentionDays', '365', 'Días de retención de logs'),
        ('MaxConcurrentSessions', '3', 'Máximo número de sesiones concurrentes por usuario');
END
GO

-- Crear procedimientos almacenados para operaciones de seguridad

-- Procedimiento para validar credenciales
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Security].[sp_ValidateCredentials]') AND type in (N'P', N'PC'))
    DROP PROCEDURE [Security].[sp_ValidateCredentials]
GO

CREATE PROCEDURE [Security].[sp_ValidateCredentials]
    @Username NVARCHAR(50),
    @PasswordHash NVARCHAR(256),
    @IPAddress NVARCHAR(45) = NULL,
    @UserAgent NVARCHAR(500) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @UserID INT = NULL;
    DECLARE @IsActive BIT = 0;
    DECLARE @RequirePasswordChange BIT = 0;
    DECLARE @LastPasswordChange DATETIME = NULL;
    DECLARE @IsLocked BIT = 0;
    DECLARE @LockoutEndTime DATETIME = NULL;
    
    -- Verificar si la cuenta está bloqueada
    SELECT @IsLocked = 1, @LockoutEndTime = LockoutEndTime
    FROM [Security].[UserLockouts]
    WHERE Username = @Username 
    AND LockoutEndTime > GETDATE()
    AND IsActive = 1;
    
    IF @IsLocked = 1
    BEGIN
        -- Registrar intento fallido por cuenta bloqueada
        INSERT INTO [Security].[UserLoginLog] (Username, IPAddress, UserAgent, Success, FailureReason)
        VALUES (@Username, @IPAddress, @UserAgent, 0, 'Account locked until ' + CONVERT(VARCHAR, @LockoutEndTime, 120));
        
        SELECT 'LOCKED' AS Status, @LockoutEndTime AS LockoutEndTime;
        RETURN;
    END
    
    -- Obtener información del usuario
    SELECT @UserID = UserID, 
           @IsActive = IsActive,
           @RequirePasswordChange = RequirePasswordChange,
           @LastPasswordChange = LastPasswordChange
    FROM [Security].[Users]
    WHERE Username = @Username;
    
    -- Verificar si el usuario existe y está activo
    IF @UserID IS NULL
    BEGIN
        INSERT INTO [Security].[UserLoginLog] (Username, IPAddress, UserAgent, Success, FailureReason)
        VALUES (@Username, @IPAddress, @UserAgent, 0, 'User not found');
        
        SELECT 'INVALID' AS Status;
        RETURN;
    END
    
    IF @IsActive = 0
    BEGIN
        INSERT INTO [Security].[UserLoginLog] (Username, IPAddress, UserAgent, Success, FailureReason)
        VALUES (@Username, @IPAddress, @UserAgent, 0, 'Account inactive');
        
        SELECT 'INACTIVE' AS Status;
        RETURN;
    END
    
    -- Verificar contraseña
    IF EXISTS (SELECT 1 FROM [Security].[Users] 
               WHERE Username = @Username AND PasswordHash = @PasswordHash)
    BEGIN
        -- Login exitoso
        UPDATE [Security].[Users] 
        SET LastLoginDate = GETDATE(), FailedLoginCount = 0
        WHERE UserID = @UserID;
        
        -- Limpiar intentos fallidos
        DELETE FROM [Security].[UserLoginAttempts] WHERE Username = @Username;
        
        -- Limpiar bloqueos
        UPDATE [Security].[UserLockouts] 
        SET IsActive = 0 
        WHERE Username = @Username;
        
        -- Registrar login exitoso
        INSERT INTO [Security].[UserLoginLog] (Username, IPAddress, UserAgent, Success)
        VALUES (@Username, @IPAddress, @UserAgent, 1);
        
        SELECT 'SUCCESS' AS Status, @RequirePasswordChange AS RequirePasswordChange;
    END
    ELSE
    BEGIN
        -- Login fallido
        INSERT INTO [Security].[UserLoginLog] (Username, IPAddress, UserAgent, Success, FailureReason)
        VALUES (@Username, @IPAddress, @UserAgent, 0, 'Invalid password');
        
        -- Incrementar contador de intentos fallidos
        IF EXISTS (SELECT 1 FROM [Security].[UserLoginAttempts] WHERE Username = @Username)
        BEGIN
            UPDATE [Security].[UserLoginAttempts] 
            SET FailedAttempts = FailedAttempts + 1, LastAttemptTime = GETDATE()
            WHERE Username = @Username;
        END
        ELSE
        BEGIN
            INSERT INTO [Security].[UserLoginAttempts] (Username, FailedAttempts, LastAttemptTime, IPAddress, UserAgent)
            VALUES (@Username, 1, GETDATE(), @IPAddress, @UserAgent);
        END
        
        SELECT 'INVALID' AS Status;
    END
END
GO

-- Procedimiento para crear sesión
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Security].[sp_CreateSession]') AND type in (N'P', N'PC'))
    DROP PROCEDURE [Security].[sp_CreateSession]
GO

CREATE PROCEDURE [Security].[sp_CreateSession]
    @SessionID NVARCHAR(255),
    @Username NVARCHAR(50),
    @IPAddress NVARCHAR(45) = NULL,
    @UserAgent NVARCHAR(500) = NULL,
    @SessionTimeoutMinutes INT = 15
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Limpiar sesiones expiradas
    DELETE FROM [Security].[ActiveSessions] 
    WHERE ExpiresAt < GETDATE() OR IsActive = 0;
    
    -- Verificar límite de sesiones concurrentes
    DECLARE @MaxSessions INT = (SELECT CAST(SettingValue AS INT) FROM [Security].[SecuritySettings] WHERE SettingName = 'MaxConcurrentSessions');
    DECLARE @CurrentSessions INT = (SELECT COUNT(*) FROM [Security].[ActiveSessions] WHERE Username = @Username AND IsActive = 1);
    
    IF @CurrentSessions >= @MaxSessions
    BEGIN
        -- Terminar la sesión más antigua
        DELETE FROM [Security].[ActiveSessions] 
        WHERE SessionID = (
            SELECT TOP 1 SessionID 
            FROM [Security].[ActiveSessions] 
            WHERE Username = @Username AND IsActive = 1 
            ORDER BY LoginTime ASC
        );
    END
    
    -- Crear nueva sesión
    INSERT INTO [Security].[ActiveSessions] (SessionID, Username, IPAddress, UserAgent, ExpiresAt)
    VALUES (@SessionID, @Username, @IPAddress, @UserAgent, DATEADD(MINUTE, @SessionTimeoutMinutes, GETDATE()));
    
    SELECT 'SUCCESS' AS Status;
END
GO

-- Procedimiento para validar sesión
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Security].[sp_ValidateSession]') AND type in (N'P', N'PC'))
    DROP PROCEDURE [Security].[sp_ValidateSession]
GO

CREATE PROCEDURE [Security].[sp_ValidateSession]
    @SessionID NVARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @Username NVARCHAR(50) = NULL;
    DECLARE @IsActive BIT = 0;
    
    SELECT @Username = Username, @IsActive = IsActive
    FROM [Security].[ActiveSessions]
    WHERE SessionID = @SessionID 
    AND ExpiresAt > GETDATE()
    AND IsActive = 1;
    
    IF @Username IS NOT NULL
    BEGIN
        -- Actualizar última actividad
        UPDATE [Security].[ActiveSessions]
        SET LastActivityTime = GETDATE()
        WHERE SessionID = @SessionID;
        
        SELECT 'VALID' AS Status, @Username AS Username;
    END
    ELSE
    BEGIN
        SELECT 'INVALID' AS Status, NULL AS Username;
    END
END
GO

-- Procedimiento para terminar sesión
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Security].[sp_TerminateSession]') AND type in (N'P', N'PC'))
    DROP PROCEDURE [Security].[sp_TerminateSession]
GO

CREATE PROCEDURE [Security].[sp_TerminateSession]
    @SessionID NVARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;
    
    UPDATE [Security].[ActiveSessions]
    SET IsActive = 0
    WHERE SessionID = @SessionID;
    
    SELECT 'SUCCESS' AS Status;
END
GO

-- Procedimiento para limpiar logs antiguos
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Security].[sp_CleanupOldLogs]') AND type in (N'P', N'PC'))
    DROP PROCEDURE [Security].[sp_CleanupOldLogs]
GO

CREATE PROCEDURE [Security].[sp_CleanupOldLogs]
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @RetentionDays INT = (SELECT CAST(SettingValue AS INT) FROM [Security].[SecuritySettings] WHERE SettingName = 'LogRetentionDays');
    DECLARE @CutoffDate DATETIME = DATEADD(DAY, -@RetentionDays, GETDATE());
    
    -- Limpiar logs de login antiguos
    DELETE FROM [Security].[UserLoginLog] WHERE LoginTime < @CutoffDate;
    
    -- Limpiar logs de auditoría antiguos
    DELETE FROM [Security].[AuditLog] WHERE Timestamp < @CutoffDate;
    
    -- Limpiar tokens de recuperación expirados
    DELETE FROM [Security].[PasswordResetTokens] WHERE ExpiresAt < GETDATE();
    
    -- Limpiar sesiones expiradas
    DELETE FROM [Security].[ActiveSessions] WHERE ExpiresAt < GETDATE();
    
    SELECT 'SUCCESS' AS Status;
END
GO

-- Crear usuario de aplicación con permisos mínimos
IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = 'SemgaBankApp')
BEGIN
    CREATE USER [SemgaBankApp] WITHOUT LOGIN;
END
GO

-- Otorgar permisos al usuario de aplicación
GRANT EXECUTE ON SCHEMA::[Security] TO [SemgaBankApp];
GRANT SELECT, INSERT, UPDATE, DELETE ON [Security].[Users] TO [SemgaBankApp];
GRANT SELECT, INSERT, UPDATE, DELETE ON [Security].[UserLoginAttempts] TO [SemgaBankApp];
GRANT SELECT, INSERT, UPDATE, DELETE ON [Security].[UserLockouts] TO [SemgaBankApp];
GRANT SELECT, INSERT ON [Security].[UserLoginLog] TO [SemgaBankApp];
GRANT SELECT, INSERT, UPDATE, DELETE ON [Security].[ActiveSessions] TO [SemgaBankApp];
GRANT SELECT, INSERT ON [Security].[AuditLog] TO [SemgaBankApp];
GRANT SELECT ON [Security].[SecuritySettings] TO [SemgaBankApp];
GRANT SELECT, INSERT, UPDATE, DELETE ON [Security].[PasswordResetTokens] TO [SemgaBankApp];

-- Crear trigger para auditoría de cambios en usuarios
IF EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[Security].[tr_Users_Audit]'))
    DROP TRIGGER [Security].[tr_Users_Audit]
GO

CREATE TRIGGER [Security].[tr_Users_Audit]
ON [Security].[Users]
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    
    INSERT INTO [Security].[AuditLog] (Username, Action, TableName, RecordID, OldValues, NewValues)
    SELECT 
        SYSTEM_USER,
        'UPDATE',
        'Users',
        CAST(i.UserID AS NVARCHAR(50)),
        (SELECT Username FROM deleted WHERE UserID = i.UserID),
        i.Username
    FROM inserted i
    INNER JOIN deleted d ON i.UserID = d.UserID
    WHERE i.Username <> d.Username;
END
GO

-- Crear job para limpieza automática de logs (opcional)
-- Este job debe ser configurado en SQL Server Agent

PRINT 'Base de datos SemgaBankDB creada exitosamente con todas las tablas y procedimientos de seguridad.';
PRINT 'Recuerde configurar el usuario de aplicación en la cadena de conexión.';
PRINT 'Configure un job en SQL Server Agent para ejecutar sp_CleanupOldLogs diariamente.';




