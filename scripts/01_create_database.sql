-- ============================================================
-- AlphaCore Ltd - Sample Company Database
-- SQL Server 2022 Express
-- ============================================================

USE master;
GO

IF EXISTS (SELECT name FROM sys.databases WHERE name = 'AlphaCoreDB')
BEGIN
    ALTER DATABASE AlphaCoreDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE AlphaCoreDB;
END
GO

CREATE DATABASE AlphaCoreDB;
GO

USE AlphaCoreDB;
GO

-- ============================================================
-- TABLES
-- ============================================================

CREATE TABLE Departments (
    DepartmentID   INT PRIMARY KEY IDENTITY(1,1),
    DepartmentName NVARCHAR(100) NOT NULL,
    ManagerName    NVARCHAR(100)
);

CREATE TABLE Employees (
    EmployeeID     INT PRIMARY KEY IDENTITY(1,1),
    FirstName      NVARCHAR(50)  NOT NULL,
    LastName       NVARCHAR(50)  NOT NULL,
    Email          NVARCHAR(100) UNIQUE NOT NULL,
    DepartmentID   INT REFERENCES Departments(DepartmentID),
    JobTitle       NVARCHAR(100),
    Salary         DECIMAL(10,2),
    HireDate       DATE,
    IsActive       BIT DEFAULT 1
);

CREATE TABLE Customers (
    CustomerID     INT PRIMARY KEY IDENTITY(1,1),
    CompanyName    NVARCHAR(150) NOT NULL,
    ContactName    NVARCHAR(100),
    Country        NVARCHAR(50),
    Email          NVARCHAR(100),
    Phone          NVARCHAR(30),
    CreatedDate    DATE DEFAULT GETDATE()
);

CREATE TABLE Products (
    ProductID      INT PRIMARY KEY IDENTITY(1,1),
    ProductName    NVARCHAR(150) NOT NULL,
    Category       NVARCHAR(80),
    UnitPrice      DECIMAL(10,2) NOT NULL,
    StockQuantity  INT DEFAULT 0
);

CREATE TABLE Orders (
    OrderID        INT PRIMARY KEY IDENTITY(1,1),
    CustomerID     INT REFERENCES Customers(CustomerID),
    EmployeeID     INT REFERENCES Employees(EmployeeID),
    OrderDate      DATE NOT NULL,
    ShipDate       DATE,
    Status         NVARCHAR(20) DEFAULT 'Pending'  -- Pending, Shipped, Cancelled
);

CREATE TABLE OrderItems (
    OrderItemID    INT PRIMARY KEY IDENTITY(1,1),
    OrderID        INT REFERENCES Orders(OrderID),
    ProductID      INT REFERENCES Products(ProductID),
    Quantity       INT NOT NULL,
    UnitPrice      DECIMAL(10,2) NOT NULL
);

CREATE TABLE AppErrors (
    ErrorID        INT PRIMARY KEY IDENTITY(1,1),
    ErrorTime      DATETIME DEFAULT GETDATE(),
    Application    NVARCHAR(100),
    ErrorMessage   NVARCHAR(MAX),
    Severity       NVARCHAR(20),  -- Low, Medium, High, Critical
    IsResolved     BIT DEFAULT 0,
    ResolvedBy     NVARCHAR(100),
    ResolvedTime   DATETIME
);
GO

-- ============================================================
-- SEED DATA
-- ============================================================

INSERT INTO Departments (DepartmentName, ManagerName) VALUES
('Sales',       'Anna Schmidt'),
('IT Support',  'Lukas Bauer'),
('Finance',     'Maria Weber'),
('Logistics',   'Peter Müller'),
('HR',          'Sara Keller');

