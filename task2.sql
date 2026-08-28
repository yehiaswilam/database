/*
=========================================================
TASK 1
Movie Database ERD + SQL DDL + SQL DML
SQL Server / T-SQL
=========================================================
*/

---------------------------------------------------------
-- PART 1: CREATE DATABASE
---------------------------------------------------------

CREATE DATABASE MovieDB;
GO

USE MovieDB;
GO


---------------------------------------------------------
-- PART 2: CREATE TABLES ACCORDING TO THE ERD
---------------------------------------------------------

-- 1. actor
CREATE TABLE actor (
    act_id INT PRIMARY KEY,
    act_fname CHAR(20),
    act_lname CHAR(20),
    act_gender CHAR(1)
);
GO


-- 2. director
CREATE TABLE director (
    dir_id INT PRIMARY KEY,
    dir_fname CHAR(20),
    dir_lname CHAR(20)
);
GO


-- 3. movie
CREATE TABLE movie (
    mov_id INT PRIMARY KEY,
    mov_title CHAR(50),
    mov_year INT,
    mov_time INT,
    mov_lang CHAR(50),
    mov_dt_rel DATE,
    mov_rel_country CHAR(5)
);
GO


-- 4. genres
CREATE TABLE genres (
    gen_id INT PRIMARY KEY,
    gen_title CHAR(20)
);
GO


-- 5. reviewer
CREATE TABLE reviewer (
    rev_id INT PRIMARY KEY,
    rev_name CHAR(30)
);
GO


-- 6. movie_cast
-- actor 1 : many movie_cast
-- movie 1 : many movie_cast
CREATE TABLE movie_cast (
    act_id INT,
    mov_id INT,
    role CHAR(30),

    CONSTRAINT FK_movie_cast_actor
        FOREIGN KEY (act_id) REFERENCES actor(act_id),

    CONSTRAINT FK_movie_cast_movie
        FOREIGN KEY (mov_id) REFERENCES movie(mov_id)
);
GO


-- 7. movie_direction
-- director 1 : many movie_direction
-- movie 1 : many movie_direction
CREATE TABLE movie_direction (
    dir_id INT,
    mov_id INT,

    CONSTRAINT FK_movie_direction_director
        FOREIGN KEY (dir_id) REFERENCES director(dir_id),

    CONSTRAINT FK_movie_direction_movie
        FOREIGN KEY (mov_id) REFERENCES movie(mov_id)
);
GO


-- 8. movie_genres
-- movie 1 : many movie_genres
-- genres 1 : many movie_genres
CREATE TABLE movie_genres (
    mov_id INT,
    gen_id INT,

    CONSTRAINT FK_movie_genres_movie
        FOREIGN KEY (mov_id) REFERENCES movie(mov_id),

    CONSTRAINT FK_movie_genres_genres
        FOREIGN KEY (gen_id) REFERENCES genres(gen_id)
);
GO


-- 9. rating
-- movie 1 : many rating
-- reviewer 1 : many rating
CREATE TABLE rating (
    mov_id INT,
    rev_id INT,
    rev_stars INT,
    num_o_ratings INT,

    CONSTRAINT FK_rating_movie
        FOREIGN KEY (mov_id) REFERENCES movie(mov_id),

    CONSTRAINT FK_rating_reviewer
        FOREIGN KEY (rev_id) REFERENCES reviewer(rev_id)
);
GO


---------------------------------------------------------
-- PART 3: DATA DEFINITION QUESTIONS
-- Questions 32 - 47
---------------------------------------------------------

-- Q32. Create Employees table
CREATE TABLE Employees (
    ID INT,
    Name VARCHAR(100),
    Salary DECIMAL(10,2)
);
GO


-- Q33. Add Department column
ALTER TABLE Employees
ADD Department VARCHAR(50);
GO


-- Q34. Remove Salary column
ALTER TABLE Employees
DROP COLUMN Salary;
GO


-- Q35. Rename Department to DeptName
EXEC sp_rename
    'Employees.Department',
    'DeptName',
    'COLUMN';
GO


-- Q36. Create Projects table
CREATE TABLE Projects (
    ProjectID INT,
    ProjectName VARCHAR(100)
);
GO


-- Q37. Add primary key to Employees.ID
ALTER TABLE Employees
ADD CONSTRAINT PK_Employees
PRIMARY KEY (ID);
GO


