-- ============================================================
-- Business Reporting Queries - AlphaCoreDB
-- CV bullet: "Wrote and ran SQL queries to retrieve, validate
--             and correct business data; prepared data extracts
--             and Excel reports for management"
-- ============================================================

USE AlphaCoreDB;
GO

-- ============================================================
-- REPORT 1: Monthly Sales Revenue
-- "Which month generated the most revenue?"
-- ============================================================
SELECT
    FORMAT(o.OrderDate, 'yyyy-MM')        AS Month,
    COUNT(DISTINCT o.OrderID)             AS TotalOrders,
    SUM(oi.Quantity * oi.UnitPrice)       AS Revenue
FROM Orders o
JOIN OrderItems oi ON o.OrderID = oi.OrderID
WHERE o.Status <> 'Cancelled'
GROUP BY FORMAT(o.OrderDate, 'yyyy-MM')
ORDER BY Month;
GO

-- ============================================================
-- REPORT 2: Top Customers by Revenue
-- "Which customers spent the most?"
-- ============================================================
SELECT TOP 5
    c.CompanyName,
    c.Country,
    COUNT(DISTINCT o.OrderID)             AS Orders,
    SUM(oi.Quantity * oi.UnitPrice)       AS TotalSpent
FROM Customers c
JOIN Orders o   ON c.CustomerID = o.CustomerID
JOIN OrderItems oi ON o.OrderID = oi.OrderID
WHERE o.Status <> 'Cancelled'
GROUP BY c.CompanyName, c.Country
ORDER BY TotalSpent DESC;
GO

-- ============================================================
-- REPORT 3: Sales Performance by Employee
-- "Which salesperson is performing best?"
-- ============================================================
SELECT
    e.FirstName + ' ' + e.LastName        AS Employee,
    d.DepartmentName,
    COUNT(DISTINCT o.OrderID)             AS OrdersClosed,
    SUM(oi.Quantity * oi.UnitPrice)       AS TotalRevenue,
    AVG(oi.Quantity * oi.UnitPrice)       AS AvgOrderValue
FROM Employees e
JOIN Departments d ON e.DepartmentID = d.DepartmentID
JOIN Orders o      ON e.EmployeeID   = o.EmployeeID
JOIN OrderItems oi ON o.OrderID      = oi.OrderID
WHERE o.Status = 'Shipped'
GROUP BY e.FirstName, e.LastName, d.DepartmentName
ORDER BY TotalRevenue DESC;
GO

-- ============================================================
-- REPORT 4: Pending Orders (Operational View)
-- "Which orders have not shipped yet?"
-- ============================================================
SELECT
    o.OrderID,
    c.CompanyName                         AS Customer,
    c.Country,
    o.OrderDate,
    DATEDIFF(day, o.OrderDate, GETDATE()) AS DaysWaiting,
    SUM(oi.Quantity * oi.UnitPrice)       AS OrderValue
FROM Orders o
JOIN Customers  c  ON o.CustomerID = c.CustomerID
JOIN OrderItems oi ON o.OrderID    = oi.OrderID
WHERE o.Status = 'Pending'
GROUP BY o.OrderID, c.CompanyName, c.Country, o.OrderDate
ORDER BY DaysWaiting DESC;
GO

-- ============================================================
-- REPORT 5: Product Sales Breakdown
-- "Which products sell most?"
-- ============================================================
SELECT
    p.ProductName,
    p.Category,
    SUM(oi.Quantity)                      AS UnitsSold,
    SUM(oi.Quantity * oi.UnitPrice)       AS Revenue,
    p.StockQuantity                       AS CurrentStock
FROM Products p
LEFT JOIN OrderItems oi ON p.ProductID = oi.ProductID
LEFT JOIN Orders o      ON oi.OrderID  = o.OrderID AND o.Status <> 'Cancelled'
GROUP BY p.ProductName, p.Category, p.StockQuantity
ORDER BY Revenue DESC;
GO

-- ============================================================
-- REPORT 6: Department Headcount & Salary Summary
-- "Salary budget per department"
-- ============================================================
SELECT
    d.DepartmentName,
    COUNT(e.EmployeeID)                   AS HeadCount,
    MIN(e.Salary)                         AS MinSalary,
    MAX(e.Salary)                         AS MaxSalary,
    AVG(e.Salary)                         AS AvgSalary,
    SUM(e.Salary)                         AS TotalSalaryBudget
FROM Departments d
LEFT JOIN Employees e ON d.DepartmentID = e.DepartmentID AND e.IsActive = 1
GROUP BY d.DepartmentName
ORDER BY TotalSalaryBudget DESC;
GO
