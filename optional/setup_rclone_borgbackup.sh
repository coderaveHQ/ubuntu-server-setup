#!/bin/bash

# Check if the script is run with root permissions
source "$(dirname "$0")/../scripts/common/check_root.sh"

# Load configuration
source "$(dirname "$0")/../scripts/common/load_config.sh"

# Install rclone and borgbackup
echo "Installing rclone and borgbackup..."
apt install rclone borgbackup -y

# Configure rclone for WebDAV
echo "Configuring rclone for WebDAV..."
rclone config create "$WEBDAV_REMOTE" webdav \
  url "$WEBDAV_URL" \
  vendor "$WEBDAV_VENDOR" \
  user "$WEBDAV_USER" \
  pass "$WEBDAV_PASS"

# Initialize Borg repository
echo "Initializing Borg repository..."
borg init --encryption=repokey "$BORG_REPO"

# Ensure the backup script is executable
chmod +x "$(dirname "$0")/../scripts/backup/perform_backup.sh"

# Add a cron job for the backup script
echo "Adding cron job for the backup script..."
(crontab -l 2>/dev/null; echo "$CRON_SCHEDULE $(dirname "$0")/../scripts/backup/perform_backup.sh >> /var/log/rclone_backup.log 2>&1") | crontab -

echo "rclone backup setup completed."
