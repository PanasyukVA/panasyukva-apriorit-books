-- Create table
CREATE TABLE dbo.Book(
  ID INT IDENTITY CONSTRAINT PK_Book PRIMARY KEY,
  Name VARCHAR(150)
)

CREATE TABLE dbo.Author(
  ID INT IDENTITY CONSTRAINT PK_Author PRIMARY KEY,
  Name VARCHAR(150)
)

CREATE TABLE dbo.BookAuthor(
  BookID INT,
  AuthorID INT
)

ALTER TABLE dbo.BookAuthor
  ADD CONSTRAINT FK_BookAuthor_BookID FOREIGN KEY (BookID) REFERENCES dbo.Book(ID)
ALTER TABLE dbo.BookAuthor
  ADD CONSTRAINT FK_BookAuthor_AuthorID FOREIGN KEY (AuthorID) REFERENCES dbo.Author(ID)
ALTER TABLE dbo.BookAuthor
  ALTER COLUMN BookID INT NOT NULL
ALTER TABLE dbo.BookAuthor
  ALTER COLUMN AuthorID INT NOT NULL
ALTER TABLE dbo.BookAuthor
  ADD CONSTRAINT PK_BookAuthor PRIMARY KEY (BookID, AuthorID)

-- Full table
INSERT INTO Book(Name) VALUES('Pro ASP.NET 4.5 in C#')
INSERT INTO Book(Name) VALUES('Pro ASP.NET MVC 4, 4th Edition')
INSERT INTO Book(Name) VALUES('Professional ASP.NET MVC 3')

INSERT INTO Author(Name) VALUES('Adam Freeman')
INSERT INTO Author(Name) VALUES('Matthew MacDonald')
INSERT INTO Author(Name) VALUES('Mario Szpuszta')
INSERT INTO Author(Name) VALUES('Jon Galloway')
INSERT INTO Author(Name) VALUES('Phil Haack')
INSERT INTO Author(Name) VALUES('Brad Wilson')
INSERT INTO Author(Name) VALUES('K. Scott Allen') 

INSERT INTO BookAuthor(BookID, AuthorID) VALUES(1, 1)
INSERT INTO BookAuthor(BookID, AuthorID) VALUES(1, 2)
INSERT INTO BookAuthor(BookID, AuthorID) VALUES(1, 3)
INSERT INTO BookAuthor(BookID, AuthorID) VALUES(2, 1)
INSERT INTO BookAuthor(BookID, AuthorID) VALUES(3, 4)
INSERT INTO BookAuthor(BookID, AuthorID) VALUES(3, 5)
INSERT INTO BookAuthor(BookID, AuthorID) VALUES(3, 6)
INSERT INTO BookAuthor(BookID, AuthorID) VALUES(3, 7)
