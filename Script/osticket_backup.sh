#!/bin/bash

DATE=$(date +"%Y%m%d_%H%M%S")
BACKUP_BASE="/backup/osticket"
DB_NAME="osticket_db"
WEB_DIR="/var/www/osticket"
LOG_FILE="$BACKUP_BASE/logs/backup.log"

DB_BACKUP="$BACKUP_BASE/db/${DB_NAME}_${DATE}.sql.gz"
WEB_BACKUP="$BACKUP_BASE/files/osticket_files_${DATE}.tar.gz"
CHECKSUM_FILE="$BACKUP_BASE/checksums/backup_${DATE}.sha256"

echo "[$(date)] Starting osTicket backup..." >> "$LOG_FILE"

mysqldump "$DB_NAME" | gzip > "$DB_BACKUP"

if [ $? -ne 0 ]; then
    echo "[$(date)] ERROR: Database backup failed." >> "$LOG_FILE"
    exit 1
fi

tar -czf "$WEB_BACKUP" "$WEB_DIR"

if [ $? -ne 0 ]; then
    echo "[$(date)] ERROR: Web file backup failed." >> "$LOG_FILE"
    exit 1
fi

sha256sum "$DB_BACKUP" "$WEB_BACKUP" > "$CHECKSUM_FILE"

find "$BACKUP_BASE/db" -type f -mtime +7 -delete
find "$BACKUP_BASE/files" -type f -mtime +7 -delete
find "$BACKUP_BASE/checksums" -type f -mtime +7 -delete

echo "[$(date)] Backup completed successfully." >> "$LOG_FILE"
echo "Database Backup: $DB_BACKUP" >> "$LOG_FILE"
echo "Web Files Backup: $WEB_BACKUP" >> "$LOG_FILE"
echo "Checksum File: $CHECKSUM_FILE" >> "$LOG_FILE"
echo "----------------------------------------" >> "$LOG_FILE"
