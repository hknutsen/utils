#! /bin/bash

# Convert source image to 600x600 cover art in the target directory.

# Arguments
#   Source file
#   Target directory

set -eu

source_file=$1
target_dir=$2

if [[ ! -f "$source_file" ]]; then
  echo "Source file $source_file does not exist"
  exit 1
fi

if [[ ! -d "$target_dir" ]]; then
  echo "Target directory $target_dir does not exist"
  exit 1
fi

target_file="$target_dir/cover.jpg"

if [[ -f "$target_file" ]]; then
  echo "$target_file already exists"
  exit 1
fi

echo "Converting $source_file to $target_file"
convert "$source_file" -resize 600x600 -quality 92 "$target_file"
