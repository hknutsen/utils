#! /bin/bash

# Transcode FLAC files in source directory to MP3 using the LAME encoder.

# Prereqs:
#   opusenc

# Arguments:
#   Source directory
#   Output directory

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
  opusenc --bitrate 128 --vbr "$file" "${output_file/".flac"/".opus"}"
done
