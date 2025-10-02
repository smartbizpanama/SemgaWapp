-- =============================================
-- STORED PROCEDURES PARA GESTIÓN DE SOCIOS
-- =============================================

-- Procedimiento para obtener socios con filtros
CREATE PROCEDURE [dbo].[spGestionSocios_ObtenerSocios]
    @FiltroNombre NVARCHAR(100) = NULL,
    @FiltroTipo INT = NULL,
    @FiltroEstatus CHAR(1) = NULL,
    @FiltroTipoDocumento CHAR(1) = NULL,
    @FiltroIdentificacion NVARCHAR(50) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        SELECT
            a.NumeroAsociado, a.IdTipoAsociado, ta.TipoAsociado, a.Nombre, a.SegundoNombre,
            a.Apellido, a.SegundoApellido, a.Estatus, a.TipoIdentificacion, a.NumeroIdentificacion,
            a.TelefonoResidencia, a.TelefonoCelular, a.TelefonoFamiliar, a.CorreoElectronico,
            a.Sexo, a.FechaNacimiento, a.ProvinciaResidencia, a.DistritoResidencia,
            a.CorregimientoResidencia, a.DireccionResidencia, a.ProvinciaTrabajo,
            a.DistritoTrabajo, a.CorregimientoTrabajo, a.DireccionTrabajo, a.LugarTrabajo,
            a.Ocupacion, a.NivelEstudio, a.Profesion, a.FechaCreacion, a.UsuarioCrea,
            a.FechaModificacion, a.UsuarioModifica, a.snEliminado
        FROM tbAsociados a
        LEFT JOIN tbTipoAsociado ta ON a.IdTipoAsociado = ta.IdTipoAsociado
        WHERE a.snEliminado = 0
            AND (@FiltroNombre IS NULL OR
                 a.Nombre LIKE '%' + @FiltroNombre + '%' OR
                 a.Apellido LIKE '%' + @FiltroNombre + '%' OR
                 a.SegundoNombre LIKE '%' + @FiltroNombre + '%' OR
                 a.SegundoApellido LIKE '%' + @FiltroNombre + '%')
            AND (@FiltroTipo IS NULL OR a.IdTipoAsociado = @FiltroTipo)
            AND (@FiltroEstatus IS NULL OR a.Estatus = @FiltroEstatus)
            AND (@FiltroTipoDocumento IS NULL OR a.TipoIdentificacion = @FiltroTipoDocumento)
            AND (@FiltroIdentificacion IS NULL OR a.NumeroIdentificacion LIKE '%' + @FiltroIdentificacion + '%')
        ORDER BY a.NumeroAsociado DESC;
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();
        RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH
END
GO

-- Procedimiento para obtener un socio por número
CREATE PROCEDURE [dbo].[spGestionSocios_ObtenerSocioPorNumero]
    @NumeroAsociado INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        SELECT
            a.NumeroAsociado, a.IdTipoAsociado, ta.TipoAsociado, a.Nombre, a.SegundoNombre,
            a.Apellido, a.SegundoApellido, a.Estatus, a.TipoIdentificacion, a.NumeroIdentificacion,
            a.TelefonoResidencia, a.TelefonoCelular, a.TelefonoFamiliar, a.CorreoElectronico,
            a.Sexo, a.FechaNacimiento, a.ProvinciaResidencia, a.DistritoResidencia,
            a.CorregimientoResidencia, a.DireccionResidencia, a.ProvinciaTrabajo,
            a.DistritoTrabajo, a.CorregimientoTrabajo, a.DireccionTrabajo, a.LugarTrabajo,
            a.Ocupacion, a.NivelEstudio, a.Profesion, a.FechaCreacion, a.UsuarioCrea,
            a.FechaModificacion, a.UsuarioModifica, a.snEliminado
        FROM tbAsociados a
        LEFT JOIN tbTipoAsociado ta ON a.IdTipoAsociado = ta.IdTipoAsociado
        WHERE a.NumeroAsociado = @NumeroAsociado
            AND a.snEliminado = 0;
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();
        RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH
END
GO

