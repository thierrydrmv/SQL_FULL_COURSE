-- TYPES
-- DATE TIME(date)  TIMESTAMP or DATE TIME 2(datetime2)
-- 2025-08-20       18:55:45     2025-08-20 18:55:45
-- Origin
SELECT 
    OrderID, 
    CreationTime FromColumn,
    '2222-22-22' HardCoded,
    GETDATE() Today
FROM Sales.Orders

-- Part extraction, Format, Calculations, Validations
-- Part extractions (DAY, MONTH, YEAR, DATEPART(numbers)), DATENAME(string), DATETRUNC(reset the rest of the date)(datetime), EOMONTH(date)
-- Format & Casting (FORMAT, CONVERT, CAST)
-- Calculations (DATEADD, DATEDIFF)
-- Validation (ISDATE)

-- PART EXTRACTION

SELECT OrderID, CreationTime, DAY(CreationTime) day, MONTH(CreationTime) month, YEAR(CreationTime) year FROM Sales.Orders

SELECT 
    OrderID, 
    CreationTime, 
    DATEPART(WEEK, CreationTime) week,
    DATEPART(HOUR, CreationTime) hour, 
    DATEPART(MINUTE, CreationTime) minute, 
    DATEPART(SECOND, CreationTime) second, 
    DATEPART(QUARTER, CreationTime) quarter,
    DATEPART(WEEKDAY, CreationTime) weekday
FROM Sales.Orders

SELECT 
    OrderID, 
    CreationTime, 
    DATENAME(WEEKDAY, CreationTime) weekday, 
    DATENAME(MONTH, CreationTime) month
FROM Sales.Orders

-- DATETRUNC(part, date) SQL SERVER 2022+ 

SELECT 
    OrderID, 
    CreationTime, 
    DATETRUNC(SECOND, CreationTime) seconds, 
    DATETRUNC(MINUTE, CreationTime) minute, 
    DATETRUNC(HOUR, CreationTime) hour,
    DATETRUNC(DAY, CreationTime) day,
    DATETRUNC(MONTH, CreationTime) month,
    DATETRUNC(YEAR, CreationTime) year
FROM Sales.Orders

-- Filtering by month
SELECT 
    DATETRUNC(MONTH, CreationTime),
    COUNT(*) total_orders_by_month
FROM Sales.Orders
GROUP BY DATETRUNC(MONTH, CreationTime)

-- EOMONTH -> last day of the month
SELECT EOMONTH('2025-01-12') -- output 2025-01-31

SELECT CreationTime, EOMONTH(CreationTime) AS last_day_of_the_month FROM Sales.Orders

SELECT CreationTime, CAST(DATETRUNC(MONTH, CreationTime) AS DATE) AS first_day_of_the_month FROM Sales.Orders

-- DATA AGREGGATIONS AND REPORTING
-- Orders by year
SELECT YEAR(OrderDate), COUNT(*) FROM Sales.Orders
GROUP BY YEAR(OrderDate)

-- Orders by month
SELECT DATENAME(MONTH, OrderDate), COUNT(*) FROM Sales.Orders
GROUP BY DATENAME(MONTH, OrderDate)

-- DATA FILTERING only orders from february
SELECT OrderDate FROM Sales.Orders
WHERE MONTH(OrderDate) = 2

--Formatting Format, convert -> changing how the values lookslike
SELECT 
    OrderID, 
    CreationTime, 
    FORMAT(CreationTime, 'dd-MM-yyyy') BRA_Format,
    FORMAT(CreationTime, 'mm-dd-yyyy') USA_Format,
    FORMAT(CreationTime, 'dd') dd, 
    FORMAT(CreationTime, 'ddd') ddd,
    FORMAT(CreationTime, 'dddd') dddd,  
    FORMAT(CreationTime, 'MM') MM, 
    FORMAT(CreationTime, 'MMM') MMM,
    FORMAT(CreationTime, 'MMMM') MMMM
FROM Sales.Orders

-- Custom format: Day Wed Jan Q1 2025 12:34:56 pm
SELECT
    OrderID,
    CreationTime,
    'Day ' + FORMAT(CreationTime, 'ddd MMM') +
    ' Q' + DATENAME(quarter, CreationTime) + 
    ' ' + FORMAT(CreationTime, 'yyyy hh:mm:ss tt') AS CustomFormat
