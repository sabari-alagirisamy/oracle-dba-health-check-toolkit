
-- Project: Oracle DBA Health Check Toolkit
-- Script: 03_invalid_objects.sql
-- Purpose: Summarize invalid database objects by owner and type.
-- Access: Requires SELECT access to DBA_OBJECTS.

SET PAGESIZE 100
SET LINESIZE 200
SET VERIFY OFF
SET FEEDBACK ON

COLUMN OWNER FORMAT A25
COLUMN OBJECT_TYPE FORMAT A30

PROMPT === Invalid Objects Summary ===

SELECT
    owner,
    object_type,
    COUNT(*) AS invalid_count
FROM dba_objects
WHERE status = 'INVALID'
GROUP BY owner, object_type
ORDER BY owner, object_type;

PROMPT === End of Invalid Objects Report ===
