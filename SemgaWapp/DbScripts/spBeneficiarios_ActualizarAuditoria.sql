-- =============================================
-- Actualización de Stored Procedures de Beneficiarios
-- Agregar campos de auditoría a los SPs existentes
-- =============================================

-- =============================================
-- Actualizar SP de Crear Beneficiario
-- =============================================
ALTER PROCEDURE [dbo].[spBeneficiarios_CrearBeneficiario]
    @NumeroAsociado INT,
    @Nombre NVARCHAR(100),
    @Apellido NVARCHAR(100),
    @TipoIdentificacion VARCHAR(10),
    @NumeroIdentificacion NVARCHAR(200),
    @IDParentezco INT,
    @Porcentaje NUMERIC(5,2),
    @UsuarioCrea INT
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
            snEliminado,
            UsuarioCrea,
            FechaHoraCrea
        )
        VALUES (
            @NumeroAsociado,
            @Nombre,
            @Apellido,
            @TipoIdentificacion,
            @NumeroIdentificacion,
            @IDParentezco,
            @Porcentaje,
            0,
            @UsuarioCrea,
            GETDATE()
        );
        
        SELECT 'SUCCESS' AS Resultado, 'Beneficiario creado correctamente' AS Mensaje;
    END TRY
    BEGIN CATCH
        SELECT 'ERROR' AS Resultado, ERROR_MESSAGE() AS Mensaje;
    END CATCH
END
GO

-- =============================================
-- Actualizar SP de Actualizar Beneficiario
-- =============================================
ALTER PROCEDURE [dbo].[spBeneficiarios_ActualizarBeneficiario]
    @IDBeneficiario INT,
    @Nombre NVARCHAR(100),
    @Apellido NVARCHAR(100),
    @TipoIdentificacion VARCHAR(10),
    @NumeroIdentificacion NVARCHAR(200),
    @IDParentezco INT,
    @Porcentaje NUMERIC(5,2),
    @UsuarioModifica INT
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
            UsuarioModifica = @UsuarioModifica,
            FechaModifica = GETDATE()
        WHERE IDBeneficiario = @IDBeneficiario;
        
        SELECT 'SUCCESS' AS Resultado, 'Beneficiario actualizado correctamente' AS Mensaje;
    END TRY
    BEGIN CATCH
        SELECT 'ERROR' AS Resultado, ERROR_MESSAGE() AS Mensaje;
    END CATCH
END
GO

-- =============================================
-- Actualizar SP de Eliminar Beneficiario
-- =============================================
ALTER PROCEDURE [dbo].[spBeneficiarios_EliminarBeneficiario]
    @IDBeneficiario INT,
    @UsuarioElimina INT
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
            UsuarioElimina = @UsuarioElimina,
            FechaElimina = GETDATE()
        WHERE IDBeneficiario = @IDBeneficiario;
        
        SELECT 'SUCCESS' AS Resultado, 'Beneficiario eliminado correctamente' AS Mensaje;
    END TRY
    BEGIN CATCH
        SELECT 'ERROR' AS Resultado, ERROR_MESSAGE() AS Mensaje;
    END CATCH
END
GO

