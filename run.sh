#!/bin/bash

# Check if script is run with root permissions
if [ "$EUID" -ne 0 ]; then
    echo "Please run with sudo or as root"
    exit
fi

# Check if the config.sh file exists
if [ ! -f config.sh ]; then
    echo "Please create a config.sh file"
    exit
fi

# Load the configuration
source config.sh

# Check if the user has set the configuration
if [ -z "$USERS" || -z "$GROUPNAME"]; then
    echo "Please set the USERS array and GROUPNAME in the config.sh file"
    exit
fi

# Execute all scripts in the scripts directory
for script in ./scripts/*.sh; do
    echo "Running $script"
    bash $script
done

# Restart the ubuntu server
echo "Restarting the server"
reboot
