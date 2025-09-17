-- All Data
-- Column-Security
-- Row-Security

-- Provide a view for EU Sales Team, without data related to USA
if OBJECT_ID('Sales.V_Order_Details_EU', 'V') IS NOT NULL
    DROP VIEW Sales.V_Order_Details_EU;
GO
CREATE VIEW Sales.V_Order_Details_EU AS (
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
    WHERE c.Country != 'USA'
)

SELECT * FROM Sales.V_Order_Details_EU

-- View are useful for flexibility too
-- If you change the table you can just change the interceptor(view) than it wont impact the user

-- You can change the columns for the user (other languages)

-- Virtual Data Marts in Warehouse System
-- A data mart is a subset of a data warehouse that is focused on a specific business area, department, or function.