-- Triggers fires stored procedures in response to a specific event

-- DML Triggers(INSERT, UPDATE, DELETE), DDL Triggers(CREATE, ALTER, DROP) AND loggon triggers
-- DML Triggers: After or instead of
-- TRIGGER Syntax
-- CREATE TRIGGER TriggerName ON TableName
-- AFTER INSERT, UPDATE, DELETE
-- BEGIN
-- -- SQL STATEMENTS
-- END

CREATE TABLE Sales.EmployeeLogs(
    LogID INT IDENTITY(1, 1) PRIMARY KEY,
    EmployeeID INT,
    LogMessage VARCHAR(255),
    LogDate DATE
)

CREATE TRIGGER trg_AfterInsertEmployee ON Sales.Employees
AFTER INSERT
AS
BEGIN
    INSERT Sales.EmployeeLogs(EmployeeID, LogMessage, LogDate)
    SELECT
        EmployeeID,
        'New Employee Added = ' + CAST(EmployeeID AS VARCHAR),
        GETDATE()
    FROM INSERTED
END

SELECT * FROM Sales.EmployeeLogs

INSERT INTO Sales.Employees
VALUES
(6, 'Maria', 'Doe', 'HR', '1988-01-12', 'F', 80000, 3)

SELECT * FROM Sales.EmployeeLogs