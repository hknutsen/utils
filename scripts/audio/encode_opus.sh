#! /bin/bash

# Decodes audio from lossless FLAC files in the input directory and
# encodes to lossy Opus files in the output directory.
# Prerequisites:
#   parallel
#   opus-tools
# Arguments:
#   Input directory, a path.
#   Output directory, a path.
# Usage:
#   ./encode_opus.sh <INPUT_DIR> <OUTPUT_DIR>
#   ./encode_opus.sh /mnt/Data/Music ~/Music/Opus

set -eu

function doit {
  input_file="${INPUT_DIR}/$1"
  output_file="${OUTPUT_DIR}/$2"

  dir=$(dirname "${output_file}")
  if [[ ! -d "${dir}" ]]; then
    mkdir -p "${dir}"
  fi

  # According to the Xiph.Org Foundation (developers of Opus),
  # "Opus at 128 KB/s (VBR) is pretty much transparent".
  # Ref: https://wiki.xiph.org/Opus_Recommended_Settings#Recommended_Bitrates (2024/04/03)
  #
  # TODO: Clarify why album gain is set to 0
  # Ref: https://wiki.xiph.org/OggOpus#Comment_Header (2024/05/02)
  # Ref: https://datatracker.ietf.org/doc/html/rfc7845#section-5.2.1 (2024/04/16)
  opusenc --bitrate 128 --vbr \
    --comment "R128_ALBUM_GAIN=0" \
    --quiet "${input_file}" "${output_file}"
}

# Ensure the input directory exists.
# Export it to the environment.
if [[ ! -d "$1" ]]; then
  echo "Input directory '$1' does not exist"
  exit 1
fi
INPUT_DIR=$(realpath "$1")
export INPUT_DIR

# Ensure the output directory exists.
# Export it to the environment.
if [[ ! -d "$2" ]]; then
  mkdir -p "$2"
fi
OUTPUT_DIR=$(realpath "$2")
export OUTPUT_DIR

# Export the function to the environment.
export -f doit

# NOW DO IT!
cd "${INPUT_DIR}"
find . -type f -name "*.flac" \
  | sort \
  | parallel --progress 'doit {} {.}.opus'
