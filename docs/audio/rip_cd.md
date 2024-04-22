# Rip CD

This document contains instructions on how to rip a CD to FLAC files using whipper.

## Prerequisites

1. Install whipper:

    ```bash
    sudo dnf install whipper
    ```

1. List mounted CD drives:

    ```bash
    whipper drive list
    ```

1. Copy the model of the CD drive you wish to use, find its drive offset [here](https://accuraterip.com/driveoffsets.htm) and configure the drive offset:

    ```bash
    whipper offset find -o <DRIVE_OFFSET>
    ```

    > [!NOTE]
    > whipper assumes a positive offset unless a negative offset is explicitly specified.

    Whipper will perform a rip of the currently inserted CD to confirm the offset.

1. Verify whipper configuration:

    ```bash
    cat ~/.config/whipper/whipper.conf
    ```

## Usage

1. Change to the music directory:

    ```bash
    cd ~/Music
    ```

1. Rip the CD:

    ```bash
    whipper cd rip
    ```
