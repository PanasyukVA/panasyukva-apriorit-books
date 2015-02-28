USE [SelfEducation]
GO
/****** Object:  StoredProcedure [dbo].[BookAdd]    Script Date: 2/23/2015 6:32:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Panasyuk Vitaliy
-- Create date: 23.12.2014
-- Description:	Add a book
-- GO
-- DECLARE @ID INT
-- EXEC SelfEducation.dbo.BookAdd
--	@Name = 'Test',
-- 	@ID = @ID OUT
-- SELECT @ID
-- GO
-- =============================================
ALTER PROCEDURE [dbo].[BookAdd]
	@Name VARCHAR(150),
	@ID INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @Err VARCHAR(1024)

    BEGIN TRY
		IF (ISNULL(@Name, '') = '')
			RAISERROR('Not defined a name of the book!', 16, 1)
			
		INSERT INTO dbo.Book(Name) VALUES(@Name)
		
		IF (@@ERROR <> 0)
			RAISERROR('Error during addition!', 16, 1)
		
		SELECT @ID = SCOPE_IDENTITY()

		IF (@ID = 0)
			RAISERROR('A book wasn''t added: error during addition!', 16, 1) 
	END TRY
	BEGIN CATCH
		SELECT @Err = ERROR_MESSAGE()

		RAISERROR(@Err, 16, 1)
	END CATCH
END
