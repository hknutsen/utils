#! /bin/bash

# Reads audio from lossless FLAC files in the source directory
# and re-encodes using the latest version of the FLAC encoder.
# Remember to always backup your FLAC files before re-encoding.
#
# Prereqs:
#   flac
#
# Arguments:
#   Source directory
#
# Usage:
#   ./reencode_flac.sh /mnt/Data/Music/

set -eu

source_dir=$1

cd "$source_dir" || exit

readarray -t flac_files < <(find . -name "*.flac")

for flac_file in "${flac_files[@]}"; do
  flac --best --force "$flac_file"
done
