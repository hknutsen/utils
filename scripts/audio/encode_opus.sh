#! /bin/bash

# Reads audio from lossless FLAC files in the source directory,
# and encodes to lossy Opus files in the output directory.
#
# Prereqs:
#   opusenc
#
# Arguments:
#   Source directory
#   Output directory
#
# Usage:
#   ./encode_opus.sh /mnt/Data/Music/ ~/Music/

set -eu

source_dir=$1
output_dir=$2

cd "$source_dir" || exit

if [[ ! -d "$output_dir" ]]; then
  mkdir -p "$output_dir"
fi

readarray -t files_array < <(find . -name "*.flac")

for file in "${files_array[@]}"; do
  output_file="$output_dir/$file"
  output_dirname=$(dirname "$output_file")
  if [[ ! -d "$output_dirname" ]]; then
    mkdir -p "$output_dirname"
  fi

  # According to the Xiph.Org Foundation (developers of Opus), "Opus at 128 KB/s (VBR) is pretty much transparent".
  # Ref: https://wiki.xiph.org/Opus_Recommended_Settings#Recommended_Bitrates (2024/04/03)
  opusenc --bitrate 128 --vbr "$file" "${output_file/".flac"/".opus"}"
done
