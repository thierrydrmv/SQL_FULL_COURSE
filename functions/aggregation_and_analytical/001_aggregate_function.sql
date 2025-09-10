-- Aggregate functions
SELECT 
    COUNT(*) number_of_products, 
    SUM(Price) total_price, 
    AVG(Price) average_price, 
    MAX(Price) max_price, 
    MIN(Price) min_price
FROM Sales.Products

SELECT 
    SalesPersonID,
    COUNT(*) number_of_orders, 
    SUM(Sales) total_sales, 
    AVG(Sales) average_sales, 
    MAX(Sales) max_sales, 
    MIN(Sales) min_sales
FROM Sales.Orders
GROUP BY SalesPersonID
