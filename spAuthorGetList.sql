USE [SelfEducation]
GO
/****** Object:  StoredProcedure [dbo].[spAuthorGetList]    Script Date: 2/26/2015 11:31:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[spAuthorGetList]
	@BookID INT = NULL
AS
BEGIN
	SET NOCOUNT ON;

    SELECT a.ID, a.Name, ISNULL((SELECT 1 
                             FROM BookAuthor ba 
							 WHERE ba.AuthorID = a.ID 
							 AND ba.BookID = @BookID), 0) AS WroteBook
    FROM Author a
END