-- Q38. Create foreign key:
-- Employees.ID -> Projects.ProjectID
--
-- SQL Server requires the referenced column to be
-- PRIMARY KEY or UNIQUE, so ProjectID is made UNIQUE
-- to allow the requested foreign key.
ALTER TABLE Projects
ADD CONSTRAINT UQ_Projects_ProjectID
UNIQUE (ProjectID);
GO

ALTER TABLE Employees
ADD CONSTRAINT FK_Employees_Projects
FOREIGN KEY (ID)
REFERENCES Projects(ProjectID);
GO


-- Q39. Remove the foreign key relationship
ALTER TABLE Employees
DROP CONSTRAINT FK_Employees_Projects;
GO


-- Q40. Add unique constraint to Employees.Name
ALTER TABLE Employees
ADD CONSTRAINT UQ_Employees_Name
UNIQUE (Name);
GO


-- Q41. Create Customers table
CREATE TABLE Customers (
    CustomerID INT,
    FirstName VARCHAR(100),
    LastName VARCHAR(100),
    Email VARCHAR(255),
    Status VARCHAR(50)
);
GO


-- Q42. Unique constraint on FirstName + LastName
ALTER TABLE Customers
ADD CONSTRAINT UQ_Customers_FirstName_LastName
UNIQUE (FirstName, LastName);
GO


-- Q43. Default value 'Active' for Status
ALTER TABLE Customers
ADD CONSTRAINT DF_Customers_Status
DEFAULT 'Active' FOR Status;
GO


-- Q44. Create Orders table
CREATE TABLE Orders (
    OrderID INT,
    CustomerID INT,
    OrderDate DATETIME,
    TotalAmount DECIMAL(10,2)
);
GO


-- Q45. Check constraint: TotalAmount > 0
ALTER TABLE Orders
ADD CONSTRAINT CK_Orders_TotalAmount
CHECK (TotalAmount > 0);
GO


-- Q46. Create Sales schema
CREATE SCHEMA Sales;
GO


-- Move Orders table into Sales schema
ALTER SCHEMA Sales
TRANSFER dbo.Orders;
GO


-- Q47. Rename Orders to SalesOrders
EXEC sp_rename
    'Sales.Orders',
    'SalesOrders';
GO


---------------------------------------------------------
-- IMPORTANT NOTE ABOUT THE TASK
--
-- Q34 removes Salary from Employees.
-- The DML questions later use Salary again.
-- To allow the complete Task 1 file to execute from
-- beginning to end, Salary is added back before DML.
---------------------------------------------------------

ALTER TABLE Employees
ADD Salary DECIMAL(10,2);
GO


---------------------------------------------------------
-- PART 4: DATA MANIPULATION QUESTIONS
-- Questions 55 - 67
---------------------------------------------------------

-- Q55. Select all columns from Employees
SELECT *
FROM Employees;
GO


-- Q56. Select Name and Salary
SELECT Name, Salary
FROM Employees;
GO


-- Q57. Select distinct DeptName
SELECT DISTINCT DeptName
FROM Employees;
GO


-- Q58. Select top 5 records
SELECT TOP 5 *
FROM Employees;
GO


-- Q59. Select all records ordered by Salary descending
SELECT *
FROM Employees
ORDER BY Salary DESC;
GO


-- Q60. Select first 10 records starting from the third record
SELECT *
FROM Employees
ORDER BY ID
OFFSET 2 ROWS
FETCH NEXT 10 ROWS ONLY;
GO


-- Q61. Select average salary
SELECT AVG(Salary) AS AverageSalary
FROM Employees;
GO


-- Q62. Select maximum and minimum salaries
SELECT
    MAX(Salary) AS MaximumSalary,
    MIN(Salary) AS MinimumSalary
FROM Employees;
GO


-- Q63. Select top 3 highest salaries
SELECT TOP 3 *
FROM Employees
ORDER BY Salary DESC;
GO


-- Q64. Select all records ordered by Name ascending
SELECT *
FROM Employees
ORDER BY Name ASC;
GO


-- Q65. Select first 5 records starting from the second record,
-- ordered by Salary descending
SELECT *
FROM Employees
ORDER BY Salary DESC
OFFSET 1 ROWS
FETCH NEXT 5 ROWS ONLY;
GO


-- Q66. Select sum of all salaries
SELECT SUM(Salary) AS TotalSalary
FROM Employees;
GO


-- Q67. Select records where Salary is between 40000 and 60000,
-- ordered by Salary ascending
SELECT *
FROM Employees
WHERE Salary BETWEEN 40000 AND 60000
ORDER BY Salary ASC;
GO
