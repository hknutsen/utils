# System administration scripts

This directory contains scripts for configuration, operation and upkeep of Fedora Linux.

## Prerequisites

1. Install Ansible:

    ```bash
    sudo dnf install ansible
    ```

## Usage

### Setup Fedora Linux

> [!IMPORTANT]
> The following steps should be performed immediately after the installation and initial setup of Fedora Linux.

1. Install software:

    ```bash
    ansible-playbook install_software.yml
    ```

1. Restart your computer to finish installation of NVIDIA drivers.
1. Configure system:

    ```bash
    ./configure_system.sh
    ```

1. Open the `Backups` application and restore your home directory from your backup at `/mnt/Backup`.
1. Restart your computer to apply the user settings that were restored from the backup.
