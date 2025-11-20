-- =============================================
-- Tabla de Auditoría de Base de Datos
-- =============================================

USE [SegmaDB]
GO

-- Crear tabla de auditoría
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbLogsAuditoria]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[tbLogsAuditoria](
        [Id] [int] IDENTITY(1,1) NOT NULL,
        [TablaAfectada] [nvarchar](100) NOT NULL,
        [RegistroId] [nvarchar](50) NOT NULL,
        [Operacion] [char](1) NOT NULL, -- 'I'nsert, 'U'pdate, 'D'elete
        [UsuarioId] [int] NOT NULL,
        [FechaHora] [datetime2](7) NOT NULL,
        [JsonPrevio] [nvarchar](max) NULL, -- NULL para INSERT
        [JsonPosterior] [nvarchar](max) NOT NULL,
        [ServidorInfo] [nvarchar](max) NULL, -- Info del servidor SQL
        [Comentarios] [nvarchar](500) NULL, -- Comentarios adicionales
        CONSTRAINT [PK_tbLogsAuditoria] PRIMARY KEY CLUSTERED ([Id] ASC)
    ) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
    
    PRINT 'Tabla tbLogsAuditoria creada exitosamente'
END
ELSE
BEGIN
    PRINT 'La tabla tbLogsAuditoria ya existe'
END
GO

-- Crear índices para mejorar performance
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[tbLogsAuditoria]') AND name = N'IX_tbLogsAuditoria_TablaAfectada')
BEGIN
    CREATE NONCLUSTERED INDEX [IX_tbLogsAuditoria_TablaAfectada] 
    ON [dbo].[tbLogsAuditoria] ([TablaAfectada] ASC)
    PRINT 'Índice IX_tbLogsAuditoria_TablaAfectada creado'
END
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[tbLogsAuditoria]') AND name = N'IX_tbLogsAuditoria_FechaHora')
BEGIN
    CREATE NONCLUSTERED INDEX [IX_tbLogsAuditoria_FechaHora] 
    ON [dbo].[tbLogsAuditoria] ([FechaHora] DESC)
    PRINT 'Índice IX_tbLogsAuditoria_FechaHora creado'
END
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[tbLogsAuditoria]') AND name = N'IX_tbLogsAuditoria_UsuarioId')
BEGIN
    CREATE NONCLUSTERED INDEX [IX_tbLogsAuditoria_UsuarioId] 
    ON [dbo].[tbLogsAuditoria] ([UsuarioId] ASC)
    PRINT 'Índice IX_tbLogsAuditoria_UsuarioId creado'
END
GO

-- Crear función auxiliar para obtener información del servidor
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fnAuditoria_ObtenerInfoServidor]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
    DROP FUNCTION [dbo].[fnAuditoria_ObtenerInfoServidor]
GO

CREATE FUNCTION [dbo].[fnAuditoria_ObtenerInfoServidor]()
RETURNS NVARCHAR(MAX)
AS
BEGIN
    DECLARE @InfoServidor NVARCHAR(MAX)
    
    SET @InfoServidor = '{"ServerName":"' + @@SERVERNAME + 
                       '","DatabaseName":"' + DB_NAME() + 
                       '","LoginName":"' + ISNULL(SUSER_NAME(), 'NULL') + 
                       '","HostName":"' + HOST_NAME() + 
                       '","SessionId":' + CAST(@@SPID AS NVARCHAR(10)) + 
                       ',"Timestamp":"' + CONVERT(NVARCHAR(23), GETDATE(), 126) + '"}'
    
    RETURN @InfoServidor
END
GO

-- Crear función auxiliar para serializar filas a JSON
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fnAuditoria_SerializarFila]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
    DROP FUNCTION [dbo].[fnAuditoria_SerializarFila]
GO

CREATE FUNCTION [dbo].[fnAuditoria_SerializarFila](@Tabla NVARCHAR(100), @RegistroId NVARCHAR(50))
RETURNS NVARCHAR(MAX)
AS
BEGIN
    DECLARE @JsonResult NVARCHAR(MAX)
    DECLARE @Sql NVARCHAR(MAX)
    
    -- Construir query dinámico para obtener el registro
    SET @Sql = 'SELECT * FROM ' + QUOTENAME(@Tabla) + ' WHERE Id = @Id'
    
    -- Ejecutar query dinámico y serializar a JSON
    -- Nota: Esta función es un placeholder, la implementación real dependerá de cada tabla
    SET @JsonResult = '{"mensaje": "Función placeholder - implementar por tabla"}'
    
    RETURN @JsonResult
END
GO

-- Crear stored procedure para obtener logs de auditoría
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spLogs_ObtenerLogAuditoria]') AND type in (N'P', N'PC'))
    DROP PROCEDURE [dbo].[spLogs_ObtenerLogAuditoria]
GO

CREATE PROCEDURE [dbo].[spLogs_ObtenerLogAuditoria]
    @TablaAfectada NVARCHAR(100) = NULL,
    @UsuarioId INT = NULL,
    @FechaDesde DATE = NULL,
    @FechaHasta DATE = NULL,
    @Operacion CHAR(1) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        SELECT 
            la.Id,
            la.TablaAfectada,
            la.RegistroId,
            la.Operacion,
            CASE la.Operacion
                WHEN 'I' THEN 'Insertar'
                WHEN 'U' THEN 'Actualizar'
                WHEN 'D' THEN 'Eliminar'
                ELSE 'Desconocido'
            END AS OperacionDescripcion,
            la.UsuarioId,
            u.Usuario AS UsuarioNombre,
            la.FechaHora,
            la.JsonPrevio,
            la.JsonPosterior,
            la.ServidorInfo,
            la.Comentarios
        FROM tbLogsAuditoria la
        LEFT JOIN tbUsuarios u ON la.UsuarioId = u.Id
        WHERE 1=1
            AND (@TablaAfectada IS NULL OR la.TablaAfectada = @TablaAfectada)
            AND (@UsuarioId IS NULL OR la.UsuarioId = @UsuarioId)
            AND (@FechaDesde IS NULL OR CAST(la.FechaHora AS DATE) >= @FechaDesde)
            AND (@FechaHasta IS NULL OR CAST(la.FechaHora AS DATE) <= @FechaHasta)
            AND (@Operacion IS NULL OR la.Operacion = @Operacion)
        ORDER BY la.FechaHora DESC;
    END TRY
    BEGIN CATCH
        DECLARE @Mensaje NVARCHAR(2048);
        SET @Mensaje = ERROR_MESSAGE();
        THROW 50001, @Mensaje, 1;
    END CATCH
END
GO

PRINT 'Sistema de auditoría de base de datos configurado exitosamente'
PRINT 'Tabla: tbLogsAuditoria'
PRINT 'Índices: 3 índices creados'
PRINT 'Funciones: fnAuditoria_ObtenerInfoServidor, fnAuditoria_SerializarFila'
PRINT 'Stored Procedure: spLogs_ObtenerLogAuditoria'
GO
