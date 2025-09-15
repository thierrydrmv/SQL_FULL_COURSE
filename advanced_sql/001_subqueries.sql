-- SUBQUERIES
-- A query inside another query
-- Dependency: non-correlated subquery and correlated subquery
-- Result types: Scalar Subquery, Row Subquery, Table Subquery
-- Location/Clauses: SELECT, FROM, JOIN, WHERE=COMPARISON OPERATORS(<,>,=,!=, >=, <=), LOGICAL OPERATORS(IN, ANY, ALL, EXISTS)

-- RESULT TYPES:
-- SCALAR SUBQUERY returns only 1 value
SELECT 
    AVG(Sales)
FROM Sales.Orders

-- ROW SUBQUERY returns multiples row with only one column
SELECT
    CustomerID
FROM Sales.Orders

-- TABLE SUBQUERY return multiples rows and multiples columns
SELECT
    OrderID,
    OrderDate
FROM Sales.Orders

-- Subquery inside the FROM clause
-- SELECT column1, column2, ... (SELECT column FROM table1 WHERE condition) AS alias
-- Main Query
SELECT 
*
FROM
    -- Subquery
    (SELECT 
    ProductID, 
    Price, 
    AVG(Price) OVER () avg_price 
    FROM Sales.Products)t
WHERE Price > avg_price


-- Subquery inside the SELECT clause, only works in a scalar subquery (one value)
-- Main Query
SELECT 
    ProductID, 
    Product, 
    Price,
    -- Subquery
    (SELECT COUNT(*) total_orders FROM Sales.Orders) total_orders
FROM Sales.Products

-- Subquery inside the JOIN clause
-- Main Query
SELECT 
    c.*,
    o.TotalOrders 
FROM Sales.Customers c
LEFT JOIN (
    SELECT
    CustomerID,
    COUNT(*) TotalOrders
    FROM Sales.Orders
    GROUP BY CustomerID) o 
ON c.CustomerID = o.CustomerID

-- Subquery inside the WHERE clause, used to complex filtering logic and makes more flexible and dynamic
-- Comparison operators (only scalar (single value))
SELECT OrderID, ProductID, CustomerID, SalesPersonID, Sales FROM Sales.Orders
WHERE Sales > (SELECT AVG(Sales) FROM Sales.Orders)

-- Logical operators
-- IN -> checks if the value matches any value from a list
SELECT
*
FROM Sales.Orders
WHERE CustomerID IN 
                (SELECT
                CustomerID
                FROM Sales.Customers
                WHERE Country = 'Germany')

-- ANY -> Value matchs any value within a list (column > ALL or ANY (list))
SELECT 
* 
FROM Sales.Employees
WHERE Gender = 'F' AND Salary > ANY(SELECT Salary FROM Sales.Employees WHERE Gender = 'M')

-- ALL -> Value matchs every value within a list
SELECT 
* 
FROM Sales.Employees
WHERE Gender = 'F' AND Salary > ALL(SELECT Salary FROM Sales.Employees WHERE Gender = 'M')

-- non-correlated subquery
-- execute only once end return everything for the main query

-- Dependency correlated subquery (bad performance)
-- (main query verify every if every row in the subquery returns something, if don't it'll not apear in the final result)
SELECT
*,
-- it is executed in every row
(SELECT COUNT(*) FROM Sales.Orders o WHERE o.CustomerID = c.CustomerID) total_sales
FROM Sales.Customers c

-- EXISTS -> verify if the subquery returns any row
SELECT
*
FROM Sales.Orders o
WHERE EXISTS (SELECT 1
              FROM Sales.Customers c 
              WHERE Country = 'Germany' 
              AND o.CustomerID = c.CustomerID)