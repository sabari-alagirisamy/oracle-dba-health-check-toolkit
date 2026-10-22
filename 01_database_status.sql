
-- Project: Oracle DBA Health Check Toolkit
-- Script: 01_database_status.sql
-- Purpose: Display basic Oracle database status and version.
-- Access: Requires appropriate read access to the queried views.

SET PAGESIZE 100
SET LINESIZE 200
SET VERIFY OFF
SET FEEDBACK ON

PROMPT === Database Information ===

SELECT
    name,
    open_mode,
    database_role
FROM v$database;

PROMPT === Oracle Database Version ===

SELECT banner
FROM v$version
WHERE banner LIKE 'Oracle Database%';

PROMPT === Instance Status ===

SELECT
    instance_name,
    status,
    database_status,
    version
FROM v$instance;

PROMPT === End of Database Status Report ===
