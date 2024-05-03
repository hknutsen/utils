#! /bin/bash

# Decodes audio from lossless FLAC files in the input directory and encodes
# using the latest version of the FLAC encoder.
#
# Prerequisites:
#   parallel
#   flac
#
# Arguments:
#   Input directory, a path.
#
# Usage:
#   ./encode_flac.sh <INPUT_DIR>
#   ./encode_flac.sh /mnt/Data/Music

set -eu

# Ensure the input directory exists.
if [[ ! -d "$1" ]]; then
  echo "Input directory '$1' does not exist"
  exit 1
fi
cd "$1"

# Re-encode FLAC files in parallel child processes.
find . -name '*.flac' -type f | sort | parallel --progress 'flac --best --force {}'
