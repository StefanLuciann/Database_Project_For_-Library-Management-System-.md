# Database Project for "Library Management System"

## Scope of the Project
The scope of this project is to use all the SQL knowledge gained throughout the Software Testing course and apply them in practice.

**Application under test:** Library Management System

**Tools used:** MySQL Workbench

## Database Description
Baza de date "Library Management System" a fost creată pentru a gestiona informațiile despre cărți, autori, cititori și împrumuturi. Aceasta permite stocarea și gestionarea eficientă a informațiilor relevante, precum titlurile cărților, datele de împrumut și informațiile personale ale cititorilor. Scopul este de a facilita accesul rapid și ușor la informații și de a urmări împrumuturile efectuate.

## Database Schema

![EER Diagram](https://github.com/user-attachments/assets/1a90b1ce-b1f0-46cf-8920-c507b98bbc94)

You can find below the database schema that was generated through Reverse Engineer and which contains all the tables and the relationships between them.

- **Authors** is connected with **Books** through a **1:n** relationship which was implemented through **Authors.AuthorID** as a primary key and **Books.AuthorID** as a foreign key.
- **Books** is connected with **Loans** through a **1:n** relationship which was implemented through **Books.BookID** as a primary key and **Loans.BookID** as a foreign key.
- **Readers** is connected with **Loans** through a **1:n** relationship which was implemented through **Readers.ReaderID** as a primary key and **Loans.ReaderID** as a foreign key.

## Database Queries

### DDL (Data Definition Language)
The following instructions were written in the scope of CREATING the structure of the database (CREATE INSTRUCTIONS):

```sql
CREATE DATABASE LibraryManagement;
USE LibraryManagement;

--- Tabela Authors (Autori)
CREATE TABLE Authors (
    AuthorID INT AUTO_INCREMENT PRIMARY KEY,
    LastName VARCHAR(50),
    FirstName VARCHAR(50),
    BirthDate DATE
);

-- Tabela Books (Cărți)
CREATE TABLE Books (
    BookID INT AUTO_INCREMENT PRIMARY KEY,
    Title VARCHAR(100),
    PublicationYear INT,
    Genre VARCHAR(50),
    AuthorID INT,
    FOREIGN KEY (AuthorID) REFERENCES Authors(AuthorID)
);

-- Tabela Genres (Genuri)
CREATE TABLE Genres (
    GenreID INT AUTO_INCREMENT PRIMARY KEY,
    GenreName VARCHAR(50)
);

-- Tabela Readers (Cititori)
CREATE TABLE Readers (
    ReaderID INT AUTO_INCREMENT PRIMARY KEY,
    LastName VARCHAR(50),
    FirstName VARCHAR(50),
    Email VARCHAR(100),
    PhoneNumber VARCHAR(20)
);

-- Tabela Loans (Împrumuturi)
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
-- Adăugăm o coloană pentru a urmări statusul de disponibilitate a cărților
ALTER TABLE Books ADD COLUMN Status VARCHAR(20) DEFAULT 'Available';

-- Modificăm tipul de date pentru numerele de telefon în tabela Readers
ALTER TABLE Readers MODIFY COLUMN PhoneNumber VARCHAR(20);

-- Actualizăm statusul cărților returnate la 'Available'
UPDATE Books 
SET Status = 'Available' 
WHERE BookID IN (SELECT BookID FROM BookLoans WHERE ReturnDate IS NOT NULL);
```

## DML (Data Manipulation Language)
In order to be able to use the database, I populated the tables with various data necessary to perform queries and manipulate the data.

Below you can find all the insert instructions that were created in the scope of this project:

```sql
-- Inserare date în tabelul Authors
INSERT INTO Authors (LastName, FirstName, BirthDate) VALUES
('Rebreanu', 'Liviu', '1885-11-27'),
('Caragiale', 'Ion Luca', '1852-01-30'),
('Creanga', 'Ion', '1837-03-01'),
('Blaga', 'Lucian', '1895-05-09'),
('Eliade', 'Mircea', '1907-03-09');

-- Inserare date în tabelul Books
INSERT INTO Books (Title, PublicationYear, Genre, AuthorID) VALUES
('Ion', 1920, 'Novel', 1),
('A Lost Letter', 1884, 'Play', 2),
('Childhood Memories', 1892, 'Autobiography', 3),
('Poems of Light', 1919, 'Poetry', 4),
('Maitreyi', 1933, 'Novel', 5);

-- Inserare date în tabelul Readers
INSERT INTO Readers (LastName, FirstName, Email, PhoneNumber) VALUES
('Marin', 'Andrei', 'andrei.marin@example.com', '0730123456'),
('Dumitrescu', 'Ioana', 'ioana.dumitrescu@example.com', '0732123457'),
('Vasilescu', 'Mihai', 'mihai.vasilescu@example.com', '0745123458'),
('Popescu', 'Ana', 'ana.popescu@example.com', '0721234567');

-- Inserare date în tabelul BookLoans
INSERT INTO BookLoans (BookID, ReaderID, LoanDate, ReturnDate) VALUES
   (1, 1, '2024-01-05', '2024-01-15'),
   (2, 2, '2024-01-10', NULL),
   (3, 3, '2024-01-12', '2024-01-20');

-- Inserare date în tabelul Genres
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


-- Setăm valorile corespunzătoare în Books pentru a asocia cărțile cu genurile din tabela Genres
UPDATE Books SET GenreID = 1 WHERE Title = 'Ion';  -- Roman
UPDATE Books SET GenreID = 2 WHERE Title = 'A Lost Letter';  -- Piesă
UPDATE Books SET GenreID = 3 WHERE Title = 'Childhood Memories';  -- Autobiografie
UPDATE Books SET GenreID = 4 WHERE Title = 'Poems of Light';  -- Poezie
UPDATE Books SET GenreID = 1 WHERE Title = 'Maitreyi';  -- Roman

```

After the testing process, I deleted the data that was no longer relevant in order to preserve the database clean:

```sql
-- Ștergem toate înregistrările de împrumut mai vechi de o anumită dată
DELETE FROM BookLoans 
WHERE ReturnDate < '2024-01-01';

```

### DQL (Data Query Language)
In order to simulate various scenarios that might happen in real life, I created the following queries that would cover multiple potential real-life situations:
```sql
-- Selectăm toate cărțile împrumutate în prezent
SELECT Title FROM Books 
JOIN BookLoans ON Books.BookID = BookLoans.BookID 
WHERE BookLoans.ReturnDate IS NULL;

-- Numărăm numărul de împrumuturi pentru fiecare cititor
SELECT Readers.LastName, Readers.FirstName, COUNT(BookLoans.LoanID) AS LoanCount
FROM Readers
JOIN BookLoans ON Readers.ReaderID = BookLoans.ReaderID
GROUP BY Readers.LastName, Readers.FirstName;

-- Selectăm toți cititorii care au împrumutat romane
SELECT Readers.LastName AS ReaderLastName, Readers.FirstName, Books.Title AS BorrowedBook
FROM Readers
JOIN BookLoans ON Readers.ReaderID = BookLoans.ReaderID
JOIN Books ON BookLoans.BookID = Books.BookID
WHERE Books.Genre = 'Novel';

-- Selectăm numărul de împrumuturi pentru fiecare gen de carte
SELECT Genre, COUNT(BookLoans.LoanID) AS TotalLoans
FROM Books
JOIN BookLoans ON Books.BookID = BookLoans.BookID
GROUP BY Genre;

-- Cărți care nu au fost niciodată împrumutate
SELECT Title FROM Books
WHERE BookID NOT IN (SELECT BookID FROM BookLoans);

-- Cititori fără niciun împrumut (utilizând LEFT JOIN)
SELECT Readers.LastName, Readers.FirstName 
FROM Readers
LEFT JOIN BookLoans ON Readers.ReaderID = BookLoans.ReaderID
WHERE BookLoans.LoanID IS NULL;

-- Funcții agregate pentru a găsi cele mai vechi și cele mai noi cărți
SELECT MIN(PublicationYear) AS OldestYear, MAX(PublicationYear) AS NewestYear FROM Books;

-- Media anului de publicare pentru fiecare autor
SELECT 
    Authors.LastName,
    Authors.FirstName,
    AVG(Books.PublicationYear) AS AveragePublicationYear
FROM Authors LEFT JOIN Books ON Authors.AuthorID = Books.AuthorID
GROUP BY Authors.AuthorID;

-- Numărăm cărțile în funcție de gen
SELECT Genre, COUNT(BookID) AS NumberOfBooks
FROM Books GROUP BY Genre;

-- Selectăm toate cărțile scrise de un anumit autor, de exemplu, Ion Luca Caragiale
SELECT Books.Title
FROM Books
JOIN Authors ON Books.AuthorID = Authors.AuthorID
WHERE Authors.LastName = 'Caragiale' AND Authors.FirstName = 'Ion Luca';

-- Selectăm numărul total de cărți din bibliotecă
SELECT COUNT(BookID) AS TotalBooks FROM Books;

-- Afișăm toate cărțile împreună cu numele autorilor lor
SELECT Books.Title, Authors.LastName, Authors.FirstName
FROM Books
JOIN Authors ON Books.AuthorID = Authors.AuthorID;

-- Afișăm toate cărțile împreună cu statusul lor (Disponibil/Împrumutat)
SELECT Title, Status FROM Books;

-- Afișăm cititorii care au împrumutat cărți, împreună cu titlurile cărților respective
SELECT Readers.LastName, Readers.FirstName, Books.Title
FROM Readers
JOIN BookLoans ON Readers.ReaderID = BookLoans.ReaderID
JOIN Books ON BookLoans.BookID = Books.BookID;

-- Afișăm cititorii care au împrumutat cărți de poezie
SELECT Readers.LastName, Readers.FirstName
FROM Readers
JOIN BookLoans ON Readers.ReaderID = BookLoans.ReaderID
JOIN Books ON BookLoans.BookID = Books.BookID
WHERE Books.Genre = 'Poetry';

-- Afișăm toate cărțile și genurile lor, folosind tabela Genres
SELECT Books.Title, Genres.GenreName
FROM Books
JOIN Genres ON Books.GenreID = Genres.GenreID;

-- Selectăm toți autorii care au mai mult de două cărți în bibliotecă
SELECT Authors.LastName, Authors.FirstName, COUNT(Books.BookID) AS NumberOfBooks
FROM Authors
JOIN Books ON Authors.AuthorID = Books.AuthorID
GROUP BY Authors.AuthorID
HAVING COUNT(Books.BookID) > 2;

-- Selectăm cititorii care au împrumutat o carte și nu au returnat-o încă
SELECT Readers.LastName, Readers.FirstName, Books.Title AS BorrowedBook
FROM Readers
JOIN BookLoans ON Readers.ReaderID = BookLoans.ReaderID
JOIN Books ON BookLoans.BookID = Books.BookID
WHERE BookLoans.ReturnDate IS NULL;

```

## Conclusions
This project has allowed me to apply the SQL concepts learned in the Software Testing course practically. I have gained hands-on experience with creating database structures, manipulating data, and writing queries to retrieve specific information. One of the key takeaways is the importance of data integrity and the role of foreign keys in maintaining relationships between tables. The project enhanced my understanding of how databases operate and how to effectively manage data using SQL.
