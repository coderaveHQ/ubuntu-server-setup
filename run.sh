#!/bin/bash

# Check if the script is run with root permissions
source "$(dirname "$0")/scripts/common/check_root.sh"

# Execute all scripts in the scripts directory
for script in ./scripts/*.sh; do
  if [[ $script != "./scripts/common/check_root.sh" && $script != "./scripts/common/load_config.sh" ]]; then
    echo "Running $script..."
    bash "$script"
  fi
done

# Restart the ubuntu server
echo "Restarting the server"
reboot
