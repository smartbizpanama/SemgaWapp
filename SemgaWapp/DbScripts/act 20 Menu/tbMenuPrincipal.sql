CREATE TABLE [dbo].[tbMenuPrincipal](
	[IdMenu] [int] NOT NULL,
	[IdParent] [int] NULL,
	[TextoMenu] [nvarchar](100) NULL,
	[Url] [nvarchar](100) NULL,
	[snActivo] [bit] NULL,
	[Orden] [int] NULL,
	[Icon] [nvarchar](100) NULL,
 CONSTRAINT [PK_tbMenuPrincipal] PRIMARY KEY CLUSTERED 
(
	[IdMenu] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
