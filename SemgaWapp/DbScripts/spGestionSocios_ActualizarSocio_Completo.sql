-- =============================================
-- Script: Recrear spGestionSocios_ActualizarSocio completo
-- Descripción: Asegurar que el SP tenga todos los parámetros necesarios
-- Fecha: 2024
-- =============================================

-- Eliminar y recrear spGestionSocios_ActualizarSocio
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
    @DireccionResidencia VARCHAR(200) = NULL,
    @DireccionTrabajo VARCHAR(200) = NULL,
    @NivelEstudio INT = NULL,
    @Profesion INT = NULL,
    @UsuarioModifica INT,
    @LugarTrabajo INT = NULL, -- Code de tbEmpresas
    @Ocupacion INT = NULL, -- Code de tbOcupaciones
    @PaisTrabajo NVARCHAR(3) = NULL, -- Code de tbPaises
    @ProvinciaTrabajo INT = NULL, -- Code de tbProvincias
    @DistritoTrabajo INT = NULL, -- Code de tbDistritos
    @CorregimientoTrabajo INT = NULL, -- Code de tbCorregimientos
    @PaisResidencia NVARCHAR(3) = NULL, -- Code de tbPaises
    @ProvinciaResidencia INT = NULL, -- Code de tbProvincias
    @DistritoResidencia INT = NULL, -- Code de tbDistritos
    @CorregimientoResidencia INT = NULL -- Code de tbCorregimientos
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
        DireccionResidencia = @DireccionResidencia,
        DireccionTrabajo = @DireccionTrabajo,
        NivelEstudio = @NivelEstudio,
        Profesion = @Profesion,
        FechaModificacion = GETDATE(),
        UsuarioModifica = @UsuarioModifica,
        LugarTrabajo = @LugarTrabajo,
        Ocupacion = @Ocupacion,
        PaisTrabajo = @PaisTrabajo,
        ProvinciaTrabajo = @ProvinciaTrabajo,
        DistritoTrabajo = @DistritoTrabajo,
        CorregimientoTrabajo = @CorregimientoTrabajo,
        PaisResidencia = @PaisResidencia,
        ProvinciaResidencia = @ProvinciaResidencia,
        DistritoResidencia = @DistritoResidencia,
        CorregimientoResidencia = @CorregimientoResidencia
    WHERE NumeroAsociado = @NumeroAsociado;
END
GO
PRINT '✅ spGestionSocios_ActualizarSocio recreado completamente'
GO

