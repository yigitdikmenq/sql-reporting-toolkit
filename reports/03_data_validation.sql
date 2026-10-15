-- ============================================================
-- Data Validation & Correction Queries - AlphaCoreDB
-- CV bullet: "Wrote SQL queries to validate and correct
--             business data; investigated data inconsistencies"
-- ============================================================

USE AlphaCoreDB;
GO

-- ============================================================
-- CHECK 1: Orders shipped before order date (data error)
-- ============================================================
SELECT
    o.OrderID,
    c.CompanyName,
    o.OrderDate,
    o.ShipDate,
    DATEDIFF(day, o.OrderDate, o.ShipDate) AS DaysToShip
FROM Orders o
JOIN Customers c ON o.CustomerID = c.CustomerID
WHERE o.ShipDate < o.OrderDate;  -- Should be zero rows
GO

-- ============================================================
-- CHECK 2: Employees without a department (orphaned records)
-- ============================================================
SELECT EmployeeID, FirstName, LastName, Email
FROM Employees
WHERE DepartmentID IS NULL;
GO

-- ============================================================
-- CHECK 3: Duplicate email addresses in Customers
-- ============================================================
SELECT Email, COUNT(*) AS Occurrences
FROM Customers
GROUP BY Email
HAVING COUNT(*) > 1;
GO

-- ============================================================
-- CHECK 4: Orders with no items (empty orders)
-- ============================================================
SELECT o.OrderID, o.OrderDate, o.Status
FROM Orders o
LEFT JOIN OrderItems oi ON o.OrderID = oi.OrderID
WHERE oi.OrderItemID IS NULL;
GO

-- ============================================================
-- CHECK 5: Products with negative or zero price
-- ============================================================
SELECT ProductID, ProductName, UnitPrice
FROM Products
WHERE UnitPrice <= 0;
GO

-- ============================================================
-- CHECK 6: Unresolved critical errors older than 24 hours
-- (would be sent as alert to management)
-- ============================================================
SELECT
    ErrorID,
    Application,
    ErrorMessage,
    Severity,
    ErrorTime,
    DATEDIFF(hour, ErrorTime, GETDATE()) AS HoursOpen
FROM AppErrors
WHERE IsResolved = 0
  AND Severity IN ('Critical', 'High')
ORDER BY ErrorTime ASC;
GO

-- ============================================================
-- CORRECTION: Mark a resolved error (example update)
-- CV bullet: "correct business data"
-- ============================================================
-- Uncomment and run when resolving an error:
/*
UPDATE AppErrors
SET    IsResolved  = 1,
       ResolvedBy  = 'Yigit Dikmen',
       ResolvedTime = GETDATE()
WHERE  ErrorID = 7;  -- 'VAT calculation rounding error'
*/
GO
