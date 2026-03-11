USE [SegmaDB]
GO

-- =============================================
-- Author:		Sistema SemgaWapp
-- Create date: 2025-01-24
-- Description:	Stored Procedures para el módulo de Auxiliares
-- =============================================

-- =============================================
-- Obtener todos los rubros
-- =============================================
CREATE OR ALTER PROCEDURE [dbo].[spAuxiliares_ObtenerRubros]
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT CodigoRubro, Descripcion 
    FROM tbRubros 
    WHERE snEliminado = 0 
    ORDER BY Descripcion
END
GO

-- =============================================
-- Obtener todos los tipos de auxiliares
-- =============================================
CREATE OR ALTER PROCEDURE [dbo].[spAuxiliares_ObtenerTiposAuxiliares]
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT DISTINCT TipoAuxiliar, Descripcion 
    FROM tbTiposAuxiliares 
    WHERE snEliminado = 0 
    ORDER BY Descripcion
END
GO

-- =============================================
-- Obtener tipos de auxiliares por rubro
-- =============================================
CREATE OR ALTER PROCEDURE [dbo].[spAuxiliares_ObtenerTiposAuxiliaresPorRubro]
    @CodigoRubro VARCHAR(5)
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT TipoAuxiliar, Descripcion 
    FROM tbTiposAuxiliares 
    WHERE CodigoRubro = @CodigoRubro 
    AND snEliminado = 0 
    ORDER BY Descripcion
END
GO

-- =============================================
-- Obtener todos los auxiliares con información completa
-- =============================================
CREATE OR ALTER PROCEDURE [dbo].[spAuxiliares_ObtenerAuxiliares]
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        a.ID,
        a.NumeroAsociado,
        CONCAT(s.Nombre, ' ', s.Apellido) AS NombreAsociado,
        s.CodTipoDoc,
        s.NumeroIdentificacion,
        r.Descripcion AS DescripcionRubro,
        ta.Descripcion AS DescripcionTipoAuxiliar,
        a.Cuota,
        a.Saldo,
        a.MontoOriginal,
        a.TasaInteres,
        a.PagoMes,
        a.FechaOtorgado,
        a.FechaUltimoPago,
        a.Cuenta,
        a.FechaCreacion,
        usrCrea.Nombre AS UsuarioCrea,
        usrMod.Nombre AS UsuarioModifica
    FROM tbAuxiliares a
    INNER JOIN tbAsociados s ON a.NumeroAsociado = s.NumeroAsociado
    LEFT JOIN tbRubros r ON a.CodigoRubro = r.CodigoRubro
    LEFT JOIN tbTiposAuxiliares ta ON a.TipoAuxiliar = ta.TipoAuxiliar AND a.CodigoRubro = ta.CodigoRubro
    LEFT JOIN tbUsuarios usrCrea ON a.UsuarioCrea = usrCrea.UsuarioId
    LEFT JOIN tbUsuarios usrMod ON a.UsuarioModifica = usrMod.UsuarioId
    WHERE a.snEliminado = 0 AND s.snEliminado = 0
    ORDER BY a.ID DESC
END
GO

