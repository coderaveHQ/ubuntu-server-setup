#!/bin/bash

# Check if script is run with root permissions
if [ "$EUID" -ne 0 ]; then
    echo "Please run with sudo or as root"
    exit
fi

# Update and Upgrade the system
echo "Updating and Upgrading the system..."

apt update
apt upgrade -y
apt full-upgrade -y
apt autoremove -y
