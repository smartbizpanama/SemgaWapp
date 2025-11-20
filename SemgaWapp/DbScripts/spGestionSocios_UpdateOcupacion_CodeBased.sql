-- =============================================
-- Script: Actualizar stored procedures para usar Code en relaciones (CORREGIDO)
-- Descripción: Modificar SPs para trabajar con tbOcupaciones usando Code en las relaciones
-- Fecha: 2024
-- =============================================

-- Modificar spGestionSocios_ObtenerSocios
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spGestionSocios_ObtenerSocios]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[spGestionSocios_ObtenerSocios];
GO

CREATE PROCEDURE [dbo].[spGestionSocios_ObtenerSocios]
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        a.NumeroAsociado,
        a.IdTipoAsociado,
        a.Nombre,
        a.SegundoNombre,
        a.Apellido,
        a.SegundoApellido,
        a.Estatus,
        a.TipoIdentificacion,
        a.NumeroIdentificacion,
        a.TelefonoResidencia,
        a.TelefonoCelular,
        a.TelefonoFamiliar,
        a.CorreoElectronico,
        a.Sexo,
        a.FechaNacimiento,
        a.ProvinciaResidencia,
        a.DistritoResidencia,
        a.CorregimientoResidencia,
        a.DireccionResidencia,
        a.ProvinciaTrabajo,
        a.DistritoTrabajo,
        a.CorregimientoTrabajo,
        a.DireccionTrabajo,
        a.NivelEstudio,
        a.Profesion,
        a.FechaCreacion,
        a.UsuarioCrea,
        a.FechaModificacion,
        a.UsuarioModifica,
        a.LugarTrabajo,
        e.Descripcion as LugarTrabajoDescripcion,
        a.Ocupacion,
        o.Descripcion as OcupacionDescripcion
    FROM tbAsociados a
    LEFT JOIN tbEmpresas e ON a.LugarTrabajo = e.Code AND e.snEliminado = 0
    LEFT JOIN tbOcupaciones o ON a.Ocupacion = o.Code AND o.snEliminado = 0
    WHERE a.snEliminado = 0
    ORDER BY a.NumeroAsociado;
END
GO

PRINT '✅ spGestionSocios_ObtenerSocios actualizado'
GO

-- Modificar spGestionSocios_ObtenerSocioPorNumero
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spGestionSocios_ObtenerSocioPorNumero]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[spGestionSocios_ObtenerSocioPorNumero];
GO

CREATE PROCEDURE [dbo].[spGestionSocios_ObtenerSocioPorNumero]
    @NumeroAsociado INT
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        a.NumeroAsociado,
        a.IdTipoAsociado,
        a.Nombre,
        a.SegundoNombre,
        a.Apellido,
        a.SegundoApellido,
        a.Estatus,
        a.TipoIdentificacion,
        a.NumeroIdentificacion,
        a.TelefonoResidencia,
        a.TelefonoCelular,
        a.TelefonoFamiliar,
        a.CorreoElectronico,
        a.Sexo,
        a.FechaNacimiento,
        a.ProvinciaResidencia,
        a.DistritoResidencia,
        a.CorregimientoResidencia,
        a.DireccionResidencia,
        a.ProvinciaTrabajo,
        a.DistritoTrabajo,
        a.CorregimientoTrabajo,
        a.DireccionTrabajo,
        a.NivelEstudio,
        a.Profesion,
        a.FechaCreacion,
        a.UsuarioCrea,
        a.FechaModificacion,
        a.UsuarioModifica,
        a.LugarTrabajo,
        e.Descripcion as LugarTrabajoDescripcion,
        a.Ocupacion,
        o.Descripcion as OcupacionDescripcion
    FROM tbAsociados a
    LEFT JOIN tbEmpresas e ON a.LugarTrabajo = e.Code AND e.snEliminado = 0
    LEFT JOIN tbOcupaciones o ON a.Ocupacion = o.Code AND o.snEliminado = 0
    WHERE a.NumeroAsociado = @NumeroAsociado AND a.snEliminado = 0;
END
GO

PRINT '✅ spGestionSocios_ObtenerSocioPorNumero actualizado'
GO

-- Modificar spGestionSocios_CrearSocio
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spGestionSocios_CrearSocio]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[spGestionSocios_CrearSocio];
GO

CREATE PROCEDURE [dbo].[spGestionSocios_CrearSocio]
    @NumeroAsociado INT,
    @IdTipoAsociado INT,
    @Nombre NVARCHAR(50),
    @SegundoNombre NVARCHAR(50) = NULL,
    @Apellido NVARCHAR(50),
    @SegundoApellido NVARCHAR(50) = NULL,
    @Estatus CHAR(1) = 'A',
    @TipoIdentificacion VARCHAR(20),
    @NumeroIdentificacion NVARCHAR(20),
    @TelefonoResidencia VARCHAR(20) = NULL,
    @TelefonoCelular VARCHAR(20) = NULL,
    @TelefonoFamiliar VARCHAR(20) = NULL,
    @CorreoElectronico NVARCHAR(100) = NULL,
    @Sexo CHAR(1),
    @FechaNacimiento DATE,
    @ProvinciaResidencia VARCHAR(50) = NULL,
    @DistritoResidencia VARCHAR(50) = NULL,
    @CorregimientoResidencia VARCHAR(50) = NULL,
    @DireccionResidencia VARCHAR(200) = NULL,
    @ProvinciaTrabajo VARCHAR(50) = NULL,
    @DistritoTrabajo VARCHAR(50) = NULL,
    @CorregimientoTrabajo VARCHAR(50) = NULL,
    @DireccionTrabajo VARCHAR(200) = NULL,
    @NivelEstudio INT = NULL,
    @Profesion INT = NULL,
    @LugarTrabajo INT,
    @Ocupacion INT,
    @UsuarioCrea INT = 1
