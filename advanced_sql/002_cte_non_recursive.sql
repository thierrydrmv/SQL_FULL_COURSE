-- Common Table Expressions
-- Temporary, named result set(virtual table in the cache(fast))
-- Like subquery but can be used more than one time in the main query
-- It's perfect to reduce redundancy and complexity(introducing modularity). Divide and conquer.
-- It's like DRY but the scope is the main query
-- Types of cte -> Non-recursive cte -> (executed only once without any repetition) and recursive cte -> (self-refering query that repeatedly process data
-- until a specific condition is met)
-- Non-recursive -> Standalone CTE and Nested CTE
-- Standalone CTE: Defined and Used independently
WITH CTE_Total_Sales AS
(
SELECT 
    CustomerID, 
    SUM(Sales) AS total_sales 
FROM Sales.Orders 
GROUP BY CustomerID
),
-- Mutiples Standalone CTEs
CTE_Last_Order AS
(
    SELECT
        CustomerID,
        MAX(OrderDate) last_order_date
    FROM Sales.Orders
    GROUP BY CustomerID
),
-- Nested CTE
-- A nested CTE uses the result of another CTE, so it can't run independently
-- Main Query
CTE_Customer_Rank AS
(
    SELECT 
    CustomerID,
    total_sales,
    RANK() OVER (ORDER BY total_sales DESC) AS customer_rank
    FROM CTE_Total_Sales
),
CTE_Customer_Segments AS
(
    SELECT
    CustomerID,
    CASE WHEN total_sales > 100 THEN 'High'
         WHEN total_sales > 50 THEN 'Medium'
         ELSE 'Low'
    END customer_segments
    FROM CTE_Total_Sales
)
SELECT 
    c.CustomerID,
    c.FirstName,
    c.LastName,
    cts.total_sales,
    clo.last_order_date,
    ccr.customer_rank,
    ccs.customer_segments
FROM Sales.Customers c
LEFT JOIN CTE_Total_Sales cts
ON cts.CustomerID = c.CustomerID
LEFT JOIN CTE_Last_Order clo
ON clo.CustomerID = c.CustomerID
LEFT JOIN CTE_Customer_Rank ccr
ON ccr.CustomerID = c.CustomerID
LEFT JOIN CTE_Customer_Segments ccs
ON ccs.CustomerID = c.CustomerID
-- Think if may sense to create new CTE or refactor an older one, not over 5 ctes in one query