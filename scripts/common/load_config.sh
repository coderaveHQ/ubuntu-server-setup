#!/bin/bash

# Determine the script's directory
SCRIPT_DIR="$(dirname "$(realpath "$0")")"

# Determine the project root directory
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# Check if the config.sh file exists
if [ ! -f "$PROJECT_ROOT/config.sh" ]; then
    echo "Please create a config.sh file in the project root directory"
    exit 1
fi

# Load configuration
source "$PROJECT_ROOT/config.sh"

# Check if the user has set the configuration
if [ -z "${USERS[*]}" ] || [ -z "$GROUPNAME" ] || [ -z "${UFW_PORTS[*]}" ]; then
    echo "Please set the USERS array, GROUPNAME, and UFW_PORTS in the config.sh file"
    exit 1
fi
