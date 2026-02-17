-------------------------------------------------------------
-- 1. Crear tabla nueva SIN IDENTITY
-------------------------------------------------------------
CREATE TABLE dbo.tbAuxiliares_New (
    ID INT NOT NULL,
    NumeroAsociado INT NOT NULL,
    CodigoRubro VARCHAR(5) NULL,
    TipoAuxiliar INT NULL,
    Cuota NUMERIC(18,2) NULL,
    Saldo NUMERIC(18,2) NULL,
    FechaCreacion DATETIME NULL,
    FechaModificacion DATETIME NULL,
    UsuarioCrea INT NULL,
    UsuarioModifica INT NULL,
    MontoOriginal NUMERIC(18,2) NULL,
    FechaOtorgado DATETIME NULL,
    TasaInteres NUMERIC(18,2) NULL,
    PagoMes NUMERIC(18,2) NULL,
    InteresCalculado NUMERIC(18,2) NULL,
    InteresPagado NUMERIC(18,2) NULL,
    FechaUltimoPago DATETIME NULL,
    FechaUltimoRetiro DATETIME NULL,
    snEliminado BIT NULL,
    MontoPignorado NUMERIC(18,2) NULL,
    UsuarioElimina NVARCHAR(50) NULL,
    FechaElimina DATETIME NULL,
    SysLastSessionID VARCHAR(50) NULL,
    FechaUltPagoInteres DATETIME NULL,
    FechaUltCalculoInteres DATE NULL,
    snActivo BIT NULL,
    PorcManejo NUMERIC(19,6) NULL,
    MontoManejo NUMERIC(19,6) NULL,
    PorcCapitalizacion NUMERIC(19,6) NULL,
    MontoCapitalizacion NUMERIC(19,6) NULL
);
GO

-------------------------------------------------------------
-- 2. Copiar datos desde la tabla original
-------------------------------------------------------------
INSERT INTO dbo.tbAuxiliares_New
SELECT *
FROM dbo.tbAuxiliares;
GO

-------------------------------------------------------------
-- 3. Eliminar la PK de la tabla original
-------------------------------------------------------------
ALTER TABLE dbo.tbAuxiliares
DROP CONSTRAINT PK_tbAuxiliaresKey;
GO

-------------------------------------------------------------
-- 4. Renombrar tablas
-------------------------------------------------------------
EXEC sp_rename 'dbo.tbAuxiliares', 'tbAuxiliares_Old';
EXEC sp_rename 'dbo.tbAuxiliares_New', 'tbAuxiliares';
GO

-------------------------------------------------------------
-- 5. Crear PK nueva en la tabla sin IDENTITY
-------------------------------------------------------------
ALTER TABLE dbo.tbAuxiliares
ADD CONSTRAINT PK_tbAuxiliaresKey
PRIMARY KEY CLUSTERED (ID ASC, NumeroAsociado ASC);
GO

-------------------------------------------------------------
-- 6. (Opcional) Eliminar tabla vieja cuando confirmes que todo funciona
-------------------------------------------------------------
-- DROP TABLE dbo.tbAuxiliares_Old;