-- Stored Procedures are usual procedures that you can register in the server side and execute easily EXEC SP
-- Program, Loops, Control flow, parameters and error handling
-- Pre-compiled
-- Use python if possible (databricks, snowflake)

-- Syntax
CREATE PROCEDURE customer_USA AS
BEGIN
SELECT 
    COUNT(*) total_customers, 
    AVG(score) avg_score 
FROM Sales.Customers 
WHERE Country = 'USA'
END

EXEC customer_USA

-- DEFAULT with two queries:
CREATE PROCEDURE customer_summary @Country NVARCHAR(50) = 'USA'
AS
BEGIN
SELECT 
    @Country country,
    COUNT(*) total_customers, 
    AVG(score) avg_score 
FROM Sales.Customers 
WHERE Country = @Country;

SELECT
    @Country country,
    COUNT(OrderID) total_orders,
    SUM(OrderID) total_sales
FROM Sales.Orders o
JOIN Sales.Customers c
ON o. CustomerID = c.CustomerID
WHERE c.Country = @Country;

END

EXEC customer_summary 'Germany'
EXEC customer_summary 'USA'

-- variable

CREATE PROCEDURE get_customer_summary @Country NVARCHAR(50) = 'USA'
AS
BEGIN

DECLARE @total_customers INT, @avg_score FLOAT;

SELECT 
   @total_customers = COUNT(*),
   @avg_score = AVG(score)
FROM Sales.Customers 
WHERE Country = @Country;

PRINT 'Total Customers from '+ @Country + ':' + CAST(@total_customers AS NVARCHAR);
PRINT 'Average Customers from '+ @Country + ':' + CAST(@avg_score AS NVARCHAR);

SELECT
    @Country country,
    COUNT(OrderID) total_orders,
    SUM(OrderID) total_sales
FROM Sales.Orders o
JOIN Sales.Customers c
ON o. CustomerID = c.CustomerID
WHERE c.Country = @Country;

END

EXEC get_customer_summary
EXEC get_customer_summary @Country = 'Germany'

-- Control Flow IF ELSE

CREATE PROCEDURE get_customer_summary_cleaned @Country NVARCHAR(50) = 'USA'
AS
BEGIN
    -- Error Handling
    BEGIN TRY

        DECLARE @total_customers INT, @avg_score FLOAT;
        -- Step 1: Prepare & Cleanup Data

        IF EXISTS (SELECT 1 FROM Sales.Customers WHERE Score IS NULL AND Country = @Country)
        BEGIN
            PRINT('Updating NULL scores to 0')
            UPDATE Sales.Customers
            SET Score = 0
            WHERE Score IS NULL AND Country = @Country;
        END

        ELSE
        BEGIN
            PRINT('No NULL scores found')
        END;

        -- Step 2: Generating Reports total customers and avg score specific country
        SELECT 
            @total_customers = COUNT(*),
            @avg_score = AVG(score)
        FROM Sales.Customers 
        WHERE Country = @Country;

        PRINT 'Total Customers from '+ @Country + ':' + CAST(@total_customers AS NVARCHAR);
        PRINT 'Average Customers from '+ @Country + ':' + CAST(@avg_score AS NVARCHAR);

        SELECT
            @Country country,
            COUNT(OrderID) total_orders,
            SUM(OrderID) total_sales
        FROM Sales.Orders o
        JOIN Sales.Customers c
        ON o. CustomerID = c.CustomerID
        WHERE c.Country = @Country;

    END TRY

    BEGIN CATCH
        PRINT('An Error ocurred.')
        PRINT('Error Message: ' + ERROR_MESSAGE()); 
        PRINT('Error Number: ' + CAST(ERROR_NUMBER() AS VARCHAR)); 
        PRINT('Error Line: ' + CAST(ERROR_LINE() AS VARCHAR)); 
        PRINT('Error Procedure: ' + ERROR_PROCEDURE()); 
    END CATCH
    END
GO

EXEC get_customer_summary_cleaned
EXEC get_customer_summary_cleaned @Country = 'Germany'


