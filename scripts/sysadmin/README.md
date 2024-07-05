# System administration

This directory contains scripts for configuration, operation and upkeep of Fedora Linux.

## Usage

### Setup Fedora Linux

1. Update system packages:

    ```bash
    sudo dnf update
    ```

1. Install drivers:

    ```bash
    ./install_drivers.sh
    ```

1. Restart your computer to finish installation of drivers.
1. Install software:

    ```bash
    ./install_software.sh
    ```

1. Configure GNOME (desktop environment):

    ```bash
    ./configure_gnome.sh
    ```
