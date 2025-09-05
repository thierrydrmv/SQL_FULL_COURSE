UPDATE customers
SET score = 0
WHERE id = 6

UPDATE customers
SET score = 0,
    country = 'UK'
WHERE id = 10

UPDATE customers
SET score = 0
WHERE score IS NULL

UPDATE customers
SET country = 'Unknown'
WHERE country is NULL
