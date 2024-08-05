<div align="center">
<img src="https://raw.githubusercontent.com/coderaveHQ/coderave-brand-kit/main/banner/coderave-banner-dot-pattern.png" alt="coderave-banner" />

<h1>Ubuntu Server Setup</h1>

[![ubuntu](https://img.shields.io/badge/20.04LTS-FF6209?style=for-the-badge&logo=ubuntu&label=ubuntu&labelColor=000000)](https://releases.ubuntu.com/20.04/)
[![ubuntu](https://img.shields.io/badge/22.04LTS-FF6209?style=for-the-badge&logo=ubuntu&label=ubuntu&labelColor=000000)](https://releases.ubuntu.com/22.04/)
[![ubuntu](https://img.shields.io/badge/24.04LTS-FF6209?style=for-the-badge&logo=ubuntu&label=ubuntu&labelColor=000000)](https://releases.ubuntu.com/24.04/)
</div>

This repository contains scripts to automate the initial setup of an Ubuntu server.

The scripts are tested on `20.04LTS` `22.04LTS` `24.04LTS`

## Usage

1. Clone the repository:
    ```bash
    git clone https://github.com/coderavehq/ubuntu-server-setup.git
    cd ubuntu-server-setup
    ```

2. Copy the example configuration file and edit the `config.cfg` file to add the desired users, passwords, and SSH public keys:
    ```bash
    cp config.cfg.example config.cfg
    nano config.cfg
    ```

3. Run the `run.sh` script:
    ```bash
    sudo bash run.sh
    ```

## Scripts

- `00_update_upgrade.sh`: Updates and upgrades the system.
- `01_create_group_user.sh`: Creates users, adds them to the specified group, and sets up their SSH keys.
- `02_configure_ssh.sh`: Configures SSH to disable root login and password authentication, and enables SSH key-based authentication.
- `03_setup_ufw.sh`: Configures UFW firewall with the ports specified in `config.cfg`.
- `04_setup_swap.sh`: Sets up a swap file based on the installed RAM, and configures swappiness and vfs_cache_pressure.
- Common scripts are stored in the `scripts/common/` folder.