From Sales.Orders

-- Cast, Convert -> Casting change the datatype
SELECT
    FORMAT(OrderDate, 'MMMM yy') AS month,
    COUNT(*) qty
FROM Sales.Orders
GROUP BY FORMAT(OrderDate, 'MMMM yy')

-- Standarize format ex: csv 20/08/25, api 20.08.2025, database 20 Aug 2025 => 2025-08-25
-- Use Format
-- Convert(data_type, value [,style])
SELECT 
    CONVERT(INT, '123'),
    CONVERT(DATE, '2025-07-20'),
    CONVERT(DATE, CreationTime),
    -- USA STYLE
    CONVERT(VARCHAR, CreationTime, 32),
    -- EU STYLE
    CONVERT(VARCHAR, CreationTime, 34),
    CreationTime
FROM Sales.Orders

-- CAST(value AS data_type)
SELECT 
    CAST('123' AS INT),
    CAST(123 AS VARCHAR),
    CAST('2025-07-20' AS DATE),
    CAST('2025-07-20' AS DATETIME2),
    CAST(CreationTime AS DATE)
    CreationTime
FROM Sales.Orders

/*
Casting change the data fundamental type,
Formating change the display type
                CASTING           |      FORMATING
CAST    | Any Type to Any Type    |    No formating
----------------------------------------------------------------
CONVERT | Any Type to Any Type    |  Formates only Date & Time
----------------------------------------------------------------
FORMAT  | Any Type to Only String |  Formates -> Date & Time
                                              -> Numbers  
*/

-- Calculations DATEADD DATEDIFF

SELECT 
    ShipDate, 
    DATEADD(year, 1, ShipDate) AS free_maintenance,
    DATEADD(month, -3, ShipDate) AS production_date,
    DATEADD(day, 7, ShipDate) AS received_at,
    DATEDIFF(day, DATEADD(month, -3, ShipDate), DATEADD(day, 7, ShipDate)) AS production_to_deliver
FROM Sales.Orders

SELECT 
    FirstName, 
    BirthDate, 
    DATEDIFF(day, BirthDate, GETDATE()) AS days_lived, 
    DATEDIFF(year, BirthDate, GETDATE()) AS age 
FROM Sales.Employees

SELECT 
    DATENAME(month, OrderDate), 
    AVG(DATEDIFF(day, OrderDate, ShipDate)) AS avg_shipping_duration
FROM Sales.Orders
GROUP BY DATENAME(month, OrderDate)

SELECT 
    OrderID, 
    OrderDate current_order_date, 
    -- get the previous record in the table using LAG
    LAG(OrderDate) OVER (ORDER BY OrderDate) previous_order_date,
    DATEDIFF(day, LAG(OrderDate) OVER (ORDER BY OrderDate), OrderDate) number_of_days
FROM Sales.Orders

-- Validation - only identifies if it follows the standard format
SELECT 
    OrderID, 
    ISDATE(CAST(OrderDate AS VARCHAR)),
    ISDATE('123')
FROM Sales.Orders

-- Useful for checking if the value is correct in a huge query
SELECT 
    --CAST(OrderDate AS DATE) OrderDate,
    OrderDate,
    ISDATE(OrderDate),
    CASE WHEN ISDATE(OrderDate) = 1 THEN CAST(OrderDate AS DATE)
    END new_order_date
FROM 
(
    SELECT '2025-08-20' AS OrderDate UNION
    SELECT '2025-08-21' UNION
    SELECT '2025-08-23' UNION
    SELECT '2025-08'
)t

SELECT 
    --CAST(OrderDate AS DATE) OrderDate,
    OrderDate,
    ISDATE(OrderDate),
    CASE WHEN ISDATE(OrderDate) = 1 THEN CAST(OrderDate AS DATE)
    END new_order_date
FROM 
(
    SELECT '2025-08-20' AS OrderDate UNION
    SELECT '2025-08-21' UNION
    SELECT '2025-08-23' UNION
    SELECT '2025-08'
)t
WHERE ISDATE(OrderDate) = 0