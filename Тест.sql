USE [master]
GO

IF  EXISTS (SELECT name FROM sys.databases WHERE name = N'Test')
DROP DATABASE [Test]
GO

CREATE DATABASE [Test]
GO

USE [Test]
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Clients]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Clients](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Created] [datetime] NOT NULL,
	[Status] [int] NOT NULL,
	[FirstName] [nvarchar](50) NOT NULL,
	[LastName] [nvarchar](50) NOT NULL,
	[SecondName] [nvarchar](50) NOT NULL,
	[BirnDate] [datetime] NOT NULL,
 CONSTRAINT [PK_Clients] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Credits]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Credits](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ClientsId] [int] NOT NULL,
	[Summa] [money] NOT NULL,
	[IssuedDate] [datetime] NOT NULL,
	[Time] [int] NOT NULL,
	[Status] [int] NOT NULL,
 CONSTRAINT [PK_Credits] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Credits_Clients]') AND parent_object_id = OBJECT_ID(N'[dbo].[Credits]'))
ALTER TABLE [dbo].[Credits]  WITH CHECK ADD  CONSTRAINT [FK_Credits_Clients] FOREIGN KEY([ClientsId])
REFERENCES [dbo].[Clients] ([Id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Credits_Clients]') AND parent_object_id = OBJECT_ID(N'[dbo].[Credits]'))
ALTER TABLE [dbo].[Credits] CHECK CONSTRAINT [FK_Credits_Clients]
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'Clients', N'COLUMN',N'Id'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Идентификатор клиента' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Clients', @level2type=N'COLUMN',@level2name=N'Id'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'Clients', N'COLUMN',N'Created'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Дата ввода данных клиента' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Clients', @level2type=N'COLUMN',@level2name=N'Created'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'Clients', N'COLUMN',N'Status'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Статус' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Clients', @level2type=N'COLUMN',@level2name=N'Status'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'Clients', N'COLUMN',N'FirstName'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Имя' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Clients', @level2type=N'COLUMN',@level2name=N'FirstName'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'Clients', N'COLUMN',N'LastName'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Фамилия' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Clients', @level2type=N'COLUMN',@level2name=N'LastName'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'Clients', N'COLUMN',N'SecondName'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Отчество' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Clients', @level2type=N'COLUMN',@level2name=N'SecondName'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'Clients', N'COLUMN',N'BirnDate'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Дата рождения' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Clients', @level2type=N'COLUMN',@level2name=N'BirnDate'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'Credits', N'COLUMN',N'Id'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Идентификатор кредита' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Credits', @level2type=N'COLUMN',@level2name=N'Id'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'Credits', N'COLUMN',N'ClientsId'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Идентификатор клиента' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Credits', @level2type=N'COLUMN',@level2name=N'ClientsId'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'Credits', N'COLUMN',N'Summa'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Выданная сумма' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Credits', @level2type=N'COLUMN',@level2name=N'Summa'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'Credits', N'COLUMN',N'IssuedDate'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Дата выдачи' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Credits', @level2type=N'COLUMN',@level2name=N'IssuedDate'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'Credits', N'COLUMN',N'Time'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Срок займа' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Credits', @level2type=N'COLUMN',@level2name=N'Time'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'Credits', N'COLUMN',N'Status'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Статус клиента' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Credits', @level2type=N'COLUMN',@level2name=N'Status'
GO
USE [master]
GO
ALTER DATABASE [Test] SET  READ_WRITE 
GO
