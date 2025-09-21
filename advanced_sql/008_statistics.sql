-- Statistics are updated?
SELECT 
    SCHEMA_NAME(t.schema_id) schema_name,
    t.name table_name,
    s.name statistic_name,
    sp.last_updated,
    DATEDIFF(day, sp.last_updated, GETDATE()) last_update_day,
    sp.rows,
    sp.modification_counter modifications_since_last_update
FROM sys.stats s
JOIN sys.tables t
ON s.object_id = t.object_id
CROSS APPLY sys.dm_db_stats_properties(s.object_id, s.stats_id) sp
ORDER BY
sp.modification_counter DESC;

UPDATE STATISTICS Sales.DBCustomers _WA_Sys_00000005_03F0984C

-- update all statistics
EXEC sp_updatestats

-- When to execute:
-- Weekly update statistics
-- After migrating Data