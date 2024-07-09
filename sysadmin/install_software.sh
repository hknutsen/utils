#! /bin/bash

set -eu

################################################################################
# UPDATE SYSTEM SOFTWARE
################################################################################

sudo dnf upgrade

################################################################################
# ADD SOFTWARE REPOSITORIES
################################################################################

# Enable RPM Fusion repositories.
# Required for installing proprietary software, such as Nvidia drivers.
# Ref: https://docs.fedoraproject.org/en-US/quick-docs/rpmfusion-setup/
sudo dnf install "https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm"
sudo dnf install "https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm"

# Add VS Code repository.
# Ref: https://code.visualstudio.com/docs/setup/linux
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
echo "[code]
name=Visual Studio Code
baseurl=https://packages.microsoft.com/yumrepos/vscode
enabled=1
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc" |
sudo tee /etc/yum.repos.d/vscode.repo > /dev/null

################################################################################
# INSTALL PACKAGES
################################################################################

packages=(
  deja-dup
  thunderbird
  akmod-nvidia
  xorg-x11-drv-nvidia-cuda
  code
  gh
  parallel
  flac
  opus-tools
  whipper
  rsgain
  picard
  foliate
)

sudo dnf install "${packages[@]}"

################################################################################
# INSTALL FLATPAKS
################################################################################

flatpaks=(
  com.bitwarden.desktop
  com.spotify.Client
)

flatpak install flathub "${flatpaks[@]}"

################################################################################
# FINISH INSTALLATION
################################################################################

echo 'Restart your computer to finish installation of software.'
