-- =============================================
-- Script: Actualizar stored procedures para manejar PaisTrabajo
-- Descripción: Modificar SPs para trabajar con tbPaises usando Code en las relaciones
-- Fecha: 2024
-- =============================================

-- Modificar spGestionSocios_ObtenerSocios
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spGestionSocios_ObtenerSocios]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[spGestionSocios_ObtenerSocios];
GO

CREATE PROCEDURE [dbo].[spGestionSocios_ObtenerSocios]
    @FiltroNombre NVARCHAR(100) = NULL,
    @FiltroTipo INT = NULL,
    @FiltroEstatus CHAR(1) = NULL,
    @FiltroTipoDocumento VARCHAR(10) = NULL,
    @FiltroIdentificacion NVARCHAR(50) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        SELECT 
            a.NumeroAsociado,
            a.IdTipoAsociado,
            ta.TipoAsociado,
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
            a.LugarTrabajo,
            e.Descripcion as LugarTrabajoDescripcion,
            a.Ocupacion,
            o.Descripcion as OcupacionDescripcion,
            a.NivelEstudio,
            a.Profesion,
            a.PaisTrabajo,
            p.Descripcion as PaisTrabajoDescripcion,
            a.FechaCreacion,
            Usr.Usuario UsuarioCrea,
            a.FechaModificacion,
            UsrM.Usuario UsuarioModifica,
            a.snEliminado,
            IsNull((Select count(aux.ID) from tbAuxiliares aux Where aux.NumeroAsociado=a.NumeroAsociado and aux.snEliminado=0),0) as CantAuxiliares
        FROM tbAsociados a
        LEFT JOIN tbTipoAsociado ta ON a.IdTipoAsociado = ta.IdTipoAsociado
        LEFT JOIN tbUsuarios Usr on Usr.Id = a.UsuarioCrea
        LEFT JOIN tbUsuarios UsrM on UsrM.Id = a.UsuarioModifica
        LEFT JOIN tbEmpresas e ON a.LugarTrabajo = e.Code AND e.snEliminado = 0
        LEFT JOIN tbOcupaciones o ON a.Ocupacion = o.Code AND o.snEliminado = 0
        LEFT JOIN tbPaises p ON a.PaisTrabajo = p.Code AND p.snEliminado = 0
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
         DECLARE @Mensaje NVARCHAR(2048);
        SET @Mensaje = ERROR_MESSAGE();
        THROW 50001, @Mensaje, 1;
    END CATCH
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
    
    BEGIN TRY
        SELECT 
            a.NumeroAsociado,
            a.IdTipoAsociado,
            ta.TipoAsociado,
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
            a.LugarTrabajo,
            e.Descripcion as LugarTrabajoDescripcion,
            a.Ocupacion,
            o.Descripcion as OcupacionDescripcion,
            a.NivelEstudio,
            a.Profesion,
            a.PaisTrabajo,
            p.Descripcion as PaisTrabajoDescripcion,
            a.FechaCreacion,
            Usr.Usuario UsuarioCrea,
            a.FechaModificacion,
            UsrM.Usuario UsuarioModifica,
            a.snEliminado,
            IsNull((Select count(aux.ID) from tbAuxiliares aux Where aux.NumeroAsociado=a.NumeroAsociado and aux.snEliminado=0),0) as CantAuxiliares
        FROM tbAsociados a
        LEFT JOIN tbTipoAsociado ta ON a.IdTipoAsociado = ta.IdTipoAsociado
        LEFT JOIN tbUsuarios Usr on Usr.Id = a.UsuarioCrea
        LEFT JOIN tbUsuarios UsrM on UsrM.Id = a.UsuarioModifica
        LEFT JOIN tbEmpresas e ON a.LugarTrabajo = e.Code AND e.snEliminado = 0
        LEFT JOIN tbOcupaciones o ON a.Ocupacion = o.Code AND o.snEliminado = 0
        LEFT JOIN tbPaises p ON a.PaisTrabajo = p.Code AND p.snEliminado = 0
        WHERE a.NumeroAsociado = @NumeroAsociado AND a.snEliminado = 0;
        
    END TRY
    BEGIN CATCH
         DECLARE @Mensaje NVARCHAR(2048);
        SET @Mensaje = ERROR_MESSAGE();
        THROW 50001, @Mensaje, 1;
    END CATCH
