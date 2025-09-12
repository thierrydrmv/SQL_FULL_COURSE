-- Ranking Window Functions, can be integer-based(discrete values) or percentage-based(continuous values)
-- Expression empty, ORDER BY required, PARTITION BY is optional

-- Integer-bases ranking: ROW_NUMBER(), RANK(), DENSE_RANK(), NTILE(n)
-- Percentage-based ranking: CUME_DIST(), PERCENT_RANK()

-- Same value don't share the same ranking
SELECT
    OrderID,
    ProductID,
    ROW_NUMBER() OVER(ORDER BY Sales DESC) sales_rank_row,
    Sales
FROM Sales.Orders

-- Same value share the same ranking 1-2-2-4-5-6
SELECT
    OrderID,
    ProductID,
    RANK() OVER(ORDER BY Sales DESC) sales_rank_rank,
    Sales
FROM Sales.Orders

-- DENSE_RANK() -- Same value share the same ranking but without gaps 1-2-2-3-4-5

SELECT
    OrderID,
    ProductID,
    DENSE_RANK() OVER(ORDER BY Sales DESC) sales_dense_rank_row,
    Sales
FROM Sales.Orders

-- Find the top highest sales for each product
SELECT *
FROM(
    SELECT
        OrderID,
        ProductID,
        Sales,
        ROW_NUMBER() OVER (PARTITION BY ProductID ORDER BY Sales DESC) rank_by_highest_sale
    FROM Sales.Orders
)t WHERE rank_by_highest_sale = 1

-- Find the lowest 2 customers based on their total sales

SELECT TOP 2
    CustomerID, 
    SUM(Sales) total_sales,
    ROW_NUMBER() OVER (ORDER BY SUM(Sales)) rank_customers
FROM Sales.Orders
GROUP BY 
CustomerID

-- Assign unique IDS to the rows
SELECT 
    ROW_NUMBER() OVER (ORDER BY OrderID, OrderDate) UniqueID,
    *
FROM Sales.OrdersArchive

-- Identify duplicates and remove them

SELECT *
FROM(
    SELECT 
        ROW_NUMBER() OVER (PARTITION BY OrderID ORDER BY CreationTime DESC) rank_orders,
        *
    FROM Sales.OrdersArchive
)t WHERE rank_orders = 1

-- ROW_NUMBER use cases:
-- 1 TOP-N Analysis
-- 2 Bottom-N Analysis
-- 3 Assign unique IDs
-- 4 Quality Checks: Identify Duplicates

-- NTILE() Divide a specific bucket of rows, order by required
-- NTILE(2) OVER (ORDER BY Sales DESC) Larger groups come first

SELECT
    OrderID,
    Sales,
    NTILE(4) OVER (ORDER BY Sales DESC) four_bucket,
    NTILE(3) OVER (ORDER BY Sales DESC) three_bucket,
    NTILE(2) OVER (ORDER BY Sales DESC) two_bucket,
    NTILE(1) OVER (ORDER BY Sales DESC) one_bucket
FROM Sales.Orders

-- Categorize: high, medium an low sales

SELECT 
*,
CASE WHEN buckets = 1 THEN 'HIGH'
    WHEN buckets = 2 THEN 'MEDIUM'
    WHEN buckets = 3 THEN 'LOW'
END sales_segmentations
FROM(
    SELECT
        OrderID,
        Sales,
        NTILE(3) OVER (ORDER BY Sales DESC) buckets
    FROM Sales.Orders
)t

-- full load, send all data for another database, ntile() to divide in some buckets before sending and after you can union on the other database
SELECT
    NTILE(4) OVER (ORDER BY OrderID) buckets,
    *
FROM Sales.Orders

-- CUME_DIST (cumulative distribution) position nr/number of rows, same value shares same position but the result is the last
-- PERCENT_RANK same value shares same position, position nr - 1/ number of rows - 1

-- Find the products with the highest 40% of the prices
SELECT
*,
CONCAT(rank * 100, '%') cume_disc_percentage
FROM(
    SELECT
        Product,
        Price,
        CUME_DIST() OVER (ORDER BY Product DESC) rank
    FROM Sales.Products
)t
WHERE rank <= 0.4

SELECT
*,
CONCAT(rank * 100, '%') cume_disc_percentage
FROM(
    SELECT
        Product,
        Price,
        PERCENT_RANK() OVER (ORDER BY Product DESC) rank
    FROM Sales.Products
)t
WHERE rank <= 0.4