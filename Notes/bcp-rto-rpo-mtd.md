# Business Continuity Planning: RTO, RPO, MTD, and MTO

This document explains the Business Continuity Planning (BCP) metrics used in the Secure IT Helpdesk Ticketing System Infrastructure project.

## Objective

The objective of the BCP implementation is to ensure that the osTicket helpdesk system can be recovered after data loss, system failure, or misconfiguration.

The BCP process includes:

- Manual database backup
- Automated backup script
- Web application file backup
- Restore testing
- SHA256 checksum verification
- Daily cron backup schedule
- Recovery time validation

## BCP Metrics

| Metric | Meaning | Target / Result |
|---|---|---|
| RTO | Recovery Time Objective | 30 minutes |
| RPO | Recovery Point Objective | 24 hours |
| MTD | Maximum Tolerable Downtime | 4 hours |
| MTO | Maximum Time Outage / Maximum Outage Time | 4 hours |
| Backup Integrity | Confirms backup files are not corrupted | SHA256 verification returned OK |
| Restore Test | Confirms backup can be restored | osTicket tables and ticket data restored successfully |

## RTO: Recovery Time Objective

**RTO** means the maximum acceptable time required to restore the system after a failure.

For this project, the RTO is:

```text
30 minutes
```

This means the osTicket system should be restored within 30 minutes after a failure.

### RTO Validation

The restore time was measured by restoring the osTicket database backup into a test database.

```bash
sudo mysql -u root -e "DROP DATABASE IF EXISTS osticket_restore_test; CREATE DATABASE osticket_restore_test;"
```

```bash
/usr/bin/time -p sudo sh -c 'mysql -u root osticket_restore_test < /backup/osticket/osticket_db_latest.sql'
```

The restore process completed within the target RTO of 30 minutes.

## RPO: Recovery Point Objective

**RPO** means the maximum acceptable amount of data loss measured by time.

For this project, the RPO is:

```text
24 hours
```

This is because the backup script is scheduled to run daily using cron.

### RPO Validation

Cron schedule:

```bash
sudo crontab -l
```

Expected result:

```text
0 2 * * * /usr/local/bin/osticket_backup.sh
```

This means the backup runs every day at 2:00 AM. If the system fails, the maximum expected data loss is up to 24 hours.

## MTD: Maximum Tolerable Downtime

**MTD** means the maximum time the system can be unavailable before it causes serious operational impact.

For this project, the MTD is:

```text
4 hours
```

This means the helpdesk system should not be unavailable for more than 4 hours.

If the outage exceeds this time, the organization may need to activate an alternative support process such as manual ticket recording using spreadsheet or email.

## MTO: Maximum Outage Time

**MTO** means the maximum outage time before an alternative recovery or business process must be activated.

For this project, the MTO is:

```text
4 hours
```

This is aligned with the MTD because the helpdesk system supports user support operations. If the system cannot be restored within the allowed time, manual support tracking should be used temporarily.

## Backup Directory Structure

Backup files are stored under:

```bash
/backup/osticket/
```

Directory structure:

```text
/backup/osticket/db
/backup/osticket/files
/backup/osticket/checksums
/backup/osticket/logs
```

| Directory | Purpose |
|---|---|
| `/backup/osticket/db` | Stores database backup files |
| `/backup/osticket/files` | Stores osTicket web application backup files |
| `/backup/osticket/checksums` | Stores SHA256 checksum files |
| `/backup/osticket/logs` | Stores backup activity logs |

## Manual Database Backup

A manual database backup can be created using:

```bash
mysqldump -u osticket_user -p osticket_db > /backup/osticket/osticket_db_backup_demo.sql
```

This backup contains the osTicket database structure and data.

## Automated Backup Script

The automated backup script is located at:

```bash
/usr/local/bin/osticket_backup.sh
```

Check script permission:

```bash
ls -l /usr/local/bin/osticket_backup.sh
```

Run backup script manually:

```bash
sudo /usr/local/bin/osticket_backup.sh
```

The script performs the following actions:

1. Creates a timestamp for each backup.
2. Dumps the osTicket database.
3. Compresses the database backup.
4. Compresses the osTicket web application directory.
5. Generates SHA256 checksums.
6. Writes backup status to a log file.
7. Removes old backup files based on retention settings.

## Backup Verification

Check backup files:

```bash
sudo ls -lh /backup/osticket/db
sudo ls -lh /backup/osticket/files
sudo ls -lh /backup/osticket/checksums
sudo ls -lh /backup/osticket/logs
```

Check backup log:

```bash
sudo tail -n 20 /backup/osticket/logs/backup.log
```

Verify backup integrity:

```bash
sudo sh -c 'sha256sum -c /backup/osticket/checksums/backup_*.sha256'
```

Expected result:

```text
OK
```

## Restore Test

A restore test should be performed using a separate test database to avoid affecting the live osTicket database.

Create restore test database:

```bash
sudo mysql -u root -e "DROP DATABASE IF EXISTS osticket_restore_test; CREATE DATABASE osticket_restore_test;"
```

Restore database backup:

```bash
/usr/bin/time -p sudo sh -c 'mysql -u root osticket_restore_test < /backup/osticket/osticket_db_latest.sql'
```

Verify restored data:

```bash
sudo mysql -u root -e "USE osticket_restore_test; SELECT t.ticket_id, t.number, c.subject, t.created FROM ost_ticket t LEFT JOIN ost_ticket__cdata c ON t.ticket_id=c.ticket_id ORDER BY t.ticket_id DESC LIMIT 5;"
```

Expected result:

- osTicket tables exist.
- Ticket records are restored.
- Restore time is within the 30-minute RTO.

## BCP Summary

| Area | Control Implemented | Validation |
|---|---|---|
| Backup Storage | Dedicated backup directories | `/backup/osticket/` |
| Manual Backup | Database exported using `mysqldump` | SQL backup file created |
| Automated Backup | Backup script created | `/usr/local/bin/osticket_backup.sh` |
| File Backup | osTicket web files compressed | `.tar.gz` backup file |
| Database Backup | Database backup compressed | `.sql.gz` backup file |
| Integrity Check | SHA256 checksum generated and verified | `sha256sum -c` returned OK |
| Backup Log | Backup activity logged | `backup.log` |
| Scheduled Backup | Daily cron job configured | `sudo crontab -l` |
| Restore Test | Backup restored into test database | `osticket_restore_test` |
| Data Validation | Restored ticket data verified | SQL query result |
| RTO Validation | Restore time measured | Completed within 30 minutes |
| RPO Validation | Daily backup schedule | 24-hour recovery point |

## Conclusion

The BCP implementation provides a practical recovery process for the osTicket helpdesk system. The system can be backed up, restored, and verified using checksum validation. The restore test confirms that the database backup is usable, and the cron schedule supports the 24-hour RPO.

This improves the availability and recoverability of the Secure IT Helpdesk Ticketing System Infrastructure.
