-- 30 tips
-- Best Practices: Fetching data
-- Tip 1: Select only what you need

-- Bad Practice
SELECT * FROM Sales.Customers
-- Good Practice
SELECT CustomerID, FirstName, LastName FROM Sales.Customers

-- Tip 2: Avoid unnecessary DISTINCT & ORDER BY

-- Bad Practice
SELECT DISTINCT
    FirstName
FROM Sales.Customers
ORDER BY FirstName

-- Good Practice
SELECT
    FirstName
FROM Sales.Customers

-- Tip 3: For exploration purpose, Limit Rows

-- Bad Practice
SELECT
    OrderID,
    Sales
FROM Sales.Orders

-- Good Practice
SELECT TOP 10
    OrderID,
    Sales
FROM Sales.Orders

-- Best Practices: Filtering Data

-- Tip 4: Create nonclustered Index on frequently used Columns in WHERE clause

SELECT * FROM Sales.Orders WHERE OrderStatus = 'Delivered'

CREATE NONCLUSTERED INDEX Idx_Orders_OrderStatus ON Sales.Orders(OrderStatus)

-- Tip 5: Avoid applying functions to columns in WHERE clause
-- Functions on columns can block index usage

-- Bad Practice
SELECT * FROM Sales.Orders
WHERE LOWER(OrderStatus) = 'delivered'

-- Good Practice
SELECT * FROM Sales.Orders
WHERE OrderStatus = 'Delivered'

-- Bad Practice
SELECT *
FROM Sales.Customers
WHERE SUBSTRING(FirstName, 1, 1) = 'A'

-- Good Practice
SELECT *
FROM Sales.Customers
WHERE FirstName LIKE 'A%'

-- Bad Practice
SELECT *
FROM Sales.Orders
WHERE YEAR(OrderDate) = 2025

-- Good Practice
SELECT *
FROM Sales.Orders
WHERE OrderDate BETWEEN '2025-01-01' AND '2025-12-31'

-- Tip 6: Avoid leading wildcards as they prevent index usage

-- Bad Practice
SELECT *
FROM Sales.Customers
WHERE LastName LIKE '%Gold%'

-- Good Practice
SELECT *
FROM Sales.Customers
WHERE LastName LIKE 'Gold%'

-- Tip 7: Use IN instead of Multiple OR

-- Bad Practice
SELECT *
FROM Sales.Orders
WHERE CustomerID = 1 OR CustomerID = 2 OR CustomerID = 3

-- Good Practice
SELECT *
FROM Sales.Orders
WHERE CustomerID IN (1, 2, 3)

-- Tip 8: Understand The Speed of Joins & Use INNER JOIN when possible

-- Best Performance
SELECT c.FirstName, o.OrderID FROM Sales.Customers c INNER JOIN Sales.Orders o ON c.CustomerID = o.CustomerID

-- Slightly Slower Performance
SELECT c.FirstName, o.OrderID FROM Sales.Customers c RIGHT JOIN Sales.Orders o ON c.CustomerID = o.CustomerID
SELECT c.FirstName, o.OrderID FROM Sales.Customers c LEFT JOIN Sales.Orders o ON c.CustomerID = o.CustomerID

-- Worst Performance
SELECT c.FirstName, o.OrderID FROM Sales.Customers c OUTER JOIN Sales.Orders o ON c.CustomerID = o.CustomerID

-- Tip 9: Use Explicit Join (ANSI Join) Instead of Implicit Join (non-ANSI Join)

-- Bad Practice
SELECT c.FirstName, o.OrderID 
FROM Sales.Customers c, Sales.Orders o
WHERE c.CustomerID = o.CustomerID

-- Good Practice
SELECT c.FirstName, o.OrderID 
FROM Sales.Customers c
INNER JOIN Sales.Orders o
ON c.CustomerID = o.CustomerID

-- Tip 10: Make sure to Index the columns used in the ON Clause

SELECT c.FirstName, o.OrderID 
FROM Sales.Orders o
INNER JOIN Sales.Customers c
ON c.CustomerID = o.CustomerID

CREATE NONCLUSTERED INDEX Idx_Orders_CustomerID ON Sales.Orders(CustomerID)

