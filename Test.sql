USE SelfEducation

SELECT * FROM Book
SELECT * FROM Author
SELECT * FROM BookAuthor

DELETE FROM BookAuthor WHERE BookID NOT IN (1, 2, 3)
DELETE FROM Book WHERE ID NOT IN (1, 2, 3)
DELETE FROM Author WHERE ID NOT IN (1, 2, 3, 4, 5, 6, 7)
