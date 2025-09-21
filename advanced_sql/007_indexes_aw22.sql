USE AdventureWorks2022
-- HEAP
SELECT *
INTO Currency_HP
FROM Sales.Currency

-- RowStore
SELECT *
INTO Currency_RS
FROM Sales.Currency

CREATE CLUSTERED INDEX idx_Currency_RS_PK
ON Currency_RS (CurrencyCode)

-- ColumnStore
SELECT *
INTO Currency_CS
FROM Sales.Currency

CREATE CLUSTERED COLUMNSTORE INDEX idx_Currency_CS_PK
ON Currency_CS 