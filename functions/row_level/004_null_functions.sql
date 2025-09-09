-- NULL Functions 
-- COALESCE. 
-- NULLIF Replace with null, 
-- True or false IS NULL, IS NOT NULL?

-- ISNULL() -> replace null with a specific value (faster than coalesce)
-- SELECT ISNULL(ShipAddress, BillAddress) FROM Sales.Orders

-- COALESCE(Value1, value2, value3) returns the first not null of the list
-- SELECT COALESCE(ShipAddress, BillAddress, 'N/a') FROM Sales.Orders
-- The NULL value is ignored in agreggation, with avg can have a really wrong value if you system needs that null becomes zero

SELECT 
    CustomerID, 
    Score, 
    COALESCE(Score, 0) Score2, 
    AVG(Score) OVER () AvgScores, 
    AVG(COALESCE(Score, 0)) OVER () AvgScores2  
FROM Sales.Customers

-- NULL + 5 = null
-- 0 + 5 = 5

-- NULL + 'b' = null
-- '' + 'b' = 'b'

SELECT 
    CustomerID,
    TRIM(COALESCE(FirstName, '') + ' ' + COALESCE(LastName, '')) full_name,
    COALESCE(Score, 0) + 10 score_with_bonus
FROM Sales.Customers

-- Handle de null before doing joins, SQL don't compare nulls and you will lose records
-- you can replace as a empty string in join and will bring every data and still maintain the null value
-- NULL comes first in the ORDER BY
-- Putting the NULL at the end of the query:
SELECT
    CustomerID, 
    Score
FROM Sales.Customers
ORDER BY CASE WHEN Score IS NULL THEN 1 ELSE 0 END, Score

-- NULLIF() -> compares two expressions and return null if they are equal and the first value if not equal
-- Preventing the division by 0
SELECT 
    OrderID,
    Sales,
    Quantity,
    Sales / NULLIF(Quantity, 0) AS Price
FROM Sales.Orders

-- IS NULL and IS NOT NULL -> verify if it is and return True Or False
SELECT * FROM Sales.Orders
WHERE BillAddress IS NULL

SELECT * FROM Sales.Orders
WHERE BillAddress IS NOT NULL

-- IS NULL IN ANTI JOINS
-- Customers that have not placed any orders
SELECT c.*, o.OrderID FROM Sales.Customers c
LEFT JOIN Sales.Orders o
ON c.CustomerID = o.CustomerID
WHERE o.OrderID IS NULL

-- Empty => blank space '  ' vs NULL => don't have any value vs Empty String => string value with zero characters
-- DATALENGTH(value) => bring the len directly

-- DATA POLICIES (set rules with the users or product managers) 
-- 1. only nulls? 
-- 2. nulls and empty string? trim it(saving in data warehouse)? 
-- 3. use unknown(before reporting)?
-- Handle bad data, cleaning and bring standards