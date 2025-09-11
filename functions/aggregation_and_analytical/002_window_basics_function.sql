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
SELECT
    OrderID,
    OrderDate,
    OrderStatus,
    Sales,
    SUM(Sales) OVER (PARTITION BY OrderStatus ORDER BY OrderDate
    -- ROWS BETWEEN CURRENT ROW AND 2 FOLLOWING) TotalSales -- -> frame will go down calculating
    ROWS 2 PRECEDING) TotalSales
FROM Sales.Orders

-- COMPACT FRAME
-- NORMAL FORM: ROWS BETWEEN CURRENT ROW AND 2 FOLLOWING
-- SHORT FORM: ROWS 2 FOLLOWING

-- RULES:
-- 1.Window functions can be used only in select and order by clauses
-- 2.Nested window functions are not allowed
-- 3.Use Window Functions after the WHERE clause

SELECT
    OrderID,
    OrderDate,
    OrderStatus,
    ProductID,
    Sales,
    SUM(Sales) OVER (PARTITION BY OrderStatus) TotalSales
FROM Sales.Orders
WHERE ProductID IN (101, 102)

-- 4.Use Window Function can be used together with GROUP BY in the same query, ONLY if the same columns are used

SELECT
    CustomerID,
    SUM(Sales) TotalSales,
    RANK() OVER (ORDER BY SUM(Sales) DESC) RankCustomers
FROM Sales.Orders
GROUP BY CustomerID
