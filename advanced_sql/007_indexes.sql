-- INDEX
-- Quick access to data, optimizing the speed of your queries
-- Structure (clustered index, non-clustered index), 
-- Storage (Row store index, column store index),
-- Functions (unique index, filtered index)
-- SQL Stores data in pages that have an offset for easy access, fixed size of 8kb
-- Heap table without clustered index (without order(quickly)) fast write, low read

-- Clustered index: b-tree -> hierarchical structure:
-- Root node (index page id 1 1:300, id 1 1:200, id 11 1:201),
-- Intermediate nodes (index page 1:200, id 1 1:100, id 6 1:101)(index page 1:201, id 11 1:102, id 16 1:103), 
-- Leaf level - Base Data page (data page 1:100, 1-5)(data page 1:101, 6-10)(data page 1:102, 11-15)(data page 1:103, 16-20)

-- Non-Clustered index: organize without changing the order in the file (1 extra layer)
-- RID ((1:150-header):(96-row)) -> one pointer for each id
-- Base Data page, one pointer for id (leaf node), index page(intermediate nodes), index page(root node)

--Syntax: CREATE [CLUSTERED | NONCLUSTURED] INDEX index_name ON table_name (column1, column2)

-- SELECT *
-- INTO Sales.DBCustomers
-- FROM Sales.Customers

CREATE CLUSTERED INDEX idx_DBCustomers_CustomerID
ON Sales.DBCustomers (CustomerID)

DROP INDEX idx_DBCustomers_CustomerID ON Sales.DBCustomers

-- I Search a lot for the last name so i will create a new non clustered index for that
CREATE NONCLUSTERED INDEX idx_DBCustomers_LastName
ON Sales.DBCustomers (LastName)
-- default nonclustered
CREATE INDEX idx_DBCustomers_FirstName
ON Sales.DBCustomers (FirstName)

SELECT *
FROM Sales.DBCustomers
WHERE LastName = 'Brown'

-- Composite Index

SELECT *
FROM Sales.DBCustomers
WHERE Country = 'USA' AND Score > 500

CREATE INDEX idx_DBCustomers_CountryScore
ON Sales.DBCustomers (Country, Score)

-- Rowstore index and columnstore index, rowstore -> normal data page, columnstore -> 1 column per data page
-- Columnstore works differently, first segment in columns, compress (rows becomes 1-2-3) than store in a LOB LARGE OBJECT dictionary, segmented by column

-- ColumnStore index syntax
DROP INDEX idx_DBCustomers_CustomerID ON Sales.DBCustomers

CREATE CLUSTERED COLUMNSTORE INDEX idx_DBCustomers_CS ON Sales.DBCustomers

CREATE NONCLUSTERED COLUMNSTORE INDEX idx_DBCustomers_CS_FirstName ON Sales.DBCustomers (FirstName)

-- unique index, fast to read slow to write
CREATE UNIQUE NONCLUSTERED INDEX idx_Products_Product
On Sales.Products (Product)

-- filtered index -> only rows with specific conditions
CREATE NONCLUSTERED INDEX idx_Customers_Country
ON Sales.Customers (Country)
WHERE Country = 'USA'

-- list all index
sp_helpindex 'Sales.DBCustomers'

-- monitor index usage metadata
-- data from possible drop indexes (no use), saving store and improving write performance
SELECT 
    tbl.name table_name,
    idx.name index_name, 
    idx.type_desc index_type, 
    idx.is_primary_key, 
    idx.is_unique, 
    idx.is_disabled,
    s.user_seeks,
    s.user_scans,
    s.user_lookups,
    s.user_updates,
    COALESCE(s.last_user_seek, s.last_user_scan) last_update
FROM sys.indexes idx
JOIN sys.tables tbl
ON idx.object_id = tbl.object_id
LEFT JOIN sys.dm_db_index_usage_stats s
ON s.object_id = idx.object_id
AND s.index_id = idx.index_id
ORDER BY tbl.name, idx.name

SELECT * FROM Sales.Products
WHERE Product = 'Caps'

