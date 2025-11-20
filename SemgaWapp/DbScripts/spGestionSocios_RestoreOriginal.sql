-- =============================================
-- Script: Restaurar spGestionSocios_ObtenerSocios con funcionalidad original + nuevos campos
-- Descripción: Mantener filtros originales y agregar campos de empresas y ocupaciones
-- Fecha: 2024
-- =============================================

-- Restaurar spGestionSocios_ObtenerSocios con funcionalidad original
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

PRINT '✅ spGestionSocios_ObtenerSocios restaurado con funcionalidad original + nuevos campos'
GO

-- Restaurar spGestionSocios_ObtenerSocioPorNumero con funcionalidad original
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
        WHERE a.NumeroAsociado = @NumeroAsociado AND a.snEliminado = 0;
        
    END TRY
    BEGIN CATCH
         DECLARE @Mensaje NVARCHAR(2048);
        SET @Mensaje = ERROR_MESSAGE();
        THROW 50001, @Mensaje, 1;
    END CATCH
END
GO

PRINT '✅ spGestionSocios_ObtenerSocioPorNumero restaurado con funcionalidad original + nuevos campos'
GO

-- Mantener spGestionSocios_CrearSocio y spGestionSocios_ActualizarSocio como están
-- (ya están correctos con los nuevos campos)

PRINT '🎉 Stored procedures restaurados con funcionalidad original + nuevos campos'
GO

