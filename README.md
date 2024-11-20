# Database Project for "Library Management System"

## Scope of the Project
The scope of this project is to use all the SQL knowledge gained throughout the Software Testing course and apply them in practice.

**Application under test:** Library Management System

**Tools used:** MySQL Workbench

## Database Description
Baza de date "Library Management System" a fost creată pentru a gestiona informațiile despre cărți, autori, cititori și împrumuturi. Aceasta permite stocarea și gestionarea eficientă a informațiilor relevante, precum titlurile cărților, datele de împrumut și informațiile personale ale cititorilor. Scopul este de a facilita accesul rapid și ușor la informații și de a urmări împrumuturile efectuate.

## Database Schema

You can find below the database schema that was generated through Reverse Engineer and which contains all the tables and the relationships between them.

![EER Diagram](https://github.com/user-attachments/assets/1a90b1ce-b1f0-46cf-8920-c507b98bbc94)



- **Authors** is connected with **Books** through a **1:n** relationship which was implemented through **Authors.AuthorID** as a primary key and **Books.AuthorID** as a foreign key.
- **Books** is connected with **Loans** through a **1:n** relationship which was implemented through **Books.BookID** as a primary key and **Loans.BookID** as a foreign key.
- **Readers** is connected with **Loans** through a **1:n** relationship which was implemented through **Readers.ReaderID** as a primary key and **Loans.ReaderID** as a foreign key.

## Database Queries

### DDL (Data Definition Language)
The following instructions were written in the scope of CREATING the structure of the database (CREATE INSTRUCTIONS):

```sql
CREATE DATABASE LibraryManagement;
USE LibraryManagement;

 -- Table Authors(Autori)
CREATE TABLE Authors (
    AuthorID INT AUTO_INCREMENT PRIMARY KEY,
    LastName VARCHAR(50),
    FirstName VARCHAR(50),
    BirthDate DATE
);

-- Table Books (Cărți)
CREATE TABLE Books (
    BookID INT AUTO_INCREMENT PRIMARY KEY,
    Title VARCHAR(100),
    PublicationYear INT,
    Genre VARCHAR(50),
    AuthorID INT,
    FOREIGN KEY (AuthorID) REFERENCES Authors(AuthorID)
);

-- Table Genres (Genuri)
CREATE TABLE Genres (
    GenreID INT AUTO_INCREMENT PRIMARY KEY,
    GenreName VARCHAR(50)
);

-- Table Readers (Cititori)
CREATE TABLE Readers (
    ReaderID INT AUTO_INCREMENT PRIMARY KEY,
    LastName VARCHAR(50),
    FirstName VARCHAR(50),
    Email VARCHAR(100),
    PhoneNumber VARCHAR(20)
);

-- Table Loans (Împrumuturi)
CREATE TABLE BookLoans (
    LoanID INT AUTO_INCREMENT PRIMARY KEY,
    BookID INT,
    ReaderID INT,
    LoanDate DATE,
    ReturnDate DATE,
    FOREIGN KEY (BookID) REFERENCES Books(BookID),
    FOREIGN KEY (ReaderID) REFERENCES Readers(ReaderID)
);
```
After the database and the tables have been created, a few ALTER instructions were written in order to update the structure of the database, as described below:
```sql
-- We add a column to track the availability status of the books.
ALTER TABLE Books ADD COLUMN Status VARCHAR(20) DEFAULT 'Available';

-- We modify the data type for phone numbers in the Readers table
ALTER TABLE Readers MODIFY COLUMN PhoneNumber VARCHAR(20);

-- We update the status of returned books to 'Available'
UPDATE Books 
SET Status = 'Available' 
WHERE BookID IN (SELECT BookID FROM BookLoans WHERE ReturnDate IS NOT NULL);
```

## DML (Data Manipulation Language)
In order to be able to use the database, I populated the tables with various data necessary to perform queries and manipulate the data.

Below you can find all the insert instructions that were created in the scope of this project:

```sql
-- Insert data into the Authors table
INSERT INTO Authors (LastName, FirstName, BirthDate) VALUES
('Rebreanu', 'Liviu', '1885-11-27'),
('Caragiale', 'Ion Luca', '1852-01-30'),
('Creanga', 'Ion', '1837-03-01'),
('Blaga', 'Lucian', '1895-05-09'),
('Eliade', 'Mircea', '1907-03-09');

-- Insert data into the Books table.
INSERT INTO Books (Title, PublicationYear, Genre, AuthorID) VALUES
('Ion', 1920, 'Novel', 1),
('A Lost Letter', 1884, 'Play', 2),
('Childhood Memories', 1892, 'Autobiography', 3),
('Poems of Light', 1919, 'Poetry', 4),
('Maitreyi', 1933, 'Novel', 5);

-- Insert data into the Readers table.
INSERT INTO Readers (LastName, FirstName, Email, PhoneNumber) VALUES
('Marin', 'Andrei', 'andrei.marin@example.com', '0730123456'),
('Dumitrescu', 'Ioana', 'ioana.dumitrescu@example.com', '0732123457'),
('Vasilescu', 'Mihai', 'mihai.vasilescu@example.com', '0745123458'),
('Popescu', 'Ana', 'ana.popescu@example.com', '0721234567');

-- Insert data into the BookLoans table
INSERT INTO BookLoans (BookID, ReaderID, LoanDate, ReturnDate) VALUES
   (1, 1, '2024-01-05', '2024-01-15'),
   (2, 2, '2024-01-10', NULL),
   (3, 3, '2024-01-12', '2024-01-20');

-- Insert data into the Genres table.
INSERT INTO Genres (GenreName) VALUES
('Novel'),
('Play'),
('Autobiography'),
('Poetry'),
('Science Fiction'),
('Fantasy');

```
After the insert, in order to prepare the data to be better suited for the testing process, I updated some data in the following way:

```sql


-- We set the corresponding values in the Books table to associate the books with the genres in the Genres table
UPDATE Books SET GenreID = 1 WHERE Title = 'Ion';  -- Roman
UPDATE Books SET GenreID = 2 WHERE Title = 'A Lost Letter';  -- Piesă
UPDATE Books SET GenreID = 3 WHERE Title = 'Childhood Memories';  -- Autobiografie
UPDATE Books SET GenreID = 4 WHERE Title = 'Poems of Light';  -- Poezie
UPDATE Books SET GenreID = 1 WHERE Title = 'Maitreyi';  -- Roman

```

After the testing process, I deleted the data that was no longer relevant in order to preserve the database clean:

```sql
-- We delete all loan records older than a certain date.
DELETE FROM BookLoans 
WHERE ReturnDate < '2024-01-01';

```

### DQL (Data Query Language)
In order to simulate various scenarios that might happen in real life, I created the following queries that would cover multiple potential real-life situations:
```sql
-- We select all books currently on loan.
SELECT Title FROM Books 
JOIN BookLoans ON Books.BookID = BookLoans.BookID 
WHERE BookLoans.ReturnDate IS NULL;

-- We count the number of loans for each reader.
SELECT Readers.LastName, Readers.FirstName, COUNT(BookLoans.LoanID) AS LoanCount
FROM Readers
JOIN BookLoans ON Readers.ReaderID = BookLoans.ReaderID
GROUP BY Readers.LastName, Readers.FirstName;

-- We select all readers who have borrowed novels.
SELECT Readers.LastName AS ReaderLastName, Readers.FirstName, Books.Title AS BorrowedBook
FROM Readers
JOIN BookLoans ON Readers.ReaderID = BookLoans.ReaderID
JOIN Books ON BookLoans.BookID = Books.BookID
WHERE Books.Genre = 'Novel';

-- We select the number of loans for each book genre.
SELECT Genre, COUNT(BookLoans.LoanID) AS TotalLoans
FROM Books
JOIN BookLoans ON Books.BookID = BookLoans.BookID
GROUP BY Genre;

-- Books that have never been borrowed.
SELECT Title FROM Books
WHERE BookID NOT IN (SELECT BookID FROM BookLoans);

-- Readers with no loans (using LEFT JOIN).
SELECT Readers.LastName, Readers.FirstName 
FROM Readers
LEFT JOIN BookLoans ON Readers.ReaderID = BookLoans.ReaderID
WHERE BookLoans.LoanID IS NULL;

-- Aggregate functions to find the oldest and newest books.
SELECT MIN(PublicationYear) AS OldestYear, MAX(PublicationYear) AS NewestYear FROM Books;

-- The average publication year for each author.
SELECT 
    Authors.LastName,
    Authors.FirstName,
    AVG(Books.PublicationYear) AS AveragePublicationYear
FROM Authors LEFT JOIN Books ON Authors.AuthorID = Books.AuthorID
GROUP BY Authors.AuthorID;

-- We count the books by genre.
SELECT Genre, COUNT(BookID) AS NumberOfBooks
FROM Books GROUP BY Genre;

-- We select all books written by a specific author, for example, Ion Luca Caragiale
SELECT Books.Title
FROM Books
JOIN Authors ON Books.AuthorID = Authors.AuthorID
WHERE Authors.LastName = 'Caragiale' AND Authors.FirstName = 'Ion Luca';

-- We select the total number of books in the library
SELECT COUNT(BookID) AS TotalBooks FROM Books;

-- We display all the books along with the names of their authors
SELECT Books.Title, Authors.LastName, Authors.FirstName
FROM Books
JOIN Authors ON Books.AuthorID = Authors.AuthorID;

-- We display all the books along with their status (Available/On loan)
SELECT Title, Status FROM Books;

-- We display the readers who have borrowed books, along with the titles of those books
SELECT Readers.LastName, Readers.FirstName, Books.Title
FROM Readers
JOIN BookLoans ON Readers.ReaderID = BookLoans.ReaderID
JOIN Books ON BookLoans.BookID = Books.BookID;

-- We display the readers who have borrowed poetry books
SELECT Readers.LastName, Readers.FirstName
FROM Readers
JOIN BookLoans ON Readers.ReaderID = BookLoans.ReaderID
JOIN Books ON BookLoans.BookID = Books.BookID
WHERE Books.Genre = 'Poetry';

-- We display all the books and their genres, using the Genres table
SELECT Books.Title, Genres.GenreName
FROM Books
JOIN Genres ON Books.GenreID = Genres.GenreID;

-- We select all authors who have more than two books in the library
SELECT Authors.LastName, Authors.FirstName, COUNT(Books.BookID) AS NumberOfBooks
FROM Authors
JOIN Books ON Authors.AuthorID = Books.AuthorID
GROUP BY Authors.AuthorID
HAVING COUNT(Books.BookID) > 2;

-- We select the readers who have borrowed a book and have not returned it yet
SELECT Readers.LastName, Readers.FirstName, Books.Title AS BorrowedBook
FROM Readers
JOIN BookLoans ON Readers.ReaderID = BookLoans.ReaderID
JOIN Books ON BookLoans.BookID = Books.BookID
WHERE BookLoans.ReturnDate IS NULL;

```

## Conclusions
This project has allowed me to apply the SQL concepts learned in the Software Testing course practically. I have gained hands-on experience with creating database structures, manipulating data, and writing queries to retrieve specific information. One of the key takeaways is the importance of data integrity and the role of foreign keys in maintaining relationships between tables. The project enhanced my understanding of how databases operate and how to effectively manage data using SQL.
