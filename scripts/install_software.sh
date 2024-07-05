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
  neovim
)

# Install packages
sudo dnf install "${packages[@]}"
