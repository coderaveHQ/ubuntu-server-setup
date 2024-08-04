#!/bin/bash

# Load common functions
source "$(dirname "$0")/../scripts/common/check_root.sh"
source "$(dirname "$0")/../scripts/common/load_config.sh"

echo "Setting up Docker..."

# Remove conflicted packages
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc;
  do apt remove $pkg;
done

# Add docker gpg key
apt update
apt install ca-certificates curl
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to apt sources
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null
apt update

# Install docker
apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

# Add users from config file to docker group
for user_info in "${USERS[@]}"; do
  IFS=':' read -r username password ssh_key <<< "$user_info"
  usermod -aG docker "$username"
  echo "User $username added to docker group."
done

# Configure docker to start on boot
systemctl enable docker.service
systemctl enable containerd.service

# Prepare /srv/docker directory and give permissions to usergroup
mkdir -p /srv/docker
chown -R $GROUPNAME:$GROUPNAME /srv/docker
chmod 775 /srv/docker

echo "Docker setup complete."
