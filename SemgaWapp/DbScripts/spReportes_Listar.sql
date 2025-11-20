CREATE PROCEDURE [dbo].[spReportes_Listar]
    @IdUsuario INT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        SELECT 
            ID,
            Nombre,
            Tipo,
            Comando,
            Descripcion,
            SnActivo,
            SnEliminado
        FROM tbReportesComandos 
        WHERE SnEliminado = 0 
        AND SnActivo = 1
        ORDER BY Tipo, Nombre;
        
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();
        
        RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH
END