INSERT INTO Employees (FirstName, LastName, Email, DepartmentID, JobTitle, Salary, HireDate, IsActive) VALUES
('James',   'Anderson',  'j.anderson@alphacore.com',  1, 'Sales Representative', 52000, '2020-03-15', 1),
('Sophie',  'Müller',    's.muller@alphacore.com',    1, 'Sales Representative', 48000, '2021-06-01', 1),
('Marco',   'Rossi',     'm.rossi@alphacore.com',     2, 'IT Support Specialist',46000, '2019-09-10', 1),
('Elif',    'Yilmaz',    'e.yilmaz@alphacore.com',    2, 'Database Administrator',54000,'2022-01-20', 1),
('Thomas',  'Berger',    't.berger@alphacore.com',    3, 'Finance Analyst',      58000, '2018-11-05', 1),
('Laura',   'Fischer',   'l.fischer@alphacore.com',   4, 'Logistics Coordinator',44000,'2021-04-22', 1),
('David',   'Klein',     'd.klein@alphacore.com',     1, 'Sales Manager',        72000, '2017-07-30', 1),
('Nina',    'Wagner',    'n.wagner@alphacore.com',    5, 'HR Specialist',        47000, '2020-08-14', 1),
('Ali',     'Celik',     'a.celik@alphacore.com',     2, 'IT Support Specialist',45000, '2023-02-01', 1),
('Emma',    'Braun',     'e.braun@alphacore.com',     3, 'Senior Accountant',    62000, '2016-05-18', 1);

INSERT INTO Customers (CompanyName, ContactName, Country, Email, Phone) VALUES
('Zürich Tech GmbH',        'Hans Meier',      'Switzerland', 'h.meier@zurichtech.ch',     '+41 44 123 4567'),
('Basel Solutions AG',      'Petra Schneider', 'Switzerland', 'p.schneider@baselsol.ch',   '+41 61 987 6543'),
('Vienna Imports GmbH',     'Klaus Hofmann',   'Austria',     'k.hofmann@viennaimp.at',    '+43 1 555 7890'),
('Berlin Digital GmbH',     'Sabine Wolf',     'Germany',     's.wolf@berlindigi.de',      '+49 30 444 5566'),
('Warsaw Systems Sp.',      'Adam Kowalski',   'Poland',      'a.kowalski@warsawsys.pl',   '+48 22 777 8899'),
('Amsterdam Trade BV',      'Jan Visser',      'Netherlands', 'j.visser@amstertrade.nl',   '+31 20 333 2211'),
('Paris Connect SARL',      'Marie Dubois',    'France',      'm.dubois@pariscon.fr',      '+33 1 234 5678'),
('Milan Fashion SRL',       'Luca Ferrari',    'Italy',       'l.ferrari@milanfash.it',    '+39 02 987 6543'),
('Madrid Services SL',      'Carlos García',   'Spain',       'c.garcia@madridserv.es',    '+34 91 555 1234'),
('Stockholm AB',            'Erik Larsson',    'Sweden',      'e.larsson@stockholmab.se',  '+46 8 123 4567');

INSERT INTO Products (ProductName, Category, UnitPrice, StockQuantity) VALUES
('Enterprise CRM License',      'Software',    1200.00,  50),
('Cloud Backup Solution',        'Software',     450.00, 100),
('Network Switch 24-Port',       'Hardware',     380.00,  30),
('Laptop Stand Pro',             'Hardware',      65.00, 200),
('IT Support Contract (annual)', 'Service',     2400.00,  999),
('SQL Server Training Course',   'Training',     850.00,  999),
('Firewall Appliance',           'Hardware',    1800.00,  15),
('Office 365 Business (yearly)', 'Software',     180.00, 500),
('SSD 1TB',                      'Hardware',      95.00,  80),
('Data Migration Service',       'Service',     3500.00, 999);

