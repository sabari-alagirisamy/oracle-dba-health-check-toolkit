
-- Project: Oracle DBA Health Check Toolkit
-- Script: 02_tablespace_usage.sql
-- Purpose: Report tablespace utilization.
-- Access: Requires access to DBA_TABLESPACE_USAGE_METRICS.

SET PAGESIZE 100
SET LINESIZE 200
SET VERIFY OFF
SET FEEDBACK ON

COLUMN TABLESPACE_NAME FORMAT A30
COLUMN USED_PERCENT FORMAT 990.00

PROMPT === Tablespace Utilization Report ===

SELECT
    tablespace_name,
    ROUND(used_percent, 2) AS used_percent,
    tablespace_size AS allocated_units
FROM dba_tablespace_usage_metrics
ORDER BY used_percent DESC;

PROMPT === End of Tablespace Report ===
