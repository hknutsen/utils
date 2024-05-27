#! /bin/bash

# Reads audio from lossless FLAC files in the input directory and re-encodes
# using the latest version of the FLAC encoder.
#
# Prerequisites:
#   parallel
#   flac
#
# Globals:
#   FLAC_DIR
#
# Usage:
#   ./encode_flac.sh

set -eu

# Ensure the input directory exists.
if [[ ! -d "$FLAC_DIR" ]]; then
  echo "Input directory '$FLAC_DIR' does not exist"
  exit 1
fi

# Re-encode FLAC files in parallel child processes.
cd "$FLAC_DIR"
find . -name '*.flac' -type f | sort | parallel --progress 'flac --best --force {}'
