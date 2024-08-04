#!/bin/bash

# Check if the config.sh file exists
if [ ! -f ./config.sh ]; then
    echo "Please create a config.sh file"
    exit
fi

# Load configuration
source ./config.sh

# Check if the user has set the configuration
if [ -z "$USERS" || -z "$GROUPNAME"]; then
    echo "Please set the USERS array and GROUPNAME in the config.sh file"
    exit
fi
