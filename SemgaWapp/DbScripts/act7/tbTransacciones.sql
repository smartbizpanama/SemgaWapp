
CREATE TABLE [dbo].[tbTransacciones](
	[IDTransaccion] [int] IDENTITY(1,1) NOT NULL,
	[FechaHora] [datetime] NULL,
	[Usuario] [int] NULL,
	[NumeroAsociado] [nchar](10) NULL,
	[jsonRequest] [nvarchar](max) NULL,
	[jsonResponse] [nvarchar](max) NULL,
 CONSTRAINT [PK_tbTransacciones] PRIMARY KEY CLUSTERED 
(
	[IDTransaccion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO


