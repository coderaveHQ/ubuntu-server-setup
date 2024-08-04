#!/bin/bash

# Check if script is run with root permissions
if [ "$EUID" -ne 0 ]; then
    echo "Please run with sudo or as root"
    exit
fi

# Update and Upgrade the system
./scripts/00_update_upgrade.sh
