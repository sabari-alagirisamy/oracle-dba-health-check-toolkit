
-- Project : Oracle DBA Health Check Toolkit
-- Module  : Oracle DBA Risk Intelligence Engine
-- Version : 1.0
-- Database: Oracle 19c
-- Purpose : Detect and prioritize common operational risks.
-- Safety  : Read-only queries; no database changes.
--
-- Risk score is a heuristic, not an Oracle-certified metric.
-- Requires read access to the referenced DBA_/GV$ views.

SET PAGESIZE 100
SET LINESIZE 220
SET VERIFY OFF
SET FEEDBACK ON
SET TRIMSPOOL ON

COLUMN category FORMAT A24
COLUMN severity FORMAT A12
COLUMN finding FORMAT A45
COLUMN evidence FORMAT A55
COLUMN recommendation FORMAT A65

PROMPT ==========================================================
PROMPT ORACLE DBA RISK INTELLIGENCE ENGINE
PROMPT ==========================================================

WITH findings AS
(
    -- 1. Tablespace utilization risk
    SELECT
        'STORAGE' AS category,
        CASE
            WHEN used_percent >= 95 THEN 'CRITICAL'
            WHEN used_percent >= 90 THEN 'HIGH'
            ELSE 'MEDIUM'
        END AS severity,
        CASE
            WHEN used_percent >= 95 THEN 40
            WHEN used_percent >= 90 THEN 30
            ELSE 20
        END AS risk_score,
        'Tablespace ' || tablespace_name ||
            ' utilization is ' ||
            TO_CHAR(ROUND(used_percent, 2)) || '%' AS finding,
        'Used percent = ' ||
            TO_CHAR(ROUND(used_percent, 2)) || '%' AS evidence,
        'Check datafile capacity, autoextend, and free space'
            AS recommendation
    FROM dba_tablespace_usage_metrics
    WHERE used_percent >= 80

    UNION ALL

    -- 2. Invalid database objects
    SELECT
        'OBJECTS',
        'MEDIUM',
        15,
        'Invalid objects detected',
        'Invalid object count = ' || COUNT(*),
        'Review affected owners and object types; validate recompilation'
    FROM dba_objects
    WHERE status = 'INVALID'
    HAVING COUNT(*) > 0

    UNION ALL

    -- 3. Blocking sessions
    SELECT
        'BLOCKING',
        'HIGH',
        30,
        'Sessions reporting a blocker',
        'Waiting sessions = ' || COUNT(*),
        'Inspect blocker session, transaction, and wait chain'
    FROM gv$session
    WHERE blocking_session IS NOT NULL
      AND type = 'USER'
    HAVING COUNT(*) > 0

    UNION ALL

    -- 4. Long-running active user sessions
    SELECT
        'ACTIVE SESSIONS',
        'MEDIUM',
        15,
        'Active sessions over 30 minutes',
        'Qualifying sessions = ' || COUNT(*),
        'Review SQL_ID, execution plan, waits, and business context'
    FROM gv$session
    WHERE type = 'USER'
      AND status = 'ACTIVE'
      AND username IS NOT NULL
      AND last_call_et >= 1800
    HAVING COUNT(*) > 0
)
SELECT
    category,
    severity,
    risk_score,
    finding,
    evidence,
    recommendation
FROM findings
ORDER BY risk_score DESC, category;

PROMPT
PROMPT ==========================================================
PROMPT RISK SUMMARY
PROMPT ==========================================================

WITH findings AS
(
    SELECT
        CASE
            WHEN used_percent >= 95 THEN 40
            WHEN used_percent >= 90 THEN 30
            ELSE 20
        END AS risk_score
    FROM dba_tablespace_usage_metrics
    WHERE used_percent >= 80

    UNION ALL

    SELECT 15
    FROM dba_objects
    WHERE status = 'INVALID'
    HAVING COUNT(*) > 0

    UNION ALL

    SELECT 30
    FROM gv$session
    WHERE blocking_session IS NOT NULL
      AND type = 'USER'
    HAVING COUNT(*) > 0

    UNION ALL

    SELECT 15
    FROM gv$session
    WHERE type = 'USER'
      AND status = 'ACTIVE'
      AND username IS NOT NULL
      AND last_call_et >= 1800
    HAVING COUNT(*) > 0
)
SELECT
    COUNT(*) AS findings_count,
    NVL(SUM(risk_score), 0) AS raw_risk_score,
    CASE
        WHEN NVL(SUM(risk_score), 0) >= 60 THEN 'HIGH'
        WHEN NVL(SUM(risk_score), 0) >= 25 THEN 'MODERATE'
        WHEN NVL(SUM(risk_score), 0) > 0 THEN 'LOW'
        ELSE 'NO FINDINGS'
    END AS overall_risk
FROM findings;

PROMPT ==========================================================
PROMPT END OF RISK INTELLIGENCE REPORT
PROMPT ==========================================================
