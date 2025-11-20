-- =============================================
-- STORED PROCEDURES PARA GESTIÓN DE BENEFICIARIOS CON SESSION TRACKING
-- =============================================

-- Eliminar y recrear spBeneficiarios_CrearBeneficiario
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spBeneficiarios_CrearBeneficiario]') AND type in (N'P', N'PC'))
    DROP PROCEDURE [dbo].[spBeneficiarios_CrearBeneficiario]
GO

CREATE PROCEDURE [dbo].[spBeneficiarios_CrearBeneficiario]
    @NumeroAsociado INT,
    @Nombre NVARCHAR(100),
    @Apellido NVARCHAR(100),
    @TipoIdentificacion VARCHAR(10),
    @NumeroIdentificacion NVARCHAR(200),
    @IDParentezco INT,
    @Porcentaje NUMERIC(5,2),
    @Usuario NVARCHAR(50) = NULL,
    @IdSession NVARCHAR(50) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        -- Validar que el porcentaje no exceda el 100% total
        DECLARE @PorcentajeTotal NUMERIC(5,2);
        SELECT @PorcentajeTotal = ISNULL(SUM(Porcentaje), 0)
        FROM tbBeneficiarios
        WHERE NumeroAsociado = @NumeroAsociado 
          AND snEliminado = 0;
        
        IF (@PorcentajeTotal + @Porcentaje) > 100
        BEGIN
            SELECT 'ERROR' AS Resultado, 
                   'El porcentaje total no puede exceder el 100%. Porcentaje actual: ' + 
                   CAST(@PorcentajeTotal AS VARCHAR(10)) + '%' AS Mensaje;
            RETURN;
        END
        
        -- Insertar el beneficiario con campos de auditoría
        INSERT INTO tbBeneficiarios (
            NumeroAsociado,
            Nombre,
            Apellido,
            TipoIdentificacion,
            NumeroIdentificacion,
            IDParentezco,
            Porcentaje,
            UsuarioCrea,
            FechaHoraCrea,
            SysLastSessionID,
            snEliminado
        )
        VALUES (
            @NumeroAsociado,
            @Nombre,
            @Apellido,
            @TipoIdentificacion,
            @NumeroIdentificacion,
            @IDParentezco,
            @Porcentaje,
            CAST(@Usuario AS INT),
            GETDATE(),
            @IdSession,
            0
        );
        
        SELECT 'SUCCESS' AS Resultado, 'Beneficiario creado correctamente' AS Mensaje;
    END TRY
    BEGIN CATCH
        SELECT 'ERROR' AS Resultado, ERROR_MESSAGE() AS Mensaje;
    END CATCH
END
GO

-- Eliminar y recrear spBeneficiarios_ActualizarBeneficiario
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spBeneficiarios_ActualizarBeneficiario]') AND type in (N'P', N'PC'))
    DROP PROCEDURE [dbo].[spBeneficiarios_ActualizarBeneficiario]
GO

CREATE PROCEDURE [dbo].[spBeneficiarios_ActualizarBeneficiario]
    @IDBeneficiario INT,
    @Nombre NVARCHAR(100),
    @Apellido NVARCHAR(100),
    @TipoIdentificacion VARCHAR(10),
    @NumeroIdentificacion NVARCHAR(200),
    @IDParentezco INT,
    @Porcentaje NUMERIC(5,2),
    @Usuario NVARCHAR(50) = NULL,
    @IdSession NVARCHAR(50) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        -- Obtener el número de asociado del beneficiario
        DECLARE @NumeroAsociado INT;
        SELECT @NumeroAsociado = NumeroAsociado
        FROM tbBeneficiarios
        WHERE IDBeneficiario = @IDBeneficiario;
        
        -- Validar que el porcentaje no exceda el 100% total (excluyendo el beneficiario actual)
        DECLARE @PorcentajeTotal NUMERIC(5,2);
        SELECT @PorcentajeTotal = ISNULL(SUM(Porcentaje), 0)
        FROM tbBeneficiarios
        WHERE NumeroAsociado = @NumeroAsociado 
          AND snEliminado = 0
          AND IDBeneficiario != @IDBeneficiario;
        
        IF (@PorcentajeTotal + @Porcentaje) > 100
        BEGIN
            SELECT 'ERROR' AS Resultado, 
                   'El porcentaje total no puede exceder el 100%. Porcentaje actual: ' + 
                   CAST(@PorcentajeTotal AS VARCHAR(10)) + '%' AS Mensaje;
            RETURN;
        END
        
        -- Actualizar el beneficiario con campos de auditoría
        UPDATE tbBeneficiarios
        SET Nombre = @Nombre,
            Apellido = @Apellido,
            TipoIdentificacion = @TipoIdentificacion,
            NumeroIdentificacion = @NumeroIdentificacion,
            IDParentezco = @IDParentezco,
            Porcentaje = @Porcentaje,
            UsuarioModifica = CAST(@Usuario AS INT),
            FechaModifica = GETDATE(),
            SysLastSessionID = @IdSession
        WHERE IDBeneficiario = @IDBeneficiario;
        
        SELECT 'SUCCESS' AS Resultado, 'Beneficiario actualizado correctamente' AS Mensaje;
    END TRY
    BEGIN CATCH
        SELECT 'ERROR' AS Resultado, ERROR_MESSAGE() AS Mensaje;
    END CATCH
END
GO

-- Eliminar y recrear spBeneficiarios_EliminarBeneficiario
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spBeneficiarios_EliminarBeneficiario]') AND type in (N'P', N'PC'))
    DROP PROCEDURE [dbo].[spBeneficiarios_EliminarBeneficiario]
GO

CREATE PROCEDURE [dbo].[spBeneficiarios_EliminarBeneficiario]
    @IDBeneficiario INT,
    @Usuario NVARCHAR(50) = NULL,
    @IdSession NVARCHAR(50) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        -- Verificar que el beneficiario existe
        IF NOT EXISTS (SELECT 1 FROM tbBeneficiarios WHERE IDBeneficiario = @IDBeneficiario)
        BEGIN
            SELECT 'ERROR' AS Resultado, 'Beneficiario no encontrado' AS Mensaje;
            RETURN;
        END
        
        -- Eliminar lógicamente el beneficiario con campos de auditoría
        UPDATE tbBeneficiarios
        SET snEliminado = 1,
            UsuarioElimina = CAST(@Usuario AS INT),
            FechaElimina = GETDATE(),
            SysLastSessionID = @IdSession
        WHERE IDBeneficiario = @IDBeneficiario;
        
        SELECT 'SUCCESS' AS Resultado, 'Beneficiario eliminado correctamente' AS Mensaje;
    END TRY
    BEGIN CATCH
        SELECT 'ERROR' AS Resultado, ERROR_MESSAGE() AS Mensaje;
    END CATCH
END
GO

PRINT 'Stored Procedures de Beneficiarios actualizados con Session Tracking:'
PRINT '- spBeneficiarios_CrearBeneficiario: Agregado @Usuario, @IdSession y campos de auditoría'
PRINT '- spBeneficiarios_ActualizarBeneficiario: Agregado @Usuario, @IdSession y campos de auditoría'
PRINT '- spBeneficiarios_EliminarBeneficiario: Agregado @Usuario, @IdSession y campos de auditoría'
GO
