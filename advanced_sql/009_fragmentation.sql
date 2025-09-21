-- Fragmentation
-- Unused spaces in data pages
-- Data pages are out of order

-- Reorganize -> defragment leaf notes to keep them sorted, light operation

-- Rebuild -> recreates index from scratch, heavy operation

-- Is it necessary? system metadata

SELECT 
    tbl.name table_name,
    idx.name index_name,
    s.avg_fragmentation_in_percent,
    s.page_count
FROM sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, 'LIMITED') s
    INNER JOIN sys.tables tbl
    ON s.object_id = tbl.object_id
    INNER JOIN sys.indexes idx
    ON idx.object_id = s.object_id
    AND idx.index_id = s.index_id
ORDER BY s.avg_fragmentation_in_percent DESC

-- if avg_fragmentation_in_percent is <= 10% No action needed
-- if 10% < avg_fragmentation_in_percent <= 30% Reorganize
ALTER INDEX idx_Products_Product ON Sales.Products REORGANIZE
-- if avg_fragmentation_in_percent is > 30% Rebuild
ALTER INDEX idx_Products_Product ON Sales.Products REBUILD
