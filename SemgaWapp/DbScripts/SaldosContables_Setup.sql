-- ============================================================
-- Saldos Contables - SemgaWapp (Cooperativa Coopsemga)
-- Permiso de menú (mosaico en dashboardSistemas.aspx).
--
-- Objetos relacionados (ejecutar en este orden):
--   1) tbCuentas_LogSaldos.sql   (tabla de log)
--   2) spCuentas_CambiarSaldo.sql (stored procedure)
--   3) Este script               (permiso de menú)
-- ============================================================


-- ============================================================
-- INSERT en tbMenuPrincipal
--    Mosaico bajo "Configuraciones del Sistema" (IdParent = 7)
--    URL: Forms/Mantenimientos/SaldosContables.aspx
-- ============================================================
IF NOT EXISTS (SELECT 1 FROM dbo.tbMenuPrincipal WHERE IdMenu = 39)
BEGIN
    INSERT INTO [dbo].[tbMenuPrincipal] ([IdMenu], [IdParent], [TextoMenu], [Url], [snActivo], [Orden], [Icon])
    VALUES
        (39, 7, N'Saldos Contables', N'Forms/Mantenimientos/SaldosContables.aspx', 1, 6, N'fas fa-balance-scale');
END
GO
