# System administration scripts

This directory contains scripts for configuration, operation and upkeep of Fedora Linux.

## Usage

### Setup Fedora Linux

1. Install software:

    ```bash
    sudo ./install_software.sh
    ```

    The following packages will be installed:

    - `deja-dup`: Simple backup tool.
    - `geary`: Simple email client.
    - `akmod-nvidia`: NVIDIA graphics driver.
    - `xorg-x11-drv-nvidia-cuda`: NVIDIA CUDA driver.
    - `code`: Visual Studio Code.
    - `gh`: GitHub CLI.
    - `parallel`: Command-line utility for executing jobs in parallel.
    - `flac`: Command-line utilities to encode and decode FLAC files.
    - `opus-tools`: Command-line utilities to encode and decode Opus files.
    - `whipper`: Command-line utility to rip audio CDs.
    - `rsgain`: Command-line utility to calculate ReplayGain for audio files (serves as the backend for the ReplayGain 2.0 plugin for MusicBrainz Picard).
    - `picard`: MusicBrainz Picard music tagger.
    - `foliate`: E-book reader.

    The following flatpaks will be installed:

    - `com.bitwarden.desktop`: Bitwarden password manager.
    - `com.spotify.Client`: Spotify audio streaming.

1. Restart your computer to finish installation of drivers.

1. Configure system:

    ```bash
    sudo ./configure_system.sh
    ```

1. Restore home directory from backup:

    ```bash
    deja-dup
    ```
