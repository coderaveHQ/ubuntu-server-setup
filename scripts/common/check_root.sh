#!/bin/bash

# Check if the script is run with root permissions
if [ "$EUID" -ne 0 ]; then
    echo "Please run with sudo or as root"
    exit 1
fi