AS
BEGIN
    SET NOCOUNT ON;
    
    INSERT INTO tbAsociados (
        NumeroAsociado, IdTipoAsociado, Nombre, SegundoNombre, Apellido, SegundoApellido,
        Estatus, TipoIdentificacion, NumeroIdentificacion, TelefonoResidencia, TelefonoCelular,
        TelefonoFamiliar, CorreoElectronico, Sexo, FechaNacimiento,
        ProvinciaResidencia, DistritoResidencia, CorregimientoResidencia, DireccionResidencia,
        ProvinciaTrabajo, DistritoTrabajo, CorregimientoTrabajo, DireccionTrabajo,
        NivelEstudio, Profesion, LugarTrabajo, Ocupacion,
        FechaCreacion, UsuarioCrea, snEliminado
    )
    VALUES (
        @NumeroAsociado, @IdTipoAsociado, @Nombre, @SegundoNombre, @Apellido, @SegundoApellido,
        @Estatus, @TipoIdentificacion, @NumeroIdentificacion, @TelefonoResidencia, @TelefonoCelular,
        @TelefonoFamiliar, @CorreoElectronico, @Sexo, @FechaNacimiento,
        @ProvinciaResidencia, @DistritoResidencia, @CorregimientoResidencia, @DireccionResidencia,
        @ProvinciaTrabajo, @DistritoTrabajo, @CorregimientoTrabajo, @DireccionTrabajo,
        @NivelEstudio, @Profesion, @LugarTrabajo, @Ocupacion,
        GETDATE(), @UsuarioCrea, 0
    );
    
    SELECT SCOPE_IDENTITY() as ID;
END
GO

PRINT '✅ spGestionSocios_CrearSocio actualizado'
GO

-- Modificar spGestionSocios_ActualizarSocio
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spGestionSocios_ActualizarSocio]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[spGestionSocios_ActualizarSocio];
GO

CREATE PROCEDURE [dbo].[spGestionSocios_ActualizarSocio]
    @NumeroAsociado INT,
    @IdTipoAsociado INT,
    @Nombre NVARCHAR(50),
    @SegundoNombre NVARCHAR(50) = NULL,
    @Apellido NVARCHAR(50),
    @SegundoApellido NVARCHAR(50) = NULL,
    @Estatus CHAR(1) = 'A',
    @TipoIdentificacion VARCHAR(20),
    @NumeroIdentificacion NVARCHAR(20),
    @TelefonoResidencia VARCHAR(20) = NULL,
    @TelefonoCelular VARCHAR(20) = NULL,
    @TelefonoFamiliar VARCHAR(20) = NULL,
    @CorreoElectronico NVARCHAR(100) = NULL,
    @Sexo CHAR(1),
    @FechaNacimiento DATE,
    @ProvinciaResidencia VARCHAR(50) = NULL,
    @DistritoResidencia VARCHAR(50) = NULL,
    @CorregimientoResidencia VARCHAR(50) = NULL,
    @DireccionResidencia VARCHAR(200) = NULL,
    @ProvinciaTrabajo VARCHAR(50) = NULL,
    @DistritoTrabajo VARCHAR(50) = NULL,
    @CorregimientoTrabajo VARCHAR(50) = NULL,
    @DireccionTrabajo VARCHAR(200) = NULL,
    @NivelEstudio INT = NULL,
    @Profesion INT = NULL,
    @LugarTrabajo INT,
    @Ocupacion INT,
    @UsuarioModifica INT = 1
AS
BEGIN
    SET NOCOUNT ON;
    
    UPDATE tbAsociados SET
        IdTipoAsociado = @IdTipoAsociado,
        Nombre = @Nombre,
        SegundoNombre = @SegundoNombre,
        Apellido = @Apellido,
        SegundoApellido = @SegundoApellido,
        Estatus = @Estatus,
        TipoIdentificacion = @TipoIdentificacion,
        NumeroIdentificacion = @NumeroIdentificacion,
        TelefonoResidencia = @TelefonoResidencia,
        TelefonoCelular = @TelefonoCelular,
        TelefonoFamiliar = @TelefonoFamiliar,
        CorreoElectronico = @CorreoElectronico,
        Sexo = @Sexo,
        FechaNacimiento = @FechaNacimiento,
        ProvinciaResidencia = @ProvinciaResidencia,
        DistritoResidencia = @DistritoResidencia,
        CorregimientoResidencia = @CorregimientoResidencia,
        DireccionResidencia = @DireccionResidencia,
        ProvinciaTrabajo = @ProvinciaTrabajo,
        DistritoTrabajo = @DistritoTrabajo,
        CorregimientoTrabajo = @CorregimientoTrabajo,
        DireccionTrabajo = @DireccionTrabajo,
        NivelEstudio = @NivelEstudio,
        Profesion = @Profesion,
        LugarTrabajo = @LugarTrabajo,
        Ocupacion = @Ocupacion,
        FechaModificacion = GETDATE(),
        UsuarioModifica = @UsuarioModifica
    WHERE NumeroAsociado = @NumeroAsociado;
END
GO

PRINT '✅ spGestionSocios_ActualizarSocio actualizado'
GO

PRINT '🎉 Todos los stored procedures actualizados para usar Code en relaciones'
GO

