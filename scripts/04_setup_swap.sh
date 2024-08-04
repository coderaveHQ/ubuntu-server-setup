#!/bin/bash

# Load common function
source "$(dirname "$0")/common/check_root.sh"

# Function to calculate swap size based on RAM
calculate_swap_size() {
    local ram_size_gb=$1
    local swap_size_gb

    # Define swap size as 1.5 times RAM size
    local swap_multiplier=1.5
    swap_size_gb=$(echo "scale=0; $ram_size_gb * $swap_multiplier" | bc)

    # Ensure the swap size is at least 1GB
    if [ "$swap_size_gb" -lt 1 ]; then
        swap_size_gb=1
    fi

    echo "${swap_size_gb}G"
}

# Get total RAM in GB
total_ram_mb=$(grep MemTotal /proc/meminfo | awk '{print $2}')
total_ram_gb=$((total_ram_mb / 1024 / 1024))
echo "Total RAM: ${total_ram_gb} GB"

# Calculate swap size based on RAM
swap_size=$(calculate_swap_size "$total_ram_gb")
SWAP_FILE="/swapfile"

# Create the swap file if it doesn't exist
if [ ! -f "$SWAP_FILE" ]; then
    echo "Creating swap file of size $swap_size..."
    fallocate -l "$swap_size" "$SWAP_FILE" || {
        echo "fallocate command failed, trying dd..."
        dd if=/dev/zero of="$SWAP_FILE" bs=1M count=$((swap_size * 1024)) || {
            echo "Failed to create swap file."
            exit 1
        }
    }
    chmod 600 "$SWAP_FILE"
    mkswap "$SWAP_FILE"
    echo "Swap file created and formatted."
fi

# Enable the swap file
swapon "$SWAP_FILE"
echo "$SWAP_FILE none swap sw 0 0" >> /etc/fstab
echo "Swap file enabled and added to /etc/fstab."

# Configure swappiness and vfs_cache_pressure
echo "Setting swappiness to 10 and vfs_cache_pressure to 50..."
sysctl vm.swappiness=10
sysctl vm.vfs_cache_pressure=50

# Make the settings persistent
echo "vm.swappiness=10" >> /etc/sysctl.conf
echo "vm.vfs_cache_pressure=50" >> /etc/sysctl.conf

# Apply sysctl settings
sysctl -p

echo "Swap file setup and system parameters updated."
