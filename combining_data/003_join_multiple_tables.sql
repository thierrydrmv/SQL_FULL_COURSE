SELECT 
    o.OrderID, 
    o.Sales, 
    c.FirstName AS customer_first_name, 
    c.LastName AS customer_last_name, 
    p.Product AS product_name, 
    p.Price, 
    e.FirstName AS seller_first_name,
    e.LastName AS seller_last_name 
FROM Sales.Orders o
LEFT JOIN Sales.Customers c
ON o.CustomerID = c.CustomerID
LEFT JOIN Sales.Products p
ON o.ProductID = p.ProductID
LEFT JOIN Sales.Employees e
ON o.SalesPersonID = e.EmployeeID

