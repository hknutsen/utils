#! /bin/bash

# Converts all "cover.jpg" files in the source music directory to "cover_600px.jpg" files for embedding.
#
# Prereqs:
#   imagemagick
#
# Arguments:
#   Source directory
#
# Usage:
#   ./create_covers.sh /mnt/Data/Music

set -eu

source_dir=$1

cd "$source_dir"

readarray -t cover_files < <(find . -name "cover.jpg")

for input_file in "${cover_files[@]}"; do
  echo "Converting $input_file"

  output_dir=$(dirname "$input_file")

  # By default, the ImageMagick convert tool estimates an appropriate quality level based on the input image.
  # If an estimate cannot be made, quality is set to 92 instead (ref: https://www.imagemagick.org/script/command-line-options.php#quality).
  # We want a consistent quality level for all album covers, so we explicitly set the quality to 92.

  # convert "$input_file" -resize 300x300 -quality 92 "$output_dir/cover_300px.jpg"
  convert "$input_file" -resize 600x600 -quality 92 "$output_dir/cover_600px.jpg"
  # convert "$input_file" -resize 1200x1200 -quality 92 "$output_dir/cover_1200px.jpg"
done
