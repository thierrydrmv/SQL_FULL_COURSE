DELETE FROM customers
WHERE id > 5

/* 
    TRUNCATE is faster 
    minimally log, 
    not rollable back
    record only the deallocation of data pages
*/
TRUNCATE TABLE persons