END
GO
PRINT '✅ spGestionSocios_ObtenerSocioPorNumero actualizado'
GO

-- Modificar spGestionSocios_CrearSocio
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
    @ProvinciaTrabajo VARCHAR(50) = NULL,
    @DistritoTrabajo VARCHAR(50) = NULL,
    @CorregimientoTrabajo VARCHAR(50) = NULL,
    @DireccionTrabajo VARCHAR(200) = NULL,
    @NivelEstudio INT = NULL,
    @Profesion INT = NULL,
    @UsuarioCrea INT,
    @LugarTrabajo INT = NULL, -- Code de tbEmpresas
    @Ocupacion INT = NULL, -- Code de tbOcupaciones
    @PaisTrabajo NVARCHAR(3) = NULL -- Code de tbPaises
AS
BEGIN
    SET NOCOUNT ON;
    
    INSERT INTO tbAsociados (
        IdTipoAsociado, Nombre, SegundoNombre, Apellido, SegundoApellido, Estatus,
        TipoIdentificacion, NumeroIdentificacion, TelefonoResidencia, TelefonoCelular,
        TelefonoFamiliar, CorreoElectronico, Sexo, FechaNacimiento, ProvinciaResidencia,
        DistritoResidencia, CorregimientoResidencia, DireccionResidencia, ProvinciaTrabajo,
        DistritoTrabajo, CorregimientoTrabajo, DireccionTrabajo, NivelEstudio, Profesion,
        FechaCreacion, UsuarioCrea, snEliminado, LugarTrabajo, Ocupacion, PaisTrabajo
    ) VALUES (
        @IdTipoAsociado, @Nombre, @SegundoNombre, @Apellido, @SegundoApellido, @Estatus,
        @TipoIdentificacion, @NumeroIdentificacion, @TelefonoResidencia, @TelefonoCelular,
        @TelefonoFamiliar, @CorreoElectronico, @Sexo, @FechaNacimiento, @ProvinciaResidencia,
        @DistritoResidencia, @CorregimientoResidencia, @DireccionResidencia, @ProvinciaTrabajo,
        @DistritoTrabajo, @CorregimientoTrabajo, @DireccionTrabajo, @NivelEstudio, @Profesion,
        GETDATE(), @UsuarioCrea, 0, @LugarTrabajo, @Ocupacion, @PaisTrabajo
    );
    
    SELECT SCOPE_IDENTITY() AS NumeroAsociado;
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
    @ProvinciaTrabajo VARCHAR(50) = NULL,
    @DistritoTrabajo VARCHAR(50) = NULL,
    @CorregimientoTrabajo VARCHAR(50) = NULL,
    @DireccionTrabajo VARCHAR(200) = NULL,
    @NivelEstudio INT = NULL,
    @Profesion INT = NULL,
    @UsuarioModifica INT,
    @LugarTrabajo INT = NULL, -- Code de tbEmpresas
    @Ocupacion INT = NULL, -- Code de tbOcupaciones
    @PaisTrabajo NVARCHAR(3) = NULL -- Code de tbPaises
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
        ProvinciaTrabajo = @ProvinciaTrabajo,
        DistritoTrabajo = @DistritoTrabajo,
        CorregimientoTrabajo = @CorregimientoTrabajo,
        DireccionTrabajo = @DireccionTrabajo,
        NivelEstudio = @NivelEstudio,
        Profesion = @Profesion,
        FechaModificacion = GETDATE(),
        UsuarioModifica = @UsuarioModifica,
        LugarTrabajo = @LugarTrabajo,
        Ocupacion = @Ocupacion,
        PaisTrabajo = @PaisTrabajo
    WHERE NumeroAsociado = @NumeroAsociado;
END
GO
PRINT '✅ spGestionSocios_ActualizarSocio actualizado'
GO

PRINT '✅ Todos los stored procedures actualizados para manejar PaisTrabajo'
GO

