IF NOT EXISTS (SELECT 1 FROM dbo.tbMenuPrincipal WHERE IdMenu = 38)
BEGIN
    INSERT INTO [dbo].[tbMenuPrincipal] ([IdMenu], [IdParent], [TextoMenu], [Url], [snActivo], [Orden], [Icon])
    VALUES
        (39, 7, N'Saldos Contables', N'Forms/Mantenimientos/SaldosContables.aspx', 1, 6, N'fas fa-balance-scale');
END

