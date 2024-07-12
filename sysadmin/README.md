# System administration scripts

This directory contains scripts for configuration, operation and upkeep of Fedora Linux.

## Usage

### Setup Fedora Linux

> [!IMPORTANT]
> The following steps should be performed immediately after the installation and initial setup of Fedora Linux.

1. Install software:

    ```bash
    sudo ./install_software.sh
    ```

1. Restart your computer to finish installation of NVIDIA drivers.
1. Configure system:

    ```bash
    sudo ./configure_system.sh
    ```

1. Open the `Backups` application and restore your home directory from the backup at `/mnt/Backup/duplicity`.
1. Restart your computer to apply the user settings that were restored from the backup.
