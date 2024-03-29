USE [SelfEducation]
GO
/****** Object:  StoredProcedure [dbo].[spAuthorEdit]    Script Date: 28.02.2015 21:50:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ==========================================
-- Author:		Panasyuk Vitaliy
-- Create date: 23/02/2015
-- Description:	this procedure edit an author
--GO
--DECLARE @ID INT
--EXEC SelfEducation.dbo.spAuthorEdit
--	@ID = @ID OUTPUT,
--	@Name = 'Test'
--SELECT @ID
--GO
-- ==========================================
ALTER PROCEDURE [dbo].[spAuthorEdit] 
	@ID INT = NULL OUTPUT,
	@Name VARCHAR(150)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @Err VARCHAR(1024)

    IF (ISNULL(@Name, '') = '')
		RAISERROR('Not defined a name of the author!', 16, 1)
			
	IF ISNULL(@ID, 0) = 0
		BEGIN
			INSERT INTO dbo.Author(Name) VALUES(@Name)
		
			IF (@@ERROR <> 0)
				RAISERROR('Error during addition!', 16, 1)
		
			SELECT @ID = SCOPE_IDENTITY()

			IF (@ID = 0)
				RAISERROR('Error during addition!', 16, 1)
		END
	ELSE
		BEGIN
			IF NOT EXISTS(SELECT 1 FROM Author WHERE ID = @ID)
				RAISERROR('Not exists the specified Author!', 16, 1)

			UPDATE dbo.Author
			SET Name = @Name
			WHERE ID = @ID

			IF (@@ROWCOUNT = 0)
				RAISERROR('Error during edition!', 16, 1)

			IF (@@ERROR <> 0)
				RAISERROR('Error during edition!', 16, 1)
		END 
END
