-- ============================================================
-- Saldos Contables - SemgaWapp (Cooperativa Coopsemga)
-- 1) Permiso de menú (mosaico en dashboardSistemas.aspx)
-- 2) Tabla de log de cambios de saldo
-- 3) SP spCuentas_CambiarSaldo (cambia el saldo y registra log)
-- ============================================================


-- ============================================================
-- 1) INSERT en tbMenuPrincipal
--    Mosaico bajo "Configuraciones del Sistema" (IdParent = 7)
--    URL: Forms/Mantenimientos/SaldosContables.aspx
-- ============================================================
IF NOT EXISTS (SELECT 1 FROM dbo.tbMenuPrincipal WHERE IdMenu = 38)
BEGIN
    INSERT INTO [dbo].[tbMenuPrincipal] ([IdMenu], [IdParent], [TextoMenu], [Url], [snActivo], [Orden], [Icon])
    VALUES
        (38, 7, N'Saldos Contables', N'Forms/Mantenimientos/SaldosContables.aspx', 1, 6, N'fas fa-balance-scale');
END
GO


-- ============================================================
-- 2) Tabla de log de cambios de saldo
-- ============================================================
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'tbLogCambiosSaldoCuenta')
BEGIN
    CREATE TABLE [dbo].[tbLogCambiosSaldoCuenta](
        [ID]            [int] IDENTITY(1,1) NOT NULL,
        [IDCuenta]      [int] NOT NULL,
        [Cuenta]        [nvarchar](50) NULL,
        [SaldoAnterior] [decimal](18, 2) NULL,
        [SaldoNuevo]    [decimal](18, 2) NULL,
        [UsuarioID]     [int] NULL,
        [IdSession]     [nvarchar](100) NULL,
        [Motivo]        [nvarchar](500) NULL,
        [FechaCambio]   [datetime] NOT NULL CONSTRAINT [DF_tbLogCambiosSaldoCuenta_FechaCambio] DEFAULT (GETDATE()),
        CONSTRAINT [PK_tbLogCambiosSaldoCuenta] PRIMARY KEY CLUSTERED ([ID] ASC)
    ) ON [PRIMARY];

    CREATE INDEX [IX_tbLogCambiosSaldoCuenta_IDCuenta]
        ON [dbo].[tbLogCambiosSaldoCuenta] ([IDCuenta]);
END
GO


-- ============================================================
-- 3) SP spCuentas_CambiarSaldo
--    Cambia el saldo de la cuenta y registra el cambio en log.
--    Devuelve columnas Resultado ('SUCCESS'/'ERROR') y Mensaje.
-- ============================================================
IF OBJECT_ID('dbo.spCuentas_CambiarSaldo', 'P') IS NOT NULL
    DROP PROCEDURE dbo.spCuentas_CambiarSaldo;
GO

CREATE PROCEDURE dbo.spCuentas_CambiarSaldo
    @ID         INT,
    @NuevoSaldo DECIMAL(18, 2),
    @UsuarioID  INT,
    @IdSession  NVARCHAR(100) = NULL,
    @Motivo     NVARCHAR(500) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- Validaciones
        IF @ID IS NULL OR @ID <= 0
        BEGIN
            SELECT 'ERROR' AS Resultado, 'La cuenta indicada no es válida.' AS Mensaje;
            RETURN;
        END

        DECLARE @SaldoAnterior DECIMAL(18, 2);
        DECLARE @Cuenta NVARCHAR(50);

        SELECT @SaldoAnterior = [Saldo], @Cuenta = [Cuenta]
        FROM dbo.tbCuentas
        WHERE [ID] = @ID;

        IF @@ROWCOUNT = 0
        BEGIN
            SELECT 'ERROR' AS Resultado, 'No se encontró la cuenta.' AS Mensaje;
            RETURN;
        END

        BEGIN TRANSACTION;

            -- Actualizar saldo
            UPDATE dbo.tbCuentas
            SET [Saldo] = @NuevoSaldo
            WHERE [ID] = @ID;

            -- Registrar log del cambio
            INSERT INTO dbo.tbLogCambiosSaldoCuenta
                ([IDCuenta], [Cuenta], [SaldoAnterior], [SaldoNuevo], [UsuarioID], [IdSession], [Motivo], [FechaCambio])
            VALUES
                (@ID, @Cuenta, @SaldoAnterior, @NuevoSaldo, @UsuarioID, @IdSession, @Motivo, GETDATE());

        COMMIT TRANSACTION;

        SELECT 'SUCCESS' AS Resultado, 'Saldo actualizado correctamente.' AS Mensaje;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        SELECT 'ERROR' AS Resultado, ERROR_MESSAGE() AS Mensaje;
    END CATCH
END
GO
