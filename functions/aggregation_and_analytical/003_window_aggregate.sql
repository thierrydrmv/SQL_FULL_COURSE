-- Using AVG AND COUNT with WINDOW
-- If is null the count ignores
SELECT 
    FirstName, 
    Country, 
    CASE WHEN Score IS NULL THEN 0 ELSE Score END AS Score,
    AVG(CASE WHEN Score IS NULL THEN 0 ELSE Score END) OVER(PARTITION by Country) avg_score_by_country,
    COUNT(Country) OVER(PARTITION BY Country) customers_by_country
FROM Sales.Customers
ORDER BY FirstName

-- Searching the average score and number of customers by country
SELECT 
    OrderID,
    CustomerID,
    COUNT(OrderStatus) OVER() total_orders, 
    COUNT(ShipAddress) OVER() total_ship_address, 
    COUNT(OrderStatus) OVER(PARTITION BY CustomerID) total_orders_by_customer, 
    OrderDate 
FROM Sales.Orders

-- Sarching duplicates
SELECT 
    OrderID,
    COUNT(*) OVER(PARTITION BY OrderID) check_pk
FROM Sales.Orders

-- Have duplicates
SELECT
*
FROM(
    SELECT 
        OrderID,
        COUNT(*) OVER(PARTITION BY OrderID) check_pk
    FROM Sales.OrdersArchive
)t WHERE check_pk > 1

-- COUNT USE CASES:
-- 1. Overall Analysis
-- 2. Category Analysis
-- 3. Quality Checks: Identify NULLs
-- 4. Quality Checks: Identify Duplicates

-- Aggregate window function SUM

SELECT 
    Product, 
    Price, 
    Category, 
    SUM(Price) OVER(PARTITION By Category) total_category_price
FROM Sales.Products

SELECT 
    OrderID,
    ProductID,
    OrderDate,
    SUM(Sales) OVER() total_sales,
    SUM(Sales) OVER(PARTITION By ProductID) sales_by_product
FROM Sales.Orders

-- Comparison use cases
SELECT 
    OrderID,
    ProductID,
    Sales, 
    SUM(Sales) OVER() total_sales,
    ROUND (CAST (Sales AS float) / SUM(Sales) OVER () * 100, 2) Percentage_of_total
FROM Sales.Orders

-- Average sales across all orders

SELECT
    OrderID,
    OrderDate,
    Sales,
    AVG(Sales) OVER () AvgSales,
    AVG(Sales) OVER (PARTITION BY ProductID) AvgSalesByProducts
FROM Sales.Orders

-- Find average scores of customers

SELECT
    CustomerID,
    LastName,
    Score,
    COALESCE(Score, 0) customer_score,
    AVG(Score) OVER () avg_score,
    AVG(COALESCE(Score, 0)) OVER () avg_score_without_nulls
FROM Sales.Customers

-- Filter all product with sales bigger than the average

SELECT
    *
FROM(
    SELECT
        OrderID,
        ProductID,
        Sales,
        AVG(Sales) OVER() avg_sales
    FROM Sales.Orders
)t WHERE Sales > avg_sales

-- Find the highest and lowest sales of all orders, products

SELECT
    OrderID,
    OrderDate,
    ProductID,
    Sales,
    MAX(Sales) OVER() highest_sales,
    MIN(Sales) OVER() lowest_sales,
    MAX(Sales) OVER(PARTITION BY ProductID) highest_sales_by_product,
    MIN(Sales) OVER(PARTITION BY ProductID) lowest_sales_by_product
FROM Sales.Orders

-- Show employee who have highest salaries

SELECT *
FROM(
    SELECT 
        *,
        MAX(Salary) OVER() highest_salary
    FROM Sales.Employees
    )t 
WHERE highest_salary = Salary

-- Find the deviation of each sales from the minimum and maximum sales amouts

SELECT
    OrderID,
    OrderDate,
    ProductID,
    Sales,
    MAX(Sales) OVER() highest_sales,
    MIN(Sales) OVER() lowest_sales,
    Sales - MIN(Sales) OVER() deviation_lowest_sales,
    MAX(Sales) OVER() - Sales deviation_highest_sales
FROM Sales.Orders

-- Running total and Rolling total 
-- Running total: Aggregate all values from the beggining up to the current point
-- without dropping off older data
-- SUM(Sales) OVER (ORDER BY month) (default is already the logic: ROWS BETWEEN UNBOUNDED PRECEDING AND CURREMT ROW)

-- Rolling Total: Aggregate all values within a fixed time window (30 days).
-- As new data is added, the oldest data point will be dropped.
-- SUM(Sales) OVER(ORDER BY MONTH 
-- ROWS BETWEEN 2 PRECEDING AND CURRENT ROW)

-- Calculate moving average of sales for each product over time AVG WITH ORDER BY
SELECT
    OrderID,
    ProductID,
    OrderDate,
    Sales,
    AVG(Sales) OVER(PARTITION BY ProductID) avg_by_product,
    AVG(Sales) OVER(PARTITION BY ProductID ORDER BY OrderDate) moving_average,
    AVG(Sales) OVER(PARTITION BY ProductID ORDER BY OrderDate ROWS BETWEEN CURRENT ROW AND 1 FOLLOWING) rolling_avg
FROM Sales.Orders