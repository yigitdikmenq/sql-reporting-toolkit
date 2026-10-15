# SQL Reporting Toolkit

A practical set of T-SQL scripts built on a sample company database (AlphaCoreDB), demonstrating real-world database administration and reporting skills.

**Tech stack:** Microsoft SQL Server 2022 Express · T-SQL · SSMS

## What's inside

| File | What it does |
|------|--------------|
| `scripts/01_create_database.sql` | Creates AlphaCoreDB with 7 tables and sample data (employees, customers, orders, products, error log) |
| `reports/02_business_reports.sql` | Management reports: monthly revenue, top customers, sales by employee, pending orders, product performance |
| `reports/03_data_validation.sql` | Data quality checks: orphaned records, duplicate emails, missing items, unresolved critical errors |
| `maintenance/04_user_management.sql` | User account and role management: logins, permissions, role assignments |
| `maintenance/05_backup_and_maintenance.sql` | Backup monitoring, job history, index fragmentation checks, data clean-up |

## Setup

1. Install [SQL Server 2022 Express](https://www.microsoft.com/en-us/sql-server/sql-server-downloads)
2. Run `scripts/01_create_database.sql` to create and seed the database
3. Open any report or maintenance script in SSMS and run

```bash
sqlcmd -S .\SQLEXPRESS -E -i scripts\01_create_database.sql
```

## Skills demonstrated

- Writing complex T-SQL queries with JOINs, aggregations, subqueries
- Data validation and inconsistency detection
- User and role-based access control
- Backup monitoring and job history analysis
- Index health checks and maintenance planning
- Routine data clean-up procedures
