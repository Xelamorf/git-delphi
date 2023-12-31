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




CREATE PROCEDURE [dbo].[tsp_IU_Client] (
	@Id int OUTPUT,
	@Status int,
	@FirstName nvarchar(50),
	@LastName nvarchar(50),
	@SecondName nvarchar(50),
	@BirnDate date)
AS
BEGIN
	SET NOCOUNT ON -- for view PRINT in App
	PRINT 'Вход в ХП tsp_IU_Client..'
	WAITFOR DELAY '00:00:05'
	
	DECLARE @IdTable TABLE(id INT)

IF NOT COALESCE(@Status,0) > 0
	BEGIN
		RAISERROR (N'Ошибка: %s ', 10, 1, 'Неверный статус клиента!') WITH NOWAIT, SETERROR;
		SET @Id = 0
		RETURN -1
	END 

IF @Id IS NULL -- вставка
 BEGIN TRY
  BEGIN TRAN
	INSERT INTO dbo.Clients (
		--[Id],
		[Created],
		[Status],
		[FirstName],
		[LastName],
		[SecondName],
		[BirnDate] )
	OUTPUT INSERTED.ID INTO @IdTable
	VALUES (
		--@Id,
		GETDATE(),
		@Status,
		@FirstName,
		@LastName,
		@SecondName,
		@BirnDate
	) 
	SELECT TOP 1 @Id = id FROM @IdTable	
   COMMIT TRAN 
    RAISERROR (N'$Вставка клиента случилась: ID = %d', 0, 1, @Id) WITH NOWAIT; -- аналог PRINT
   RETURN @Id
 END TRY
 BEGIN CATCH
    BEGIN
        SET @Id = 0
        DECLARE @ErrorMessageI NVARCHAR(MAX) = NULL
        ROLLBACK TRAN
        SELECT @ErrorMessageI = ERROR_MESSAGE()
        RAISERROR (N'Ошибка вставки клиента: %s ', 16, 1, @ErrorMessageI) WITH NOWAIT, SETERROR;
        RETURN -1
    END
 END CATCH
 ELSE -- обновление
 BEGIN TRY
  BEGIN TRAN
	UPDATE C 
	SET	--@Id,
		[Created] = GETDATE(),
		[Status] = @Status,
		[FirstName] = @FirstName,
		[LastName] = @LastName,
		[SecondName] = @SecondName,
		[BirnDate] = @BirnDate
	FROM dbo.Clients AS C
	WHERE Id = @Id -- уникальность записи гарантирована ключом PK
   COMMIT TRAN 
    RAISERROR (N'$Обновление клиента случилось: ID = %d', 0, 1, @Id) WITH NOWAIT; -- аналог PRINT
   RETURN @Id
 END TRY
 BEGIN CATCH
    BEGIN
        SET @Id = 0
        DECLARE @ErrorMessageU NVARCHAR(MAX) = NULL
        ROLLBACK TRAN
        SELECT @ErrorMessageU = ERROR_MESSAGE()
        RAISERROR (N'Ошибка обновления клиента: %s ', 16, 1, @ErrorMessageU) WITH NOWAIT, SETERROR;
        RETURN -1
    END
 END CATCH
	
END

GO

CREATE PROCEDURE [dbo].[tsp_IU_Credit] (
	@Id int OUTPUT,
	@ClientsId int,
	@Summa money,
	--@IssuedDate datetime, -- подстановка текущего в коде
	@Time int,
	@Status int)
AS
BEGIN
	SET NOCOUNT ON -- for view PRINT in App
	PRINT 'Вход в ХП tsp_IU_Credit..'
	WAITFOR DELAY '00:00:05'
	
	DECLARE @IdTable TABLE(id INT)

IF NOT COALESCE(@Status,0) > 0
	BEGIN
		RAISERROR (N'Ошибка: %s ', 10, 1, 'Неверный статус кредита!') WITH NOWAIT, SETERROR;
		SET @Id = 0
		RETURN -1
	END 

IF @Id IS NULL -- вставка
 BEGIN TRY
  BEGIN TRAN
	INSERT INTO dbo.Credits (
		--[Id],
		[ClientsId],
		[Summa],
		[IssuedDate],
		[Time],
		[Status])
	OUTPUT INSERTED.ID INTO @IdTable
	VALUES (
		--@Id,		
		@ClientsId,
		@Summa,
		GETDATE(),
		@Time,
		@Status) 
	SELECT TOP 1 @Id = id FROM @IdTable	
   COMMIT TRAN 
    RAISERROR (N'$Вставка кредита случилась: ID = %d', 0, 1, @Id) WITH NOWAIT; -- аналог PRINT
   RETURN @Id
 END TRY
 BEGIN CATCH
    BEGIN
        SET @Id = 0
        DECLARE @ErrorMessage NVARCHAR(MAX) = NULL
        ROLLBACK TRAN
        SELECT @ErrorMessage = ERROR_MESSAGE()
        RAISERROR (N'Ошибка добавления кредита: %s ', 16, 1, @ErrorMessage) WITH NOWAIT, SETERROR;
        RETURN -1
    END
 END CATCH
 --	редактирование кредита не предполагается заданием	
END

GO	
