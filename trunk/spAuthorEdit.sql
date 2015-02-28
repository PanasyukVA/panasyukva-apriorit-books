USE [SelfEducation]
GO
/****** Object:  StoredProcedure [dbo].[spAuthorEdit]    Script Date: 2/26/2015 6:58:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[spAuthorEdit] 
	@ID INT OUTPUT,
	@Name VARCHAR(150)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @Err VARCHAR(1024)

    BEGIN TRY
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

				UPDATE Author
				SET Name = @Name
				WHERE ID = @ID

				IF (@@ROWCOUNT = 0)
					RAISERROR('Error during edition!', 16, 1)

				IF (@@ERROR <> 0)
					RAISERROR('Error during edition!', 16, 1)
			END 
	END TRY
	BEGIN CATCH
		SELECT @Err = ERROR_MESSAGE()

		RAISERROR(@Err, 16, 1)
	END CATCH
END
