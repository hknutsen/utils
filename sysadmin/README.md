# System administration scripts

This directory contains scripts for configuration, operation and upkeep of Fedora Linux.

## Usage

### Setup Fedora Linux

> [!IMPORTANT]
> The following steps should be performed immediately after the installation and initial setup of Fedora Linux.

1. Install software:

    ```bash
    ./install_software.sh
    ```

1. Restart your computer to finish installation of NVIDIA drivers.
1. Configure system:

    ```bash
    ./configure_system.sh
    ```

1. Open the `Backups` application and restore your home directory from your backup at `/mnt/Backup`.
1. Restart your computer to apply the user settings that were restored from the backup.

### Sign locally built akmods

Required to use proprietary Nvidia driver when Secure Boot is enabled (<https://rpmfusion.org/Howto/Secure%20Boot>).

Read `/usr/share/doc/akmods/README.secureboot` for more information.

1. Install required tools:

    ```bash
    sudo dnf install kmodtool akmods mokutil openssl
    ```

1. Generate key:

    ```bash
    sudo kmodgenca -a
    ```

1. Enroll public key in MOK:

    ```bash
    sudo mokutil --import /etc/pki/akmods/certs/public_key.der
    ```

   Enter a strong password at the prompt. You will need this password again soon.

1. Reboot the system:

    ```bash
    systemctl reboot --firmware-setup
    ```

    > [!NOTE]
    > Entering firmware setup first ensures your keyboard is detected before entering MOK.

1. Exit firmware setup to enter MOK.
1. Select `Enroll MOK`.
1. Select `Continue`.
1. Select `Yes` to confirm enrollment.
1. Enter the password.
