-- =============================================
-- STORED PROCEDURES PARA GESTIÓN DE SOCIOS CON SESSION TRACKING (FIXED)
-- =============================================

-- Eliminar y recrear spGestionSocios_CrearSocio
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spGestionSocios_CrearSocio]') AND type in (N'P', N'PC'))
    DROP PROCEDURE [dbo].[spGestionSocios_CrearSocio]
GO

CREATE PROCEDURE [dbo].[spGestionSocios_CrearSocio]
    @IdTipoAsociado INT = NULL, @Nombre NVARCHAR(100) = NULL, @SegundoNombre NVARCHAR(100) = NULL,
    @Apellido NVARCHAR(100) = NULL, @SegundoApellido NVARCHAR(100) = NULL, @Estatus CHAR(1) = 'A',
    @TipoIdentificacion NVARCHAR(20) = NULL, @NumeroIdentificacion NVARCHAR(50) = NULL,
    @TelefonoResidencia NVARCHAR(20) = NULL, @TelefonoCelular NVARCHAR(20) = NULL,
    @TelefonoFamiliar NVARCHAR(20) = NULL, @TelefonoTrabajo NVARCHAR(20) = NULL,
    @CorreoElectronico NVARCHAR(100) = NULL,
    @Sexo CHAR(1) = NULL, @FechaNacimiento DATE = NULL, @ProvinciaResidencia NVARCHAR(50) = NULL,
    @DistritoResidencia NVARCHAR(50) = NULL, @CorregimientoResidencia NVARCHAR(50) = NULL,
    @DireccionResidencia NVARCHAR(200) = NULL, @ProvinciaTrabajo NVARCHAR(50) = NULL,
    @DistritoTrabajo NVARCHAR(50) = NULL, @CorregimientoTrabajo NVARCHAR(50) = NULL,
    @DireccionTrabajo NVARCHAR(200) = NULL, @LugarTrabajo NVARCHAR(100) = NULL,
    @Ocupacion NVARCHAR(100) = NULL, @NivelEstudio NVARCHAR(50) = NULL, @Profesion NVARCHAR(100) = NULL,
    @PaisResidencia NVARCHAR(10) = NULL, @PaisTrabajo NVARCHAR(10) = NULL,
    @Usuario NVARCHAR(50) = NULL, @IdSession NVARCHAR(50) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        IF EXISTS (SELECT 1 FROM tbAsociados WHERE NumeroIdentificacion = @NumeroIdentificacion AND snEliminado = 0)
        BEGIN
            RAISERROR('Ya existe un socio con este número de identificación', 16, 1);
            RETURN;
        END
        INSERT INTO tbAsociados (
            IdTipoAsociado, Nombre, SegundoNombre, Apellido, SegundoApellido, Estatus,
            TipoIdentificacion, NumeroIdentificacion, TelefonoResidencia, TelefonoCelular,
            TelefonoFamiliar, TelefonoTrabajo, CorreoElectronico, Sexo, FechaNacimiento, ProvinciaResidencia,
            DistritoResidencia, CorregimientoResidencia, DireccionResidencia, ProvinciaTrabajo,
            DistritoTrabajo, CorregimientoTrabajo, DireccionTrabajo, LugarTrabajo, Ocupacion,
            NivelEstudio, Profesion, PaisResidencia, PaisTrabajo, FechaCreacion, UsuarioCrea, 
            SysLastSessionID, snEliminado
        ) VALUES (
            @IdTipoAsociado, @Nombre, @SegundoNombre, @Apellido, @SegundoApellido, @Estatus,
            @TipoIdentificacion, @NumeroIdentificacion, @TelefonoResidencia, @TelefonoCelular,
            @TelefonoFamiliar, @TelefonoTrabajo, @CorreoElectronico, @Sexo, @FechaNacimiento, @ProvinciaResidencia,
            @DistritoResidencia, @CorregimientoResidencia, @DireccionResidencia, @ProvinciaTrabajo,
            @DistritoTrabajo, @CorregimientoTrabajo, @DireccionTrabajo, @LugarTrabajo, @Ocupacion,
            @NivelEstudio, @Profesion, @PaisResidencia, @PaisTrabajo, GETDATE(), CAST(@Usuario AS INT), 
            @IdSession, 0
        );
        SELECT SCOPE_IDENTITY() AS NumeroAsociado;
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();
        RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH
END
GO

-- Eliminar y recrear spGestionSocios_ActualizarSocio
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spGestionSocios_ActualizarSocio]') AND type in (N'P', N'PC'))
    DROP PROCEDURE [dbo].[spGestionSocios_ActualizarSocio]
