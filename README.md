
# Oracle DBA Health Check Toolkit

A collection of read-only Oracle SQL diagnostics designed to help database administrators monitor database status, tablespace utilization, datafile configuration, invalid objects, active sessions, and common performance risks.

## Project Overview

The Oracle DBA Health Check Toolkit provides reusable SQL scripts for routine database administration and troubleshooting. The toolkit is intended for Oracle DBAs who want a practical starting point for database health checks and operational diagnostics.

## Features

| Script | Description |
|---|---|
| `01_database_status.sql` | Reports database name, open mode, database role, version, and instance status. |
| `02_tablespace_usage.sql` | Reports tablespace utilization percentages. |
| `03_invalid_objects.sql` | Summarizes invalid database objects by owner and object type. |
| `04_datafile_storage_health.sql` | Reports datafile sizes, autoextend settings, and maximum sizes. |
| `05_long_running_sessions.sql` | Identifies active user sessions and their activity duration. |
| `06_database_performance_diagnostics.sql` | Examines active sessions, blocking information, wait events, SQL IDs, and session counts. |
| `07_oracle_risk_intelligence_engine.sql` | Applies configurable heuristic scores to selected storage, object, blocking, and session findings. |

## Requirements

- Oracle Database 19c or a compatible Oracle release.
- Oracle SQL Developer, SQL*Plus, or a compatible SQL execution environment.
- Appropriate read privileges for the data dictionary and dynamic performance views referenced by each script.

Some scripts use `DBA_` and `GV$` views. Required privileges depend on the database configuration and the account executing the scripts.

## How to Run

1. Clone or download this repository.
2. Open the required `.sql` file in SQL Developer or another supported SQL client.
3. Connect to an authorized development or test database.
4. Execute the script. In SQL Developer, use **Run Script (F5)**.
5. Review the output and investigate any findings using your organization's DBA procedures.

Test each script individually before using it in another environment.

## Safety Considerations

- The included diagnostic queries are intended to be read-only.
- No session termination, data modification, or configuration changes are intended.
- Review SQL statements and privileges before execution.
- Do not publish passwords, connection strings, hostnames, production identifiers, or confidential database output.
- Risk scores are heuristic indicators, not guarantees of database health or failure probability.

## Validation Status

The initial database status, tablespace utilization, and invalid-object scripts have been executed in a development environment. Additional scripts should be tested individually, and their validation status should be updated only after successful execution.

## Limitations

- Results depend on the privileges available to the executing account.
- Session and wait information represents a point-in-time observation.
- Thresholds and risk scores are configurable examples and may need adjustment for individual environments.
- A report with no findings does not guarantee that the database is healthy.

## Future Enhancements

- Historical health snapshots and anomaly detection.
- Configurable alert thresholds.
- SQL performance trend analysis.
- Structured report export and dashboard integration.
- Additional backup and recovery diagnostics.

## Learning Outcomes

This project explores Oracle database monitoring, data dictionary views, dynamic performance views, SQL reporting, operational risk prioritization, and reusable DBA diagnostics.

## Author

Sabari Alagirisamy

## License

Choose and add an appropriate open-source license before encouraging reuse or redistribution.
