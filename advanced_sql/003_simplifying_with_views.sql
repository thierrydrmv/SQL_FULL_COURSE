-- View with details from orders, products, customers and employees
if OBJECT_ID('Sales.V_Order_Details', 'V') IS NOT NULL
    DROP VIEW Sales.V_Order_Details;
GO
CREATE VIEW Sales.V_Order_Details AS (
    SELECT 
    o.OrderID,
    o.OrderDate,
    p.Product,
    p.Category,
    COALESCE(TRIM(c.FirstName), '') + ' ' + COALESCE(TRIM(c.LastName), '') customer_name,
    c.Country customer_country,
    COALESCE(TRIM(e.FirstName), '') + ' ' + COALESCE(TRIM(e.LastName), '') seller_name,
    e.Department,
    o.Sales,
    o.Quantity
    FROM Sales.Orders o
    LEFT JOIN Sales.Products p
    ON p.ProductID = o.ProductID
    LEFT JOIN Sales.Customers c
    ON c.CustomerID = o.CustomerID
    LEFT JOIN Sales.Employees e
    ON e.EmployeeID = o.SalesPersonID
)

-- SELECT * FROM Sales.V_Order_Details