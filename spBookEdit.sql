USE [SelfEducation]
GO
/****** Object:  StoredProcedure [dbo].[spBookEdit]    Script Date: 2/26/2015 2:27:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[spBookEdit] 
	@ID INT OUTPUT,
	@Name VARCHAR(150),
	@Authors VARCHAR(1024)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @Err VARCHAR(1024),
			@CommaPosition INT = 0,
			@StartPosition INT = 1,
			@AuthorName VARCHAR(50)

    BEGIN TRY
		IF (ISNULL(@Name, '') = '')
			RAISERROR('Not defined a name of the book!', 16, 1)
			
		IF ISNULL(@ID, 0) = 0
			BEGIN
				INSERT INTO dbo.Book(Name) VALUES(@Name)
		
				IF (@@ERROR <> 0)
					RAISERROR('Error during addition!', 16, 1)
		
				SELECT @ID = SCOPE_IDENTITY()

				IF (@ID = 0)
					RAISERROR('Error during addition!', 16, 1)

				WHILE @CommaPosition < ISNULL(LEN(@Authors), '')
				BEGIN
					SET @CommaPosition = CHARINDEX(',', @Authors, @CommaPosition + 1)
					SET @AuthorName = SUBSTRING(@Authors, @StartPosition, @CommaPosition - @StartPosition)

					IF EXISTS(SELECT 1 FROM Author WHERE Name = @AuthorName)
						INSERT INTO BookAuthor(BookID, AuthorID)
						SELECT @ID, ID 
						FROM Author 
						WHERE Name = @AuthorName

					SET @StartPosition = @CommaPosition + 2
				END
			END
		ELSE
			BEGIN
				IF NOT EXISTS(SELECT 1 FROM Book WHERE ID = @ID)
					RAISERROR('Not exists the specified Book!', 16, 1)

				UPDATE Book
				SET Name = @Name
				WHERE ID = @ID

				IF (@@ROWCOUNT = 0)
					RAISERROR('Error during edition l!', 16, 1)

				IF (@@ERROR <> 0)
					RAISERROR('Error during edition g!', 16, 1)

				DELETE FROM BookAuthor WHERE BookID = @ID

				WHILE @CommaPosition < ISNULL(LEN(@Authors), '')
				BEGIN
					SET @CommaPosition = CHARINDEX(',', @Authors, @CommaPosition + 1)
					SET @AuthorName = SUBSTRING(@Authors, @StartPosition, @CommaPosition - @StartPosition)

					IF EXISTS(SELECT 1 FROM Author WHERE Name = @AuthorName)
						INSERT INTO BookAuthor(BookID, AuthorID)
						SELECT @ID, ID 
						FROM Author
						WHERE Name = @AuthorName

					SET @StartPosition = @CommaPosition + 2
				END
			END 
	END TRY
	BEGIN CATCH
		SELECT @Err = ERROR_MESSAGE()

		RAISERROR(@Err, 16, 1)
	END CATCH
END
