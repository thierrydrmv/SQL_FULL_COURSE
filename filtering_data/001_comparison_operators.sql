-- equal
SELECT * FROM customers
WHERE country = 'USA'

-- not equal <> or !=
SELECT * FROM customers
WHERE country <> 'Germany'

-- greater
SELECT * FROM customers
WHERE score > 500

-- greater or equal
SELECT * FROM customers
WHERE score >= 500