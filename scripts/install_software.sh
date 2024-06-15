#! /bin/bash

set -eu

packages=(
  # Sysadmin
  gnome-tweaks # Tweak GNOME desktop environment
  deja-dup     # Backups

  # General
  thunderbird # Email

  # Audio tools
  whipper   # CD ripper
  picard    # Music tagger
  rsgain    # ReplayGain tagging utility
  quodlibet # Music player

  # Games
  steam
)

sudo dnf install "${packages[@]}"
