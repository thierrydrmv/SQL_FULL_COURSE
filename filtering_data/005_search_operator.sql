--LIKE % accepts any quantity, _ exact 1

SELECT * FROM customers
WHERE country LIKE 'U%'

SELECT * FROM customers
WHERE country LIKE 'U_'

SELECT * FROM customers
WHERE first_name LIKE '%r%'

SELECT * FROM customers
Where first_name LIKE '__r%'
