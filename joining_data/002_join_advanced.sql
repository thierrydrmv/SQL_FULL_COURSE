--ADVANCED

--FULL ANTI JOIN (A) AB (B)
SELECT * FROM customers AS c
FULL JOIN orders AS o
ON o.customer_id = c.id
WHERE c.id IS NULL 
OR o.customer_id IS NULL
--using LEFT JOIN
SELECT * FROM customers AS c
LEFT JOIN orders AS o
ON o.customer_id = c.id
WHERE o.customer_id IS NOT NULL

--LEFT ANTI JOIN (A A)B B
--A ROWS that has no match in B
SELECT * FROM customers AS c
LEFT JOIN orders AS o
ON c.id = o.customer_id
WHERE o.customer_id IS NULL

--RIGHT ANTI JOIN A A(B B)
--B ROWS that has no match in A
-- SELECT * FROM customers AS c
-- RIGHT JOIN orders AS o
-- ON c.id = o.customer_id
-- WHERE c.id IS NULL
-- USING LEFT JOIN
SELECT * FROM orders AS o
LEFT JOIN customers AS c
ON o.customer_id = c.id
WHERE c.id IS NULL

--CROSS JOIN (A?B)
--All possible combinations - Cartersian JOIN -
SELECT * FROM orders
CROSS JOIN customers

