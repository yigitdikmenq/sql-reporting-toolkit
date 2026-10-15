-- ============================================================
-- Backup & Maintenance Scripts - AlphaCoreDB
-- CV bullet: "Monitored scheduled jobs and backup completion;
--             performed routine maintenance: data clean-up,
--             imports/exports and checks after software updates"
-- ============================================================

USE AlphaCoreDB;
GO

-- ============================================================
-- BACKUP: Full database backup
-- ============================================================
-- BACKUP DATABASE AlphaCoreDB
--     TO DISK = 'C:\SQLBackups\AlphaCoreDB_Full_'
--              + CONVERT(VARCHAR, GETDATE(), 112) + '.bak'
--     WITH FORMAT, COMPRESSION, STATS = 10;
-- GO

-- ============================================================
-- CHECK 1: Last backup history (when was the last backup?)
-- CV bullet: "monitored backup completion"
-- ============================================================
SELECT TOP 5
    bs.database_name,
    bs.type                              AS BackupType,  -- D=Full, L=Log, I=Differential
    bs.backup_start_date,
    bs.backup_finish_date,
    DATEDIFF(minute, bs.backup_start_date, bs.backup_finish_date) AS DurationMin,
    CAST(bs.backup_size / 1048576.0 AS DECIMAL(10,2))             AS SizeMB,
    bmf.physical_device_name            AS BackupFile
FROM msdb.dbo.backupset bs
JOIN msdb.dbo.backupmediafamily bmf ON bs.media_set_id = bmf.media_set_id
WHERE bs.database_name = 'AlphaCoreDB'
ORDER BY bs.backup_start_date DESC;
GO

-- ============================================================
-- CHECK 2: SQL Agent job history (did scheduled jobs run?)
-- CV bullet: "monitored scheduled jobs"
-- ============================================================
SELECT TOP 20
    j.name                               AS JobName,
    h.run_date,
    h.run_time,
    CASE h.run_status
        WHEN 0 THEN 'Failed'
        WHEN 1 THEN 'Succeeded'
        WHEN 3 THEN 'Cancelled'
        ELSE 'Unknown'
    END                                  AS Status,
    h.message
FROM msdb.dbo.sysjobhistory h
JOIN msdb.dbo.sysjobs j ON h.job_id = j.job_id
ORDER BY h.run_date DESC, h.run_time DESC;
GO

-- ============================================================
-- CHECK 3: Database size and free space
-- CV bullet: "routine maintenance and checks"
-- ============================================================
SELECT
    DB_NAME()                            AS DatabaseName,
    name                                 AS FileName,
    type_desc                            AS FileType,
    CAST(size * 8.0 / 1024 AS DECIMAL(10,2))            AS SizeMB,
    CAST(FILEPROPERTY(name,'SpaceUsed') * 8.0/1024 AS DECIMAL(10,2)) AS UsedMB,
    CAST((size - FILEPROPERTY(name,'SpaceUsed')) * 8.0/1024 AS DECIMAL(10,2)) AS FreeMB
FROM sys.database_files;
GO

-- ============================================================
-- CHECK 4: Index fragmentation (performance check)
-- CV bullet: "checks after software updates"
-- ============================================================
SELECT
    OBJECT_NAME(ips.object_id)           AS TableName,
    i.name                               AS IndexName,
    ips.index_type_desc,
    CAST(ips.avg_fragmentation_in_percent AS DECIMAL(5,1)) AS FragmentationPct,
    ips.page_count
FROM sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, 'LIMITED') ips
JOIN sys.indexes i ON ips.object_id = i.object_id
                   AND ips.index_id  = i.index_id
WHERE ips.avg_fragmentation_in_percent > 5
  AND ips.page_count > 10
ORDER BY ips.avg_fragmentation_in_percent DESC;
GO

-- ============================================================
-- MAINTENANCE: Rebuild fragmented indexes
-- Run after checking fragmentation above
-- ============================================================
-- ALTER INDEX ALL ON Orders    REBUILD;
-- ALTER INDEX ALL ON OrderItems REBUILD;
-- GO

-- ============================================================
-- MAINTENANCE: Data clean-up example
-- CV bullet: "data clean-up"
-- Delete cancelled orders older than 1 year
-- ============================================================
-- DELETE FROM OrderItems
-- WHERE OrderID IN (
--     SELECT OrderID FROM Orders
--     WHERE Status = 'Cancelled'
--       AND OrderDate < DATEADD(year, -1, GETDATE())
-- );
-- DELETE FROM Orders
-- WHERE Status = 'Cancelled'
--   AND OrderDate < DATEADD(year, -1, GETDATE());
-- GO
