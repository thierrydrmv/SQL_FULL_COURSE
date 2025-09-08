-- Manipulation:
-- CONCAT, UPPER, LOWER, TRIM, REPLACE
-- Calculation:
-- LEN
-- String Extraction:
-- LEFT, RIGHT, SUBSTRING

-- Manipulation
SELECT CONCAT(first_name, ' ', Country) AS full_country 
FROM customers;

SELECT UPPER(first_name) 
FROM customers;

SELECT LOWER(first_name) 
FROM customers;

SELECT first_name
FROM customers
WHERE first_name != TRIM(first_name);

SELECT 
    order_id, 
    customer_id, 
    REPLACE(order_date, '-', '/'), 
    sales 
FROM orders

-- Calculation
SELECT first_name, LEN(first_name) AS len_name from customers

-- String Extraction:
SELECT first_name, LEFT(first_name, 2) FROM customers

SELECT first_name, RIGHT(first_name, 2) FROM customers

-- SUBSTRING(expression, position, size) using len you can get the rest
SELECT first_name, SUBSTRING(TRIM(first_name), 2, LEN(first_name)) FROM customers