INSERT INTO Orders (CustomerID, EmployeeID, OrderDate, ShipDate, Status) VALUES
(1, 1, '2024-01-10', '2024-01-15', 'Shipped'),
(2, 2, '2024-01-18', '2024-01-23', 'Shipped'),
(3, 1, '2024-02-05', '2024-02-10', 'Shipped'),
(4, 7, '2024-02-14', NULL,         'Pending'),
(5, 2, '2024-02-20', '2024-02-25', 'Shipped'),
(1, 7, '2024-03-01', '2024-03-06', 'Shipped'),
(6, 1, '2024-03-12', NULL,         'Pending'),
(7, 2, '2024-03-22', '2024-03-27', 'Shipped'),
(8, 7, '2024-04-03', '2024-04-08', 'Shipped'),
(2, 1, '2024-04-15', NULL,         'Cancelled'),
(9, 2, '2024-05-02', '2024-05-07', 'Shipped'),
(10,7, '2024-05-20', '2024-05-25', 'Shipped'),
(3, 1, '2024-06-08', '2024-06-13', 'Shipped'),
(5, 2, '2024-06-25', NULL,         'Pending'),
(1, 7, '2024-07-10', '2024-07-15', 'Shipped');

INSERT INTO OrderItems (OrderID, ProductID, Quantity, UnitPrice) VALUES
(1,  1, 2, 1200.00), (1,  8, 5,  180.00),
(2,  5, 1, 2400.00), (2,  2, 2,  450.00),
(3,  7, 1, 1800.00), (3,  9, 4,   95.00),
(4,  1, 3, 1200.00),
(5,  6, 2,  850.00), (5,  4, 5,   65.00),
(6,  5, 1, 2400.00), (6, 10, 1, 3500.00),
(7,  2, 3,  450.00),
(8,  3, 2,  380.00), (8,  4, 10,  65.00),
(9,  1, 1, 1200.00), (9,  8, 10, 180.00),
(10, 5, 1, 2400.00),
(11, 6, 3,  850.00),
(12, 7, 1, 1800.00), (12, 9, 5,   95.00),
(13, 1, 2, 1200.00), (13, 2, 1,  450.00),
(14,10, 1, 3500.00),
(15, 5, 2, 2400.00), (15, 8, 5,  180.00);

INSERT INTO AppErrors (ErrorTime, Application, ErrorMessage, Severity, IsResolved, ResolvedBy, ResolvedTime) VALUES
('2024-03-10 09:15:00', 'CRM App',      'Connection timeout to DB server',           'High',     1, 'Elif Yilmaz', '2024-03-10 10:30:00'),
('2024-03-12 14:22:00', 'Billing App',  'Duplicate invoice ID detected',             'Critical', 1, 'Elif Yilmaz', '2024-03-12 15:00:00'),
('2024-04-01 08:05:00', 'HR Portal',    'Login page returns 500 error',              'High',     1, 'Marco Rossi', '2024-04-01 09:45:00'),
('2024-04-15 11:30:00', 'CRM App',      'Report export fails for large datasets',    'Medium',   1, 'Elif Yilmaz', '2024-04-16 10:00:00'),
('2024-05-03 16:45:00', 'Backup Agent', 'Scheduled backup did not complete',         'Critical', 1, 'Elif Yilmaz', '2024-05-03 17:30:00'),
('2024-05-20 13:10:00', 'CRM App',      'Slow query on Orders table (>30s)',         'Medium',   1, 'Elif Yilmaz', '2024-05-21 09:00:00'),
('2024-06-02 10:00:00', 'Billing App',  'VAT calculation rounding error',            'Medium',   0, NULL,          NULL),
('2024-06-18 15:55:00', 'HR Portal',    'Password reset emails not sending',         'High',     0, NULL,          NULL),
('2024-07-05 09:20:00', 'Backup Agent', 'Disk space below 10% on backup drive',      'High',     0, NULL,          NULL),
('2024-07-12 11:00:00', 'CRM App',      'User permissions not applying after update','Medium',   0, NULL,          NULL);
GO

PRINT 'AlphaCoreDB created and seeded successfully.';
GO