-- =============================================
-- Filtrar auxiliares con parámetros
-- =============================================
CREATE OR ALTER PROCEDURE [dbo].[spAuxiliares_FiltrarAuxiliares]
    @Busqueda VARCHAR(255) = NULL,
    @TipoAuxiliar INT = NULL,
    @CodigoRubro VARCHAR(5) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        a.ID,
        a.NumeroAsociado,
        CONCAT(s.Nombre, ' ', s.Apellido) AS NombreAsociado,
        s.CodTipoDoc,
        s.NumeroIdentificacion,
        r.Descripcion AS DescripcionRubro,
        ta.Descripcion AS DescripcionTipoAuxiliar,
        a.Cuota,
        a.Saldo,
        a.MontoOriginal,
        a.TasaInteres,
        a.PagoMes,
        a.FechaOtorgado,
        a.FechaUltimoPago,
        a.Cuenta,
        a.FechaCreacion,
        usrCrea.Nombre AS UsuarioCrea,
        usrMod.Nombre AS UsuarioModifica
    FROM tbAuxiliares a
    INNER JOIN tbAsociados s ON a.NumeroAsociado = s.NumeroAsociado
    LEFT JOIN tbRubros r ON a.CodigoRubro = r.CodigoRubro
    LEFT JOIN tbTiposAuxiliares ta ON a.TipoAuxiliar = ta.TipoAuxiliar AND a.CodigoRubro = ta.CodigoRubro
    LEFT JOIN tbUsuarios usrCrea ON a.UsuarioCrea = usrCrea.UsuarioId
    LEFT JOIN tbUsuarios usrMod ON a.UsuarioModifica = usrMod.UsuarioId
    WHERE a.snEliminado = 0 AND s.snEliminado = 0
    AND (@Busqueda IS NULL OR 
         s.Nombre LIKE '%' + @Busqueda + '%' OR 
         s.Apellido LIKE '%' + @Busqueda + '%' OR 
         r.Descripcion LIKE '%' + @Busqueda + '%' OR 
         ta.Descripcion LIKE '%' + @Busqueda + '%')
    AND (@TipoAuxiliar IS NULL OR a.TipoAuxiliar = @TipoAuxiliar)
    AND (@CodigoRubro IS NULL OR a.CodigoRubro = @CodigoRubro)
    ORDER BY a.ID DESC
END
GO

-- =============================================
-- Buscar asociados para selección
-- =============================================
CREATE OR ALTER PROCEDURE [dbo].[spAuxiliares_BuscarAsociados]
    @Busqueda VARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT TOP 10
        s.NumeroAsociado,
        CONCAT(s.Nombre, ' ', s.Apellido) AS NombreCompleto,
        s.NumeroIdentificacion,
        ta.TipoAsociado,
        s.CodTipoDoc,
        (SELECT COUNT(*) 
         FROM tbAuxiliares a 
         WHERE a.NumeroAsociado = s.NumeroAsociado 
         AND a.snEliminado = 0) AS CantAuxiliares
    FROM tbAsociados s
    LEFT JOIN tbTipoAsociado ta ON s.IdTipoAsociado = ta.IdTipoAsociado
    WHERE s.snEliminado = 0 
    AND (
        s.Nombre LIKE '%' + @Busqueda + '%' 
        OR s.Apellido LIKE '%' + @Busqueda + '%' 
        OR s.NumeroIdentificacion LIKE '%' + @Busqueda + '%'
        OR CAST(s.NumeroAsociado AS VARCHAR) LIKE '%' + @Busqueda + '%'
    )
    ORDER BY s.Nombre, s.Apellido
END
GO

