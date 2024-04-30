#! /bin/bash

# Decodes audio from lossless FLAC files in the input directory and
# encodes to lossy Opus files in the output directory.
# Prerequisites:
#   parallel
#   opus-tools
#   rsgain
# Arguments:
#   Input directory, a path.
#   Output directory, a path.
# Usage:
#   ./encode_opus.sh <INPUT_DIR> <OUTPUT_DIR>
#   ./encode_opus.sh /mnt/Data/Music ~/Music/opus

set -eu

function doit {
  input_file="${INPUT_DIR}/$1"
  output_file="${OUTPUT_DIR}/$2"

  # Ensure directory exists.
  dir=$(dirname "${OUTPUT_DIR}/$2")
  if [[ ! -d "${dir}" ]]; then
    mkdir -p "${dir}"
  fi

  # According to the Xiph.Org Foundation (developers of Opus), "Opus at 128 KB/s (VBR) is pretty much transparent".
  # Ref: https://wiki.xiph.org/Opus_Recommended_Settings#Recommended_Bitrates (2024/04/03)
  opusenc --bitrate 128 --vbr --quiet "${input_file}" "${output_file}"
}

# Ensure the input directory exists.
# Export it to the environment.
if [[ ! -d "$1" ]]; then
  echo "Source directory '$1' does not exist"
  exit 1
fi
INPUT_DIR="$1"
export INPUT_DIR

# Ensure output directory exists.
# Export it to the environment.
if [[ ! -d "$2" ]]; then
  mkdir -p "$2"
fi
OUTPUT_DIR="$2"
export OUTPUT_DIR

# Export the function to the environment.
export -f doit

# Convert FLAC files in input the directory to Opus files in the output directory.
echo "Converting FLAC files in '$INPUT_DIR' to Opus files in '$OUTPUT_DIR'"
cd "${INPUT_DIR}"
find . -type f -name "*.flac" | sort | parallel --progress 'doit {} {.}.opus'

# Calculate gain for Opus files in the output directory.
echo "Calculating gain for Opus files in '$OUTPUT_DIR'"
rsgain easy -m MAX "$OUTPUT_DIR"
