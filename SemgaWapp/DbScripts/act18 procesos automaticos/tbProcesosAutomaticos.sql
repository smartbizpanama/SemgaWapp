

CREATE TABLE [dbo].[tbProcesosAutomaticos](
	[ID] INT IDENTITY(1,1) NOT NULL,
	[ProcessType] [varchar](10) NULL,
	[ProccessCommand] [nchar](10) NULL,
	[snActivo] [bit] NULL
) ON [PRIMARY]
GO


