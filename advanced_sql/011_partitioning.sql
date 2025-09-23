-- SQL PARTITIONING
-- Divides big table into smaller partitions (usually date)
-- Allows parallel processing

-- 1. Partition function:
-- Logic on how to divide your data based on Partition Key Like (Column, Region, Date ..) Bounderies

CREATE PARTITION FUNCTION partition_by_year (DATE)
AS RANGE LEFT FOR VALUES('2023-12-31', '2024-12-31', '2025-12-31')

SELECT
    name,
    function_id,
    type,
    type_desc,
    boundary_value_on_right
FROM sys.partition_functions

-- 2. File groups -> like 4 folders
-- Logical container to help organize partitions

ALTER DATABASE SalesDB ADD FILEGROUP FG_2023;
ALTER DATABASE SalesDB ADD FILEGROUP FG_2024;
ALTER DATABASE SalesDB ADD FILEGROUP FG_2025;
ALTER DATABASE SalesDB ADD FILEGROUP FG_2026;

-- Syntax drop: ALTER DATABASE SalesDB REMOVE FILEGROUP FG_2023;
SELECT 
*
FROM sys.filegroups
WHERE type = 'FG'

-- 3. Data files: .ndf -> fisical files where the data is stored

ALTER DATABASE SalesDB ADD FILE
(
    NAME = p_2023, -- Logical Name
    FILENAME = '/var/opt/mssql/data/p_2023.ndf'
) TO FILEGROUP FG_2023

ALTER DATABASE SalesDB ADD FILE
(
    NAME = p_2024, -- Logical Name
    FILENAME = '/var/opt/mssql/data/p_2024.ndf'
) TO FILEGROUP FG_2024

ALTER DATABASE SalesDB ADD FILE
(
    NAME = p_2025, -- Logical Name
    FILENAME = '/var/opt/mssql/data/p_2025.ndf'
) TO FILEGROUP FG_2025

ALTER DATABASE SalesDB ADD FILE
(
    NAME = p_2026, -- Logical Name
    FILENAME = '/var/opt/mssql/data/p_2026.ndf'
) TO FILEGROUP FG_2026

-- Check metadata
SELECT
    fg.name file_group_name,
    mf.name logical_file_name,
    mf.physical_name physical_file_path,
    mf.size / 128 size_in_mb
FROM 
    sys.filegroups fg
JOIN 
    sys.master_files mf ON fg.data_space_id = mf.data_space_id
WHERE
    mf.database_id = DB_ID('SalesDB')

-- 4. Partition schema: connection between partition function to file groups

CREATE PARTITION SCHEME scheme_partition_by_year
AS PARTITION partition_by_year
TO (FG_2023, FG_2024, FG_2025, FG_2026)

SELECT
    ps.name partition_scheme_name,
    pf.name partition_function_name,
    ds.destination_id partition_number,
    fg.name file_group_name
FROM sys.partition_schemes ps
JOIN sys.partition_functions pf ON ps.function_id = pf.function_id
JOIN sys.destination_data_spaces ds ON ps.data_space_id = ds.partition_scheme_id
JOIN sys.filegroups fg ON ds.data_space_id = fg.data_space_id

-- 5 Create partition Table

CREATE TABLE Sales.orders_partitioned
(
    OrderID INT,
    OrderDate DATE,
    Sales INT
) ON scheme_partition_by_year (OrderDate)

-- 6 Insert data into the partitioned table

INSERT INTO Sales.orders_partitioned VALUES (1, '2023-05-15', 111);
INSERT INTO Sales.orders_partitioned VALUES (2, '2024-01-12', 32);
-- Verify bounderies (date)
INSERT INTO Sales.orders_partitioned VALUES (3, '2025-12-31', 331);
INSERT INTO Sales.orders_partitioned VALUES (4, '2026-11-30', 1);

SELECT * FROM Sales.orders_partitioned

-- 7 Search the row

SELECT
    p.partition_number,
    f.name partition_file_group,
    p.rows number_of_rows
FROM sys.partitions p
JOIN sys.destination_data_spaces dds ON p.partition_number = dds.destination_id
JOIN sys.filegroups f ON dds.data_space_id = f.data_space_id
WHERE OBJECT_NAME(p.object_id) = 'orders_partitioned';

-- Table -> partition scheme -> partition function, file groups -> data files