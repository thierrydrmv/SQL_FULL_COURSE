-- CTAS -> Create Table As SELECT, Create table with the result of a query, structure and data.
-- its faster than views but the data will be the data of the time that ctas is created, static data
-- Syntax
-- Refresh everyday

IF OBJECT_ID('Sales.MonthlyOrders', 'U') IS NOT NULL
    DROP TABLE Sales.MonthlyOrders
GO
SELECT
    DATENAME(month, OrderDate) order_month,
    COUNT(OrderID) total_orders
INTO Sales.MonthlyOrders
FROM Sales.Orders
GROUP BY DATENAME(month, OrderDate)

SELECT * FROM Sales.MonthlyOrders

-- Snapshot to analyse without worrying of losing data

-- Physical Data Marts -> performance for reports of the data warehouse

-- Temporary tables -> intermediate results in temporary storage, drop automatic when you end the session
-- Syntax
SELECT
*
INTO #Orders
FROM Sales.Orders

