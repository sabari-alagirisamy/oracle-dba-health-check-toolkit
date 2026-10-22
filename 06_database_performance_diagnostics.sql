
-- Project : Oracle DBA Health Check Toolkit
-- Script  : 06_database_performance_diagnostics.sql
-- Purpose : Diagnose active sessions, blocking, waits,
--           SQL execution, and session resource usage.
-- Database: Oracle 19c
-- Access  : Appropriate V$ view privileges required.
-- Safety  : Read-only diagnostic queries.

SET PAGESIZE 100
SET LINESIZE 260
SET VERIFY OFF
SET FEEDBACK ON
SET TRIMSPOOL ON

COLUMN username FORMAT A18
COLUMN machine FORMAT A25
COLUMN program FORMAT A30
COLUMN status FORMAT A8
COLUMN sql_id FORMAT A13
COLUMN event FORMAT A32
COLUMN wait_class FORMAT A16
COLUMN blocking_status FORMAT A18
COLUMN sql_text FORMAT A80 WORD_WRAPPED

PROMPT ==========================================================
PROMPT ORACLE DATABASE PERFORMANCE DIAGNOSTICS
PROMPT ==========================================================

PROMPT
PROMPT 1. Active User Sessions

SELECT
    s.inst_id,
    s.sid,
    s.serial#,
    s.username,
    s.machine,
    s.program,
    s.status,
    s.sql_id,
    ROUND(s.last_call_et / 60, 2) AS active_minutes,
    s.wait_class,
    s.event
FROM gv$session s
WHERE s.type = 'USER'
  AND s.status = 'ACTIVE'
  AND s.username IS NOT NULL
ORDER BY s.last_call_et DESC;

PROMPT
PROMPT 2. Blocking Session Details

SELECT
    w.inst_id AS waiting_inst,
    w.sid AS waiting_sid,
    w.serial# AS waiting_serial,
    w.username AS waiting_user,
    w.event AS waiting_event,
    w.seconds_in_wait,
    w.blocking_instance AS blocker_inst,
    w.blocking_session AS blocker_sid,
    b.serial# AS blocker_serial,
    b.username AS blocker_user,
    b.machine AS blocker_machine,
    b.sql_id AS blocker_sql_id
FROM gv$session w
LEFT JOIN gv$session b
  ON b.inst_id = w.blocking_instance
 AND b.sid = w.blocking_session
WHERE w.blocking_session IS NOT NULL
ORDER BY w.seconds_in_wait DESC;

PROMPT
PROMPT 3. Sessions With Significant Wait Time

SELECT
    inst_id,
    sid,
    serial#,
    username,
    sql_id,
    wait_class,
    event,
    state,
    seconds_in_wait
FROM gv$session
WHERE type = 'USER'
  AND username IS NOT NULL
  AND status = 'ACTIVE'
  AND wait_class <> 'Idle'
ORDER BY seconds_in_wait DESC
FETCH FIRST 30 ROWS ONLY;

PROMPT
PROMPT 4. Current SQL Text for Active Sessions

SELECT
    s.inst_id,
    s.sid,
    s.serial#,
    s.username,
    s.sql_id,
    SUBSTR(q.sql_text, 1, 150) AS sql_text
FROM gv$session s
JOIN gv$sql q
  ON q.inst_id = s.inst_id
 AND q.sql_id = s.sql_id
WHERE s.status = 'ACTIVE'
  AND s.type = 'USER'
  AND s.username IS NOT NULL
ORDER BY s.last_call_et DESC
FETCH FIRST 30 ROWS ONLY;

PROMPT
PROMPT 5. Database Session Summary

SELECT
    inst_id,
    status,
    COUNT(*) AS session_count
FROM gv$session
GROUP BY inst_id, status
ORDER BY inst_id, status;

PROMPT
PROMPT ==========================================================
PROMPT END OF PERFORMANCE DIAGNOSTICS
PROMPT ==========================================================
