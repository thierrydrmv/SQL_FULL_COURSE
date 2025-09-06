--return all distric rows from both queries
--remove duplicates
SELECT CustomerID AS id, FirstName AS first_name, LastName AS last_name FROM Sales.Customers
UNION
SELECT EmployeeID, FirstName, LastName FROM Sales.Employees