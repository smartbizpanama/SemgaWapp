CREATE TABLE dbo.tbLogProcesosAutomaticos_H
(
    LogH_ID        INT IDENTITY(1,1) NOT NULL,
    ProcName       NVARCHAR(250) NOT NULL,
    Mes            INT NOT NULL,
    Año            INT NOT NULL,
    FechaInicio    DATETIME2(0) NOT NULL,
    FechaFin       DATETIME2(0) NULL,
    Resultado      CHAR(1) NULL,        -- S / E
    Mensaje        NVARCHAR(MAX) NULL,

    CONSTRAINT PK_tbLogProcesosAutomaticos_H
        PRIMARY KEY CLUSTERED (LogH_ID)
);
GO
