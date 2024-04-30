#! /bin/bash

# Decodes audio from lossless FLAC files in the source directory and encodes to lossy Opus files in the output directory.
#
# Prereqs:
#   parallel
#   opus-tools
#   rsgain
#
# Usage:
#   ./encode_opus.sh <SOURCE_DIR> <OUTPUT_DIR>
#   ./encode_opus.sh /mnt/Data/Music ~/Music/opus

set -eu

function flac2opus {
  flac_file="$1"
  opus_file="$TARGET_DIR/$2"

  # According to the Xiph.Org Foundation (developers of Opus), "Opus at 128 KB/s (VBR) is pretty much transparent".
  # Ref: https://wiki.xiph.org/Opus_Recommended_Settings#Recommended_Bitrates (2024/04/03)
  opusenc --bitrate 128 --vbr --quiet "$flac_file" "$opus_file"

  echo "$opus_file"
}

export TARGET_DIR # used to track which directory to store Opus files in
export -f flac2opus # used to convert flac files to opus files

if [[ ! -d "$1" ]]; then
  echo "Directory '$1' does not exist"
  exit 1
fi
SOURCE_DIR=$(realpath "$1")

if [[ ! -d "$2" ]]; then
  mkdir -p "$2"
fi
OUTPUT_DIR=$(realpath "$2")

cd "$SOURCE_DIR"
readarray -t album_dirs < <(find . -maxdepth 1 -type d)

for album_dir in "${album_dirs[@]}"; do
  cd "$SOURCE_DIR/$album_dir"  
  readarray -t flac_files < <(find . -maxdepth 1 -type f -name "*.flac" | sort)
  
  if [[ "${#flac_files[@]}" -eq 0 ]]; then
    continue
  fi

  TARGET_DIR="$OUTPUT_DIR/$album_dir"
  
  if [[ ! -d "$TARGET_DIR" ]]; then
    mkdir -p "$TARGET_DIR"
  fi

  readarray -t opus_files < <(parallel 'flac2opus {} {.}.opus' ::: "${flac_files[@]}")

  if [[ "${#opus_files[@]}" -gt 0 ]]; then
    # Calculate track and album gain, and write RFC 7845 standard tags.
    # Ref: https://datatracker.ietf.org/doc/html/rfc7845#section-5.2.1 (2024/04/16)
    rsgain custom --album --tagmode=i --opus-mode=s --quiet "${opus_files[@]}"
  fi
done
