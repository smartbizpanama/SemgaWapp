-- =============================================
-- Trigger de Auditoría para tbBeneficiarios
-- Captura todos los cambios: INSERT, UPDATE, SOFT DELETE, DELETE FÍSICO
-- Códigos: I=INSERT, U=UPDATE, D=SOFT DELETE, X=DELETE FÍSICO
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
    
    -- Obtener información del servidor
    SET @ServidorInfo = dbo.fnAuditoria_ObtenerInfoServidor()
    
    -- Procesar registros afectados
    IF @Operacion = 'I' -- INSERT
    BEGIN
        -- Para INSERT, solo hay estado posterior
        DECLARE insert_cursor CURSOR FOR
        SELECT 
            CAST(IDBeneficiario AS NVARCHAR(50)) as RegistroId,
            ISNULL(UsuarioCrea, 0) as UsuarioId,
            '{"IDBeneficiario":' + CAST(IDBeneficiario AS NVARCHAR(10)) +
            ',"NumeroAsociado":' + CAST(ISNULL(NumeroAsociado, 0) AS NVARCHAR(10)) +
            ',"Nombre":"' + ISNULL(Nombre, '') + '"' +
            ',"Apellido":"' + ISNULL(Apellido, '') + '"' +
            ',"TipoIdentificacion":"' + ISNULL(TipoIdentificacion, '') + '"' +
            ',"NumeroIdentificacion":"' + ISNULL(NumeroIdentificacion, '') + '"' +
            ',"IDParentezco":' + CAST(ISNULL(IDParentezco, 0) AS NVARCHAR(10)) +
            ',"Porcentaje":' + CAST(ISNULL(Porcentaje, 0) AS NVARCHAR(10)) +
            ',"snEliminado":' + CASE WHEN snEliminado = 1 THEN 'true' ELSE 'false' END +
            ',"UsuarioCrea":' + CAST(ISNULL(UsuarioCrea, 0) AS NVARCHAR(10)) +
            ',"FechaHoraCrea":"' + ISNULL(CONVERT(NVARCHAR(23), FechaHoraCrea, 126), '') + '"' +
            ',"UsuarioModifica":' + CAST(ISNULL(UsuarioModifica, 0) AS NVARCHAR(10)) +
            ',"FechaModifica":"' + ISNULL(CONVERT(NVARCHAR(23), FechaModifica, 126), '') + '"' +
            ',"UsuarioElimina":' + CAST(ISNULL(UsuarioElimina, 0) AS NVARCHAR(10)) +
            ',"FechaElimina":"' + ISNULL(CONVERT(NVARCHAR(23), FechaElimina, 126), '') + '"' +
            '}' as JsonPosterior
        FROM inserted
        
        OPEN insert_cursor
        FETCH NEXT FROM insert_cursor INTO @RegistroId, @UsuarioId, @JsonPosterior
        
        WHILE @@FETCH_STATUS = 0
        BEGIN
            SET @Comentarios = 'Registro creado - Nuevo beneficiario'
            
            INSERT INTO tbLogsAuditoria (
                TablaAfectada, RegistroId, Operacion, UsuarioId, FechaHora,
                JsonPrevio, JsonPosterior, ServidorInfo, Comentarios
            ) VALUES (
                'tbBeneficiarios', @RegistroId, @Operacion, @UsuarioId, GETDATE(),
                NULL, @JsonPosterior, @ServidorInfo, @Comentarios
            )
            
            FETCH NEXT FROM insert_cursor INTO @RegistroId, @UsuarioId, @JsonPosterior
        END
        
        CLOSE insert_cursor
        DEALLOCATE insert_cursor
    END
    
    ELSE IF @Operacion = 'U' -- UPDATE normal
    BEGIN
        -- Para UPDATE normal, hay estado anterior y posterior
        DECLARE update_cursor CURSOR FOR
        SELECT 
            CAST(i.IDBeneficiario AS NVARCHAR(50)) as RegistroId,
            ISNULL(i.UsuarioModifica, 0) as UsuarioId,
            -- Estado anterior (deleted)
            '{"IDBeneficiario":' + CAST(d.IDBeneficiario AS NVARCHAR(10)) +
            ',"NumeroAsociado":' + CAST(ISNULL(d.NumeroAsociado, 0) AS NVARCHAR(10)) +
            ',"Nombre":"' + ISNULL(d.Nombre, '') + '"' +
            ',"Apellido":"' + ISNULL(d.Apellido, '') + '"' +
            ',"TipoIdentificacion":"' + ISNULL(d.TipoIdentificacion, '') + '"' +
            ',"NumeroIdentificacion":"' + ISNULL(d.NumeroIdentificacion, '') + '"' +
            ',"IDParentezco":' + CAST(ISNULL(d.IDParentezco, 0) AS NVARCHAR(10)) +
            ',"Porcentaje":' + CAST(ISNULL(d.Porcentaje, 0) AS NVARCHAR(10)) +
            ',"snEliminado":' + CASE WHEN d.snEliminado = 1 THEN 'true' ELSE 'false' END +
            ',"UsuarioCrea":' + CAST(ISNULL(d.UsuarioCrea, 0) AS NVARCHAR(10)) +
            ',"FechaHoraCrea":"' + ISNULL(CONVERT(NVARCHAR(23), d.FechaHoraCrea, 126), '') + '"' +
            ',"UsuarioModifica":' + CAST(ISNULL(d.UsuarioModifica, 0) AS NVARCHAR(10)) +
            ',"FechaModifica":"' + ISNULL(CONVERT(NVARCHAR(23), d.FechaModifica, 126), '') + '"' +
            ',"UsuarioElimina":' + CAST(ISNULL(d.UsuarioElimina, 0) AS NVARCHAR(10)) +
            ',"FechaElimina":"' + ISNULL(CONVERT(NVARCHAR(23), d.FechaElimina, 126), '') + '"' +
            '}' as JsonPrevio,
            -- Estado posterior (inserted)
            '{"IDBeneficiario":' + CAST(i.IDBeneficiario AS NVARCHAR(10)) +
            ',"NumeroAsociado":' + CAST(ISNULL(i.NumeroAsociado, 0) AS NVARCHAR(10)) +
            ',"Nombre":"' + ISNULL(i.Nombre, '') + '"' +
            ',"Apellido":"' + ISNULL(i.Apellido, '') + '"' +
            ',"TipoIdentificacion":"' + ISNULL(i.TipoIdentificacion, '') + '"' +
            ',"NumeroIdentificacion":"' + ISNULL(i.NumeroIdentificacion, '') + '"' +
            ',"IDParentezco":' + CAST(ISNULL(i.IDParentezco, 0) AS NVARCHAR(10)) +
            ',"Porcentaje":' + CAST(ISNULL(i.Porcentaje, 0) AS NVARCHAR(10)) +
            ',"snEliminado":' + CASE WHEN i.snEliminado = 1 THEN 'true' ELSE 'false' END +
            ',"UsuarioCrea":' + CAST(ISNULL(i.UsuarioCrea, 0) AS NVARCHAR(10)) +
            ',"FechaHoraCrea":"' + ISNULL(CONVERT(NVARCHAR(23), i.FechaHoraCrea, 126), '') + '"' +
            ',"UsuarioModifica":' + CAST(ISNULL(i.UsuarioModifica, 0) AS NVARCHAR(10)) +
            ',"FechaModifica":"' + ISNULL(CONVERT(NVARCHAR(23), i.FechaModifica, 126), '') + '"' +
            ',"UsuarioElimina":' + CAST(ISNULL(i.UsuarioElimina, 0) AS NVARCHAR(10)) +
            ',"FechaElimina":"' + ISNULL(CONVERT(NVARCHAR(23), i.FechaElimina, 126), '') + '"' +
            '}' as JsonPosterior
        FROM inserted i
        INNER JOIN deleted d ON i.IDBeneficiario = d.IDBeneficiario
        
        OPEN update_cursor
        FETCH NEXT FROM update_cursor INTO @RegistroId, @UsuarioId, @JsonPrevio, @JsonPosterior
        
        WHILE @@FETCH_STATUS = 0
        BEGIN
            SET @Comentarios = 'Registro actualizado - Modificación de datos'
            
            INSERT INTO tbLogsAuditoria (
                TablaAfectada, RegistroId, Operacion, UsuarioId, FechaHora,
                JsonPrevio, JsonPosterior, ServidorInfo, Comentarios
            ) VALUES (
                'tbBeneficiarios', @RegistroId, @Operacion, @UsuarioId, GETDATE(),
                @JsonPrevio, @JsonPosterior, @ServidorInfo, @Comentarios
            )
            
            FETCH NEXT FROM update_cursor INTO @RegistroId, @UsuarioId, @JsonPrevio, @JsonPosterior
        END
        
        CLOSE update_cursor
        DEALLOCATE update_cursor
    END
    
    ELSE IF @Operacion = 'D' -- SOFT DELETE
    BEGIN
        -- Soft delete - usar datos de inserted y deleted
        DECLARE soft_delete_cursor CURSOR FOR
        SELECT 
            CAST(i.IDBeneficiario AS NVARCHAR(50)) as RegistroId,
            ISNULL(i.UsuarioElimina, ISNULL(i.UsuarioModifica, 0)) as UsuarioId,
            -- Estado anterior (deleted - antes del soft delete)
            '{"IDBeneficiario":' + CAST(d.IDBeneficiario AS NVARCHAR(10)) +
            ',"NumeroAsociado":' + CAST(ISNULL(d.NumeroAsociado, 0) AS NVARCHAR(10)) +
            ',"Nombre":"' + ISNULL(d.Nombre, '') + '"' +
            ',"Apellido":"' + ISNULL(d.Apellido, '') + '"' +
            ',"TipoIdentificacion":"' + ISNULL(d.TipoIdentificacion, '') + '"' +
            ',"NumeroIdentificacion":"' + ISNULL(d.NumeroIdentificacion, '') + '"' +
            ',"IDParentezco":' + CAST(ISNULL(d.IDParentezco, 0) AS NVARCHAR(10)) +
            ',"Porcentaje":' + CAST(ISNULL(d.Porcentaje, 0) AS NVARCHAR(10)) +
            ',"snEliminado":' + CASE WHEN d.snEliminado = 1 THEN 'true' ELSE 'false' END +
            ',"UsuarioCrea":' + CAST(ISNULL(d.UsuarioCrea, 0) AS NVARCHAR(10)) +
            ',"FechaHoraCrea":"' + ISNULL(CONVERT(NVARCHAR(23), d.FechaHoraCrea, 126), '') + '"' +
            ',"UsuarioModifica":' + CAST(ISNULL(d.UsuarioModifica, 0) AS NVARCHAR(10)) +
            ',"FechaModifica":"' + ISNULL(CONVERT(NVARCHAR(23), d.FechaModifica, 126), '') + '"' +
            ',"UsuarioElimina":' + CAST(ISNULL(d.UsuarioElimina, 0) AS NVARCHAR(10)) +
            ',"FechaElimina":"' + ISNULL(CONVERT(NVARCHAR(23), d.FechaElimina, 126), '') + '"' +
            '}' as JsonPrevio,
            -- Estado posterior (inserted - después del soft delete)
            '{"IDBeneficiario":' + CAST(i.IDBeneficiario AS NVARCHAR(10)) +
            ',"NumeroAsociado":' + CAST(ISNULL(i.NumeroAsociado, 0) AS NVARCHAR(10)) +
            ',"Nombre":"' + ISNULL(i.Nombre, '') + '"' +
            ',"Apellido":"' + ISNULL(i.Apellido, '') + '"' +
            ',"TipoIdentificacion":"' + ISNULL(i.TipoIdentificacion, '') + '"' +
            ',"NumeroIdentificacion":"' + ISNULL(i.NumeroIdentificacion, '') + '"' +
            ',"IDParentezco":' + CAST(ISNULL(i.IDParentezco, 0) AS NVARCHAR(10)) +
            ',"Porcentaje":' + CAST(ISNULL(i.Porcentaje, 0) AS NVARCHAR(10)) +
            ',"snEliminado":' + CASE WHEN i.snEliminado = 1 THEN 'true' ELSE 'false' END +
            ',"UsuarioCrea":' + CAST(ISNULL(i.UsuarioCrea, 0) AS NVARCHAR(10)) +
            ',"FechaHoraCrea":"' + ISNULL(CONVERT(NVARCHAR(23), i.FechaHoraCrea, 126), '') + '"' +
            ',"UsuarioModifica":' + CAST(ISNULL(i.UsuarioModifica, 0) AS NVARCHAR(10)) +
            ',"FechaModifica":"' + ISNULL(CONVERT(NVARCHAR(23), i.FechaModifica, 126), '') + '"' +
            ',"UsuarioElimina":' + CAST(ISNULL(i.UsuarioElimina, 0) AS NVARCHAR(10)) +
            ',"FechaElimina":"' + ISNULL(CONVERT(NVARCHAR(23), i.FechaElimina, 126), '') + '"' +
            '}' as JsonPosterior
        FROM inserted i
        INNER JOIN deleted d ON i.IDBeneficiario = d.IDBeneficiario
        
        OPEN soft_delete_cursor
        FETCH NEXT FROM soft_delete_cursor INTO @RegistroId, @UsuarioId, @JsonPrevio, @JsonPosterior
        
        WHILE @@FETCH_STATUS = 0
        BEGIN
            SET @Comentarios = 'Registro eliminado - Soft delete aplicado'
            
            INSERT INTO tbLogsAuditoria (
                TablaAfectada, RegistroId, Operacion, UsuarioId, FechaHora,
                JsonPrevio, JsonPosterior, ServidorInfo, Comentarios
            ) VALUES (
                'tbBeneficiarios', @RegistroId, @Operacion, @UsuarioId, GETDATE(),
                @JsonPrevio, @JsonPosterior, @ServidorInfo, @Comentarios
            )
            
            FETCH NEXT FROM soft_delete_cursor INTO @RegistroId, @UsuarioId, @JsonPrevio, @JsonPosterior
        END
        
        CLOSE soft_delete_cursor
        DEALLOCATE soft_delete_cursor
    END
    
    ELSE IF @Operacion = 'X' -- DELETE FÍSICO
    BEGIN
        -- Delete físico - usar solo datos de deleted
        DECLARE delete_cursor CURSOR FOR
        SELECT 
            CAST(IDBeneficiario AS NVARCHAR(50)) as RegistroId,
            ISNULL(UsuarioModifica, 0) as UsuarioId,
            '{"IDBeneficiario":' + CAST(IDBeneficiario AS NVARCHAR(10)) +
            ',"NumeroAsociado":' + CAST(ISNULL(NumeroAsociado, 0) AS NVARCHAR(10)) +
            ',"Nombre":"' + ISNULL(Nombre, '') + '"' +
            ',"Apellido":"' + ISNULL(Apellido, '') + '"' +
            ',"TipoIdentificacion":"' + ISNULL(TipoIdentificacion, '') + '"' +
            ',"NumeroIdentificacion":"' + ISNULL(NumeroIdentificacion, '') + '"' +
            ',"IDParentezco":' + CAST(ISNULL(IDParentezco, 0) AS NVARCHAR(10)) +
            ',"Porcentaje":' + CAST(ISNULL(Porcentaje, 0) AS NVARCHAR(10)) +
            ',"snEliminado":' + CASE WHEN snEliminado = 1 THEN 'true' ELSE 'false' END +
            ',"UsuarioCrea":' + CAST(ISNULL(UsuarioCrea, 0) AS NVARCHAR(10)) +
            ',"FechaHoraCrea":"' + ISNULL(CONVERT(NVARCHAR(23), FechaHoraCrea, 126), '') + '"' +
            ',"UsuarioModifica":' + CAST(ISNULL(UsuarioModifica, 0) AS NVARCHAR(10)) +
            ',"FechaModifica":"' + ISNULL(CONVERT(NVARCHAR(23), FechaModifica, 126), '') + '"' +
            ',"UsuarioElimina":' + CAST(ISNULL(UsuarioElimina, 0) AS NVARCHAR(10)) +
            ',"FechaElimina":"' + ISNULL(CONVERT(NVARCHAR(23), FechaElimina, 126), '') + '"' +
            '}' as JsonPrevio
        FROM deleted
        
        OPEN delete_cursor
        FETCH NEXT FROM delete_cursor INTO @RegistroId, @UsuarioId, @JsonPrevio
        
        WHILE @@FETCH_STATUS = 0
        BEGIN
            SET @JsonPosterior = '{"Estado":"ELIMINADO_FISICAMENTE","snEliminado":true}'
            SET @Comentarios = 'Registro eliminado físicamente'
            
            INSERT INTO tbLogsAuditoria (
                TablaAfectada, RegistroId, Operacion, UsuarioId, FechaHora,
                JsonPrevio, JsonPosterior, ServidorInfo, Comentarios
            ) VALUES (
                'tbBeneficiarios', @RegistroId, @Operacion, @UsuarioId, GETDATE(),
                @JsonPrevio, @JsonPosterior, @ServidorInfo, @Comentarios
            )
            
            FETCH NEXT FROM delete_cursor INTO @RegistroId, @UsuarioId, @JsonPrevio
        END
        
        CLOSE delete_cursor
        DEALLOCATE delete_cursor
    END
END
GO

PRINT 'Trigger tr_Auditoria_tbBeneficiarios creado exitosamente'
PRINT 'Captura: INSERT (I), UPDATE (U), SOFT DELETE (D), DELETE FÍSICO (X)'
PRINT 'Campos: Todos los 15 campos de tbBeneficiarios'
PRINT 'JSON: Estado anterior y posterior completo'
PRINT 'Códigos: D=Soft Delete, X=Delete Físico'
GO

