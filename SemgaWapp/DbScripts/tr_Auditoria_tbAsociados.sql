-- =============================================
-- Trigger de Auditoría para tbAsociados
-- Captura todos los cambios: INSERT, UPDATE, DELETE
-- =============================================

USE [SegmaDB]
GO

-- Eliminar trigger si existe
IF EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[tr_Auditoria_tbAsociados]'))
    DROP TRIGGER [dbo].[tr_Auditoria_tbAsociados]
GO

CREATE TRIGGER [dbo].[tr_Auditoria_tbAsociados]
ON [dbo].[tbAsociados]
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
                   INNER JOIN deleted d ON i.NumeroAsociado = d.NumeroAsociado 
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
    
    -- El UsuarioId se obtendrá de los campos UsuarioCrea/UsuarioModifica según la operación
    
    -- Procesar registros afectados
    IF @Operacion = 'I' -- INSERT
    BEGIN
        -- Para INSERT, solo hay estado posterior
        DECLARE insert_cursor CURSOR FOR
        SELECT 
            CAST(NumeroAsociado AS NVARCHAR(50)) as RegistroId,
            ISNULL(UsuarioCrea, 0) as UsuarioId,
            '{"NumeroAsociado":' + CAST(NumeroAsociado AS NVARCHAR(10)) +
            ',"IdTipoAsociado":' + CAST(ISNULL(IdTipoAsociado, 0) AS NVARCHAR(10)) +
            ',"Nombre":"' + ISNULL(Nombre, '') + '"' +
            ',"SegundoNombre":"' + ISNULL(SegundoNombre, '') + '"' +
            ',"Apellido":"' + ISNULL(Apellido, '') + '"' +
            ',"SegundoApellido":"' + ISNULL(SegundoApellido, '') + '"' +
            ',"Estatus":"' + ISNULL(Estatus, '') + '"' +
            ',"TipoIdentificacion":"' + ISNULL(TipoIdentificacion, '') + '"' +
            ',"NumeroIdentificacion":"' + ISNULL(NumeroIdentificacion, '') + '"' +
            ',"TelefonoResidencia":"' + ISNULL(TelefonoResidencia, '') + '"' +
            ',"TelefonoCelular":"' + ISNULL(TelefonoCelular, '') + '"' +
            ',"TelefonoFamiliar":"' + ISNULL(TelefonoFamiliar, '') + '"' +
            ',"CorreoElectronico":"' + ISNULL(CorreoElectronico, '') + '"' +
            ',"Sexo":"' + ISNULL(Sexo, '') + '"' +
            ',"FechaNacimiento":"' + ISNULL(CONVERT(NVARCHAR(10), FechaNacimiento, 120), '') + '"' +
            ',"DireccionResidencia":"' + ISNULL(DireccionResidencia, '') + '"' +
            ',"DireccionTrabajo":"' + ISNULL(DireccionTrabajo, '') + '"' +
            ',"NivelEstudio":' + CAST(ISNULL(NivelEstudio, 0) AS NVARCHAR(10)) +
            ',"Profesion":' + CAST(ISNULL(Profesion, 0) AS NVARCHAR(10)) +
            ',"FechaCreacion":"' + ISNULL(CONVERT(NVARCHAR(23), FechaCreacion, 126), '') + '"' +
            ',"UsuarioCrea":' + CAST(ISNULL(UsuarioCrea, 0) AS NVARCHAR(10)) +
            ',"FechaModificacion":"' + ISNULL(CONVERT(NVARCHAR(23), FechaModificacion, 126), '') + '"' +
            ',"UsuarioModifica":' + CAST(ISNULL(UsuarioModifica, 0) AS NVARCHAR(10)) +
            ',"snEliminado":' + CASE WHEN snEliminado = 1 THEN 'true' ELSE 'false' END +
            ',"LugarTrabajo":' + CAST(ISNULL(LugarTrabajo, 0) AS NVARCHAR(10)) +
            ',"Ocupacion":' + CAST(ISNULL(Ocupacion, 0) AS NVARCHAR(10)) +
            ',"PaisTrabajo":"' + ISNULL(PaisTrabajo, '') + '"' +
            ',"ProvinciaTrabajo":' + CAST(ISNULL(ProvinciaTrabajo, 0) AS NVARCHAR(10)) +
            ',"DistritoTrabajo":' + CAST(ISNULL(DistritoTrabajo, 0) AS NVARCHAR(10)) +
            ',"CorregimientoTrabajo":' + CAST(ISNULL(CorregimientoTrabajo, 0) AS NVARCHAR(10)) +
            ',"PaisResidencia":"' + ISNULL(PaisResidencia, '') + '"' +
            ',"ProvinciaResidencia":' + CAST(ISNULL(ProvinciaResidencia, 0) AS NVARCHAR(10)) +
            ',"DistritoResidencia":' + CAST(ISNULL(DistritoResidencia, 0) AS NVARCHAR(10)) +
            ',"CorregimientoResidencia":' + CAST(ISNULL(CorregimientoResidencia, 0) AS NVARCHAR(10)) +
            '}' as JsonPosterior
        FROM inserted
        
        OPEN insert_cursor
        FETCH NEXT FROM insert_cursor INTO @RegistroId, @UsuarioId, @JsonPosterior
        
        WHILE @@FETCH_STATUS = 0
        BEGIN
            SET @Comentarios = 'Registro creado - Nuevo asociado'
            
            INSERT INTO tbLogsAuditoria (
                TablaAfectada, RegistroId, Operacion, UsuarioId, FechaHora,
                JsonPrevio, JsonPosterior, ServidorInfo, Comentarios
            ) VALUES (
                'tbAsociados', @RegistroId, @Operacion, @UsuarioId, GETDATE(),
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
            CAST(i.NumeroAsociado AS NVARCHAR(50)) as RegistroId,
            ISNULL(i.UsuarioModifica, 0) as UsuarioId,
            -- Estado anterior (deleted)
            '{"NumeroAsociado":' + CAST(d.NumeroAsociado AS NVARCHAR(10)) +
            ',"IdTipoAsociado":' + CAST(ISNULL(d.IdTipoAsociado, 0) AS NVARCHAR(10)) +
            ',"Nombre":"' + ISNULL(d.Nombre, '') + '"' +
            ',"SegundoNombre":"' + ISNULL(d.SegundoNombre, '') + '"' +
            ',"Apellido":"' + ISNULL(d.Apellido, '') + '"' +
            ',"SegundoApellido":"' + ISNULL(d.SegundoApellido, '') + '"' +
            ',"Estatus":"' + ISNULL(d.Estatus, '') + '"' +
            ',"TipoIdentificacion":"' + ISNULL(d.TipoIdentificacion, '') + '"' +
            ',"NumeroIdentificacion":"' + ISNULL(d.NumeroIdentificacion, '') + '"' +
            ',"TelefonoResidencia":"' + ISNULL(d.TelefonoResidencia, '') + '"' +
            ',"TelefonoCelular":"' + ISNULL(d.TelefonoCelular, '') + '"' +
            ',"TelefonoFamiliar":"' + ISNULL(d.TelefonoFamiliar, '') + '"' +
            ',"CorreoElectronico":"' + ISNULL(d.CorreoElectronico, '') + '"' +
            ',"Sexo":"' + ISNULL(d.Sexo, '') + '"' +
            ',"FechaNacimiento":"' + ISNULL(CONVERT(NVARCHAR(10), d.FechaNacimiento, 120), '') + '"' +
            ',"DireccionResidencia":"' + ISNULL(d.DireccionResidencia, '') + '"' +
            ',"DireccionTrabajo":"' + ISNULL(d.DireccionTrabajo, '') + '"' +
            ',"NivelEstudio":' + CAST(ISNULL(d.NivelEstudio, 0) AS NVARCHAR(10)) +
            ',"Profesion":' + CAST(ISNULL(d.Profesion, 0) AS NVARCHAR(10)) +
            ',"FechaCreacion":"' + ISNULL(CONVERT(NVARCHAR(23), d.FechaCreacion, 126), '') + '"' +
            ',"UsuarioCrea":' + CAST(ISNULL(d.UsuarioCrea, 0) AS NVARCHAR(10)) +
            ',"FechaModificacion":"' + ISNULL(CONVERT(NVARCHAR(23), d.FechaModificacion, 126), '') + '"' +
            ',"UsuarioModifica":' + CAST(ISNULL(d.UsuarioModifica, 0) AS NVARCHAR(10)) +
            ',"snEliminado":' + CASE WHEN d.snEliminado = 1 THEN 'true' ELSE 'false' END +
            ',"LugarTrabajo":' + CAST(ISNULL(d.LugarTrabajo, 0) AS NVARCHAR(10)) +
            ',"Ocupacion":' + CAST(ISNULL(d.Ocupacion, 0) AS NVARCHAR(10)) +
            ',"PaisTrabajo":"' + ISNULL(d.PaisTrabajo, '') + '"' +
            ',"ProvinciaTrabajo":' + CAST(ISNULL(d.ProvinciaTrabajo, 0) AS NVARCHAR(10)) +
            ',"DistritoTrabajo":' + CAST(ISNULL(d.DistritoTrabajo, 0) AS NVARCHAR(10)) +
            ',"CorregimientoTrabajo":' + CAST(ISNULL(d.CorregimientoTrabajo, 0) AS NVARCHAR(10)) +
            ',"PaisResidencia":"' + ISNULL(d.PaisResidencia, '') + '"' +
            ',"ProvinciaResidencia":' + CAST(ISNULL(d.ProvinciaResidencia, 0) AS NVARCHAR(10)) +
            ',"DistritoResidencia":' + CAST(ISNULL(d.DistritoResidencia, 0) AS NVARCHAR(10)) +
            ',"CorregimientoResidencia":' + CAST(ISNULL(d.CorregimientoResidencia, 0) AS NVARCHAR(10)) +
            '}' as JsonPrevio,
            -- Estado posterior (inserted)
            '{"NumeroAsociado":' + CAST(i.NumeroAsociado AS NVARCHAR(10)) +
            ',"IdTipoAsociado":' + CAST(ISNULL(i.IdTipoAsociado, 0) AS NVARCHAR(10)) +
            ',"Nombre":"' + ISNULL(i.Nombre, '') + '"' +
            ',"SegundoNombre":"' + ISNULL(i.SegundoNombre, '') + '"' +
            ',"Apellido":"' + ISNULL(i.Apellido, '') + '"' +
            ',"SegundoApellido":"' + ISNULL(i.SegundoApellido, '') + '"' +
            ',"Estatus":"' + ISNULL(i.Estatus, '') + '"' +
            ',"TipoIdentificacion":"' + ISNULL(i.TipoIdentificacion, '') + '"' +
            ',"NumeroIdentificacion":"' + ISNULL(i.NumeroIdentificacion, '') + '"' +
            ',"TelefonoResidencia":"' + ISNULL(i.TelefonoResidencia, '') + '"' +
            ',"TelefonoCelular":"' + ISNULL(i.TelefonoCelular, '') + '"' +
            ',"TelefonoFamiliar":"' + ISNULL(i.TelefonoFamiliar, '') + '"' +
            ',"CorreoElectronico":"' + ISNULL(i.CorreoElectronico, '') + '"' +
            ',"Sexo":"' + ISNULL(i.Sexo, '') + '"' +
            ',"FechaNacimiento":"' + ISNULL(CONVERT(NVARCHAR(10), i.FechaNacimiento, 120), '') + '"' +
            ',"DireccionResidencia":"' + ISNULL(i.DireccionResidencia, '') + '"' +
            ',"DireccionTrabajo":"' + ISNULL(i.DireccionTrabajo, '') + '"' +
            ',"NivelEstudio":' + CAST(ISNULL(i.NivelEstudio, 0) AS NVARCHAR(10)) +
            ',"Profesion":' + CAST(ISNULL(i.Profesion, 0) AS NVARCHAR(10)) +
            ',"FechaCreacion":"' + ISNULL(CONVERT(NVARCHAR(23), i.FechaCreacion, 126), '') + '"' +
            ',"UsuarioCrea":' + CAST(ISNULL(i.UsuarioCrea, 0) AS NVARCHAR(10)) +
            ',"FechaModificacion":"' + ISNULL(CONVERT(NVARCHAR(23), i.FechaModificacion, 126), '') + '"' +
            ',"UsuarioModifica":' + CAST(ISNULL(i.UsuarioModifica, 0) AS NVARCHAR(10)) +
            ',"snEliminado":' + CASE WHEN i.snEliminado = 1 THEN 'true' ELSE 'false' END +
            ',"LugarTrabajo":' + CAST(ISNULL(i.LugarTrabajo, 0) AS NVARCHAR(10)) +
            ',"Ocupacion":' + CAST(ISNULL(i.Ocupacion, 0) AS NVARCHAR(10)) +
            ',"PaisTrabajo":"' + ISNULL(i.PaisTrabajo, '') + '"' +
            ',"ProvinciaTrabajo":' + CAST(ISNULL(i.ProvinciaTrabajo, 0) AS NVARCHAR(10)) +
            ',"DistritoTrabajo":' + CAST(ISNULL(i.DistritoTrabajo, 0) AS NVARCHAR(10)) +
            ',"CorregimientoTrabajo":' + CAST(ISNULL(i.CorregimientoTrabajo, 0) AS NVARCHAR(10)) +
            ',"PaisResidencia":"' + ISNULL(i.PaisResidencia, '') + '"' +
            ',"ProvinciaResidencia":' + CAST(ISNULL(i.ProvinciaResidencia, 0) AS NVARCHAR(10)) +
            ',"DistritoResidencia":' + CAST(ISNULL(i.DistritoResidencia, 0) AS NVARCHAR(10)) +
            ',"CorregimientoResidencia":' + CAST(ISNULL(i.CorregimientoResidencia, 0) AS NVARCHAR(10)) +
            '}' as JsonPosterior
        FROM inserted i
        INNER JOIN deleted d ON i.NumeroAsociado = d.NumeroAsociado
        
        OPEN update_cursor
        FETCH NEXT FROM update_cursor INTO @RegistroId, @UsuarioId, @JsonPrevio, @JsonPosterior
        
        WHILE @@FETCH_STATUS = 0
        BEGIN
            SET @Comentarios = 'Registro actualizado - Modificación de datos'
            
            INSERT INTO tbLogsAuditoria (
                TablaAfectada, RegistroId, Operacion, UsuarioId, FechaHora,
                JsonPrevio, JsonPosterior, ServidorInfo, Comentarios
            ) VALUES (
                'tbAsociados', @RegistroId, @Operacion, @UsuarioId, GETDATE(),
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
            CAST(i.NumeroAsociado AS NVARCHAR(50)) as RegistroId,
            ISNULL(i.UsuarioElimina, ISNULL(i.UsuarioModifica, 0)) as UsuarioId,
            -- Estado anterior (deleted - antes del soft delete)
            '{"NumeroAsociado":' + CAST(d.NumeroAsociado AS NVARCHAR(10)) +
            ',"IdTipoAsociado":' + CAST(ISNULL(d.IdTipoAsociado, 0) AS NVARCHAR(10)) +
            ',"Nombre":"' + ISNULL(d.Nombre, '') + '"' +
            ',"SegundoNombre":"' + ISNULL(d.SegundoNombre, '') + '"' +
            ',"Apellido":"' + ISNULL(d.Apellido, '') + '"' +
            ',"SegundoApellido":"' + ISNULL(d.SegundoApellido, '') + '"' +
            ',"Estatus":"' + ISNULL(d.Estatus, '') + '"' +
            ',"TipoIdentificacion":"' + ISNULL(d.TipoIdentificacion, '') + '"' +
            ',"NumeroIdentificacion":"' + ISNULL(d.NumeroIdentificacion, '') + '"' +
            ',"TelefonoResidencia":"' + ISNULL(d.TelefonoResidencia, '') + '"' +
            ',"TelefonoCelular":"' + ISNULL(d.TelefonoCelular, '') + '"' +
            ',"TelefonoFamiliar":"' + ISNULL(d.TelefonoFamiliar, '') + '"' +
            ',"CorreoElectronico":"' + ISNULL(d.CorreoElectronico, '') + '"' +
            ',"Sexo":"' + ISNULL(d.Sexo, '') + '"' +
            ',"FechaNacimiento":"' + ISNULL(CONVERT(NVARCHAR(10), d.FechaNacimiento, 120), '') + '"' +
            ',"DireccionResidencia":"' + ISNULL(d.DireccionResidencia, '') + '"' +
            ',"DireccionTrabajo":"' + ISNULL(d.DireccionTrabajo, '') + '"' +
            ',"NivelEstudio":' + CAST(ISNULL(d.NivelEstudio, 0) AS NVARCHAR(10)) +
            ',"Profesion":' + CAST(ISNULL(d.Profesion, 0) AS NVARCHAR(10)) +
            ',"FechaCreacion":"' + ISNULL(CONVERT(NVARCHAR(23), d.FechaCreacion, 126), '') + '"' +
            ',"UsuarioCrea":' + CAST(ISNULL(d.UsuarioCrea, 0) AS NVARCHAR(10)) +
            ',"FechaModificacion":"' + ISNULL(CONVERT(NVARCHAR(23), d.FechaModificacion, 126), '') + '"' +
            ',"UsuarioModifica":' + CAST(ISNULL(d.UsuarioModifica, 0) AS NVARCHAR(10)) +
            ',"snEliminado":' + CASE WHEN d.snEliminado = 1 THEN 'true' ELSE 'false' END +
            ',"LugarTrabajo":' + CAST(ISNULL(d.LugarTrabajo, 0) AS NVARCHAR(10)) +
            ',"Ocupacion":' + CAST(ISNULL(d.Ocupacion, 0) AS NVARCHAR(10)) +
            ',"PaisTrabajo":"' + ISNULL(d.PaisTrabajo, '') + '"' +
            ',"ProvinciaTrabajo":' + CAST(ISNULL(d.ProvinciaTrabajo, 0) AS NVARCHAR(10)) +
            ',"DistritoTrabajo":' + CAST(ISNULL(d.DistritoTrabajo, 0) AS NVARCHAR(10)) +
            ',"CorregimientoTrabajo":' + CAST(ISNULL(d.CorregimientoTrabajo, 0) AS NVARCHAR(10)) +
            ',"PaisResidencia":"' + ISNULL(d.PaisResidencia, '') + '"' +
            ',"ProvinciaResidencia":' + CAST(ISNULL(d.ProvinciaResidencia, 0) AS NVARCHAR(10)) +
            ',"DistritoResidencia":' + CAST(ISNULL(d.DistritoResidencia, 0) AS NVARCHAR(10)) +
            ',"CorregimientoResidencia":' + CAST(ISNULL(d.CorregimientoResidencia, 0) AS NVARCHAR(10)) +
            '}' as JsonPrevio,
            -- Estado posterior (inserted - después del soft delete)
            '{"NumeroAsociado":' + CAST(i.NumeroAsociado AS NVARCHAR(10)) +
            ',"IdTipoAsociado":' + CAST(ISNULL(i.IdTipoAsociado, 0) AS NVARCHAR(10)) +
            ',"Nombre":"' + ISNULL(i.Nombre, '') + '"' +
            ',"SegundoNombre":"' + ISNULL(i.SegundoNombre, '') + '"' +
            ',"Apellido":"' + ISNULL(i.Apellido, '') + '"' +
            ',"SegundoApellido":"' + ISNULL(i.SegundoApellido, '') + '"' +
            ',"Estatus":"' + ISNULL(i.Estatus, '') + '"' +
            ',"TipoIdentificacion":"' + ISNULL(i.TipoIdentificacion, '') + '"' +
            ',"NumeroIdentificacion":"' + ISNULL(i.NumeroIdentificacion, '') + '"' +
            ',"TelefonoResidencia":"' + ISNULL(i.TelefonoResidencia, '') + '"' +
            ',"TelefonoCelular":"' + ISNULL(i.TelefonoCelular, '') + '"' +
            ',"TelefonoFamiliar":"' + ISNULL(i.TelefonoFamiliar, '') + '"' +
            ',"CorreoElectronico":"' + ISNULL(i.CorreoElectronico, '') + '"' +
            ',"Sexo":"' + ISNULL(i.Sexo, '') + '"' +
            ',"FechaNacimiento":"' + ISNULL(CONVERT(NVARCHAR(10), i.FechaNacimiento, 120), '') + '"' +
            ',"DireccionResidencia":"' + ISNULL(i.DireccionResidencia, '') + '"' +
            ',"DireccionTrabajo":"' + ISNULL(i.DireccionTrabajo, '') + '"' +
            ',"NivelEstudio":' + CAST(ISNULL(i.NivelEstudio, 0) AS NVARCHAR(10)) +
            ',"Profesion":' + CAST(ISNULL(i.Profesion, 0) AS NVARCHAR(10)) +
            ',"FechaCreacion":"' + ISNULL(CONVERT(NVARCHAR(23), i.FechaCreacion, 126), '') + '"' +
            ',"UsuarioCrea":' + CAST(ISNULL(i.UsuarioCrea, 0) AS NVARCHAR(10)) +
            ',"FechaModificacion":"' + ISNULL(CONVERT(NVARCHAR(23), i.FechaModificacion, 126), '') + '"' +
            ',"UsuarioModifica":' + CAST(ISNULL(i.UsuarioModifica, 0) AS NVARCHAR(10)) +
            ',"snEliminado":' + CASE WHEN i.snEliminado = 1 THEN 'true' ELSE 'false' END +
            ',"UsuarioElimina":' + CAST(ISNULL(i.UsuarioElimina, 0) AS NVARCHAR(10)) +
            ',"FechaEliminacion":"' + ISNULL(CONVERT(NVARCHAR(23), i.FechaModificacion, 126), '') + '"' +
            ',"LugarTrabajo":' + CAST(ISNULL(i.LugarTrabajo, 0) AS NVARCHAR(10)) +
            ',"Ocupacion":' + CAST(ISNULL(i.Ocupacion, 0) AS NVARCHAR(10)) +
            ',"PaisTrabajo":"' + ISNULL(i.PaisTrabajo, '') + '"' +
            ',"ProvinciaTrabajo":' + CAST(ISNULL(i.ProvinciaTrabajo, 0) AS NVARCHAR(10)) +
            ',"DistritoTrabajo":' + CAST(ISNULL(i.DistritoTrabajo, 0) AS NVARCHAR(10)) +
            ',"CorregimientoTrabajo":' + CAST(ISNULL(i.CorregimientoTrabajo, 0) AS NVARCHAR(10)) +
            ',"PaisResidencia":"' + ISNULL(i.PaisResidencia, '') + '"' +
            ',"ProvinciaResidencia":' + CAST(ISNULL(i.ProvinciaResidencia, 0) AS NVARCHAR(10)) +
            ',"DistritoResidencia":' + CAST(ISNULL(i.DistritoResidencia, 0) AS NVARCHAR(10)) +
            ',"CorregimientoResidencia":' + CAST(ISNULL(i.CorregimientoResidencia, 0) AS NVARCHAR(10)) +
            '}' as JsonPosterior
        FROM inserted i
        INNER JOIN deleted d ON i.NumeroAsociado = d.NumeroAsociado
        
        OPEN soft_delete_cursor
        FETCH NEXT FROM soft_delete_cursor INTO @RegistroId, @UsuarioId, @JsonPrevio, @JsonPosterior
        
        WHILE @@FETCH_STATUS = 0
        BEGIN
            SET @Comentarios = 'Registro eliminado - Soft delete aplicado'
            
            INSERT INTO tbLogsAuditoria (
                TablaAfectada, RegistroId, Operacion, UsuarioId, FechaHora,
                JsonPrevio, JsonPosterior, ServidorInfo, Comentarios
            ) VALUES (
                'tbAsociados', @RegistroId, @Operacion, @UsuarioId, GETDATE(),
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
            CAST(NumeroAsociado AS NVARCHAR(50)) as RegistroId,
            ISNULL(UsuarioModifica, 0) as UsuarioId,
            '{"NumeroAsociado":' + CAST(NumeroAsociado AS NVARCHAR(10)) +
            ',"IdTipoAsociado":' + CAST(ISNULL(IdTipoAsociado, 0) AS NVARCHAR(10)) +
            ',"Nombre":"' + ISNULL(Nombre, '') + '"' +
            ',"SegundoNombre":"' + ISNULL(SegundoNombre, '') + '"' +
            ',"Apellido":"' + ISNULL(Apellido, '') + '"' +
            ',"SegundoApellido":"' + ISNULL(SegundoApellido, '') + '"' +
            ',"Estatus":"' + ISNULL(Estatus, '') + '"' +
            ',"TipoIdentificacion":"' + ISNULL(TipoIdentificacion, '') + '"' +
            ',"NumeroIdentificacion":"' + ISNULL(NumeroIdentificacion, '') + '"' +
            ',"TelefonoResidencia":"' + ISNULL(TelefonoResidencia, '') + '"' +
            ',"TelefonoCelular":"' + ISNULL(TelefonoCelular, '') + '"' +
            ',"TelefonoFamiliar":"' + ISNULL(TelefonoFamiliar, '') + '"' +
            ',"CorreoElectronico":"' + ISNULL(CorreoElectronico, '') + '"' +
            ',"Sexo":"' + ISNULL(Sexo, '') + '"' +
            ',"FechaNacimiento":"' + ISNULL(CONVERT(NVARCHAR(10), FechaNacimiento, 120), '') + '"' +
            ',"DireccionResidencia":"' + ISNULL(DireccionResidencia, '') + '"' +
            ',"DireccionTrabajo":"' + ISNULL(DireccionTrabajo, '') + '"' +
            ',"NivelEstudio":' + CAST(ISNULL(NivelEstudio, 0) AS NVARCHAR(10)) +
            ',"Profesion":' + CAST(ISNULL(Profesion, 0) AS NVARCHAR(10)) +
            ',"FechaCreacion":"' + ISNULL(CONVERT(NVARCHAR(23), FechaCreacion, 126), '') + '"' +
            ',"UsuarioCrea":' + CAST(ISNULL(UsuarioCrea, 0) AS NVARCHAR(10)) +
            ',"FechaModificacion":"' + ISNULL(CONVERT(NVARCHAR(23), FechaModificacion, 126), '') + '"' +
            ',"UsuarioModifica":' + CAST(ISNULL(UsuarioModifica, 0) AS NVARCHAR(10)) +
            ',"snEliminado":' + CASE WHEN snEliminado = 1 THEN 'true' ELSE 'false' END +
            ',"LugarTrabajo":' + CAST(ISNULL(LugarTrabajo, 0) AS NVARCHAR(10)) +
            ',"Ocupacion":' + CAST(ISNULL(Ocupacion, 0) AS NVARCHAR(10)) +
            ',"PaisTrabajo":"' + ISNULL(PaisTrabajo, '') + '"' +
            ',"ProvinciaTrabajo":' + CAST(ISNULL(ProvinciaTrabajo, 0) AS NVARCHAR(10)) +
            ',"DistritoTrabajo":' + CAST(ISNULL(DistritoTrabajo, 0) AS NVARCHAR(10)) +
            ',"CorregimientoTrabajo":' + CAST(ISNULL(CorregimientoTrabajo, 0) AS NVARCHAR(10)) +
            ',"PaisResidencia":"' + ISNULL(PaisResidencia, '') + '"' +
            ',"ProvinciaResidencia":' + CAST(ISNULL(ProvinciaResidencia, 0) AS NVARCHAR(10)) +
            ',"DistritoResidencia":' + CAST(ISNULL(DistritoResidencia, 0) AS NVARCHAR(10)) +
            ',"CorregimientoResidencia":' + CAST(ISNULL(CorregimientoResidencia, 0) AS NVARCHAR(10)) +
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
                'tbAsociados', @RegistroId, @Operacion, @UsuarioId, GETDATE(),
                @JsonPrevio, @JsonPosterior, @ServidorInfo, @Comentarios
            )
            
            FETCH NEXT FROM delete_cursor INTO @RegistroId, @UsuarioId, @JsonPrevio
        END
        
        CLOSE delete_cursor
        DEALLOCATE delete_cursor
    END
END
GO

PRINT 'Trigger tr_Auditoria_tbAsociados creado exitosamente'
PRINT 'Captura: INSERT (I), UPDATE (U), SOFT DELETE (D), DELETE FÍSICO (X)'
PRINT 'Campos: Todos los 34 campos de tbAsociados'
PRINT 'JSON: Estado anterior y posterior completo'
PRINT 'Códigos: D=Soft Delete, X=Delete Físico'
GO