GO

CREATE PROCEDURE [dbo].[spGestionSocios_ActualizarSocio]
    @NumeroAsociado INT, @IdTipoAsociado INT = NULL, @Nombre NVARCHAR(100) = NULL,
    @SegundoNombre NVARCHAR(100) = NULL, @Apellido NVARCHAR(100) = NULL,
    @SegundoApellido NVARCHAR(100) = NULL, @Estatus CHAR(1) = NULL,
    @TipoIdentificacion NVARCHAR(20) = NULL, @NumeroIdentificacion NVARCHAR(50) = NULL,
    @TelefonoResidencia NVARCHAR(20) = NULL, @TelefonoCelular NVARCHAR(20) = NULL,
    @TelefonoFamiliar NVARCHAR(20) = NULL, @TelefonoTrabajo NVARCHAR(20) = NULL,
    @CorreoElectronico NVARCHAR(100) = NULL,
    @Sexo CHAR(1) = NULL, @FechaNacimiento DATE = NULL, @ProvinciaResidencia NVARCHAR(50) = NULL,
    @DistritoResidencia NVARCHAR(50) = NULL, @CorregimientoResidencia NVARCHAR(50) = NULL,
    @DireccionResidencia NVARCHAR(200) = NULL, @ProvinciaTrabajo NVARCHAR(50) = NULL,
    @DistritoTrabajo NVARCHAR(50) = NULL, @CorregimientoTrabajo NVARCHAR(50) = NULL,
    @DireccionTrabajo NVARCHAR(200) = NULL, @LugarTrabajo NVARCHAR(100) = NULL,
    @Ocupacion NVARCHAR(100) = NULL, @NivelEstudio NVARCHAR(50) = NULL, @Profesion NVARCHAR(100) = NULL,
    @PaisResidencia NVARCHAR(10) = NULL, @PaisTrabajo NVARCHAR(10) = NULL,
    @Usuario NVARCHAR(50) = NULL, @IdSession NVARCHAR(50) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM tbAsociados WHERE NumeroAsociado = @NumeroAsociado AND snEliminado = 0)
        BEGIN
            RAISERROR('El socio no existe o ha sido eliminado', 16, 1);
            RETURN;
        END
        IF EXISTS (SELECT 1 FROM tbAsociados WHERE NumeroIdentificacion = @NumeroIdentificacion AND NumeroAsociado != @NumeroAsociado AND snEliminado = 0)
        BEGIN
            RAISERROR('Ya existe otro socio con este número de identificación', 16, 1);
            RETURN;
        END
        UPDATE tbAsociados SET
            IdTipoAsociado = @IdTipoAsociado, Nombre = @Nombre, SegundoNombre = @SegundoNombre,
            Apellido = @Apellido, SegundoApellido = @SegundoApellido, Estatus = @Estatus,
            TipoIdentificacion = @TipoIdentificacion, NumeroIdentificacion = @NumeroIdentificacion,
            TelefonoResidencia = @TelefonoResidencia, TelefonoCelular = @TelefonoCelular,
            TelefonoFamiliar = @TelefonoFamiliar, TelefonoTrabajo = @TelefonoTrabajo, CorreoElectronico = @CorreoElectronico,
            Sexo = @Sexo, FechaNacimiento = @FechaNacimiento, ProvinciaResidencia = @ProvinciaResidencia,
            DistritoResidencia = @DistritoResidencia, CorregimientoResidencia = @CorregimientoResidencia,
            DireccionResidencia = @DireccionResidencia, ProvinciaTrabajo = @ProvinciaTrabajo,
            DistritoTrabajo = @DistritoTrabajo, CorregimientoTrabajo = @CorregimientoTrabajo,
            DireccionTrabajo = @DireccionTrabajo, LugarTrabajo = @LugarTrabajo, Ocupacion = @Ocupacion,
            NivelEstudio = @NivelEstudio, Profesion = @Profesion, PaisResidencia = @PaisResidencia,
            PaisTrabajo = @PaisTrabajo, FechaModificacion = GETDATE(), UsuarioModifica = CAST(@Usuario AS INT),
            SysLastSessionID = @IdSession
        WHERE NumeroAsociado = @NumeroAsociado;
        IF @@ROWCOUNT = 0
        BEGIN
            RAISERROR('No se pudo actualizar el socio', 16, 1);
            RETURN;
        END
        SELECT 'Socio actualizado correctamente' AS Mensaje;
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();
        RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH
END
GO

