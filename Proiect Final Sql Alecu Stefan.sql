CREATE DATABASE LibraryManagement;
USE LibraryManagement;


-- Authors Table
CREATE TABLE Authors (
    AuthorID INT AUTO_INCREMENT PRIMARY KEY,
    LastName VARCHAR(50),
    FirstName VARCHAR(50),
    BirthDate DATE
);

-- Books Table
CREATE TABLE Books (
    BookID INT AUTO_INCREMENT PRIMARY KEY,
    Title VARCHAR(100),
    PublicationYear YEAR,
    Genre VARCHAR(50),
    AuthorID INT,
    FOREIGN KEY (AuthorID) REFERENCES Authors(AuthorID)
);

-- Genres Table
CREATE TABLE Genres (
    GenreID INT AUTO_INCREMENT PRIMARY KEY,
    GenreName VARCHAR(50)
);


-- Readers Table
CREATE TABLE Readers (
    ReaderID INT AUTO_INCREMENT PRIMARY KEY,
    LastName VARCHAR(50),
    FirstName VARCHAR(50),
    Email VARCHAR(100),
    PhoneNumber VARCHAR(15)
);

-- Loans Table
CREATE TABLE Loans (
    LoanID INT AUTO_INCREMENT PRIMARY KEY,
    BookID INT,
    ReaderID INT,
    LoanDate DATE,
    ReturnDate DATE,
    FOREIGN KEY (BookID) REFERENCES Books(BookID),
    FOREIGN KEY (ReaderID) REFERENCES Readers(ReaderID)
);


-- Adding a column to track the availability status of books
ALTER TABLE Books ADD COLUMN Status VARCHAR(20) DEFAULT 'Available';

-- Changing the data type for phone numbers in the Readers table
ALTER TABLE Readers MODIFY COLUMN PhoneNumber VARCHAR(20);

-- Renaming the Loans table to BookLoans
ALTER TABLE Loans RENAME TO BookLoans;

--  Changing PublicationYear to INT
ALTER TABLE Books MODIFY COLUMN PublicationYear INT;


-- Inserting Sample Data into Tables

-- 1.Authors Table
INSERT INTO Authors (LastName, FirstName, BirthDate) VALUES
('Rebreanu', 'Liviu', '1885-11-27'),
('Caragiale', 'Ion Luca', '1852-01-30'),
('Creanga', 'Ion', '1837-03-01'),
('Blaga', 'Lucian', '1895-05-09'),
('Eliade', 'Mircea', '1907-03-09');


-- 2.Book Table
INSERT INTO Books (Title, PublicationYear, Genre, AuthorID) VALUES
('Ion', 1920, 'Novel', 1),
('A Lost Letter', 1884, 'Play', 2),
('Childhood Memories', 1892, 'Autobiography', 3),
('Poems of Light', 1919, 'Poetry', 4),
('Maitreyi', 1933, 'Novel', 5);

-- 3.Reader Table
INSERT INTO Readers (LastName, FirstName, Email, PhoneNumber) VALUES
('Marin', 'Andrei', 'andrei.marin@example.com', '0730123456'),
('Dumitrescu', 'Ioana', 'ioana.dumitrescu@example.com', '0732123457'),
('Vasilescu', 'Mihai', 'mihai.vasilescu@example.com', '0745123458'),
('Popescu', 'Ana' , 'ana.popescu@example.com', '0721234567');


-- 4.Loans Table
INSERT INTO Loans (BookID, ReaderID, LoanDate, ReturnDate) VALUES
   (6, 1, '2024-01-05', '2024-01-15'),
   (7, 2, '2024-01-10', NULL),
   (8, 3, '2024-01-12', '2024-01-20');
   
   -- 5. Genre Table
   INSERT INTO Genres (GenreName) VALUES
('Novel'),
('Play'),
('Autobiography'),
('Poetry'),
('Science Fiction'),
('Fantasy');



-- Update the status of returned books to 'Available'
UPDATE Books 
SET Status = 'Available' 
WHERE BookID IN (SELECT BookID FROM Loans WHERE ReturnDate IS NOT NULL);

-- Delete all loan records older than a specific date
DELETE FROM Loans 
WHERE ReturnDate < '2024-01-01';


-- Retrieve All Books Currently Loaned
SELECT Title FROM Books 
JOIN Loans ON Books.BookID = Loans.BookID 
WHERE Loans.ReturnDate IS NULL;

-- Count the Number of Loans for Each Reader
SELECT Readers.LastName, Readers.FirstName, COUNT(Loans.LoanID) AS LoanCount
FROM Readers
JOIN Loans ON Readers.ReaderID = Loans.ReaderID
GROUP BY Readers.LastName, Readers.FirstName;

-- Retrieve All Readers Who Have Borrowed Novels
SELECT Readers.LastName AS ReaderLastName, Readers.FirstName, Books.Title AS BorrowedBook
FROM Readers
JOIN Loans ON Readers.ReaderID = Loans.ReaderID
JOIN Books ON Loans.BookID = Books.BookID
WHERE Books.Genre = 'Novel';

-- Retrieve the Number of Loans for Each Book Genre
SELECT Genre, COUNT(Loans.LoanID) AS TotalLoans
FROM Books
JOIN Loans ON Books.BookID = Loans.BookID
GROUP BY Genre;

-- Books That Have Never Been Loaned
SELECT Title FROM Books
WHERE BookID NOT IN (SELECT BookID FROM Loans);

-- Readers Without Any Loans (Using LEFT JOIN)
SELECT Readers.LastName, Readers.FirstName 
FROM Readers
LEFT JOIN Loans ON Readers.ReaderID = Loans.ReaderID
WHERE Loans.LoanID IS NULL;

-- Aggregate Functions to Find the Oldest and Newest Books
SELECT MIN(PublicationYear) AS OldestYear, MAX(PublicationYear) AS NewestYear FROM Books;

-- Group by
-- Average Publication Year: To find the average publication year of books for each author
SELECT 
    Authors.LastName,
    Authors.FirstName,
    AVG(Books.PublicationYear) AS AveragePublicationYear
FROM Authors LEFT JOIN Books ON Authors.AuthorID = Books.AuthorID
GROUP BY Authors.AuthorID;

-- Count Books by Genre
SELECT Genre, COUNT(BookID) AS NumberOfBooks
FROM Books GROUP BY Genre;

UPDATE Books SET GenreID = 1 WHERE Title = 'Ion';  -- Novel
UPDATE Books SET GenreID = 2 WHERE Title = 'A Lost Letter';  -- Play
UPDATE Books SET GenreID = 3 WHERE Title = 'Childhood Memories';  -- Autobiography
UPDATE Books SET GenreID = 4 WHERE Title = 'Poems of Light';  -- Poetry
UPDATE Books SET GenreID = 1 WHERE Title = 'Maitreyi';  -- Novel


-- Readers and Details of Loaned Books
SELECT 
    Readers.FirstName AS ReaderFirstName,
    Readers.LastName AS ReaderLastName,
    Books.Title AS BookTitle
FROM Readers LEFT JOIN Loans ON Readers.ReaderID = Loans.ReaderID
LEFT JOIN Books ON Loans.BookID = Books.BookID;
