USE [SegmaDB]
GO

/****** Object: StoredProcedure [dbo].[spAuxiliares_ModificarMontoPignorado] ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Sistema SemgaWapp
-- Create date: 2025-01-27
-- Description: Modifica el monto pignorado de un auxiliar específico
-- =============================================
CREATE PROCEDURE [dbo].[spAuxiliares_ModificarMontoPignorado]
    @AuxiliarID INT,
    @NumeroAsociado INT,
    @NuevoMonto DECIMAL(18,2),
    @UsuarioModifica NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        -- Verificar que el auxiliar existe y pertenece al asociado
        IF NOT EXISTS (
            SELECT 1 
            FROM tbAuxiliares 
            WHERE ID = @AuxiliarID 
            AND NumeroAsociado = @NumeroAsociado 
            AND snEliminado = 0
        )
        BEGIN
            RAISERROR('El auxiliar no existe o no pertenece al asociado especificado', 16, 1);
            RETURN;
        END
        
        -- Actualizar el monto pignorado
        UPDATE tbAuxiliares 
        SET 
            MontoPignorado = @NuevoMonto,
            FechaModificacion = GETDATE(),
            UsuarioModifica = @UsuarioModifica
        WHERE 
            ID = @AuxiliarID 
            AND NumeroAsociado = @NumeroAsociado 
            AND snEliminado = 0;
        
        -- Verificar que se actualizó correctamente
        IF @@ROWCOUNT = 0
        BEGIN
            RAISERROR('No se pudo actualizar el monto pignorado', 16, 1);
            RETURN;
        END
        
        -- Retornar éxito
        SELECT 'Monto pignorado actualizado correctamente' AS Mensaje;
        
    END TRY
    BEGIN CATCH
        DECLARE @Mensaje NVARCHAR(2048);
        SET @Mensaje = ERROR_MESSAGE();
        RAISERROR(@Mensaje, 16, 1);
    END CATCH
END
GO

