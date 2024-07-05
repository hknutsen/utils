#! /bin/bash

set -eu

# Enable RPM Fusion repositories.
# Required for installing Nvidia driver.
# Ref: https://docs.fedoraproject.org/en-US/quick-docs/rpmfusion-setup/
sudo dnf install "https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm"
sudo dnf install "https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm"

# Install Nvidia driver.
# Ref: https://rpmfusion.org/Howto/NVIDIA
sudo dnf install akmod-nvidia
echo -e "\033[0;33mWait ~5 minutes, then run 'modinfo -F version nvidia' to check the installed Nvidia driver version (e.g. '550.78').\033[0m"
echo "Restart your computer to start using the newly installed driver."
