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
  input_file="$INPUT_DIR/$1"
  output_file="$OUTPUT_DIR/$2"

  dir=$(dirname "$output_file")
  if [[ ! -d "$dir" ]]; then
    mkdir -p "$dir"
  fi

  # According to the Xiph.Org Foundation (developers of Opus), "Opus at 128 KB/s
  # (VBR) is pretty much transparent".
  # Ref: https://wiki.xiph.org/Opus_Recommended_Settings#Recommended_Bitrates
  #
  # Opus follows the EBU R128 specification for loudness normalization.
  # According to the Opus specification, gain must be stored in the "Output
  # Gain" field in the ID header. Media players should apply this gain by
  # default. Additional track and album gain can be stored in the
  # "R128_TRACK_GAIN" and "R128_ALBUM_GAIN" tags in the comment header.
  # Ref: https://datatracker.ietf.org/doc/html/rfc7845#section-5.2.1
  #
  # If the input FLAC file has a "REPLAYGAIN_ALBUM_GAIN" tag, its value will be
  # converted to the R128 reference level and stored in the "Output Gain" field
  # of the output Opus file. If the input FLAC file has a
  # "REPLAYGAIN_TRACK_GAIN" tag, its value relative to the album gain will be
  # converted to the R128 reference level and stored in the "R128_TRACK_GAIN"
  # tag of the output Opus file.
  # Ref: https://github.com/xiph/opus-tools/blob/v0.2/src/flac.c#L179-L193
  #
  # Some media players might require ReplayGain to be turned off in order apply
  # the default output gain (i.e. the album gain) without applying the
  # additional track gain.
  opusenc --bitrate 128 --vbr --quiet "$input_file" "$output_file"
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
cd "$INPUT_DIR"
find . -type f -name "*.flac" | sort | parallel --progress 'doit {} {.}.opus'