-- Eliminar y recrear spGestionSocios_EliminarAsociado
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spGestionSocios_EliminarAsociado]') AND type in (N'P', N'PC'))
    DROP PROCEDURE [dbo].[spGestionSocios_EliminarAsociado]
GO

CREATE PROCEDURE [dbo].[spGestionSocios_EliminarAsociado]
    @NumeroAsociado INT,
    @UsuarioElimina INT,
    @IdSession NVARCHAR(50) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -- Validar que el asociado existe
        IF NOT EXISTS (SELECT 1 FROM tbAsociados WHERE NumeroAsociado = @NumeroAsociado)
        BEGIN
            RAISERROR('El asociado con número %d no existe', 16, 1, @NumeroAsociado);
            RETURN;
        END
        
        -- Validar que el asociado no esté ya eliminado
        IF EXISTS (SELECT 1 FROM tbAsociados WHERE NumeroAsociado = @NumeroAsociado AND snEliminado = 1)
        BEGIN
            RAISERROR('El asociado con número %d ya está eliminado', 16, 1, @NumeroAsociado);
            RETURN;
        END
        
        -- Validar que el asociado no tenga auxiliares activos
        DECLARE @CantidadAuxiliares INT;
        SELECT @CantidadAuxiliares = COUNT(*)
        FROM tbAuxiliares 
        WHERE NumeroAsociado = @NumeroAsociado 
        AND snEliminado = 0;
        
        IF @CantidadAuxiliares > 0
        BEGIN
            RAISERROR('No se puede eliminar el asociado %d porque tiene %d auxiliar(es) activo(s). Debe eliminar primero los auxiliares.', 16, 1, @NumeroAsociado, @CantidadAuxiliares);
            RETURN;
        END
        
        -- Validar que el asociado no tenga beneficiarios
        DECLARE @CantidadBeneficiarios INT;
        SELECT @CantidadBeneficiarios = COUNT(*)
        FROM tbBeneficiarios 
        WHERE NumeroAsociado = @NumeroAsociado 
        AND snEliminado = 0;
        
        IF @CantidadBeneficiarios > 0
        BEGIN
            RAISERROR('No se puede eliminar el asociado %d porque tiene %d beneficiario(s) activo(s). Debe eliminar primero los beneficiarios.', 16, 1, @NumeroAsociado, @CantidadBeneficiarios);
            RETURN;
        END
        
        -- Obtener información del asociado antes de eliminar (para auditoría)
        DECLARE @NombreCompleto NVARCHAR(200);
        SELECT @NombreCompleto = ISNULL(Nombre, '') + ' ' + ISNULL(Apellido, '')
        FROM tbAsociados 
        WHERE NumeroAsociado = @NumeroAsociado;
        
        -- Realizar soft delete del asociado con session tracking
        UPDATE tbAsociados 
        SET 
            snEliminado = 1,
            FechaModificacion = GETDATE(),
            UsuarioModifica = @UsuarioElimina,
            SysLastSessionID = @IdSession
        WHERE NumeroAsociado = @NumeroAsociado;
        
        -- Verificar que la eliminación fue exitosa
        IF @@ROWCOUNT = 0
        BEGIN
            RAISERROR('Error al eliminar el asociado %d', 16, 1, @NumeroAsociado);
            RETURN;
        END
        
        -- Retornar éxito
        SELECT 
            'SUCCESS' AS Resultado,
            'Asociado eliminado exitosamente' AS Mensaje,
            @NumeroAsociado AS NumeroAsociado,
            @NombreCompleto AS NombreCompleto,
            @UsuarioElimina AS UsuarioElimina,
            GETDATE() AS FechaEliminacion;
            
    END TRY
    BEGIN CATCH
        DECLARE @Mensaje NVARCHAR(2048);
        SET @Mensaje = ERROR_MESSAGE();
        
        -- Retornar error
        SELECT 
            'ERROR' AS Resultado,
            @Mensaje AS Mensaje,
            @NumeroAsociado AS NumeroAsociado,
            NULL AS NombreCompleto,
            @UsuarioElimina AS UsuarioElimina,
            NULL AS FechaEliminacion;
    END CATCH
END
GO

PRINT 'Stored Procedures recreados con Session Tracking:'
PRINT '- spGestionSocios_CrearSocio: Agregado @IdSession y SysLastSessionID'
PRINT '- spGestionSocios_ActualizarSocio: Agregado @IdSession y SysLastSessionID'
PRINT '- spGestionSocios_EliminarAsociado: Agregado @IdSession y SysLastSessionID'
GO
