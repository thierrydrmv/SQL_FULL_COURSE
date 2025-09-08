-- ROUND 2 (2 decimal places) .5 or more round up
SELECT 3.516,
        ROUND(3.516, 2) AS round_2,
        ROUND(3.516, 1) AS round_1,
        ROUND(3.516, 0) AS round_0

-- ABSOLUTE (convert negative to positive)

SELECT -10, ABS(-10), ABS(10)