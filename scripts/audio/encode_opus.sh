#! /bin/bash

# Decodes audio from lossless FLAC files in the source directory and encodes to lossy Opus files in the output directory.
#
# Prereqs:
#   opus-tools
#   rsgain
#
# Usage:
#   ./encode_opus.sh <SOURCE_DIR> <OUTPUT_DIR>
#   ./encode_opus.sh /mnt/Data/Music ~/Music/opus

set -eu

if [[ ! -d "$1" ]]; then
  echo "Directory '$1' does not exist"
  exit 1
fi

if [[ ! -d "$2" ]]; then
  mkdir -p "$2"
fi

SOURCE_DIR=$(realpath "$1")
OUTPUT_DIR=$(realpath "$2")

cd "$SOURCE_DIR"
readarray -t album_dirs < <(find . -type d -maxdepth 1)

for album_dir in "${album_dirs[@]}"; do
  cd "$SOURCE_DIR/$album_dir"  
  readarray -t flac_files < <(find . -type f -name "*.flac" -maxdepth 1)
  
  if [[ "${#flac_files[@]}" -eq 0 ]]; then
    continue
  fi

  target_dir="$OUTPUT_DIR/$album_dir"
  
  if [[ ! -d "$target_dir" ]]; then
    mkdir -p "$target_dir"
  fi

  # According to the Xiph.Org Foundation (developers of Opus), "Opus at 128 KB/s (VBR) is pretty much transparent".
  # Ref: https://wiki.xiph.org/Opus_Recommended_Settings#Recommended_Bitrates (2024/04/03)
  parallel opusenc --bitrate 128 --vbr --quiet "{}" "$target_dir/{.}.opus" ::: "${flac_files[@]}"

  readarray -t opus_files < <(find "$target_dir" -type f -name "*.opus" -maxdepth 1)
  if [[ "${#opus_files[@]}" -gt 0 ]]; then
    # Calculate track and album gain, and write RFC 7845 standard tags.
    # Ref: https://datatracker.ietf.org/doc/html/rfc7845#section-5.2.1 (2024/04/16)
    echo "Calculating gain for '$target_dir'"
    rsgain custom --album --tagmode=i --opus-mode=s --quiet "${opus_files[@]}"
  fi
done
