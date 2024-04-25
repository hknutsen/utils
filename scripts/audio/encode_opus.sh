#! /bin/bash

# Decodes audio from lossless FLAC files in the source directory and encodes to lossy Opus files in the output directory.
#
# Prereqs:
#   opus-tools
#   rsgain
#
# Usage:
#   ./encode_opus.sh

set -eu

source_dir="/mnt/Data/Music"
output_dir="$HOME/Music/opus"

if [[ ! -d "$source_dir" ]]; then
  echo "Source directory '$source_dir' does not exist"
  exit 1
fi

if [[ ! -d "$output_dir" ]]; then
  echo "Output directory '$output_dir' does not exist"
  exit 1
fi

cd "$source_dir"

readarray -t album_dirs < <(find . -mindepth 1 -maxdepth 1 -type d | sort)

for album_dir in "${album_dirs[@]}"; do
  cd "$source_dir/$album_dir"

  readarray -t flac_files < <(find . -maxdepth 1 -type f -name "*.flac" | sort)

  if [[ "${#flac_files[@]}" -eq 0 ]]; then
    echo "Album directory '$album_dir' does not contain any FLAC files"
    continue
  fi

  target_dir="$output_dir/$album_dir"

  if [[ ! -d "$target_dir" ]]; then
    mkdir -p "$target_dir"
  fi

  opusenc_args=()
  source_cover="cover.jpg"
  target_cover="$target_dir/cover.jpg"
  if [[ -f "$source_cover" ]]; then
    # By default, the ImageMagick convert tool estimates an appropriate quality level based on the input image.
    # If an estimate cannot be made, quality is set to 92 instead (ref: https://www.imagemagick.org/script/command-line-options.php#quality).
    # We want a consistent quality level for all album covers, so we explicitly set the quality to 92.
    convert "$source_cover" -resize 600x600 -quality 92 "$target_cover"
    opusenc_args+=(--picture "||||$target_cover")
  fi

  opus_files=()

  for flac_file in "${flac_files[@]}"; do
    opus_file="$target_dir/${flac_file/".flac"/".opus"}"

    if [[ -f "$opus_file" ]]; then
      echo "Opus file '$opus_file' already exists"
      continue
    fi

    # According to the Xiph.Org Foundation (developers of Opus), "Opus at 128 KB/s (VBR) is pretty much transparent".
    # Ref: https://wiki.xiph.org/Opus_Recommended_Settings#Recommended_Bitrates (2024/04/03)
    echo "Converting '$flac_file' to '$opus_file'"
    opusenc --bitrate 128 --vbr "${opusenc_args[@]}" --quiet "$flac_file" "$opus_file"

    opus_files+=("$opus_file")
  done

  if [[ -f "$target_cover" ]]; then
    rm "$target_cover"
  fi

  if [[ "${#opus_files[@]}" -gt 0 ]]; then
    # Calculate track and album gain, and write RFC 7845 standard tags.
    # Ref: https://datatracker.ietf.org/doc/html/rfc7845#section-5.2.1 (2024/04/16)
    echo "Calculating gain for '$target_dir'"
    rsgain custom --album --tagmode=i --opus-mode=s --quiet "${opus_files[@]}"
  fi
done
