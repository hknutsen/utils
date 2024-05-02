#! /bin/bash

# Decodes audio from lossless FLAC files in the input directory and encodes to 
# lossy Opus files in the output directory.
#
# Prerequisites:
#   parallel
#   opus-tools
#
# Arguments:
#   Input directory, a path.
#   Output directory, a path.
#
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
  # Ref: https://wiki.xiph.org/Opus_Recommended_Settings (2024/04/03)
  #
  # According to the Opus specification, gain must be stored in the
  # "Output Gain" field in the ID header. Media players should apply this output
  # gain by default. Additional track and album gain should be stored in the
  # "R128_TRACK_GAIN" and "R128_ALBUM_GAIN" fields in the comment header. Media
  # players should apply the track and album gain in addition to the output
  # gain. The reference Opus encoder stores album gain in the "Output Gain"
  # field and additional track gain in the "R128_TRACK_GAIN" field. It is
  # implicit that the value of the "R128_ALBUM_GAIN" field is 0, however the
  # lack of an explicit "R128_ALBUM_GAIN" field results in some media players
  # falling back to applying the additional track gain when only album gain is
  # preferred. Explicitly set the value of the "R128_ALBUM_GAIN" field to 0 to
  # prevent this behavior.
  # Ref: https://datatracker.ietf.org/doc/html/rfc7845 (2024/05/02)
  opusenc --bitrate 128 --vbr \
    --comment "R128_ALBUM_GAIN=0" \
    --quiet "${input_file}" "${output_file}"
}

# Ensure the input directory exists.
if [[ ! -d "$1" ]]; then
  echo "Input directory '$1' does not exist"
  exit 1
fi
INPUT_DIR=$(realpath "$1")

# Ensure the output directory exists.
if [[ ! -d "$2" ]]; then
  mkdir -p "$2"
fi
OUTPUT_DIR=$(realpath "$2")

# Export variables and functions, allowing child processes to inherit them.
export INPUT_DIR
export OUTPUT_DIR
export -f doit

# Convert FLAC files to Opus files in parallel child processes.
cd "${INPUT_DIR}"
find . -type f -name "*.flac" \
  | sort \
  | parallel --progress 'doit {} {.}.opus'
