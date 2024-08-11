#!/bin/bash

# Determine the script's directory
SCRIPT_DIR="$(dirname "$(realpath "$0")")"

# Source the root check script
source "$SCRIPT_DIR/scripts/common/check_root.sh"

echo "Running setup scripts..."

# Execute all scripts in the scripts directory
for script in ./scripts/*.sh; do
  if [[ $script != "./scripts/common/check_root.sh" && $script != "./scripts/common/load_config.sh" ]]; then
    echo "Running $script..."
    bash "$script"
  fi
done

echo "Initial Setup complete."

# Prompt to run optional scripts
echo "Would you like to run optional scripts? (y/n)"

read -r response
if [[ "$response" == "y" || "$response" == "Y" ]]; then
  echo "Select optional scripts to run:"
  echo "1) Install Docker"
  echo "Enter the numbers of the scripts you want to run, separated by spaces (e.g., '1 n'):"
  read -r scripts_to_run

  for script in $scripts_to_run; do
    case $script in
      1)
        "$SCRIPT_DIR/optional-scripts/setup_docker.sh"
        ;;
      *)
        echo "Invalid option: $script"
        ;;
    esac
  done
fi

# Prompt to reboot the system
echo "Would you like to reboot the system now? (y/n)"

read -r response
if [[ "$response" == "y" || "$response" == "Y" ]]; then
  echo "Rebooting..."
  reboot
fi
