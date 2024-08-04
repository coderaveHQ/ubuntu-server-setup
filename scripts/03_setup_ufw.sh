#!/bin/bash

# Load common functions
source "$(dirname "$0")/common/check_root.sh"
source "$(dirname "$0")/common/load_config.sh"

# Ensure UFW is installed
if ! command -v ufw >/dev/null 2>&1; then
    echo "UFW is not installed. Installing..."
    apt-get update -y
    apt-get install -y ufw
fi

# Reset UFW to default settings
ufw reset -y

# Set default policies
ufw default deny incoming
ufw default allow outgoing

# Allow SSH and other ports defined in the config file
for port in "${UFW_PORTS[@]}"; do
    ufw allow "$port"
    echo "Allowed $port through UFW."
done

# Enable UFW
ufw enable -y
echo "UFW has been enabled."

# Display UFW status
ufw status verbose
