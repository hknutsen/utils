#! /bin/bash

# Reads audio from lossless FLAC files in the source directory and resamples
# to 16-bit/44.1kHz (CD quality) FLAC files in the output directory.
#
# Prereqs:
#   sox
#
# Arguments:
#   Source directory
#   Output directory (relative to source directory)
#
# Usage:
#   ./resample_flac.sh /mnt/Data/Music/ ~/Music/

set -eu

source_dir=$1
output_dir=$2

cd "$source_dir" || exit

readarray -t flac_files < <(find . -name "*.flac")

for flac_file in "${flac_files[@]}"; do
  output_file="$output_dir/$flac_file"
  if [[ -f "$output_file" ]]; then
    echo "$output_file already exists"
    continue
  fi

  parent_dir=$(dirname "$output_file")
  if [[ ! -d "$parent_dir" ]]; then
    mkdir -p "$parent_dir"
  fi

  sox -V "$flac_file" -b 16 "$output_file" rate "44.1k"
done