-- =============================================
-- Guardar auxiliar (crear o actualizar)
-- =============================================
CREATE OR ALTER PROCEDURE [dbo].[spAuxiliares_GuardarAuxiliar]
    @ID INT = 0,
    @NumeroAsociado INT,
    @CodigoRubro VARCHAR(5),
    @TipoAuxiliar INT,
    @Cuota NUMERIC(18,2) = 0,
    @Saldo NUMERIC(18,2) = 0,
    @MontoOriginal NUMERIC(18,2) = 0,
    @FechaOtorgado DATETIME = NULL,
    @TasaInteres NUMERIC(18,2) = 0,
    @PagoMes NUMERIC(18,2) = 0,
    @UsuarioID INT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION;
        
        -- Validaciones
        IF @NumeroAsociado IS NULL OR @NumeroAsociado = 0
        BEGIN
            SELECT 'ERROR' AS Resultado, 'El número de asociado es requerido' AS Mensaje;
            ROLLBACK TRANSACTION;
            RETURN;
        END
        
        IF @CodigoRubro IS NULL OR @CodigoRubro = ''
        BEGIN
            SELECT 'ERROR' AS Resultado, 'El código de rubro es requerido' AS Mensaje;
            ROLLBACK TRANSACTION;
            RETURN;
        END
        
        IF @TipoAuxiliar IS NULL OR @TipoAuxiliar = 0
        BEGIN
            SELECT 'ERROR' AS Resultado, 'El tipo de auxiliar es requerido' AS Mensaje;
            ROLLBACK TRANSACTION;
            RETURN;
        END
        
        -- Verificar que el asociado existe
        IF NOT EXISTS (SELECT 1 FROM tbAsociados WHERE NumeroAsociado = @NumeroAsociado AND snEliminado = 0)
        BEGIN
            SELECT 'ERROR' AS Resultado, 'El asociado no existe o está eliminado' AS Mensaje;
            ROLLBACK TRANSACTION;
            RETURN;
        END
        
        -- Verificar que el rubro existe
        IF NOT EXISTS (SELECT 1 FROM tbRubros WHERE CodigoRubro = @CodigoRubro AND snEliminado = 0)
        BEGIN
            SELECT 'ERROR' AS Resultado, 'El rubro no existe o está eliminado' AS Mensaje;
            ROLLBACK TRANSACTION;
            RETURN;
        END
        
        -- Verificar que el tipo de auxiliar existe para el rubro
        IF NOT EXISTS (SELECT 1 FROM tbTiposAuxiliares WHERE CodigoRubro = @CodigoRubro AND TipoAuxiliar = @TipoAuxiliar AND snEliminado = 0)
        BEGIN
            SELECT 'ERROR' AS Resultado, 'El tipo de auxiliar no existe para el rubro seleccionado' AS Mensaje;
            ROLLBACK TRANSACTION;
            RETURN;
        END
        
        -- Si es nuevo (ID = 0)
        IF @ID = 0
        BEGIN
            -- Generar nuevo ID
            DECLARE @NuevoID INT;
            SELECT @NuevoID = ISNULL(MAX(ID), 0) + 1 FROM tbAuxiliares WHERE NumeroAsociado = @NumeroAsociado;
            
            -- Insertar nuevo auxiliar
            INSERT INTO tbAuxiliares (
                ID,
                NumeroAsociado,
                CodigoRubro,
                TipoAuxiliar,
                Cuota,
                Saldo,
                MontoOriginal,
                FechaOtorgado,
                TasaInteres,
                PagoMes,
                FechaCreacion,
                UsuarioCrea,
                snEliminado
            ) VALUES (
                @NuevoID,
                @NumeroAsociado,
                @CodigoRubro,
                @TipoAuxiliar,
                @Cuota,
                @Saldo,
                @MontoOriginal,
                @FechaOtorgado,
                @TasaInteres,
                @PagoMes,
                GETDATE(),
                @UsuarioID,
                0
            );
            
            SELECT 'SUCCESS' AS Resultado, 'Auxiliar creado exitosamente' AS Mensaje, @NuevoID AS ID, @NumeroAsociado AS NumeroAsociado;
        END
        ELSE
        BEGIN
            -- Actualizar auxiliar existente
            UPDATE tbAuxiliares SET
                CodigoRubro = @CodigoRubro,
                TipoAuxiliar = @TipoAuxiliar,
                Cuota = @Cuota,
                Saldo = @Saldo,
                MontoOriginal = @MontoOriginal,
                FechaOtorgado = @FechaOtorgado,
                TasaInteres = @TasaInteres,
                PagoMes = @PagoMes,
                FechaModificacion = GETDATE(),
                UsuarioModifica = @UsuarioID
            WHERE ID = @ID AND NumeroAsociado = @NumeroAsociado AND snEliminado = 0;
            
            IF @@ROWCOUNT = 0
            BEGIN
                SELECT 'ERROR' AS Resultado, 'No se encontró el auxiliar a actualizar' AS Mensaje;
                ROLLBACK TRANSACTION;
                RETURN;
            END
            
            SELECT 'SUCCESS' AS Resultado, 'Auxiliar actualizado exitosamente' AS Mensaje, @ID AS ID, @NumeroAsociado AS NumeroAsociado;
        END
        
        COMMIT TRANSACTION;
        
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        
        SELECT 'ERROR' AS Resultado, 
               'Error al guardar auxiliar: ' + ERROR_MESSAGE() AS Mensaje;
    END CATCH
END
GO

