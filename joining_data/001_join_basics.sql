/* Usually used to:
1- Recombine data: See the big Picture 
INNER
LEFT
RIGHT
FULL

2- Data Enrichment: Add extra Info
LEFT
RIGHT

3- Check Existence: Filter if a costumer has an order 
INNER
LEFT + WHERE
RIGHT + WHERE
FULL + WHERE
*/

--BASICS

--NO JOIN (A) AB (B)
SELECT * FROM customers;
SELECT * FROM orders;

--INNER JOIN A (AB) B
SELECT 
    c.id, 
    c.first_name, 
    o.order_id, 
    o.sales 
FROM customers AS c
    INNER JOIN orders AS o
ON c.id = o.customer_id

--FULL JOIN (A AB B)
SELECT * FROM customers AS c
    FULL JOIN orders AS o
ON c.id = o.customer_id

--LEFT JOIN (A AB) B
SELECT * FROM customers AS c
    LEFT JOIN orders AS o
ON c.id = o.customer_id

--RIGHT JOIN A (BA B)
SELECT * FROM customers AS c
    RIGHT JOIN orders AS o
ON c.id = o.customer_id
