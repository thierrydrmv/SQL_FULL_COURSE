--IN verify if exists in a list
SELECT * FROM customers
WHERE country IN ('Germany', 'USA')

--NOT IN verify if not exists in a list
SELECT * FROM customers
WHERE country NOT IN ('Germany', 'USA')