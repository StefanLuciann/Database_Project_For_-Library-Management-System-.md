# Database Project for "Library Management System"

## Scope of the Project
The scope of this project is to use all the SQL knowledge gained throughout the Software Testing course and apply them in practice.

**Application under test:** Library Management System

**Tools used:** MySQL Workbench

## Database Description
Baza de date "Library Management System" a fost creată pentru a gestiona informațiile despre cărți, autori, cititori și împrumuturi. Aceasta permite stocarea și gestionarea eficientă a informațiilor relevante, precum titlurile cărților, datele de împrumut și informațiile personale ale cititorilor. Scopul este de a facilita accesul rapid și ușor la informații și de a urmări împrumuturile efectuate.

## Database Schema
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

-- Create Authors Table
CREATE TABLE Authors (
    AuthorID INT AUTO_INCREMENT PRIMARY KEY,
    LastName VARCHAR(50),
    FirstName VARCHAR(50),
    BirthDate DATE
);

-- Create Books Table
CREATE TABLE Books (
    BookID INT AUTO_INCREMENT PRIMARY KEY,
    Title VARCHAR(100),
    PublicationYear YEAR,
    Genre VARCHAR(50),
    AuthorID INT,
    FOREIGN KEY (AuthorID) REFERENCES Authors(AuthorID)
);

-- Create Readers Table
CREATE TABLE Readers (
    ReaderID INT AUTO_INCREMENT PRIMARY KEY,
    LastName VARCHAR(50),
    FirstName VARCHAR(50),
    Email VARCHAR(100),
    PhoneNumber VARCHAR(15)
);

-- Create Loans Table
CREATE TABLE Loans (
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
ALTER TABLE Books ADD COLUMN Status VARCHAR(20) DEFAULT 'Available';
ALTER TABLE Readers MODIFY COLUMN PhoneNumber VARCHAR(20);
ALTER TABLE Loans RENAME TO BookLoans;
ALTER TABLE Books MODIFY COLUMN PublicationYear INT;
```

## DML (Data Manipulation Language)
In order to be able to use the database, I populated the tables with various data necessary to perform queries and manipulate the data.

Below you can find all the insert instructions that were created in the scope of this project:

```sql
INSERT INTO Authors (LastName, FirstName, BirthDate) VALUES
('Rebreanu', 'Liviu', '1885-11-27'),
('Caragiale', 'Ion Luca', '1852-01-30'),
('Creanga', 'Ion', '1837-03-01');

INSERT INTO Books (Title, PublicationYear, Genre, AuthorID) VALUES
('Ion', 1920, 'Novel', 1),
('A Lost Letter', 1884, 'Play', 2),
('Childhood Memories', 1892, 'Autobiography', 3);

INSERT INTO Readers (LastName, FirstName, Email, PhoneNumber) VALUES
('Marin', 'Andrei', 'andrei.marin@example.com', '0730123456'),
('Dumitrescu', 'Maria', 'maria.dumitrescu@example.com', '0745123456');
```
After the insert, in order to prepare the data to be better suited for the testing process, I updated some data in the following way:

```sql
UPDATE Books SET Status = 'Checked Out' WHERE Title = 'Ion';
UPDATE Readers SET PhoneNumber = '0750123456' WHERE LastName = 'Marin';
```

After the testing process, I deleted the data that was no longer relevant in order to preserve the database clean:

```sql
DELETE FROM BookLoans WHERE LoanDate < '2023-01-01';
DELETE FROM Books WHERE Title = 'A Lost Letter';
```

### DQL (Data Query Language)
In order to simulate various scenarios that might happen in real life, I created the following queries that would cover multiple potential real-life situations:
```sql
SELECT * FROM Books WHERE AuthorID = 1;  -- Retrieve all books by Liviu Rebreanu
SELECT * FROM Readers WHERE LastName LIKE 'M%';  -- Retrieve all readers with last name starting with 'M'
SELECT b.Title, r.LastName 
FROM Books b 
LEFT JOIN BookLoans bl ON b.BookID = bl.BookID 
LEFT JOIN Readers r ON bl.ReaderID = r.ReaderID;  -- Retrieve all books and their readers (if any)
SELECT COUNT(*) FROM BookLoans GROUP BY ReaderID HAVING COUNT(*) > 1;  -- Count of loans per reader
```

## Conclusions
This project has allowed me to apply the SQL concepts learned in the Software Testing course practically. I have gained hands-on experience with creating database structures, manipulating data, and writing queries to retrieve specific information. One of the key takeaways is the importance of data integrity and the role of foreign keys in maintaining relationships between tables. The project enhanced my understanding of how databases operate and how to effectively manage data using SQL.
