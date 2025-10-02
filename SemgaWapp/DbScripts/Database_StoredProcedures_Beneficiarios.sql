-- =============================================
-- Stored Procedures para Gestión de Beneficiarios
-- =============================================

-- =============================================
-- Obtener todos los parentezcos
-- =============================================
CREATE PROCEDURE [dbo].[spBeneficiarios_ObtenerParentezcos]
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        SELECT 
            IDParentezco,
            Parentezco
        FROM tbParentezcos
        ORDER BY Parentezco;
        
        SELECT 'SUCCESS' AS Resultado, '' AS Mensaje;
    END TRY
    BEGIN CATCH
        SELECT 'ERROR' AS Resultado, ERROR_MESSAGE() AS Mensaje;
    END CATCH
END
GO

-- =============================================
-- Obtener beneficiarios de un socio
-- =============================================
CREATE PROCEDURE [dbo].[spBeneficiarios_ObtenerBeneficiarios]
    @NumeroAsociado INT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        SELECT 
            b.IDBeneficiario,
            b.NumeroAsociado,
            b.Nombre,
            b.Apellido,
            b.TipoIdentificacion,
            b.NumeroIdentificacion,
            b.IDParentezco,
            b.Porcentaje,
            p.Parentezco
        FROM tbBeneficiarios b
        LEFT JOIN tbParentezcos p ON b.IDParentezco = p.IDParentezco
        WHERE b.NumeroAsociado = @NumeroAsociado 
          AND b.snEliminado = 0
        ORDER BY b.Nombre, b.Apellido;
        
        SELECT 'SUCCESS' AS Resultado, '' AS Mensaje;
    END TRY
    BEGIN CATCH
        SELECT 'ERROR' AS Resultado, ERROR_MESSAGE() AS Mensaje;
    END CATCH
END
GO

-- =============================================
-- Crear nuevo beneficiario
-- =============================================
CREATE PROCEDURE [dbo].[spBeneficiarios_CrearBeneficiario]
    @NumeroAsociado INT,
    @Nombre NVARCHAR(100),
    @Apellido NVARCHAR(100),
    @TipoIdentificacion VARCHAR(10),
    @NumeroIdentificacion NVARCHAR(200),
    @IDParentezco INT,
    @Porcentaje NUMERIC(5,2)
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
        
        -- Insertar el beneficiario
        INSERT INTO tbBeneficiarios (
            NumeroAsociado,
            Nombre,
            Apellido,
            TipoIdentificacion,
            NumeroIdentificacion,
            IDParentezco,
            Porcentaje,
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
            0
        );
        
        SELECT 'SUCCESS' AS Resultado, 'Beneficiario creado correctamente' AS Mensaje;
    END TRY
    BEGIN CATCH
        SELECT 'ERROR' AS Resultado, ERROR_MESSAGE() AS Mensaje;
    END CATCH
END
GO

-- =============================================
-- Actualizar beneficiario
-- =============================================
CREATE PROCEDURE [dbo].[spBeneficiarios_ActualizarBeneficiario]
    @IDBeneficiario INT,
    @Nombre NVARCHAR(100),
    @Apellido NVARCHAR(100),
    @TipoIdentificacion VARCHAR(10),
    @NumeroIdentificacion NVARCHAR(200),
    @IDParentezco INT,
    @Porcentaje NUMERIC(5,2)
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
        
        -- Actualizar el beneficiario
        UPDATE tbBeneficiarios
        SET Nombre = @Nombre,
            Apellido = @Apellido,
            TipoIdentificacion = @TipoIdentificacion,
            NumeroIdentificacion = @NumeroIdentificacion,
            IDParentezco = @IDParentezco,
            Porcentaje = @Porcentaje
        WHERE IDBeneficiario = @IDBeneficiario;
        
        SELECT 'SUCCESS' AS Resultado, 'Beneficiario actualizado correctamente' AS Mensaje;
    END TRY
    BEGIN CATCH
        SELECT 'ERROR' AS Resultado, ERROR_MESSAGE() AS Mensaje;
    END CATCH
END
GO

-- =============================================
-- Eliminar beneficiario (soft delete)
-- =============================================
CREATE PROCEDURE [dbo].[spBeneficiarios_EliminarBeneficiario]
    @IDBeneficiario INT
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
        
        -- Eliminar lógicamente el beneficiario
        UPDATE tbBeneficiarios
        SET snEliminado = 1
        WHERE IDBeneficiario = @IDBeneficiario;
        
        SELECT 'SUCCESS' AS Resultado, 'Beneficiario eliminado correctamente' AS Mensaje;
    END TRY
    BEGIN CATCH
        SELECT 'ERROR' AS Resultado, ERROR_MESSAGE() AS Mensaje;
    END CATCH
END
GO

-- =============================================
-- Obtener porcentaje total asignado de un socio
-- =============================================
CREATE PROCEDURE [dbo].[spBeneficiarios_ObtenerPorcentajeTotal]
    @NumeroAsociado INT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        SELECT 
            ISNULL(SUM(Porcentaje), 0) AS PorcentajeTotal,
            (100 - ISNULL(SUM(Porcentaje), 0)) AS PorcentajeRestante
        FROM tbBeneficiarios
        WHERE NumeroAsociado = @NumeroAsociado 
          AND snEliminado = 0;
        
        SELECT 'SUCCESS' AS Resultado, '' AS Mensaje;
    END TRY
    BEGIN CATCH
        SELECT 'ERROR' AS Resultado, ERROR_MESSAGE() AS Mensaje;
    END CATCH
END
GO






