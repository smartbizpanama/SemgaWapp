-- =============================================
-- Script: Actualizar stored procedures para manejar ProvinciaTrabajo (CORREGIDO)
-- Descripción: Modificar SPs para trabajar con tbProvincias usando Code en las relaciones
-- Fecha: 2024
-- =============================================

-- Modificar spGestionSocios_CrearSocio (CORREGIDO)
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spGestionSocios_CrearSocio]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[spGestionSocios_CrearSocio];
GO

CREATE PROCEDURE [dbo].[spGestionSocios_CrearSocio]
    @IdTipoAsociado INT,
    @Nombre NVARCHAR(50),
    @SegundoNombre NVARCHAR(50) = NULL,
    @Apellido NVARCHAR(50),
    @SegundoApellido NVARCHAR(50) = NULL,
    @Estatus CHAR(1),
    @TipoIdentificacion VARCHAR(10),
    @NumeroIdentificacion NVARCHAR(20),
    @TelefonoResidencia VARCHAR(15) = NULL,
    @TelefonoCelular VARCHAR(15) = NULL,
    @TelefonoFamiliar VARCHAR(15) = NULL,
    @CorreoElectronico NVARCHAR(100) = NULL,
    @Sexo CHAR(1),
    @FechaNacimiento DATE,
    @ProvinciaResidencia VARCHAR(50) = NULL,
    @DistritoResidencia VARCHAR(50) = NULL,
    @CorregimientoResidencia VARCHAR(50) = NULL,
    @DireccionResidencia VARCHAR(200) = NULL,
    @DistritoTrabajo VARCHAR(50) = NULL,
    @CorregimientoTrabajo VARCHAR(50) = NULL,
    @DireccionTrabajo VARCHAR(200) = NULL,
    @NivelEstudio INT = NULL,
    @Profesion INT = NULL,
    @UsuarioCrea INT,
    @LugarTrabajo INT = NULL, -- Code de tbEmpresas
    @Ocupacion INT = NULL, -- Code de tbOcupaciones
    @PaisTrabajo NVARCHAR(3) = NULL, -- Code de tbPaises
    @ProvinciaTrabajo INT = NULL -- Code de tbProvincias
AS
BEGIN
    SET NOCOUNT ON;
    
    INSERT INTO tbAsociados (
        IdTipoAsociado, Nombre, SegundoNombre, Apellido, SegundoApellido, Estatus,
        TipoIdentificacion, NumeroIdentificacion, TelefonoResidencia, TelefonoCelular,
        TelefonoFamiliar, CorreoElectronico, Sexo, FechaNacimiento, ProvinciaResidencia,
        DistritoResidencia, CorregimientoResidencia, DireccionResidencia, 
        DistritoTrabajo, CorregimientoTrabajo, DireccionTrabajo, NivelEstudio, Profesion,
        FechaCreacion, UsuarioCrea, snEliminado, LugarTrabajo, Ocupacion, PaisTrabajo, ProvinciaTrabajo
    ) VALUES (
        @IdTipoAsociado, @Nombre, @SegundoNombre, @Apellido, @SegundoApellido, @Estatus,
        @TipoIdentificacion, @NumeroIdentificacion, @TelefonoResidencia, @TelefonoCelular,
        @TelefonoFamiliar, @CorreoElectronico, @Sexo, @FechaNacimiento, @ProvinciaResidencia,
        @DistritoResidencia, @CorregimientoResidencia, @DireccionResidencia, 
        @DistritoTrabajo, @CorregimientoTrabajo, @DireccionTrabajo, @NivelEstudio, @Profesion,
        GETDATE(), @UsuarioCrea, 0, @LugarTrabajo, @Ocupacion, @PaisTrabajo, @ProvinciaTrabajo
    );
    
    SELECT SCOPE_IDENTITY() AS NumeroAsociado;
END
GO
PRINT '✅ spGestionSocios_CrearSocio corregido'
GO

-- Modificar spGestionSocios_ActualizarSocio (CORREGIDO)
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
    @Estatus CHAR(1),
    @TipoIdentificacion VARCHAR(10),
    @NumeroIdentificacion NVARCHAR(20),
    @TelefonoResidencia VARCHAR(15) = NULL,
    @TelefonoCelular VARCHAR(15) = NULL,
    @TelefonoFamiliar VARCHAR(15) = NULL,
    @CorreoElectronico NVARCHAR(100) = NULL,
    @Sexo CHAR(1),
    @FechaNacimiento DATE,
    @ProvinciaResidencia VARCHAR(50) = NULL,
    @DistritoResidencia VARCHAR(50) = NULL,
    @CorregimientoResidencia VARCHAR(50) = NULL,
    @DireccionResidencia VARCHAR(200) = NULL,
    @DistritoTrabajo VARCHAR(50) = NULL,
    @CorregimientoTrabajo VARCHAR(50) = NULL,
    @DireccionTrabajo VARCHAR(200) = NULL,
    @NivelEstudio INT = NULL,
    @Profesion INT = NULL,
    @UsuarioModifica INT,
    @LugarTrabajo INT = NULL, -- Code de tbEmpresas
    @Ocupacion INT = NULL, -- Code de tbOcupaciones
    @PaisTrabajo NVARCHAR(3) = NULL, -- Code de tbPaises
    @ProvinciaTrabajo INT = NULL -- Code de tbProvincias
AS
BEGIN
    SET NOCOUNT ON;
    
    UPDATE tbAsociados
    SET
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
        DistritoTrabajo = @DistritoTrabajo,
        CorregimientoTrabajo = @CorregimientoTrabajo,
        DireccionTrabajo = @DireccionTrabajo,
        NivelEstudio = @NivelEstudio,
        Profesion = @Profesion,
        FechaModificacion = GETDATE(),
        UsuarioModifica = @UsuarioModifica,
        LugarTrabajo = @LugarTrabajo,
        Ocupacion = @Ocupacion,
        PaisTrabajo = @PaisTrabajo,
        ProvinciaTrabajo = @ProvinciaTrabajo
    WHERE NumeroAsociado = @NumeroAsociado;
END
GO
PRINT '✅ spGestionSocios_ActualizarSocio corregido'
GO

PRINT '✅ Stored procedures corregidos para manejar ProvinciaTrabajo'
GO

