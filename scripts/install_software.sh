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

  # Development tools
  code # VS Code
  gh   # GitHub CLI
)

flatpaks=(
  com.spotify.Client # Music streaming
)

# Add VS Code repository
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/vscode.repo > /dev/null

# Install packages
sudo dnf install "${packages[@]}"

# Install flatpaks
flatpak install flathub "${flatpaks[@]}"
