#!/bin/bash

# Check if script is run with root permissions
source ./scripts/common/check_root.sh

# Update and Upgrade the system
echo "Updating and Upgrading the system..."

apt update
apt upgrade -y
apt full-upgrade -y
apt autoremove -y
