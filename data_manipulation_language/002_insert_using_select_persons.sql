--- the columns don't have to match only the type value

INSERT INTO persons(id, person_name, birth_day, phone)
SELECT 
    id,
    first_name as person_name,
    NULL as birth_day,
    'Unknown' as phone
FROM customers

