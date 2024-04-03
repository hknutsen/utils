#! /bin/bash

# Reads audio from lossless FLAC files in the source directory and downsamples
# to 16-bit/44.1kHz (CD quality) FLAC files in the output directory.
#
# Prereqs:
#   sox
#
# Arguments:
#   Source directory
#   Output directory
#
# Usage:
#   ./downsample /mnt/Data/Music/ ~/Music/

set -eu

source_dir=$1
output_dir=$2

cd "$source_dir" || exit

if [[ ! -d "$output_dir" ]]; then
  mkdir "$output_dir"
fi

readarray -t files < <(find -- *.flac)

for file in "${files[@]}"; do
  output_file="$output_dir/$file"
  sox "$file" -b 16 "$output_file" rate "44.1k" dither
done