-- Procedimiento para crear un nuevo socio
CREATE PROCEDURE [dbo].[spGestionSocios_CrearSocio]
    @IdTipoAsociado INT = NULL, @Nombre NVARCHAR(100) = NULL, @SegundoNombre NVARCHAR(100) = NULL,
    @Apellido NVARCHAR(100) = NULL, @SegundoApellido NVARCHAR(100) = NULL, @Estatus CHAR(1) = 'A',
    @TipoIdentificacion NVARCHAR(20) = NULL, @NumeroIdentificacion NVARCHAR(50) = NULL,
    @TelefonoResidencia NVARCHAR(20) = NULL, @TelefonoCelular NVARCHAR(20) = NULL,
    @TelefonoFamiliar NVARCHAR(20) = NULL, @CorreoElectronico NVARCHAR(100) = NULL,
    @Sexo CHAR(1) = NULL, @FechaNacimiento DATE = NULL, @ProvinciaResidencia NVARCHAR(50) = NULL,
    @DistritoResidencia NVARCHAR(50) = NULL, @CorregimientoResidencia NVARCHAR(50) = NULL,
    @DireccionResidencia NVARCHAR(200) = NULL, @ProvinciaTrabajo NVARCHAR(50) = NULL,
    @DistritoTrabajo NVARCHAR(50) = NULL, @CorregimientoTrabajo NVARCHAR(50) = NULL,
    @DireccionTrabajo NVARCHAR(200) = NULL, @LugarTrabajo NVARCHAR(100) = NULL,
    @Ocupacion NVARCHAR(100) = NULL, @NivelEstudio NVARCHAR(50) = NULL, @Profesion NVARCHAR(100) = NULL,
    @Usuario NVARCHAR(50) = NULL
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
            TelefonoFamiliar, CorreoElectronico, Sexo, FechaNacimiento, ProvinciaResidencia,
            DistritoResidencia, CorregimientoResidencia, DireccionResidencia, ProvinciaTrabajo,
            DistritoTrabajo, CorregimientoTrabajo, DireccionTrabajo, LugarTrabajo, Ocupacion,
            NivelEstudio, Profesion, FechaCreacion, UsuarioCrea, snEliminado
        ) VALUES (
            @IdTipoAsociado, @Nombre, @SegundoNombre, @Apellido, @SegundoApellido, @Estatus,
            @TipoIdentificacion, @NumeroIdentificacion, @TelefonoResidencia, @TelefonoCelular,
            @TelefonoFamiliar, @CorreoElectronico, @Sexo, @FechaNacimiento, @ProvinciaResidencia,
            @DistritoResidencia, @CorregimientoResidencia, @DireccionResidencia, @ProvinciaTrabajo,
            @DistritoTrabajo, @CorregimientoTrabajo, @DireccionTrabajo, @LugarTrabajo, @Ocupacion,
            @NivelEstudio, @Profesion, GETDATE(), @Usuario, 0
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

-- Procedimiento para actualizar un socio existente
CREATE PROCEDURE [dbo].[spGestionSocios_ActualizarSocio]
    @NumeroAsociado INT, @IdTipoAsociado INT = NULL, @Nombre NVARCHAR(100) = NULL,
    @SegundoNombre NVARCHAR(100) = NULL, @Apellido NVARCHAR(100) = NULL,
    @SegundoApellido NVARCHAR(100) = NULL, @Estatus CHAR(1) = NULL,
    @TipoIdentificacion NVARCHAR(20) = NULL, @NumeroIdentificacion NVARCHAR(50) = NULL,
    @TelefonoResidencia NVARCHAR(20) = NULL, @TelefonoCelular NVARCHAR(20) = NULL,
    @TelefonoFamiliar NVARCHAR(20) = NULL, @CorreoElectronico NVARCHAR(100) = NULL,
    @Sexo CHAR(1) = NULL, @FechaNacimiento DATE = NULL, @ProvinciaResidencia NVARCHAR(50) = NULL,
    @DistritoResidencia NVARCHAR(50) = NULL, @CorregimientoResidencia NVARCHAR(50) = NULL,
    @DireccionResidencia NVARCHAR(200) = NULL, @ProvinciaTrabajo NVARCHAR(50) = NULL,
    @DistritoTrabajo NVARCHAR(50) = NULL, @CorregimientoTrabajo NVARCHAR(50) = NULL,
    @DireccionTrabajo NVARCHAR(200) = NULL, @LugarTrabajo NVARCHAR(100) = NULL,
    @Ocupacion NVARCHAR(100) = NULL, @NivelEstudio NVARCHAR(50) = NULL, @Profesion NVARCHAR(100) = NULL,
    @Usuario NVARCHAR(50) = NULL
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
            TelefonoFamiliar = @TelefonoFamiliar, CorreoElectronico = @CorreoElectronico,
            Sexo = @Sexo, FechaNacimiento = @FechaNacimiento, ProvinciaResidencia = @ProvinciaResidencia,
            DistritoResidencia = @DistritoResidencia, CorregimientoResidencia = @CorregimientoResidencia,
            DireccionResidencia = @DireccionResidencia, ProvinciaTrabajo = @ProvinciaTrabajo,
            DistritoTrabajo = @DistritoTrabajo, CorregimientoTrabajo = @CorregimientoTrabajo,
            DireccionTrabajo = @DireccionTrabajo, LugarTrabajo = @LugarTrabajo, Ocupacion = @Ocupacion,
            NivelEstudio = @NivelEstudio, Profesion = @Profesion, FechaModificacion = GETDATE(),
            UsuarioModifica = @Usuario
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
