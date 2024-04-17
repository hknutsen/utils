#! /bin/bash

# Reads audio from lossless FLAC files in the source directory and encodes to lossy Opus files in the output directory.
# FLAC files in the same directory are considered an album.
#
# Prereqs:
#   opus-tools
#   rsgain
#
# Arguments:
#   Source directory
#   Output directory
#
# Usage:
#   ./encode_opus.sh /mnt/Data/Music/ ~/Music/

set -eu

source_dir=$(realpath "$1")
output_dir=$(realpath "$2")

cd "$source_dir"
readarray -t album_dirs < <(find . -type d)

for album_dir in "${album_dirs[@]}"; do
  cd "$source_dir/$album_dir"
  readarray -t flac_files < <(find . -maxdepth 1 -type f -name "*.flac")
  if [[ "${#flac_files[@]}" -eq 0 ]]; then
    continue
  fi

  target_dir="$output_dir/$album_dir"
  if [[ ! -d "$target_dir" ]]; then
    mkdir -p "$target_dir"
  fi

  opus_files=()

  for flac_file in "${flac_files[@]}"; do
    opus_file="$target_dir/${flac_file/".flac"/".opus"}"
    if [[ -f "$opus_file" ]]; then
      echo "$opus_file already exists"
      continue
    fi

    # According to the Xiph.Org Foundation (developers of Opus), "Opus at 128 KB/s (VBR) is pretty much transparent".
    # Ref: https://wiki.xiph.org/Opus_Recommended_Settings#Recommended_Bitrates (2024/04/03)
    opusenc --bitrate 128 --vbr "$flac_file" "$opus_file"
    opus_files+=("$opus_file")
  done

  if [[ "${#opus_files[@]}" -gt 0 ]]; then
    # Calculate track and album gain and write tags to files, fully compliant to RFC 7845 standard.
    # Ref: https://datatracker.ietf.org/doc/html/rfc7845#section-5.2.1 (2024/04/16)
    rsgain custom --album --tagmode=i --opus-mode=s "${opus_files[@]}"
  fi
done
