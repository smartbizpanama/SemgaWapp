USE [SegmaDB]
GO
/****** Object:  StoredProcedure [dbo].[spAuxiliares_ObtenerDatosComprobante]    Script Date: 24/01/2025 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER PROCEDURE [dbo].[spAuxiliares_ObtenerDatosComprobante]
    @AuxiliarID INT,
    @NumeroAsociado INT
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        right('000000000000' + cast(a.ID as varchar(12)),12) AS ID,
        a.NumeroAsociado,
        s.TipoIdentificacion,
        s.NumeroIdentificacion,
        s.CodTipoDoc,
        s.Nombre + ' ' + s.Apellido AS NombreAsociado,
        a.CodigoRubro,
        r.Descripcion AS DescripcionRubro,
        a.TipoAuxiliar,
        ta.Descripcion AS DescripcionTipoAuxiliar,
        right('000000000000' + cast(a.ID as varchar(12)),12) AS Cuenta,
        a.MontoOriginal,
        a.MontoOriginal AS MontoTotal,
        (a.MontoOriginal - ISNULL(a.MontoManejo, 0) - ISNULL(a.MontoCapitalizacion, 0)) AS MontoDesembolso,
        a.Cuota,
        a.TasaInteres,
        a.PagoMes,
        a.FechaOtorgado,
        a.FechaCreacion,
        u.Nombre AS UsuarioNombre,
        a.PorcManejo,
        a.PorcCapitalizacion,
        a.MontoManejo,
        a.MontoCapitalizacion
    FROM tbAuxiliares a
    INNER JOIN tbAsociados s ON a.NumeroAsociado = s.NumeroAsociado 
    LEFT JOIN tbRubros r ON a.CodigoRubro = r.CodigoRubro AND (r.snEliminado = 0 OR r.snEliminado IS NULL)
    LEFT JOIN tbTiposAuxiliares ta ON a.TipoAuxiliar = ta.ID 
        AND a.CodigoRubro = ta.CodigoRubro 
        AND (ta.snEliminado = 0 OR ta.snEliminado IS NULL)
    LEFT JOIN tbUsuarios u ON a.UsuarioCrea = u.Id AND (u.snEliminado = 0 OR u.snEliminado IS NULL)
    WHERE a.ID = @AuxiliarID
      AND a.NumeroAsociado = @NumeroAsociado
      AND a.snEliminado = 0
      AND s.snEliminado = 0;
END;
GO