-- Tip 11: Filter Before Joining (Big Tables)

-- Filter After Join (WHERE)
SELECT c.FirstName, o.OrderID 
FROM Sales.Customers c
INNER JOIN Sales.Orders o
ON c.CustomerID = o.CustomerID
WHERE o.OrderStatus = 'Delivered'

-- Filter During Join (ON)
SELECT c.FirstName, o.OrderID
FROM Sales.Customers c
INNER JOIN Sales.Orders o
ON c.CustomerID = o.CustomerID
AND o.OrderStatus = 'Delivered'

-- Filter Before Join (SUBQUERY)
-- Try to isolate the preparation step in a CTE or subquery
SELECT c.FirstName, o.OrderID
FROM Sales.Customers c
INNER JOIN (SELECT OrderID, CustomerID FROM Sales.Orders WHERE OrderStatus = 'Delivered') o
ON c.CustomerID = o.CustomerID

-- Tip 12: Aggregate Before Joining (Big Tables)

-- Best Practice For Small-Medium Tables
-- Grouping and Joining
SELECT c.CustomerID, c.FirstName, COUNT(o.OrderID) order_count
FROM Sales.Customers c 
INNER JOIN Sales.Orders o 
ON c.CustomerID = o.CustomerID 
GROUP BY c.CustomerID, c.FirstName

-- Best Practice For Big Tables
-- Pre-aggregated Subquery
SELECT c.CustomerID, c.FirstName, o.order_count
FROM Sales.Customers c 
INNER JOIN (
    SELECT CustomerID, COUNT(OrderID) order_count
    FROM Sales.Orders
    GROUP BY CustomerID
) o 
ON c.CustomerID = o.CustomerID 

-- Bad Practice
-- Correlated Subquery
SELECT
    c.CustomerID,
    c.FirstName,
    (SELECT COUNT(o.OrderID)
     FROM Sales.Orders o
     WHERE o.CustomerID = c.CustomerID) order_count
FROM Sales.Customers c

-- Tip 13: Use Union instead of OR in Joins

-- Bad Practice
SELECT o.OrderID, c.FirstName
FROM Sales.Customers c 
INNER JOIN Sales.Orders o 
ON c.CustomerID = o.CustomerID 
OR c.CustomerID = o.SalesPersonID 

-- Best Practice
SELECT o.OrderID, c.FirstName
FROM Sales.Customers c 
INNER JOIN Sales.Orders o 
ON c.CustomerID = o.CustomerID
UNION
SELECT o.OrderID, c.FirstName
FROM Sales.Customers c 
INNER JOIN Sales.Orders o 
ON c.CustomerID = o.SalesPersonID

-- Tip 14: Check for Nested Loops and use SQL HINTS when necessary

SELECT o.OrderID, c.FirstName
FROM Sales.Customers c 
INNER JOIN Sales.Orders o 
ON c.CustomerID = o.CustomerID 

-- Good Practice for Having Big Table & Small Table
SELECT o.OrderID, c.FirstName
FROM Sales.Customers c 
INNER JOIN Sales.Orders o 
ON c.CustomerID = o.CustomerID 
OPTION (HASH JOIN)

-- Tip 15: Use UNION ALL instead of using UNION | duplicates are acceptable

-- Bad Practice
SELECT CustomerID FROM Sales.Orders
UNION
SELECT CustomerID FROM Sales.OrdersArchive

-- Best Practice
SELECT CustomerID FROM Sales.Orders
UNION ALL
SELECT CustomerID FROM Sales.OrdersArchive

-- Tip 16: Use UNION ALL + DISTINCT instead of using UNION | duplicates are not acceptable

-- Bad Practice
SELECT CustomerID FROM Sales.Orders
UNION
SELECT CustomerID FROM Sales.OrdersArchive

-- Best Practice
SELECT DISTINCT CustomerID 
FROM (
    SELECT CustomerID FROM Sales.Orders
    UNION ALL
    SELECT CustomerID FROM Sales.OrdersArchive
) combined_data

-- Best Practices Aggregating data

-- Tip 17: Use Columnstore Index for Aggregations on Large Tables

