--combine rows
--mapping correct columns
--number of rows must be the same
--data types must be compatible
--first query controls the alias
--order by is always at the end of the query
SELECT CustomerID AS id, FirstName AS first_name, LastName AS last_name FROM Sales.Customers
UNION
SELECT EmployeeID, FirstName, LastName FROM Sales.Employees
ORDER BY FirstName ASC

--combine similar information befora analyzing the data(UNION)
--write a report about all the individuals in the organization
--first union all the tables together than manipulate the data
--less chance of forgetting to change one manipulation before merging the data 
--don't use * just search for 1000 and pick the columns in the query
--add a column with de source valuable information
SELECT 
    'Orders' AS SourceTable
    ,[OrderID]
    ,[ProductID]
    ,[CustomerID]
    ,[SalesPersonID]
    ,[OrderDate]
    ,[ShipDate]
    ,[OrderStatus]
    ,[ShipAddress]
    ,[BillAddress]
    ,[Quantity]
    ,[Sales]
    ,[CreationTime] 
FROM Sales.Orders
UNION
SELECT 
    'OrdersArchive' AS SourceTable
    ,[OrderID]
    ,[ProductID]
    ,[CustomerID]
    ,[SalesPersonID]
    ,[OrderDate]
    ,[ShipDate]
    ,[OrderStatus]
    ,[ShipAddress]
    ,[BillAddress]
    ,[Quantity]
    ,[Sales]
    ,[CreationTime] 
FROM Sales.OrdersArchive
ORDER BY OrderID