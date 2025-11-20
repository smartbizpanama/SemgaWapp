-- =============================================
-- Trigger de Auditoría para tbAsociados con JSON completo y SessionInfo
-- Captura todos los cambios: INSERT, UPDATE, DELETE
-- Obtiene información de sesión desde tbLogSesionHdr usando IdSession
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
    DECLARE @IdSession NVARCHAR(50)
    
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
    
    -- Procesar registros afectados
    IF @Operacion = 'I' -- INSERT
    BEGIN
        DECLARE insert_cursor CURSOR FOR
        SELECT 
            i.NumeroAsociado,
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
            SELECT @JsonPosterior = 
                '{"NumeroAsociado":' + CAST(i.NumeroAsociado AS NVARCHAR(10)) +
                ',"IdTipoAsociado":"' + dbo.fnAuditoria_ObtenerTipoAsociado(i.IdTipoAsociado) + '"' +
                ',"Nombre":"' + ISNULL(i.Nombre, '') + '"' +
                ',"SegundoNombre":"' + ISNULL(i.SegundoNombre, '') + '"' +
                ',"Apellido":"' + ISNULL(i.Apellido, '') + '"' +
                ',"SegundoApellido":"' + ISNULL(i.SegundoApellido, '') + '"' +
                ',"Estatus":"' + ISNULL(i.Estatus, '') + '"' +
                ',"TipoIdentificacion":"' + dbo.fnAuditoria_ObtenerTipoDocumento(i.TipoIdentificacion) + '"' +
                ',"NumeroIdentificacion":"' + ISNULL(i.NumeroIdentificacion, '') + '"' +
                ',"TelefonoResidencia":"' + ISNULL(i.TelefonoResidencia, '') + '"' +
                ',"TelefonoCelular":"' + ISNULL(i.TelefonoCelular, '') + '"' +
                ',"TelefonoFamiliar":"' + ISNULL(i.TelefonoFamiliar, '') + '"' +
                ',"TelefonoTrabajo":"' + ISNULL(i.TelefonoTrabajo, '') + '"' +
                ',"CorreoElectronico":"' + ISNULL(i.CorreoElectronico, '') + '"' +
                ',"Sexo":"' + ISNULL(i.Sexo, '') + '"' +
                ',"FechaNacimiento":"' + ISNULL(CONVERT(NVARCHAR(10), i.FechaNacimiento, 120), '') + '"' +
                ',"ProvinciaResidencia":"' + dbo.fnAuditoria_ObtenerProvincia(i.ProvinciaResidencia) + '"' +
                ',"DistritoResidencia":"' + dbo.fnAuditoria_ObtenerDistrito(i.DistritoResidencia) + '"' +
                ',"CorregimientoResidencia":"' + dbo.fnAuditoria_ObtenerCorregimiento(i.CorregimientoResidencia) + '"' +
                ',"DireccionResidencia":"' + ISNULL(i.DireccionResidencia, '') + '"' +
                ',"ProvinciaTrabajo":"' + dbo.fnAuditoria_ObtenerProvincia(i.ProvinciaTrabajo) + '"' +
                ',"DistritoTrabajo":"' + dbo.fnAuditoria_ObtenerDistrito(i.DistritoTrabajo) + '"' +
                ',"CorregimientoTrabajo":"' + dbo.fnAuditoria_ObtenerCorregimiento(i.CorregimientoTrabajo) + '"' +
                ',"DireccionTrabajo":"' + ISNULL(i.DireccionTrabajo, '') + '"' +
                ',"LugarTrabajo":"' + dbo.fnAuditoria_ObtenerLugarTrabajo(i.LugarTrabajo) + '"' +
                ',"Ocupacion":"' + dbo.fnAuditoria_ObtenerOcupacion(i.Ocupacion) + '"' +
                ',"PaisTrabajo":"' + dbo.fnAuditoria_ObtenerPais(i.PaisTrabajo) + '"' +
                ',"PaisResidencia":"' + dbo.fnAuditoria_ObtenerPais(i.PaisResidencia) + '"' +
                ',"NivelEstudio":"' + dbo.fnAuditoria_ObtenerNivelEstudio(i.NivelEstudio) + '"' +
                ',"Profesion":"' + dbo.fnAuditoria_ObtenerProfesion(i.Profesion) + '"' +
                ',"FechaCreacion":"' + ISNULL(CONVERT(NVARCHAR(23), i.FechaCreacion, 126), '') + '"' +
                ',"UsuarioCrea":"' + dbo.fnAuditoria_ObtenerUsuario(i.UsuarioCrea) + '"' +
                ',"FechaModificacion":"' + ISNULL(CONVERT(NVARCHAR(23), i.FechaModificacion, 126), '') + '"' +
                ',"UsuarioModifica":"' + dbo.fnAuditoria_ObtenerUsuario(i.UsuarioModifica) + '"' +
                ',"snEliminado":' + CASE WHEN i.snEliminado = 1 THEN 'true' ELSE 'false' END +
                ',"UsuarioElimina":"' + dbo.fnAuditoria_ObtenerUsuario(i.UsuarioElimina) + '"' +
                ',"FechaElimina":"' + ISNULL(CONVERT(NVARCHAR(23), i.FechaElimina, 126), '') + '"' +
                '}'
            FROM inserted i
            WHERE i.NumeroAsociado = @RegistroId
            SET @JsonPrevio = NULL
            
            -- Insertar en tabla de auditoría
            INSERT INTO tbLogsAuditoria (
                TablaAfectada, RegistroId, Operacion, UsuarioId, FechaHora,
                JsonPrevio, JsonPosterior, ServidorInfo, Comentarios
            )
            VALUES (
                'tbAsociados', @RegistroId, @Operacion, @UsuarioId, GETDATE(),
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
            i.NumeroAsociado,
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
            SELECT @JsonPrevio = 
                '{"NumeroAsociado":' + CAST(d.NumeroAsociado AS NVARCHAR(10)) +
                ',"IdTipoAsociado":"' + dbo.fnAuditoria_ObtenerTipoAsociado(d.IdTipoAsociado) + '"' +
                ',"Nombre":"' + ISNULL(d.Nombre, '') + '"' +
                ',"SegundoNombre":"' + ISNULL(d.SegundoNombre, '') + '"' +
                ',"Apellido":"' + ISNULL(d.Apellido, '') + '"' +
                ',"SegundoApellido":"' + ISNULL(d.SegundoApellido, '') + '"' +
                ',"Estatus":"' + ISNULL(d.Estatus, '') + '"' +
                ',"TipoIdentificacion":"' + dbo.fnAuditoria_ObtenerTipoDocumento(d.TipoIdentificacion) + '"' +
                ',"NumeroIdentificacion":"' + ISNULL(d.NumeroIdentificacion, '') + '"' +
                ',"TelefonoResidencia":"' + ISNULL(d.TelefonoResidencia, '') + '"' +
                ',"TelefonoCelular":"' + ISNULL(d.TelefonoCelular, '') + '"' +
                ',"TelefonoFamiliar":"' + ISNULL(d.TelefonoFamiliar, '') + '"' +
                ',"TelefonoTrabajo":"' + ISNULL(d.TelefonoTrabajo, '') + '"' +
                ',"CorreoElectronico":"' + ISNULL(d.CorreoElectronico, '') + '"' +
                ',"Sexo":"' + ISNULL(d.Sexo, '') + '"' +
                ',"FechaNacimiento":"' + ISNULL(CONVERT(NVARCHAR(10), d.FechaNacimiento, 120), '') + '"' +
                ',"ProvinciaResidencia":"' + dbo.fnAuditoria_ObtenerProvincia(d.ProvinciaResidencia) + '"' +
                ',"DistritoResidencia":"' + dbo.fnAuditoria_ObtenerDistrito(d.DistritoResidencia) + '"' +
                ',"CorregimientoResidencia":"' + dbo.fnAuditoria_ObtenerCorregimiento(d.CorregimientoResidencia) + '"' +
                ',"DireccionResidencia":"' + ISNULL(d.DireccionResidencia, '') + '"' +
                ',"ProvinciaTrabajo":"' + dbo.fnAuditoria_ObtenerProvincia(d.ProvinciaTrabajo) + '"' +
                ',"DistritoTrabajo":"' + dbo.fnAuditoria_ObtenerDistrito(d.DistritoTrabajo) + '"' +
                ',"CorregimientoTrabajo":"' + dbo.fnAuditoria_ObtenerCorregimiento(d.CorregimientoTrabajo) + '"' +
                ',"DireccionTrabajo":"' + ISNULL(d.DireccionTrabajo, '') + '"' +
                ',"LugarTrabajo":"' + dbo.fnAuditoria_ObtenerLugarTrabajo(d.LugarTrabajo) + '"' +
                ',"Ocupacion":"' + dbo.fnAuditoria_ObtenerOcupacion(d.Ocupacion) + '"' +
                ',"PaisTrabajo":"' + dbo.fnAuditoria_ObtenerPais(d.PaisTrabajo) + '"' +
                ',"PaisResidencia":"' + dbo.fnAuditoria_ObtenerPais(d.PaisResidencia) + '"' +
                ',"NivelEstudio":"' + dbo.fnAuditoria_ObtenerNivelEstudio(d.NivelEstudio) + '"' +
                ',"Profesion":"' + dbo.fnAuditoria_ObtenerProfesion(d.Profesion) + '"' +
                ',"FechaCreacion":"' + ISNULL(CONVERT(NVARCHAR(23), d.FechaCreacion, 126), '') + '"' +
                ',"UsuarioCrea":"' + dbo.fnAuditoria_ObtenerUsuario(d.UsuarioCrea) + '"' +
                ',"FechaModificacion":"' + ISNULL(CONVERT(NVARCHAR(23), d.FechaModificacion, 126), '') + '"' +
                ',"UsuarioModifica":"' + dbo.fnAuditoria_ObtenerUsuario(d.UsuarioModifica) + '"' +
                ',"snEliminado":' + CASE WHEN d.snEliminado = 1 THEN 'true' ELSE 'false' END +
                ',"UsuarioElimina":"' + dbo.fnAuditoria_ObtenerUsuario(d.UsuarioElimina) + '"' +
                ',"FechaElimina":"' + ISNULL(CONVERT(NVARCHAR(23), d.FechaElimina, 126), '') + '"' +
                '}',
                @JsonPosterior = 
                '{"NumeroAsociado":' + CAST(i.NumeroAsociado AS NVARCHAR(10)) +
                ',"IdTipoAsociado":"' + dbo.fnAuditoria_ObtenerTipoAsociado(i.IdTipoAsociado) + '"' +
                ',"Nombre":"' + ISNULL(i.Nombre, '') + '"' +
                ',"SegundoNombre":"' + ISNULL(i.SegundoNombre, '') + '"' +
                ',"Apellido":"' + ISNULL(i.Apellido, '') + '"' +
                ',"SegundoApellido":"' + ISNULL(i.SegundoApellido, '') + '"' +
                ',"Estatus":"' + ISNULL(i.Estatus, '') + '"' +
                ',"TipoIdentificacion":"' + dbo.fnAuditoria_ObtenerTipoDocumento(i.TipoIdentificacion) + '"' +
                ',"NumeroIdentificacion":"' + ISNULL(i.NumeroIdentificacion, '') + '"' +
                ',"TelefonoResidencia":"' + ISNULL(i.TelefonoResidencia, '') + '"' +
                ',"TelefonoCelular":"' + ISNULL(i.TelefonoCelular, '') + '"' +
                ',"TelefonoFamiliar":"' + ISNULL(i.TelefonoFamiliar, '') + '"' +
                ',"TelefonoTrabajo":"' + ISNULL(i.TelefonoTrabajo, '') + '"' +
                ',"CorreoElectronico":"' + ISNULL(i.CorreoElectronico, '') + '"' +
                ',"Sexo":"' + ISNULL(i.Sexo, '') + '"' +
                ',"FechaNacimiento":"' + ISNULL(CONVERT(NVARCHAR(10), i.FechaNacimiento, 120), '') + '"' +
                ',"ProvinciaResidencia":"' + dbo.fnAuditoria_ObtenerProvincia(i.ProvinciaResidencia) + '"' +
                ',"DistritoResidencia":"' + dbo.fnAuditoria_ObtenerDistrito(i.DistritoResidencia) + '"' +
                ',"CorregimientoResidencia":"' + dbo.fnAuditoria_ObtenerCorregimiento(i.CorregimientoResidencia) + '"' +
                ',"DireccionResidencia":"' + ISNULL(i.DireccionResidencia, '') + '"' +
                ',"ProvinciaTrabajo":"' + dbo.fnAuditoria_ObtenerProvincia(i.ProvinciaTrabajo) + '"' +
                ',"DistritoTrabajo":"' + dbo.fnAuditoria_ObtenerDistrito(i.DistritoTrabajo) + '"' +
                ',"CorregimientoTrabajo":"' + dbo.fnAuditoria_ObtenerCorregimiento(i.CorregimientoTrabajo) + '"' +
                ',"DireccionTrabajo":"' + ISNULL(i.DireccionTrabajo, '') + '"' +
                ',"LugarTrabajo":"' + dbo.fnAuditoria_ObtenerLugarTrabajo(i.LugarTrabajo) + '"' +
                ',"Ocupacion":"' + dbo.fnAuditoria_ObtenerOcupacion(i.Ocupacion) + '"' +
                ',"PaisTrabajo":"' + dbo.fnAuditoria_ObtenerPais(i.PaisTrabajo) + '"' +
                ',"PaisResidencia":"' + dbo.fnAuditoria_ObtenerPais(i.PaisResidencia) + '"' +
                ',"NivelEstudio":"' + dbo.fnAuditoria_ObtenerNivelEstudio(i.NivelEstudio) + '"' +
                ',"Profesion":"' + dbo.fnAuditoria_ObtenerProfesion(i.Profesion) + '"' +
                ',"FechaCreacion":"' + ISNULL(CONVERT(NVARCHAR(23), i.FechaCreacion, 126), '') + '"' +
                ',"UsuarioCrea":"' + dbo.fnAuditoria_ObtenerUsuario(i.UsuarioCrea) + '"' +
                ',"FechaModificacion":"' + ISNULL(CONVERT(NVARCHAR(23), i.FechaModificacion, 126), '') + '"' +
                ',"UsuarioModifica":"' + dbo.fnAuditoria_ObtenerUsuario(i.UsuarioModifica) + '"' +
                ',"snEliminado":' + CASE WHEN i.snEliminado = 1 THEN 'true' ELSE 'false' END +
                ',"UsuarioElimina":"' + dbo.fnAuditoria_ObtenerUsuario(i.UsuarioElimina) + '"' +
                ',"FechaElimina":"' + ISNULL(CONVERT(NVARCHAR(23), i.FechaElimina, 126), '') + '"' +
                '}'
            FROM inserted i
            INNER JOIN deleted d ON i.NumeroAsociado = d.NumeroAsociado
            WHERE i.NumeroAsociado = @RegistroId
            
            -- Insertar en tabla de auditoría
            INSERT INTO tbLogsAuditoria (
                TablaAfectada, RegistroId, Operacion, UsuarioId, FechaHora,
                JsonPrevio, JsonPosterior, ServidorInfo, Comentarios
            )
            VALUES (
                'tbAsociados', @RegistroId, @Operacion, @UsuarioId, GETDATE(),
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
            i.NumeroAsociado,
            i.UsuarioModifica,
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
            SELECT @JsonPrevio = 
                '{"NumeroAsociado":' + CAST(d.NumeroAsociado AS NVARCHAR(10)) +
                ',"IdTipoAsociado":"' + dbo.fnAuditoria_ObtenerTipoAsociado(d.IdTipoAsociado) + '"' +
                ',"Nombre":"' + ISNULL(d.Nombre, '') + '"' +
                ',"SegundoNombre":"' + ISNULL(d.SegundoNombre, '') + '"' +
                ',"Apellido":"' + ISNULL(d.Apellido, '') + '"' +
                ',"SegundoApellido":"' + ISNULL(d.SegundoApellido, '') + '"' +
                ',"Estatus":"' + ISNULL(d.Estatus, '') + '"' +
                ',"TipoIdentificacion":"' + dbo.fnAuditoria_ObtenerTipoDocumento(d.TipoIdentificacion) + '"' +
                ',"NumeroIdentificacion":"' + ISNULL(d.NumeroIdentificacion, '') + '"' +
                ',"TelefonoResidencia":"' + ISNULL(d.TelefonoResidencia, '') + '"' +
                ',"TelefonoCelular":"' + ISNULL(d.TelefonoCelular, '') + '"' +
                ',"TelefonoFamiliar":"' + ISNULL(d.TelefonoFamiliar, '') + '"' +
                ',"TelefonoTrabajo":"' + ISNULL(d.TelefonoTrabajo, '') + '"' +
                ',"CorreoElectronico":"' + ISNULL(d.CorreoElectronico, '') + '"' +
                ',"Sexo":"' + ISNULL(d.Sexo, '') + '"' +
                ',"FechaNacimiento":"' + ISNULL(CONVERT(NVARCHAR(10), d.FechaNacimiento, 120), '') + '"' +
                ',"ProvinciaResidencia":"' + dbo.fnAuditoria_ObtenerProvincia(d.ProvinciaResidencia) + '"' +
                ',"DistritoResidencia":"' + dbo.fnAuditoria_ObtenerDistrito(d.DistritoResidencia) + '"' +
                ',"CorregimientoResidencia":"' + dbo.fnAuditoria_ObtenerCorregimiento(d.CorregimientoResidencia) + '"' +
                ',"DireccionResidencia":"' + ISNULL(d.DireccionResidencia, '') + '"' +
                ',"ProvinciaTrabajo":"' + dbo.fnAuditoria_ObtenerProvincia(d.ProvinciaTrabajo) + '"' +
                ',"DistritoTrabajo":"' + dbo.fnAuditoria_ObtenerDistrito(d.DistritoTrabajo) + '"' +
                ',"CorregimientoTrabajo":"' + dbo.fnAuditoria_ObtenerCorregimiento(d.CorregimientoTrabajo) + '"' +
                ',"DireccionTrabajo":"' + ISNULL(d.DireccionTrabajo, '') + '"' +
                ',"LugarTrabajo":"' + dbo.fnAuditoria_ObtenerLugarTrabajo(d.LugarTrabajo) + '"' +
                ',"Ocupacion":"' + dbo.fnAuditoria_ObtenerOcupacion(d.Ocupacion) + '"' +
                ',"PaisTrabajo":"' + dbo.fnAuditoria_ObtenerPais(d.PaisTrabajo) + '"' +
                ',"PaisResidencia":"' + dbo.fnAuditoria_ObtenerPais(d.PaisResidencia) + '"' +
                ',"NivelEstudio":"' + dbo.fnAuditoria_ObtenerNivelEstudio(d.NivelEstudio) + '"' +
                ',"Profesion":"' + dbo.fnAuditoria_ObtenerProfesion(d.Profesion) + '"' +
                ',"FechaCreacion":"' + ISNULL(CONVERT(NVARCHAR(23), d.FechaCreacion, 126), '') + '"' +
                ',"UsuarioCrea":"' + dbo.fnAuditoria_ObtenerUsuario(d.UsuarioCrea) + '"' +
                ',"FechaModificacion":"' + ISNULL(CONVERT(NVARCHAR(23), d.FechaModificacion, 126), '') + '"' +
                ',"UsuarioModifica":"' + dbo.fnAuditoria_ObtenerUsuario(d.UsuarioModifica) + '"' +
                ',"snEliminado":' + CASE WHEN d.snEliminado = 1 THEN 'true' ELSE 'false' END +
                ',"UsuarioElimina":"' + dbo.fnAuditoria_ObtenerUsuario(d.UsuarioElimina) + '"' +
                ',"FechaElimina":"' + ISNULL(CONVERT(NVARCHAR(23), d.FechaElimina, 126), '') + '"' +
                '}',
                @JsonPosterior = 
                '{"NumeroAsociado":' + CAST(i.NumeroAsociado AS NVARCHAR(10)) +
                ',"IdTipoAsociado":"' + dbo.fnAuditoria_ObtenerTipoAsociado(i.IdTipoAsociado) + '"' +
                ',"Nombre":"' + ISNULL(i.Nombre, '') + '"' +
                ',"SegundoNombre":"' + ISNULL(i.SegundoNombre, '') + '"' +
                ',"Apellido":"' + ISNULL(i.Apellido, '') + '"' +
                ',"SegundoApellido":"' + ISNULL(i.SegundoApellido, '') + '"' +
                ',"Estatus":"' + ISNULL(i.Estatus, '') + '"' +
                ',"TipoIdentificacion":"' + dbo.fnAuditoria_ObtenerTipoDocumento(i.TipoIdentificacion) + '"' +
                ',"NumeroIdentificacion":"' + ISNULL(i.NumeroIdentificacion, '') + '"' +
                ',"TelefonoResidencia":"' + ISNULL(i.TelefonoResidencia, '') + '"' +
                ',"TelefonoCelular":"' + ISNULL(i.TelefonoCelular, '') + '"' +
                ',"TelefonoFamiliar":"' + ISNULL(i.TelefonoFamiliar, '') + '"' +
                ',"TelefonoTrabajo":"' + ISNULL(i.TelefonoTrabajo, '') + '"' +
                ',"CorreoElectronico":"' + ISNULL(i.CorreoElectronico, '') + '"' +
                ',"Sexo":"' + ISNULL(i.Sexo, '') + '"' +
                ',"FechaNacimiento":"' + ISNULL(CONVERT(NVARCHAR(10), i.FechaNacimiento, 120), '') + '"' +
                ',"ProvinciaResidencia":"' + dbo.fnAuditoria_ObtenerProvincia(i.ProvinciaResidencia) + '"' +
                ',"DistritoResidencia":"' + dbo.fnAuditoria_ObtenerDistrito(i.DistritoResidencia) + '"' +
                ',"CorregimientoResidencia":"' + dbo.fnAuditoria_ObtenerCorregimiento(i.CorregimientoResidencia) + '"' +
                ',"DireccionResidencia":"' + ISNULL(i.DireccionResidencia, '') + '"' +
                ',"ProvinciaTrabajo":"' + dbo.fnAuditoria_ObtenerProvincia(i.ProvinciaTrabajo) + '"' +
                ',"DistritoTrabajo":"' + dbo.fnAuditoria_ObtenerDistrito(i.DistritoTrabajo) + '"' +
                ',"CorregimientoTrabajo":"' + dbo.fnAuditoria_ObtenerCorregimiento(i.CorregimientoTrabajo) + '"' +
                ',"DireccionTrabajo":"' + ISNULL(i.DireccionTrabajo, '') + '"' +
                ',"LugarTrabajo":"' + dbo.fnAuditoria_ObtenerLugarTrabajo(i.LugarTrabajo) + '"' +
                ',"Ocupacion":"' + dbo.fnAuditoria_ObtenerOcupacion(i.Ocupacion) + '"' +
                ',"PaisTrabajo":"' + dbo.fnAuditoria_ObtenerPais(i.PaisTrabajo) + '"' +
                ',"PaisResidencia":"' + dbo.fnAuditoria_ObtenerPais(i.PaisResidencia) + '"' +
                ',"NivelEstudio":"' + dbo.fnAuditoria_ObtenerNivelEstudio(i.NivelEstudio) + '"' +
                ',"Profesion":"' + dbo.fnAuditoria_ObtenerProfesion(i.Profesion) + '"' +
                ',"FechaCreacion":"' + ISNULL(CONVERT(NVARCHAR(23), i.FechaCreacion, 126), '') + '"' +
                ',"UsuarioCrea":"' + dbo.fnAuditoria_ObtenerUsuario(i.UsuarioCrea) + '"' +
                ',"FechaModificacion":"' + ISNULL(CONVERT(NVARCHAR(23), i.FechaModificacion, 126), '') + '"' +
                ',"UsuarioModifica":"' + dbo.fnAuditoria_ObtenerUsuario(i.UsuarioModifica) + '"' +
                ',"snEliminado":' + CASE WHEN i.snEliminado = 1 THEN 'true' ELSE 'false' END +
                ',"UsuarioElimina":"' + dbo.fnAuditoria_ObtenerUsuario(i.UsuarioElimina) + '"' +
                ',"FechaElimina":"' + ISNULL(CONVERT(NVARCHAR(23), i.FechaElimina, 126), '') + '"' +
                '}'
            FROM inserted i
            INNER JOIN deleted d ON i.NumeroAsociado = d.NumeroAsociado
            WHERE i.NumeroAsociado = @RegistroId
            
            -- Insertar en tabla de auditoría
            INSERT INTO tbLogsAuditoria (
                TablaAfectada, RegistroId, Operacion, UsuarioId, FechaHora,
                JsonPrevio, JsonPosterior, ServidorInfo, Comentarios
            )
            VALUES (
                'tbAsociados', @RegistroId, @Operacion, @UsuarioId, GETDATE(),
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
            d.NumeroAsociado,
            d.UsuarioModifica,
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
            
            -- Si no se encuentra SessionInfo, usar función de SQL Server
            IF @SessionInfoDelete = '' OR @SessionInfoDelete IS NULL
            BEGIN
                SET @ServidorInfo = dbo.fnAuditoria_ObtenerSessionInfo()
            END
            ELSE
            BEGIN
                SET @ServidorInfo = @SessionInfoDelete
            END
            
            -- Serializar datos previos (registro eliminado)
            SELECT @JsonPrevio = 
                '{"NumeroAsociado":' + CAST(d.NumeroAsociado AS NVARCHAR(10)) +
                ',"IdTipoAsociado":"' + dbo.fnAuditoria_ObtenerTipoAsociado(d.IdTipoAsociado) + '"' +
                ',"Nombre":"' + ISNULL(d.Nombre, '') + '"' +
                ',"SegundoNombre":"' + ISNULL(d.SegundoNombre, '') + '"' +
                ',"Apellido":"' + ISNULL(d.Apellido, '') + '"' +
                ',"SegundoApellido":"' + ISNULL(d.SegundoApellido, '') + '"' +
                ',"Estatus":"' + ISNULL(d.Estatus, '') + '"' +
                ',"TipoIdentificacion":"' + dbo.fnAuditoria_ObtenerTipoDocumento(d.TipoIdentificacion) + '"' +
                ',"NumeroIdentificacion":"' + ISNULL(d.NumeroIdentificacion, '') + '"' +
                ',"TelefonoResidencia":"' + ISNULL(d.TelefonoResidencia, '') + '"' +
                ',"TelefonoCelular":"' + ISNULL(d.TelefonoCelular, '') + '"' +
                ',"TelefonoFamiliar":"' + ISNULL(d.TelefonoFamiliar, '') + '"' +
                ',"TelefonoTrabajo":"' + ISNULL(d.TelefonoTrabajo, '') + '"' +
                ',"CorreoElectronico":"' + ISNULL(d.CorreoElectronico, '') + '"' +
                ',"Sexo":"' + ISNULL(d.Sexo, '') + '"' +
                ',"FechaNacimiento":"' + ISNULL(CONVERT(NVARCHAR(10), d.FechaNacimiento, 120), '') + '"' +
                ',"ProvinciaResidencia":"' + dbo.fnAuditoria_ObtenerProvincia(d.ProvinciaResidencia) + '"' +
                ',"DistritoResidencia":"' + dbo.fnAuditoria_ObtenerDistrito(d.DistritoResidencia) + '"' +
                ',"CorregimientoResidencia":"' + dbo.fnAuditoria_ObtenerCorregimiento(d.CorregimientoResidencia) + '"' +
                ',"DireccionResidencia":"' + ISNULL(d.DireccionResidencia, '') + '"' +
                ',"ProvinciaTrabajo":"' + dbo.fnAuditoria_ObtenerProvincia(d.ProvinciaTrabajo) + '"' +
                ',"DistritoTrabajo":"' + dbo.fnAuditoria_ObtenerDistrito(d.DistritoTrabajo) + '"' +
                ',"CorregimientoTrabajo":"' + dbo.fnAuditoria_ObtenerCorregimiento(d.CorregimientoTrabajo) + '"' +
                ',"DireccionTrabajo":"' + ISNULL(d.DireccionTrabajo, '') + '"' +
                ',"LugarTrabajo":"' + dbo.fnAuditoria_ObtenerLugarTrabajo(d.LugarTrabajo) + '"' +
                ',"Ocupacion":"' + dbo.fnAuditoria_ObtenerOcupacion(d.Ocupacion) + '"' +
                ',"PaisTrabajo":"' + dbo.fnAuditoria_ObtenerPais(d.PaisTrabajo) + '"' +
                ',"PaisResidencia":"' + dbo.fnAuditoria_ObtenerPais(d.PaisResidencia) + '"' +
                ',"NivelEstudio":"' + dbo.fnAuditoria_ObtenerNivelEstudio(d.NivelEstudio) + '"' +
                ',"Profesion":"' + dbo.fnAuditoria_ObtenerProfesion(d.Profesion) + '"' +
                ',"FechaCreacion":"' + ISNULL(CONVERT(NVARCHAR(23), d.FechaCreacion, 126), '') + '"' +
                ',"UsuarioCrea":"' + dbo.fnAuditoria_ObtenerUsuario(d.UsuarioCrea) + '"' +
                ',"FechaModificacion":"' + ISNULL(CONVERT(NVARCHAR(23), d.FechaModificacion, 126), '') + '"' +
                ',"UsuarioModifica":"' + dbo.fnAuditoria_ObtenerUsuario(d.UsuarioModifica) + '"' +
                ',"snEliminado":' + CASE WHEN d.snEliminado = 1 THEN 'true' ELSE 'false' END +
                ',"UsuarioElimina":"' + dbo.fnAuditoria_ObtenerUsuario(d.UsuarioElimina) + '"' +
                ',"FechaElimina":"' + ISNULL(CONVERT(NVARCHAR(23), d.FechaElimina, 126), '') + '"' +
                '}'
            FROM deleted d
            WHERE d.NumeroAsociado = @RegistroId
            SET @JsonPosterior = NULL
            
            -- Insertar en tabla de auditoría
            INSERT INTO tbLogsAuditoria (
                TablaAfectada, RegistroId, Operacion, UsuarioId, FechaHora,
                JsonPrevio, JsonPosterior, ServidorInfo, Comentarios
            )
            VALUES (
                'tbAsociados', @RegistroId, @Operacion, @UsuarioId, GETDATE(),
                @JsonPrevio, @JsonPosterior, @ServidorInfo, 'Registro eliminado (físico)'
            )
            
            FETCH NEXT FROM delete_cursor INTO @RegistroId, @UsuarioId, @IdSession
        END
        
        CLOSE delete_cursor
        DEALLOCATE delete_cursor
    END
END
GO

PRINT 'Trigger de auditoría para tbAsociados actualizado con JSON completo y SessionInfo desde tbLogSesionHdr'
GO
