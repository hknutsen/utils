#! /bin/bash

set -eu

NC='\033[0;37m'
YELLOW='\033[0;33m'
GREEN='\033[0;32m'

function info {
  echo -e "${YELLOW}$1${NC}"
}

################################################################################
# UPDATE SYSTEM SOFTWARE
################################################################################
info 'Updating system software...'
sudo dnf upgrade --refresh

################################################################################
# ADD SOFTWARE REPOSITORIES
################################################################################
info 'Adding software repositories...'

# Enable RPM Fusion repositories.
# Required for installing proprietary software such as NVIDIA drivers.
# Refs:
# - https://docs.fedoraproject.org/en-US/quick-docs/rpmfusion-setup/
# - https://rpmfusion.org/Howto/NVIDIA
rpmfusion_url='https://download1.rpmfusion.org'
os='fedora'
os_version=$(rpm -E %fedora)
sudo dnf install \
  "$rpmfusion_url/free/$os/rpmfusion-free-release-$os_version.noarch.rpm" \
  "$rpmfusion_url/nonfree/$os/rpmfusion-nonfree-release-$os_version.noarch.rpm"

# Add Visual Studio Code repository.
# Ref: https://code.visualstudio.com/docs/setup/linux
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
echo '[code]
name=Visual Studio Code
baseurl=https://packages.microsoft.com/yumrepos/vscode
enabled=1
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc' |
sudo tee /etc/yum.repos.d/vscode.repo > /dev/null

################################################################################
# INSTALL PACKAGES
################################################################################
info 'Installing packages...'
packages=(
  gnome-tweaks
  gnome-extensions-app
  deja-dup
  geary
  akmod-nvidia
  xorg-x11-drv-nvidia-cuda
  code
  gh
  parallel
  quodlibet
  flac
  opus-tools
  whipper
  rsgain
  picard
  foliate
  torbrowser-launcher
)
sudo dnf install "${packages[@]}"

################################################################################
# INSTALL FLATPAKS
################################################################################
info 'Installing flatpaks...'
flatpaks=(
  com.bitwarden.desktop
)
flatpak install flathub "${flatpaks[@]}"

################################################################################
# FINISH INSTALLATION
################################################################################
modinfo -F version nvidia > /dev/null 2>&1 ||
info 'Restart your computer to finish installation of NVIDIA drivers.'
echo -e "${GREEN}Done!${NC}"
