#! /bin/bash

set -eu

packages=(
  # Sysadmin
  deja-dup # Backups

  # General
  thunderbird # Email

  # Script tools
  parallel # Run other tools in parallel processes

  # Audio tools
  flac       # FLAC encoder
  opus-tools # Opus encoder
  whipper    # CD ripper
  picard     # Music tagger
  rsgain     # ReplayGain tagging utility
  quodlibet  # Music player

  # Development tools
  code
)

# Add VS Code repository
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/vscode.repo > /dev/null

# Install packages
sudo dnf install "${packages[@]}"
