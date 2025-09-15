-- -- Looping 1 to 10 using recursive query
-- WITH series AS (
--     SELECT 
--     1 
--     AS number
--     UNION ALL
--     -- Recursive Query
--     SELECT
--     number + 1
--     FROM series
--     WHERE number < 10
-- )
-- SELECT *
-- FROM series
-- OPTION (MAXRECURSION 9)

WITH CTE_Emp_Hierarchy AS
(
    -- Anchor query
    SELECT 
        EmployeeID,
        FirstName,
        ManagerID,
        1 AS Level
    FROM Sales.Employees
    WHERE ManagerID IS NULL
    UNION ALL
    -- Recursive Query
    SELECT
        e.EmployeeID,
        e.FirstName,
        e.ManagerID,
        Level + 1
    FROM Sales.Employees e
    INNER JOIN CTE_Emp_Hierarchy ceh
    ON e.ManagerID = ceh.EmployeeID
)
-- Main Query
SELECT * FROM CTE_Emp_Hierarchy