-- =============================================
-- Eliminar auxiliar (eliminación lógica)
-- =============================================
CREATE OR ALTER PROCEDURE [dbo].[spAuxiliares_EliminarAuxiliar]
    @ID INT,
    @NumeroAsociado INT,
    @UsuarioID INT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION;
        
        -- Validaciones
        IF @ID IS NULL OR @ID = 0
        BEGIN
            SELECT 'ERROR' AS Resultado, 'El ID del auxiliar es requerido' AS Mensaje;
            ROLLBACK TRANSACTION;
            RETURN;
        END
        
        IF @NumeroAsociado IS NULL OR @NumeroAsociado = 0
        BEGIN
            SELECT 'ERROR' AS Resultado, 'El número de asociado es requerido' AS Mensaje;
            ROLLBACK TRANSACTION;
            RETURN;
        END
        
        -- Verificar que el auxiliar existe
        IF NOT EXISTS (SELECT 1 FROM tbAuxiliares WHERE ID = @ID AND NumeroAsociado = @NumeroAsociado AND snEliminado = 0)
        BEGIN
            SELECT 'ERROR' AS Resultado, 'El auxiliar no existe o ya está eliminado' AS Mensaje;
            ROLLBACK TRANSACTION;
            RETURN;
        END
        
        -- Marcar como eliminado
        UPDATE tbAuxiliares SET
            snEliminado = 1,
            FechaModificacion = GETDATE(),
            UsuarioModifica = @UsuarioID
        WHERE ID = @ID AND NumeroAsociado = @NumeroAsociado;
        
        SELECT 'SUCCESS' AS Resultado, 'Auxiliar eliminado exitosamente' AS Mensaje;
        
        COMMIT TRANSACTION;
        
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        
        SELECT 'ERROR' AS Resultado, 
               'Error al eliminar auxiliar: ' + ERROR_MESSAGE() AS Mensaje;
    END CATCH
END
GO

-- =============================================
-- Obtener un auxiliar específico
-- =============================================
CREATE OR ALTER PROCEDURE [dbo].[spAuxiliares_ObtenerAuxiliar]
    @ID INT,
    @NumeroAsociado INT
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        a.ID,
        a.NumeroAsociado,
        CONCAT(s.Nombre, ' ', s.Apellido) AS NombreAsociado,
        s.NumeroIdentificacion,
        a.CodigoRubro,
        r.Descripcion AS DescripcionRubro,
        a.TipoAuxiliar,
        ta.Descripcion AS DescripcionTipoAuxiliar,
        a.Cuota,
        a.Saldo,
        a.MontoOriginal,
        a.TasaInteres,
        a.PagoMes,
        a.FechaOtorgado,
        a.FechaUltimoPago,
        a.FechaUltimoRetiro,
        a.InteresCalculado,
        a.InteresPagado
    FROM tbAuxiliares a
    INNER JOIN tbAsociados s ON a.NumeroAsociado = s.NumeroAsociado
    LEFT JOIN tbRubros r ON a.CodigoRubro = r.CodigoRubro
    LEFT JOIN tbTiposAuxiliares ta ON a.TipoAuxiliar = ta.TipoAuxiliar AND a.CodigoRubro = ta.CodigoRubro
    WHERE a.ID = @ID 
    AND a.NumeroAsociado = @NumeroAsociado 
    AND a.snEliminado = 0 
    AND s.snEliminado = 0;
END
GO

-- =============================================
-- Autor: Sistema
-- Fecha de creación: 24/01/2025
-- Descripción: Buscar asociado por ID específico
-- =============================================
ALTER PROCEDURE [dbo].[spAuxiliares_BuscarAsociadoPorID]
    @NumeroAsociado INT
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT TOP 10
        s.NumeroAsociado,
        CONCAT(s.Nombre, ' ', s.Apellido) AS NombreCompleto,
        s.NumeroIdentificacion,
        ta.TipoAsociado,
        s.CodTipoDoc,
        (SELECT COUNT(*) 
         FROM tbAuxiliares a 
         WHERE a.NumeroAsociado = s.NumeroAsociado 
         AND a.snEliminado = 0) AS CantAuxiliares
    FROM tbAsociados s
    LEFT JOIN tbTipoAsociado ta ON s.IdTipoAsociado = ta.IdTipoAsociado
    WHERE s.snEliminado = 0 
    AND s.NumeroAsociado = @NumeroAsociado
    ORDER BY s.Nombre, s.Apellido
END
GO