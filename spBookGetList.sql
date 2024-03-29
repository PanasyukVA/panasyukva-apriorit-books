USE [SelfEducation]
GO
/****** Object:  StoredProcedure [dbo].[spBookGetList]    Script Date: 2/25/2015 8:22:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =================================================
-- Author:		Panasyuk Vitaliy
-- Create date: 23/02/2015
-- Description:	this procedure get the list of books
--GO
--EXEC SelfEducation.dbo.spBookGetList
--	@AuthorID = 1
--GO
-- =================================================
ALTER PROCEDURE [dbo].[spBookGetList]
	@AuthorID INT = NULL
AS
BEGIN
	SET NOCOUNT ON;

    SELECT DISTINCT b.ID, b.Name 
	FROM Book b JOIN BookAuthor ba ON b.ID = ba.BookID
	WHERE ba.AuthorID = ISNULL(@AuthorID, ba.AuthorID)
	ORDER BY b.ID
END
