#! /bin/bash

set -eu

source_dir="/mnt/Data/Pictures/Cover Art"
music_dir="/mnt/Data/Music"

if [[ ! -d "$source_dir" ]]; then
  echo "Source directory $source_dir does not exist"
  exit 1
fi

if [[ ! -d "$music_dir" ]]; then
  echo "Music directory $music_dir does not exist"
  exit 1
fi

readarray -t source_files < <(find -- *.jpg)

for source_file in "${source_files[@]}"; do
  album_name="${source_file/".jpg"/""}"
  album_dir="$music_dir/$album_name"

  if [[ ! -d "$album_dir" ]]; then
    echo "Album directory $album_dir does not exist"
    exit 1
  fi

  cover_file="$album_dir/cover.jpg"

  if [[ -f "$cover_file" ]]; then
    echo "Cover file $cover_file already exists"
    exit 1
  fi

  echo "Converting $source_file to $cover_file"
  convert "$source_file" -resize 600x600 -quality 92 "$cover_file"
done
