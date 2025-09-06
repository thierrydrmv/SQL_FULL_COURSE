-- Returns all rows that are in both tables
SELECT FirstName, LastName FROM Sales.Customers
INTERSECT
SELECT FirstName, LastName FROM Sales.Employees