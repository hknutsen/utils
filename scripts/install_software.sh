#! /bin/bash

set -eu

packages=(
  # Sysadmin
  gnome-tweaks # Tweak advanced GNOME settings
  deja-dup     # Backups

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
  neovim # Code editor
  gh     # GitHub CLI
)

flatpaks=(
  com.spotify.Client # Music streaming
)

# Install packages
sudo dnf install "${packages[@]}"

# Install flatpaks
flatpak install flathub "${flatpaks[@]}"
