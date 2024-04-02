#! /bin/bash

# Downsample FLAC files in source directory to 16-bit/44.1kHz.

# Arguments:
#   Source directory

set -eu

source_dir=$1

cd "$source_dir" || exit

output_dir="downsample"

if [[ ! -d "$output_dir" ]]; then
  mkdir "$output_dir"
fi

readarray -t files < <(find -- *.flac)

for file in "${files[@]}"; do
  output_file="$output_dir/$file"
  sox "$file" -b 16 "$output_file" rate "44.1k" dither
done
