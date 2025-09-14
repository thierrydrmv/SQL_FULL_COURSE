-- Challenges of a system without subqueries, cte, views, temp tables or ctas
-- Redundancy, performance issues, complexity, hard to maintain, db stress, security

-- Terms:
-- Database Engine:
-- It is the brain of the database, executing multiple operations such as storing,
-- retrieving, and managing data within the database.
-- Storage: Disk and Cache

-- Disk Storage: long term memory, where data is stored permanently
-- can hold a large amout of data
-- slow to write and read
-- 3 types of storages: user, catalog and temp

-- User Data Storage: main content of the database,
-- is where the actual data that users care about is stored.

-- System catalog: blueprint that keeps track of everything about the database itself,
-- it holds the metadata (Data about Data) information about the database.
-- Information Schema: is the system defined with built-in views that provide info about the database, like tables and columns.
SELECT 
DISTINCT TABLE_NAME
FROM INFORMATION_SCHEMA.COLUMNS

-- Temp Data Storage: temporary space used by the database for short-term tasks, like processing queries or sorting data,
-- once these tasks are done, the storage is cleared. - tempdb

-- Cache Storage: fast short-term memory, where data is stored temporarily
-- extremely fast to read and write
-- stored for a short period of time