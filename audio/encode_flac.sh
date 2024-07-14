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

NC='\033[0;37m'
YELLOW='\033[0;33m'
GREEN='\033[0;32m'

function doit {
  flac_file="$FLAC_DIR/$1"

  file_encoding=$(metaflac --show-vendor-tag "$flac_file")
  encoder_version=$(flac --version)
  if [[ "${file_encoding,,}" == *"${encoder_version,,}"* ]]; then
    # If input FLAC file already encoded using latest FLAC encoder, skip.
    exit 0
  fi

  echo -e "${YELLOW}Re-encoding '$flac_file'${NC}"
  flac --best --silent --force "$flac_file"
}

# Ensure the input directory exists.
if [[ ! -d "$FLAC_DIR" ]]; then
  echo "Input directory '$FLAC_DIR' does not exist"
  exit 1
fi

# Export variables and function, allowing child processes to inherit them.
export NC
export YELLOW
export -f doit

# Re-encode FLAC files in parallel child processes.
cd "$FLAC_DIR"
find . -name '*.flac' -type f | sort | parallel --progress 'doit {}'
echo -e "${GREEN}Done!${NC}"
