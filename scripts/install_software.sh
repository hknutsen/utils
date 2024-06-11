#! /bin/bash

set -eu

packages=(
  # Audio tools
  whipper   # CD ripper
  picard    # Music tagger
  rsgain    # ReplayGain tagging utility
  quodlibet # Music player
)

sudo dnf install "${packages[@]}"
