-- CASE STATEMENT
-- Evaluates a list of conditions and returns a value when the first condition is met
-- The syntax:
-- CASE 
--    WHEN condition1 THEN result1
--    WHEN condition2 THEN result2
--    ELSE result
-- END
SELECT 
    FirstName Name,
    CASE 
        WHEN Salary > 70000 THEN 'HIGH'
        WHEN Salary > 60000 THEN 'MEDIUM'
        ELSE 'LOW'
    END AS Sales,
    Salary,
    Department
FROM Sales.Employees

-- Data transformation -- Derive new informations

-- Categorizing DATA
SELECT
    report_sales,
    SUM(Sales) AS total_sales
FROM(
    SELECT 
    OrderID, 
        Sales,
        CASE
            WHEN Sales > 50 THEN 'High'
            WHEN Sales > 20 THEN 'Medium'
            ELSE 'Low'
        END AS report_sales
    FROM Sales.Orders
)t
GROUP BY report_sales
ORDER BY total_sales DESC

-- RULES the data type of the results must match
-- Mapping rules -> otimize performance 0 and 1
SELECT 
    EmployeeID,
    FirstName,
    LastName,
    Gender,
    CASE 
    WHEN Gender = 'M' THEN 'Male'
    WHEN Gender = 'F' THEN 'Female'
     ELSE 'Not avaliable' END gender_string
FROM Sales.Employees

SELECT 
    CustomerID,
    FirstName,
    LastName,
    Country,
    CASE 
    WHEN Country = 'Germany' THEN 'DE'
    WHEN Country = 'USA' THEN 'US'
    ELSE 'n/a' END country_string
FROM Sales.Customers

-- Small syntax only for equal
SELECT DISTINCT
    Country,
    CASE Country
    WHEN 'Germany' THEN 'DE'
    WHEN 'USA' THEN 'US'
    ELSE 'n/a' END country_string
FROM Sales.Customers

-- Handling NULLS
SELECT 
    CustomerID, 
    LastName,
    Score,
    CASE 
        WHEN Score IS NULL THEN 0 
        ELSE Score 
    END score_clean,
    AVG(CASE 
        WHEN Score IS NULL THEN 0 
            ELSE Score 
        END) OVER () average_score 
FROM Sales.Customers

-- Conditional Aggregation
-- count the number of sales bigger than 30 per customer
SELECT
    CustomerID,
    SUM(CASE
        WHEN Sales > 30 THEN 1
        ELSE 0 
    END) AS total_high_sales,
    COUNT(*) AS total_orders
FROM Sales.Orders
GROUP BY CustomerID