#! /bin/bash

set -eu

packages=(
  # Sysadmin
  deja-dup # Backups

  # Audio tools
  whipper   # CD ripper
  picard    # Music tagger
  rsgain    # ReplayGain tagging utility
  quodlibet # Music player
)

sudo dnf install "${packages[@]}"
