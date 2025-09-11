-- WINDOW functions/analitic functions
-- Like GROUP BY but without losing lower level data (same number of rows)
-- Result Granuality the number of the rows output is defined by the dimension
-- Row level calculations
-- Has the same agreggate functions that GROUP BY has: COUNT(expr), SUM(expr), AVG(expr), MIN(expr), MAX(expr)
-- Rank functions: ROW_NUMBER(), RANK(), DENSE_RANK(), CUME_DIST(), PERCENT_RANK(), NTILE(n) ORDER BY required
-- Value (Analytics) Functions: LEAD(expr, offset, default), LAG(expr, offset, default) FIRST_VALUE(expr) ORDER BY required
-- OVER(PARTITION BY) its like GROUP BY but with window

SELECT 
    OrderID,
    OrderDate,
    ProductID,
    OrderStatus,
    Sales,
    SUM(Sales) OVER () TotalSales,
    SUM(Sales) OVER (PARTITION BY ProductID) TotalSalesByProduct,
    SUM(Sales) OVER (PARTITION BY ProductID, OrderStatus) TotalSalesByProductAndStatus
FROM Sales.Orders

-- WINDOW Syntax            Over Clause
-- Window Function      Partition, Order, Frame
-- PARTITION BY divides the result into partitions (windows)
SELECT 
    OrderID,
    OrderDate,
    Sales,
    Rank() OVER(Order By Sales DESC) AS sales_order
FROM Sales.Orders

-- Window Frame scope for the calculation
-- Can only be used together with ORDER BY
-- Lower Value must be BEFORE the higher Value
-- ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING (framing has a lot of possibilities and is write like english read de doc)