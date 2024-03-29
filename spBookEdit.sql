USE [SelfEducation]
GO
/****** Object:  StoredProcedure [dbo].[spBookEdit]    Script Date: 01.03.2015 19:04:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ==========================================
-- Author:		Panasyuk Vitaliy
-- Create date: 23/02/2015
-- Description:	this procedure edit a book
--GO
--DECLARE @ID INT
--EXEC SelfEducation.dbo.spBookEdit
--	@ID = @ID OUTPUT,
--	@Name = 'Test',
--	@Authors = 'Test, Test,'
--SELECT @ID
--GO
-- ==========================================
ALTER PROCEDURE [dbo].[spBookEdit] 
	@ID INT = NULL OUTPUT,
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

		BEGIN TRANSACTION
			IF ISNULL(@ID, 0) = 0
				BEGIN
					INSERT INTO dbo.Book(Name) VALUES(@Name)
		
					IF (@@ERROR <> 0)
						RAISERROR('Error during addition!', 16, 1)
		
					SELECT @ID = SCOPE_IDENTITY()

					IF (@ID = 0)
						RAISERROR('Error during addition!', 16, 1)
				END
			ELSE
				BEGIN
					IF NOT EXISTS(SELECT 1 FROM Book WHERE ID = @ID)
						RAISERROR('Not exists the specified Book!', 16, 1)

					UPDATE dbo.Book
					SET Name = @Name
					WHERE ID = @ID

					IF (@@ROWCOUNT = 0)
						RAISERROR('Error during edition l!', 16, 1)

					IF (@@ERROR <> 0)
						RAISERROR('Error during edition g!', 16, 1)

					DELETE FROM dbo.BookAuthor WHERE BookID = @ID
				END

			;WITH AuthorNames(startPosition, commaPosition, AuthorName) AS
					(
						SELECT 1 AS startPosition, 
						CHARINDEX(',', @Authors) AS commaPosition, 
						SUBSTRING(@Authors, 1, CHARINDEX(',', @Authors) - 1) AS AuthorName
						UNION ALL
						SELECT commaPosition + 2 AS startPosition, 
						CHARINDEX(',', @Authors, commaPosition + 1) AS commaPosition, 
						SUBSTRING(@Authors, commaPosition + 2, CHARINDEX(',', @Authors, commaPosition + 1) - (commaPosition + 2)) AS AuthorName
						FROM AuthorNames
						WHERE commaPosition < LEN(@Authors) 
					)

			INSERT INTO BookAuthor(BookID, AuthorID)
			SELECT @ID, a.ID 
			FROM dbo.Author a JOIN AuthorNames an ON an.AuthorName = a.Name
		COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
		SELECT @Err = ERROR_MESSAGE()

		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION
		
		RAISERROR(@Err, 16, 1)
	END CATCH
END
