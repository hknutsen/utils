#! /bin/bash

# Converts all "cover.jpg" files in the source directory to "cover_600px.jpg"
# files for embedding.
#
# Prereqs:
#   parallel
#   imagemagick
#
# Globals:
#   FLAC_DIR
#
# Usage:
#   ./convert_cover.sh

set -eu

NC='\033[0;37m'
YELLOW='\033[0;33m'
GREEN='\033[0;32m'

function doit() {
  input_file="$1"
  output_file="$2"

  if [[ -f "$output_file" ]]; then
    # If output file already exists, skip.
    exit 0
  fi

  # By default, the ImageMagick convert tool estimates an appropriate quality
  # level based on the input image. If an estimate cannot be made, quality is
  # set to 92 instead. We want a consistent quality level for all album covers,
  # so we explicitly set the quality to 92.
  # Ref: https://www.imagemagick.org/script/command-line-options.php#quality
  echo -e "${YELLOW}Converting '$input_file' to '$output_file'${NC}"
  magick convert "$input_file" -resize 600x600 -quality 92 "$output_file"
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

# Convert "cover.jpg" and "cover.png" files in parallel child processes.
cd "$FLAC_DIR"
find . -name 'cover.jpg' -o -name 'cover.png' \
  | sort \
  | parallel --progress 'doit {} {.}_600px.jpg'
echo -e "${GREEN}Done!${NC}"
