
# Oracle DBA Health Check Toolkit

## Overview

The Oracle DBA Health Check Toolkit is a collection of SQL scripts
designed to help Oracle Database Administrators perform basic,
read-only database health checks.

## Scripts

| Script | Purpose |
|---|---|
| `01_database_status.sql` | Displays database name, open mode, role, version, and instance status. |
| `02_tablespace_usage.sql` | Reports tablespace utilization using Oracle's DBA view. |
| `03_invalid_objects.sql` | Summarizes invalid database objects by owner and object type. |

## Prerequisites

- Access to an authorized Oracle Database environment.
- SQL*Plus or SQLcl.
- Appropriate read privileges on the required database views.
- A non-production database is recommended for initial testing.

## How to Run

Connect using an approved database account:

```sql
sqlplus username@service_name
```

Execute the scripts individually:

```sql
@01_database_status.sql
@02_tablespace_usage.sql
@03_invalid_objects.sql
```

## Safety

These scripts are intended for read-only reporting.
They do not intentionally modify database objects or data.

Review the scripts and confirm required privileges before execution.
Do not commit passwords, connection strings, private keys,
production data, or confidential company information.

## Validation Status

The scripts have been added to the repository.
Execution and output validation must be completed in an authorized
Oracle environment before the results can be considered verified.

## Learning Outcomes

- Query Oracle database and instance information.
- Review tablespace utilization metrics.
- Identify and summarize invalid database objects.
- Organize reusable DBA SQL scripts in GitHub.
- Document prerequisites, usage, and safe operating practices.
