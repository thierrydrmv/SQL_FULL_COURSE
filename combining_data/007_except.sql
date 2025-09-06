-- Returns all distinct rows from the first query that are not found in the second query
-- identify the new data before inserting in the data warehouse
-- quality and repetition
-- Return all customers that are not employees
SELECT FirstName, LastName FROM Sales.Customers
EXCEPT
SELECT FirstName, LastName FROM Sales.Employees