#! /bin/bash

# Resize JPEG files to 600x600 thumbnails.

# Arguments
#   Source directory

set -eu

source_dir=$1

cd "$source_dir" || exit

readarray -t jpeg_files < <(find -- *.jpg)

resolution="600x600"
target_dir="thumb_$resolution"

if [[ ! -d "$target_dir" ]]; then
  mkdir "$target_dir"
fi

for jpeg_file in "${jpeg_files[@]}"; do
  target_file="$target_dir/$jpeg_file"

  if [[ -f "$target_file" ]]; then
    echo "$target_file already exists"
  else
    echo "Converting $jpeg_file to $resolution"
    convert "$jpeg_file" -resize "$resolution" "$target_file"
  fi
done
