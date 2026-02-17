IF OBJECT_ID('dbo.tbLogProcesosAutomaticos_D', 'U') IS NOT NULL
    DROP TABLE dbo.tbLogProcesosAutomaticos_D;
GO

CREATE TABLE dbo.tbLogProcesosAutomaticos_D
(
    LogD_ID       INT IDENTITY(1,1) NOT NULL,
    LogH_ID       INT NOT NULL,              -- FK a cabecera
    RefID         INT NOT NULL,              -- ID UNIDAD MINIMA (Asociado, Auxiliar, etc.)
    RefTipo       NVARCHAR(50) NOT NULL,     -- TIPO UNIDAD MINIMA (Asociado, Auxiliar, etc.)
    Mes           INT NOT NULL,
    Año           INT NOT NULL,
    FechaInicio   DATETIME2(0) NOT NULL,
    FechaFin      DATETIME2(0) NOT NULL,
    Resultado     CHAR(1) NOT NULL,          -- S / E
    Mensaje       NVARCHAR(MAX) NULL,

    CONSTRAINT PK_tbLogProcesosAutomaticos_D
        PRIMARY KEY CLUSTERED (LogD_ID),

    CONSTRAINT FK_tbLogProcesosAutomaticos_D_H
        FOREIGN KEY (LogH_ID)
        REFERENCES dbo.tbLogProcesosAutomaticos_H (LogH_ID)
);
GO

CREATE NONCLUSTERED INDEX IX_tbLogProcesosAutomaticos_D_Ref_Periodo
ON dbo.tbLogProcesosAutomaticos_D (RefID, Año, Mes);

CREATE NONCLUSTERED INDEX IX_tbLogProcesosAutomaticos_D_LogH
ON dbo.tbLogProcesosAutomaticos_D (LogH_ID);
GO
