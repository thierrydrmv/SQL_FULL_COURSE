--performatic, don't remove duplicates
SELECT FirstName, LastName FROM Sales.Customers
UNION ALL
SELECT FirstName, LastName FROM Sales.Employees
ORDER BY FirstName