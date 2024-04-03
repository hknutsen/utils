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
#   ./encode_flac.sh /mnt/Data/Music/

set -eu

source_dir=$1

cd "$source_dir" || exit

files=$(find . -name "*.flac")
readarray -t files_array <<< "$files"

for file in "${files_array[@]}"; do
  file_path=$(realpath "$file")
  echo "Reencoding file: $file_path"
  flac --best --force "$file"
  echo ""
done
