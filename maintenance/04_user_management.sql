-- ============================================================
-- User & Access Management - AlphaCoreDB
-- CV bullet: "Managed user accounts, roles and access
--             permissions for databases and business applications"
-- ============================================================

USE AlphaCoreDB;
GO

-- ============================================================
-- STEP 1: Create SQL Server logins
-- (Run once on the server as sysadmin)
-- ============================================================

-- Sales team: read-only access to orders and customers
-- IF NOT EXISTS (SELECT * FROM sys.server_principals WHERE name = 'sales_readonly')
--     CREATE LOGIN sales_readonly WITH PASSWORD = 'Str0ng!Pass2024';

-- IT support: read/write on AppErrors, read on everything
-- IF NOT EXISTS (SELECT * FROM sys.server_principals WHERE name = 'itsupport_user')
--     CREATE LOGIN itsupport_user WITH PASSWORD = 'Str0ng!Pass2024';

-- ============================================================
-- STEP 2: Create database users mapped to logins
-- ============================================================

-- CREATE USER sales_readonly  FOR LOGIN sales_readonly;
-- CREATE USER itsupport_user  FOR LOGIN itsupport_user;

-- ============================================================
-- STEP 3: Grant permissions
-- ============================================================

-- Sales team: read customers, orders, products
-- GRANT SELECT ON Customers   TO sales_readonly;
-- GRANT SELECT ON Orders      TO sales_readonly;
-- GRANT SELECT ON OrderItems  TO sales_readonly;
-- GRANT SELECT ON Products    TO sales_readonly;

-- IT Support: read all, write on AppErrors
-- GRANT SELECT ON Customers   TO itsupport_user;
-- GRANT SELECT ON Orders      TO itsupport_user;
-- GRANT SELECT ON Employees   TO itsupport_user;
-- GRANT SELECT, INSERT, UPDATE ON AppErrors TO itsupport_user;

-- ============================================================
-- STEP 4: Check current users and permissions (always works)
-- ============================================================

-- Who has access to this database?
SELECT
    dp.name                              AS DatabaseUser,
    dp.type_desc                         AS UserType,
    dp.create_date                       AS CreatedDate
FROM sys.database_principals dp
WHERE dp.type IN ('S','U','G')  -- SQL user, Windows user, Windows group
ORDER BY dp.name;
GO

-- What roles does each user belong to?
SELECT
    m.name                               AS Member,
    r.name                               AS Role
FROM sys.database_role_members rm
JOIN sys.database_principals r ON rm.role_principal_id  = r.principal_id
JOIN sys.database_principals m ON rm.member_principal_id = m.principal_id
ORDER BY r.name, m.name;
GO

-- ============================================================
-- STEP 5: Check fixed server roles (sysadmin, etc.)
-- CV bullet: "managed user accounts for business applications"
-- ============================================================
SELECT
    sp.name                              AS Login,
    sp.type_desc                         AS LoginType,
    srm.role_principal_id,
    sr.name                              AS ServerRole
FROM sys.server_principals sp
JOIN sys.server_role_members srm ON sp.principal_id = srm.member_principal_id
JOIN sys.server_principals sr   ON srm.role_principal_id = sr.principal_id
WHERE sp.type IN ('S','U')
ORDER BY sr.name, sp.name;
GO
