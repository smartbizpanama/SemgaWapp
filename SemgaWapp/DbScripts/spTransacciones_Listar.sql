CREATE OR ALTER PROCEDURE [dbo].[spTransacciones_Listar]
    @NumeroAsociado INT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        SELECT tr.[IDTransaccion]
              ,[FechaHora]
              ,usr.Usuario AS Cajero
              ,ISNULL(movs.CantTran, 0) AS CantTran
        FROM [tbTransacciones] tr
        INNER JOIN tbUsuarios usr ON tr.Usuario = usr.Id
        LEFT JOIN (
            SELECT IDTransaccion, COUNT(*) AS CantTran 
            FROM tbMovimientos 
            GROUP BY IDTransaccion
        ) AS movs ON movs.IDTransaccion = tr.IDTransaccion
        WHERE tr.NumeroAsociado = @NumeroAsociado
        ORDER BY tr.FechaHora DESC;
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();
        
        RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH
END
GO
