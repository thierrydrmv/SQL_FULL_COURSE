-- Views: is a virtual table that shows data without storing it physically, abstraction layer
-- Table are hard to maintain, fast response and you can Read/Write
-- Views are easy to change and maintain but are slower because it executes 2 queries one in the
-- table and another in the view, only Readable
-- VIEW vs CTE
-- CTE reduces redundancy in 1 query, no maintence -auto cleanup-
-- VIEW reduces redundancy in multiples queries, persist logic, need to mantain CREATE/DROP
-- VIEW SYNTAX
-- CREATE VIEW VIEW-NAME AS (query)
if OBJECT_ID('Sales.V_Monthly_Summary', 'V') IS NOT NULL
    DROP VIEW Sales.V_Monthly_Summary;
GO
CREATE VIEW Sales.V_Monthly_Summary AS (
    SELECT 
        DATENAME(month, OrderDate) order_month,
        SUM(Sales) total_sales,
        COUNT(OrderID) total_orders,
        SUM(Quantity) total_quantities
    FROM Sales.Orders
    GROUP BY DATENAME(month, OrderDate), MONTH(OrderDate)
)

SELECT
    order_month,
    total_sales,
    SUM(total_sales) OVER (ORDER BY order_month) AS running_total
FROM Sales.V_Monthly_Summary
