-- Select a value from other row: 
-- LEAD(expr, offset, default), LAG(expr, offset, default), FIRST_VALUE(expr), LAST_VALUE(expr) 
-- ORDER BY ALWAYS REQUIRED, offset number of rows forward or backward default = 1

-- LEAD(Sales) OVER (ORDER BY Month) -> Access a value from the next row within a window
-- LEAD(Sales, 2, 0) OVER (ORDER BY Month) -> 2 months foward and if don't find(NULL) bring 0
-- LAG(Sales) OVER (ORDER BY Month) -> Access a value from the previous row within a window

-- Analyze the month-over-month (MOM) and compare
SELECT 
*,
CurrentMonthSales - PreviousMonthSales AS MoM_change,
ROUND(CAST((CurrentMonthSales - PreviousMonthSales) AS FLOAT)/PreviousMonthSales * 100, 1) AS mom_percentage
FROM(
    SELECT
        MONTH(OrderDate) OrderMonth,
        SUM(Sales) CurrentMonthSales,
        LAG(SUM(Sales)) OVER (ORDER BY MONTH(OrderDate)) PreviousMonthSales
    FROM Sales.Orders
    GROUP BY
        MONTH(OrderDate)
)t

-- RANK of customers based on the average days between their orders
SELECT
    CustomerID,
    AVG(days_to_next_order) average_days,
    RANK() OVER (ORDER BY COALESCE(AVG(days_to_next_order), 9999)) rank_average
FROM (
    SELECT
        OrderID,
        CustomerID,
        OrderDate current_order,
        LEAD(OrderDate) OVER (PARTITION BY CustomerID ORDER BY OrderDate) next_order,
        DATEDIFF(day, OrderDate, LEAD(OrderDate) OVER (PARTITION BY CustomerID ORDER BY OrderDate)) days_to_next_order
    FROM Sales.Orders
)t
GROUP BY CustomerID

-- FIRST_VALUE() access a value from the first row within a window
-- FIRST_VALUE(Sales) OVER (ORDER BY Month)

-- LAST_VALUE() access a value from the last row within a window
-- LAST_VALUE(Sales) OVER (ORDER BY Month
-- ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING)

-- Find the lowest and highest sales for each product
SELECT
    OrderID,
    ProductID,
    Sales,
    FIRST_VALUE(Sales) OVER (PARTITION BY ProductID ORDER BY Sales) lowest_sales,
    LAST_VALUE(Sales) OVER (PARTITION BY ProductID ORDER BY Sales
    ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) highest_sales,
    Sales - FIRST_VALUE(Sales) OVER (PARTITION BY ProductID ORDER BY Sales) sales_diference
    -- FIRST_VALUE(Sales) OVER (PARTITION BY ProductID ORDER BY Sales DESC) highest_sales_using_first_value,
    -- MIN(Sales) OVER (PARTITION BY ProductID ) lowest_sales_using_min,
    -- MAX(Sales) OVER (PARTITION BY ProductID ) highest_sales_using_max
FROM Sales.Orders