SELECT CustomerID, COUNT(OrderID) order_count
FROM Sales.Orders
GROUP BY CustomerID

CREATE CLUSTERED COLUMNSTORE INDEX Idx_Orders_Columnstore ON Sales.Orders

-- Tip 18: Pre-Aggregate Data and store it in new Table for Reporting

SELECT MONTH(OrderDate) order_year, SUM(Sales) total_sales
INTO Sales.SalesSummary
FROM Sales.Orders
GROUP BY MONTH(OrderDate)

SELECT * FROM Sales.SalesSummary

-- Best Practices SUBQUERIES

-- Tip 19: JOIN vs EXISTS vs IN

-- JOIN (Best Practice: if performance equals to EXISTS)
SELECT o.OrderID, o.Sales
FROM Sales.Orders o
INNER JOIN Sales.Customers c
ON o.CustomerID = c.CustomerID
WHERE c.Country = 'USA'

-- EXISTS (Best Practice: Use it for Large Tables)
SELECT o.OrderID, o.Sales
FROM Sales.Orders o
WHERE EXISTS(
    SELECT 1
    FROM Sales.Customers c
    WHERE o.CustomerID = c.CustomerID
    AND c.Country = 'USA'
)

-- IN (Bad Practice)
SELECT o.OrderID, o.Sales
FROM Sales.Orders o
WHERE o.CustomerID IN (
    SELECT CustomerID
    FROM Sales.Customers
    WHERE Country = 'USA'
)

-- Tip 20: Avoid Redundant Logic in Your Query

-- Bad Practice
SELECT EmployeeID, FirstName, 'Above Average' Status
FROM Sales.Employees
WHERE Salary > (SELECT AVG(Salary) FROM Sales.Employees)
UNION ALL
SELECT EmployeeID, FirstName, 'Below Average' Status
FROM Sales.Employees
WHERE Salary < (SELECT AVG(Salary) FROM Sales.Employees)

-- Good Practice
SELECT
    EmployeeID,
    FirstName,
    CASE
        WHEN Salary > AVG(Salary) OVER () THEN 'Above Average'
        WHEN Salary < AVG(Salary) OVER () THEN 'Below Average'
        ELSE 'Average'
    END AS Status
FROM Sales.Employees

-- Best Practices CREATING TABLES (DDL)

-- Tip 21: Avoid Data Types VARCHAR & TEXT
-- Tip 22: Avoid (MAX) Unnecesarily large lengths in data types
-- Tip 23: Use the NOT NULL constraint where applicable
-- Tip 24: Ensure all your tables have a Clustered Primary Key

CREATE TABLE CustomersInfoBadPractice (
    CustomerID INT,
    FirstName VARCHAR(MAX),
    LastName TEXT,
    Country VARCHAR(255),
    TotalPurchases FLOAT,
    Score VARCHAR(255),
    BirthDate VARCHAR(255),
    EmployeeID INT,
    CONSTRAINT FK_CustomersInfo_EmployeeID FOREIGN KEY (EmployeeID)
        REFERENCES Sales.Employees(EmployeeID)
)

CREATE TABLE CustomersInfoGoodPractice (
    CustomerID INT PRIMARY KEY CLUSTERED,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Country VARCHAR(50) NOT NULL,
    TotalPurchases FLOAT,
    Score INT,
    BirthDate DATE,
    EmployeeID INT,
    CONSTRAINT FK_CustomersInfo_EmployeeID FOREIGN KEY (EmployeeID)
        REFERENCES Sales.Employees(EmployeeID)
)

-- Tip 25: Create a non-clustered index for foreign keys that are used frequently

CREATE NONCLUSTERED INDEX IX_CustomersInfo_EmployeeID
ON CustomersInfoGoodPractice(EmployeeID)

-- Best Practices INDEXING

-- Tip 26: Avoid Over Indexing
-- Tip 27: Drop unused Indexes
-- Tip 28: Update Statistics (Weekly)
-- Tip 29: Reorganize & Rebuild Indexes (Weekly)
-- Tip 30: Partition Large Tables (Facts) to improve performance, next, apply a Columnstore Index for the best results