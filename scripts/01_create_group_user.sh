#!/bin/bash

# Load common functions
source "$(dirname "$0")/common/check_root.sh"
source "$(dirname "$0")/common/load_config.sh"

# Create the group if it doesn't exist
if ! getent group "$GROUPNAME" >/dev/null; then
  groupadd "$GROUPNAME"
  echo "Group $GROUPNAME created."
fi

# Create users and add them to the group
for user_info in "${USERS[@]}"; do
  IFS=':' read -r username password ssh_key <<< "$user_info"

  # Create user if it doesn't exist
  if ! id -u "$username" >/dev/null 2>&1; then
    useradd -m -s /bin/bash "$username"
    echo "$username:$password" | chpasswd
    echo "User $username created."

    # Add the user to the specified group and sudo group
    usermod -aG "$GROUPNAME" "$username"
    usermod -aG sudo "$username"
    echo "User $username added to groups $GROUPNAME and sudo."

    # Set up SSH key for the user
    if [ -n "$ssh_key" ]; then
      user_home=$(eval echo "~$username")
      mkdir -p "$user_home/.ssh"
      echo "$ssh_key" > "$user_home/.ssh/authorized_keys"
      chown -R "$username:$username" "$user_home/.ssh"
      chmod 700 "$user_home/.ssh"
      chmod 600 "$user_home/.ssh/authorized_keys"
      echo "SSH key added for user $username."
    fi
  else
    echo "User $username already exists."
  fi
done
