#!/bin/bash

# Load common functions
source "$(dirname "$0")/common/check_root.sh"

# Ensure SSH configuration file exists
SSH_CONFIG_FILE="/etc/ssh/sshd_config"
if [ ! -f "$SSH_CONFIG_FILE" ]; then
  echo "SSH configuration file $SSH_CONFIG_FILE not found!"
  exit 1
fi

# Disable root login and password authentication
echo "Configuring SSH settings..."

# Backup the current SSH configuration
cp "$SSH_CONFIG_FILE" "$SSH_CONFIG_FILE.bak"
echo "Backup of SSH configuration saved to $SSH_CONFIG_FILE.bak"

# Disable root login
sed -i 's/^#PermitRootLogin .*/PermitRootLogin no/' "$SSH_CONFIG_FILE"
sed -i 's/^PermitRootLogin .*/PermitRootLogin no/' "$SSH_CONFIG_FILE"

# Disable password authentication
sed -i 's/^#PasswordAuthentication .*/PasswordAuthentication no/' "$SSH_CONFIG_FILE"
sed -i 's/^PasswordAuthentication .*/PasswordAuthentication no/' "$SSH_CONFIG_FILE"

# Enable public key authentication
sed -i 's/^#PubkeyAuthentication .*/PubkeyAuthentication yes/' "$SSH_CONFIG_FILE"
sed -i 's/^PubkeyAuthentication .*/PubkeyAuthentication yes/' "$SSH_CONFIG_FILE"

# Restart SSH service to apply changes
systemctl restart ssh
echo "SSH configuration updated and SSH service restarted."
