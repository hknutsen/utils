# System administration scripts

This directory contains scripts for configuration, operation and upkeep of Fedora Linux.

## Usage

### Setup Fedora Linux

1. Install software:

    ```bash
    ./install_software.sh
    ```

1. Restart your computer to finish installation of drivers.

1. Configure system:

    ```bash
    ./configure_system.sh
    ```

1. Restore home directory from backup:

    ```bash
    deja-dup --restore "$HOME"
    ```
