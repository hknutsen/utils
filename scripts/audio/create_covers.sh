#! /bin/bash

# Convert images in cover art directory to "cover.jpg" files.
# Source cover art path: /mnt/Data/Pictures/Cover Art/<album_name>.jpg
# Destination album path: /mnt/Data/Music/<album_name>

set -e

source_dir="/mnt/Data/Pictures/Cover Art"
music_dir="/mnt/Data/Music"

cd "$source_dir" || exit

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

  if [[ -f "$cover_file" ]] && [[ ! "$1" == "-f" ]]; then
    echo "Cover file $cover_file already exists"
  else
    echo "Converting $source_file to $cover_file"
    convert "$source_file" -resize 1200x1200 -quality 92 "$cover_file"
    # 92 is the default quality, but it's set explicitly to clarify what's being done (resize with quality 92)
  fi
done
