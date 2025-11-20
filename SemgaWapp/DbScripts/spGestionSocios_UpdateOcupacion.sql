-- =============================================
-- Script: Actualizar stored procedures para manejar Ocupacion como Code
-- Descripción: Modificar SPs para trabajar con tbOcupaciones en lugar de texto libre
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
        a.ID,
        a.NumeroAsociado,
        a.Nombre,
        a.SegundoNombre,
        a.Apellido,
        a.SegundoApellido,
        a.FechaNacimiento,
        a.Sexo,
        a.EstadoCivil,
        a.TipoDocumento,
        a.NumeroDocumento,
        a.Telefono,
        a.Email,
        a.Direccion,
        a.FechaRegistro,
        a.Estado,
        a.TipoAsociado,
        a.LugarTrabajo,
        e.Descripcion as LugarTrabajoDescripcion,
        a.Ocupacion,
        o.Descripcion as OcupacionDescripcion,
        a.NivelEstudio,
        a.Profesion,
        a.ProvinciaTrabajo,
        a.DistritoTrabajo,
        a.CorregimientoTrabajo,
        a.DireccionTrabajo,
        a.ProvinciaResidencia,
        a.DistritoResidencia,
        a.CorregimientoResidencia,
        a.DireccionResidencia
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
        a.ID,
        a.NumeroAsociado,
        a.Nombre,
        a.SegundoNombre,
        a.Apellido,
        a.SegundoApellido,
        a.FechaNacimiento,
        a.Sexo,
        a.EstadoCivil,
        a.TipoDocumento,
        a.NumeroDocumento,
        a.Telefono,
        a.Email,
        a.Direccion,
        a.FechaRegistro,
        a.Estado,
        a.TipoAsociado,
        a.LugarTrabajo,
        e.Descripcion as LugarTrabajoDescripcion,
        a.Ocupacion,
        o.Descripcion as OcupacionDescripcion,
        a.NivelEstudio,
        a.Profesion,
        a.ProvinciaTrabajo,
        a.DistritoTrabajo,
        a.CorregimientoTrabajo,
        a.DireccionTrabajo,
        a.ProvinciaResidencia,
        a.DistritoResidencia,
        a.CorregimientoResidencia,
        a.DireccionResidencia
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
    @Nombre NVARCHAR(50),
    @SegundoNombre NVARCHAR(50) = NULL,
    @Apellido NVARCHAR(50),
    @SegundoApellido NVARCHAR(50) = NULL,
    @FechaNacimiento DATE,
    @Sexo CHAR(1),
    @EstadoCivil NVARCHAR(20),
    @TipoDocumento INT,
    @NumeroDocumento NVARCHAR(20),
    @Telefono NVARCHAR(20) = NULL,
    @Email NVARCHAR(100) = NULL,
    @Direccion NVARCHAR(200) = NULL,
    @TipoAsociado INT,
    @LugarTrabajo INT,
    @Ocupacion INT,
    @NivelEstudio NVARCHAR(50) = NULL,
    @Profesion NVARCHAR(50) = NULL,
    @ProvinciaTrabajo NVARCHAR(50) = NULL,
    @DistritoTrabajo NVARCHAR(50) = NULL,
    @CorregimientoTrabajo NVARCHAR(50) = NULL,
    @DireccionTrabajo NVARCHAR(200) = NULL,
    @ProvinciaResidencia NVARCHAR(50) = NULL,
    @DistritoResidencia NVARCHAR(50) = NULL,
    @CorregimientoResidencia NVARCHAR(50) = NULL,
    @DireccionResidencia NVARCHAR(200) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    INSERT INTO tbAsociados (
        NumeroAsociado, Nombre, SegundoNombre, Apellido, SegundoApellido,
        FechaNacimiento, Sexo, EstadoCivil, TipoDocumento, NumeroDocumento,
        Telefono, Email, Direccion, FechaRegistro, Estado, TipoAsociado,
        LugarTrabajo, Ocupacion, NivelEstudio, Profesion,
        ProvinciaTrabajo, DistritoTrabajo, CorregimientoTrabajo, DireccionTrabajo,
        ProvinciaResidencia, DistritoResidencia, CorregimientoResidencia, DireccionResidencia
    )
    VALUES (
        @NumeroAsociado, @Nombre, @SegundoNombre, @Apellido, @SegundoApellido,
        @FechaNacimiento, @Sexo, @EstadoCivil, @TipoDocumento, @NumeroDocumento,
        @Telefono, @Email, @Direccion, GETDATE(), 'Activo', @TipoAsociado,
        @LugarTrabajo, @Ocupacion, @NivelEstudio, @Profesion,
        @ProvinciaTrabajo, @DistritoTrabajo, @CorregimientoTrabajo, @DireccionTrabajo,
        @ProvinciaResidencia, @DistritoResidencia, @CorregimientoResidencia, @DireccionResidencia
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
    @ID INT,
    @NumeroAsociado INT,
    @Nombre NVARCHAR(50),
    @SegundoNombre NVARCHAR(50) = NULL,
    @Apellido NVARCHAR(50),
    @SegundoApellido NVARCHAR(50) = NULL,
    @FechaNacimiento DATE,
    @Sexo CHAR(1),
    @EstadoCivil NVARCHAR(20),
    @TipoDocumento INT,
    @NumeroDocumento NVARCHAR(20),
    @Telefono NVARCHAR(20) = NULL,
    @Email NVARCHAR(100) = NULL,
    @Direccion NVARCHAR(200) = NULL,
    @TipoAsociado INT,
    @LugarTrabajo INT,
    @Ocupacion INT,
    @NivelEstudio NVARCHAR(50) = NULL,
    @Profesion NVARCHAR(50) = NULL,
    @ProvinciaTrabajo NVARCHAR(50) = NULL,
    @DistritoTrabajo NVARCHAR(50) = NULL,
    @CorregimientoTrabajo NVARCHAR(50) = NULL,
    @DireccionTrabajo NVARCHAR(200) = NULL,
    @ProvinciaResidencia NVARCHAR(50) = NULL,
    @DistritoResidencia NVARCHAR(50) = NULL,
    @CorregimientoResidencia NVARCHAR(50) = NULL,
    @DireccionResidencia NVARCHAR(200) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    UPDATE tbAsociados SET
        NumeroAsociado = @NumeroAsociado,
        Nombre = @Nombre,
        SegundoNombre = @SegundoNombre,
        Apellido = @Apellido,
        SegundoApellido = @SegundoApellido,
        FechaNacimiento = @FechaNacimiento,
        Sexo = @Sexo,
        EstadoCivil = @EstadoCivil,
        TipoDocumento = @TipoDocumento,
        NumeroDocumento = @NumeroDocumento,
        Telefono = @Telefono,
        Email = @Email,
        Direccion = @Direccion,
        TipoAsociado = @TipoAsociado,
        LugarTrabajo = @LugarTrabajo,
        Ocupacion = @Ocupacion,
        NivelEstudio = @NivelEstudio,
        Profesion = @Profesion,
        ProvinciaTrabajo = @ProvinciaTrabajo,
        DistritoTrabajo = @DistritoTrabajo,
        CorregimientoTrabajo = @CorregimientoTrabajo,
        DireccionTrabajo = @DireccionTrabajo,
        ProvinciaResidencia = @ProvinciaResidencia,
        DistritoResidencia = @DistritoResidencia,
        CorregimientoResidencia = @CorregimientoResidencia,
        DireccionResidencia = @DireccionResidencia
    WHERE ID = @ID;
END
GO

PRINT '✅ spGestionSocios_ActualizarSocio actualizado'
GO

PRINT '🎉 Todos los stored procedures actualizados exitosamente'
GO

