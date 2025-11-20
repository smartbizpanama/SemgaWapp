-- =============================================
-- Trigger de Auditoría para tbBeneficiarios con SessionInfo desde tbLogSesionHdr
-- Captura todos los cambios: INSERT, UPDATE, DELETE
-- Obtiene información de sesión desde tbLogSesionHdr usando IdSession
-- =============================================

USE [SegmaDB]
GO

-- Eliminar trigger si existe
IF EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[tr_Auditoria_tbBeneficiarios]'))
    DROP TRIGGER [dbo].[tr_Auditoria_tbBeneficiarios]
GO

CREATE TRIGGER [dbo].[tr_Auditoria_tbBeneficiarios]
ON [dbo].[tbBeneficiarios]
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @Operacion CHAR(1)
    DECLARE @UsuarioId INT
    DECLARE @RegistroId NVARCHAR(50)
    DECLARE @JsonPrevio NVARCHAR(MAX)
    DECLARE @JsonPosterior NVARCHAR(MAX)
    DECLARE @ServidorInfo NVARCHAR(MAX)
    DECLARE @Comentarios NVARCHAR(500)
    DECLARE @IdSession NVARCHAR(50)
    
    -- Determinar tipo de operación
    IF EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted)
    BEGIN
        -- Verificar si es un soft delete (snEliminado cambia de 0 a 1)
        IF EXISTS (SELECT 1 FROM inserted i 
                   INNER JOIN deleted d ON i.IDBeneficiario = d.IDBeneficiario 
                   WHERE d.snEliminado = 0 AND i.snEliminado = 1)
            SET @Operacion = 'D' -- SOFT DELETE
        ELSE
            SET @Operacion = 'U' -- UPDATE normal
    END
    ELSE IF EXISTS (SELECT * FROM inserted)
        SET @Operacion = 'I' -- INSERT
    ELSE
        SET @Operacion = 'X' -- DELETE físico
    
    -- No obtener información del servidor - solo usar SessionInfo
    
    -- Procesar registros afectados
    IF @Operacion = 'I' -- INSERT
    BEGIN
        DECLARE insert_cursor CURSOR FOR
        SELECT 
            i.IDBeneficiario,
            i.UsuarioCrea,
            i.SysLastSessionID
        FROM inserted i
        
        OPEN insert_cursor
        FETCH NEXT FROM insert_cursor INTO @RegistroId, @UsuarioId, @IdSession
        
        WHILE @@FETCH_STATUS = 0
        BEGIN
            -- Obtener SessionInfo desde tbLogSesionHdr
            DECLARE @SessionInfo NVARCHAR(MAX) = ''
            IF @IdSession IS NOT NULL AND @IdSession != ''
            BEGIN
                SELECT @SessionInfo = ISNULL(SessionInfo, '') 
                FROM tbLogSesionHdr 
                WHERE IDSesion = @IdSession
            END
            
            -- Si no se encuentra SessionInfo, usar información básica
            IF @SessionInfo = '' OR @SessionInfo IS NULL
            BEGIN
                SET @SessionInfo = '{"Usuario":"' + ISNULL(CAST(@UsuarioId AS NVARCHAR(10)), '0') + '","IdSession":"' + ISNULL(@IdSession, '') + '","Timestamp":"' + CONVERT(NVARCHAR(23), GETDATE(), 126) + '","Nota":"SessionInfo no encontrado en tbLogSesionHdr"}'
            END
            
            -- Usar únicamente SessionInfo
            SET @ServidorInfo = @SessionInfo
            
            -- Serializar datos posteriores (nuevo registro)
            SET @JsonPosterior = dbo.fnAuditoria_SerializarFila('tbBeneficiarios', @RegistroId)
            SET @JsonPrevio = NULL
            
            -- Insertar en tabla de auditoría
            INSERT INTO tbLogsAuditoria (
                TablaAfectada, RegistroId, Operacion, UsuarioId, FechaHora,
                JsonPrevio, JsonPosterior, ServidorInfo, Comentarios
            )
            VALUES (
                'tbBeneficiarios', @RegistroId, @Operacion, @UsuarioId, GETDATE(),
                @JsonPrevio, @JsonPosterior, @ServidorInfo, 'Registro creado'
            )
            
            FETCH NEXT FROM insert_cursor INTO @RegistroId, @UsuarioId, @IdSession
        END
        
        CLOSE insert_cursor
        DEALLOCATE insert_cursor
    END
    ELSE IF @Operacion = 'U' -- UPDATE
    BEGIN
        DECLARE update_cursor CURSOR FOR
        SELECT 
            i.IDBeneficiario,
            i.UsuarioModifica,
            i.SysLastSessionID
        FROM inserted i
        
        OPEN update_cursor
        FETCH NEXT FROM update_cursor INTO @RegistroId, @UsuarioId, @IdSession
        
        WHILE @@FETCH_STATUS = 0
        BEGIN
            -- Obtener SessionInfo desde tbLogSesionHdr
            DECLARE @SessionInfoUpdate NVARCHAR(MAX) = ''
            IF @IdSession IS NOT NULL AND @IdSession != ''
            BEGIN
                SELECT @SessionInfoUpdate = ISNULL(SessionInfo, '') 
                FROM tbLogSesionHdr 
                WHERE IDSesion = @IdSession
            END
            
            -- Si no se encuentra SessionInfo, usar información básica
            IF @SessionInfoUpdate = '' OR @SessionInfoUpdate IS NULL
            BEGIN
                SET @SessionInfoUpdate = '{"Usuario":"' + ISNULL(CAST(@UsuarioId AS NVARCHAR(10)), '0') + '","IdSession":"' + ISNULL(@IdSession, '') + '","Timestamp":"' + CONVERT(NVARCHAR(23), GETDATE(), 126) + '","Nota":"SessionInfo no encontrado en tbLogSesionHdr"}'
            END
            
            -- Usar únicamente SessionInfo
            SET @ServidorInfo = @SessionInfoUpdate
            
            -- Serializar datos previos y posteriores
            SET @JsonPrevio = dbo.fnAuditoria_SerializarFila('tbBeneficiarios', @RegistroId)
            SET @JsonPosterior = dbo.fnAuditoria_SerializarFila('tbBeneficiarios', @RegistroId)
            
            -- Insertar en tabla de auditoría
            INSERT INTO tbLogsAuditoria (
                TablaAfectada, RegistroId, Operacion, UsuarioId, FechaHora,
                JsonPrevio, JsonPosterior, ServidorInfo, Comentarios
            )
            VALUES (
                'tbBeneficiarios', @RegistroId, @Operacion, @UsuarioId, GETDATE(),
                @JsonPrevio, @JsonPosterior, @ServidorInfo, 'Registro actualizado'
            )
            
            FETCH NEXT FROM update_cursor INTO @RegistroId, @UsuarioId, @IdSession
        END
        
        CLOSE update_cursor
        DEALLOCATE update_cursor
    END
    ELSE IF @Operacion = 'D' -- SOFT DELETE
    BEGIN
        DECLARE soft_delete_cursor CURSOR FOR
        SELECT 
            i.IDBeneficiario,
            i.UsuarioElimina,
            i.SysLastSessionID
        FROM inserted i
        
        OPEN soft_delete_cursor
        FETCH NEXT FROM soft_delete_cursor INTO @RegistroId, @UsuarioId, @IdSession
        
        WHILE @@FETCH_STATUS = 0
        BEGIN
            -- Obtener SessionInfo desde tbLogSesionHdr
            DECLARE @SessionInfoSoftDelete NVARCHAR(MAX) = ''
            IF @IdSession IS NOT NULL AND @IdSession != ''
            BEGIN
                SELECT @SessionInfoSoftDelete = ISNULL(SessionInfo, '') 
                FROM tbLogSesionHdr 
                WHERE IDSesion = @IdSession
            END
            
            -- Si no se encuentra SessionInfo, usar información básica
            IF @SessionInfoSoftDelete = '' OR @SessionInfoSoftDelete IS NULL
            BEGIN
                SET @SessionInfoSoftDelete = '{"Usuario":"' + ISNULL(CAST(@UsuarioId AS NVARCHAR(10)), '0') + '","IdSession":"' + ISNULL(@IdSession, '') + '","Timestamp":"' + CONVERT(NVARCHAR(23), GETDATE(), 126) + '","Nota":"SessionInfo no encontrado en tbLogSesionHdr"}'
            END
            
            -- Usar únicamente SessionInfo
            SET @ServidorInfo = @SessionInfoSoftDelete
            
            -- Serializar datos previos y posteriores
            SET @JsonPrevio = dbo.fnAuditoria_SerializarFila('tbBeneficiarios', @RegistroId)
            SET @JsonPosterior = dbo.fnAuditoria_SerializarFila('tbBeneficiarios', @RegistroId)
            
            -- Insertar en tabla de auditoría
            INSERT INTO tbLogsAuditoria (
                TablaAfectada, RegistroId, Operacion, UsuarioId, FechaHora,
                JsonPrevio, JsonPosterior, ServidorInfo, Comentarios
            )
            VALUES (
                'tbBeneficiarios', @RegistroId, @Operacion, @UsuarioId, GETDATE(),
                @JsonPrevio, @JsonPosterior, @ServidorInfo, 'Registro eliminado (soft delete)'
            )
            
            FETCH NEXT FROM soft_delete_cursor INTO @RegistroId, @UsuarioId, @IdSession
        END
        
        CLOSE soft_delete_cursor
        DEALLOCATE soft_delete_cursor
    END
    ELSE IF @Operacion = 'X' -- DELETE físico
    BEGIN
        DECLARE delete_cursor CURSOR FOR
        SELECT 
            d.IDBeneficiario,
            d.UsuarioElimina,
            d.SysLastSessionID
        FROM deleted d
        
        OPEN delete_cursor
        FETCH NEXT FROM delete_cursor INTO @RegistroId, @UsuarioId, @IdSession
        
        WHILE @@FETCH_STATUS = 0
        BEGIN
            -- Obtener SessionInfo desde tbLogSesionHdr
            DECLARE @SessionInfoDelete NVARCHAR(MAX) = ''
            IF @IdSession IS NOT NULL AND @IdSession != ''
            BEGIN
                SELECT @SessionInfoDelete = ISNULL(SessionInfo, '') 
                FROM tbLogSesionHdr 
                WHERE IDSesion = @IdSession
            END
            
            -- Si no se encuentra SessionInfo, usar información básica
            IF @SessionInfoDelete = '' OR @SessionInfoDelete IS NULL
            BEGIN
                SET @SessionInfoDelete = '{"Usuario":"' + ISNULL(CAST(@UsuarioId AS NVARCHAR(10)), '0') + '","IdSession":"' + ISNULL(@IdSession, '') + '","Timestamp":"' + CONVERT(NVARCHAR(23), GETDATE(), 126) + '","Nota":"SessionInfo no encontrado en tbLogSesionHdr"}'
            END
            
            -- Usar únicamente SessionInfo
            SET @ServidorInfo = @SessionInfoDelete
            
            -- Serializar datos previos (registro eliminado)
            SET @JsonPrevio = dbo.fnAuditoria_SerializarFila('tbBeneficiarios', @RegistroId)
            SET @JsonPosterior = NULL
            
            -- Insertar en tabla de auditoría
            INSERT INTO tbLogsAuditoria (
                TablaAfectada, RegistroId, Operacion, UsuarioId, FechaHora,
                JsonPrevio, JsonPosterior, ServidorInfo, Comentarios
            )
            VALUES (
                'tbBeneficiarios', @RegistroId, @Operacion, @UsuarioId, GETDATE(),
                @JsonPrevio, @JsonPosterior, @ServidorInfo, 'Registro eliminado (físico)'
            )
            
            FETCH NEXT FROM delete_cursor INTO @RegistroId, @UsuarioId, @IdSession
        END
        
        CLOSE delete_cursor
        DEALLOCATE delete_cursor
    END
END
GO

PRINT 'Trigger de auditoría para tbBeneficiarios actualizado con SessionInfo desde tbLogSesionHdr'
GO
