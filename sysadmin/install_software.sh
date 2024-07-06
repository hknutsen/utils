#! /bin/bash

set -eu

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
  picard
  rsgain
  foliate
)

flatpaks=(
  com.spotify.Client
)

sudo dnf update

# Enable RPM Fusion repositories.
# Required for installing proprietary software, such as Nvidia drivers.
# Ref: https://docs.fedoraproject.org/en-US/quick-docs/rpmfusion-setup/
sudo dnf install "https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm"
sudo dnf install "https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm"

# Add VS Code repository.
# Ref: https://code.visualstudio.com/docs/setup/linux
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/vscode.repo > /dev/null

# Install packages.
sudo dnf install "${packages[@]}"

# Install flatpaks.
flatpak install flathub "${flatpaks[@]}"

echo 'Restart your computer to finish installation of drivers.'
