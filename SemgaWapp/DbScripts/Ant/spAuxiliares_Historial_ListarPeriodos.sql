-- Periodos disponibles en historial de auxiliares (año, mes, versión) para filtros del reporte.

CREATE OR ALTER PROCEDURE [dbo].[spAuxiliares_Historial_ListarPeriodos]
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        SELECT DISTINCT
            H.[YearCorte] AS [AnioHistorial],
            H.[MonthCorte] AS [MesHistorial],
            H.[Version] AS [VersionHistorial]
        FROM [dbo].[sys.HST.tbAuxiliares] H
        ORDER BY
            H.[YearCorte] DESC,
            H.[MonthCorte] DESC,
            H.[Version] DESC;
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();
        RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH
END
