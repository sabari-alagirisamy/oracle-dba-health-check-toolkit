-- Project: Oracle DBA Health Check Toolkit
-- Script: 04_datafile_storage_health.sql
-- Purpose: Report datafile size and autoextend configuration.
-- Access: Requires access to DBA_DATA_FILES.

SET PAGESIZE 100
SET LINESIZE 220
SET VERIFY OFF
SET FEEDBACK ON

COLUMN TABLESPACE_NAME FORMAT A25
COLUMN FILE_NAME FORMAT A65
COLUMN SIZE_MB FORMAT 999,999,990.00
COLUMN MAX_SIZE_MB FORMAT 999,999,990.00
COLUMN AUTOEXTENSIBLE FORMAT A15

PROMPT === Datafile Storage Health Report ===

SELECT
    tablespace_name,
    file_name,
    ROUND(bytes / 1024 / 1024, 2) AS size_mb,
    autoextensible,
    ROUND(maxbytes / 1024 / 1024, 2) AS max_size_mb
FROM dba_data_files
ORDER BY tablespace_name, file_name;

PROMPT === End of Datafile Storage Health Report ===
