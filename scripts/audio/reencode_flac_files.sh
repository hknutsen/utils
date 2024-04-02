#! /bin/bash

# Re-encode FLAC files in source directory using the latest version of the native FLAC encoder.

# Arguments:
#   Source directory

set -eu

source_dir=$1

cd "$source_dir" || exit

files=$(find . -name "*.flac")
readarray -t files_array <<< "$files"

for file in "${files_array[@]}"; do
  file_path=$(realpath "$file")
  echo "Reencoding file: $file_path"
  flac --best --force "$file"
  echo ""
done
