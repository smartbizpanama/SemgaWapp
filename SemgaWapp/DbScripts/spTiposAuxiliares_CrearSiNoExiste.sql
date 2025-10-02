-- Script para crear el stored procedure spTiposAuxiliares_Listar si no existe

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spTiposAuxiliares_Listar]') AND type in (N'P', N'PC'))
BEGIN
    EXEC('
    CREATE PROCEDURE [dbo].[spTiposAuxiliares_Listar]
        @CodigoRubro VARCHAR(5) = NULL,
        @TipoAuxiliar INT = NULL,
        @Descripcion NVARCHAR(150) = NULL
    AS
    BEGIN
        SET NOCOUNT ON;
        
        SELECT 
            ta.ID,
            ta.CodigoRubro,
            r.Descripcion AS RubroDescripcion,
            ta.TipoAuxiliar,
            ta.Descripcion,
            ta.Tasa,
            ta.Plazo,
            ta.MontoMaximo,
            ta.MontoMinimo,
            ta.PorManejo,
            ta.PorCapitalizacion,
            ta.PorProteccion,
            ta.snEliminado
        FROM tbTiposAuxiliares ta
        INNER JOIN tbRubros r ON ta.CodigoRubro = r.CodigoRubro
        WHERE ta.snEliminado = 0
            AND (@CodigoRubro IS NULL OR ta.CodigoRubro = @CodigoRubro)
            AND (@TipoAuxiliar IS NULL OR ta.TipoAuxiliar = @TipoAuxiliar)
            AND (@Descripcion IS NULL OR ta.Descripcion LIKE ''%'' + @Descripcion + ''%'')
        ORDER BY ta.CodigoRubro, ta.TipoAuxiliar;
    END
    ')
    PRINT ''Stored procedure spTiposAuxiliares_Listar creado exitosamente''
END
ELSE
BEGIN
    PRINT ''Stored procedure spTiposAuxiliares_Listar ya existe''
END

