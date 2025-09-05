-- AND
SELECT * FROM customers
WHERE country = 'USA' AND score > 500

-- OR
SELECT * FROM customers
WHERE country = 'USA' OR country = 'UK'

-- NOT
SELECT * FROM customers
WHERE NOT score < 500