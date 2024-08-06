#!/bin/bash

# Load configuration
source "$(dirname "$0")/../common/load_config.sh"

# Variables
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")

# Stop all Docker containers
docker stop $(docker ps -q)

# Export passphrase for Borg
export BORG_PASSPHRASE='$BORG_PASSPHRASE'

# Create a new backup
borg create --verbose --filter AME --list --stats --show-rc \
  --compression lz4 \
  ::${TIMESTAMP} $BACKUP_SOURCE

# Prune old backups
borg prune --list --prefix '' \
  --keep-daily=7 --keep-weekly=4 --keep-monthly=6

# Unset passphrase
unset BORG_PASSPHRASE

# Sync the backup repository to WebDAV using rclone
rclone sync $BORG_REPO $WEBDAV_REMOTE

# Start all Docker containers
docker start $(docker ps -aq)

echo "Backup and upload completed at ${TIMESTAMP}"
