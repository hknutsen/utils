#! /bin/bash

# Decodes audio from lossless FLAC files in the input directory and encodes to
# lossy Opus files in the output directory.
#
# Prerequisites:
#   parallel
#   opus-tools
#
# Globals:
#   FLAC_DIR
#   OPUS_DIR
#
# Usage:
#   ./encode_opus.sh

set -eu

NC='\033[0;37m'
YELLOW='\033[0;33m'
GREEN='\033[0;32m'

function doit {
  flac_file="$FLAC_DIR/$1"
  opus_file="$OPUS_DIR/$2"

  if [[ -f "$opus_file" ]]; then
    # If output Opus file already exists, skip.
    exit 0
  fi

  dir=$(dirname "$opus_file")
  if [[ ! -d "$dir" ]]; then
    mkdir -p "$dir"
  fi

  # According to the Xiph.Org Foundation (developers of Opus), "Opus at 128 KB/s
  # (VBR) is pretty much transparent".
  # Ref: https://wiki.xiph.org/Opus_Recommended_Settings#Recommended_Bitrates
  echo -e "${YELLOW}Converting '$flac_file' to '$opus_file'${NC}"
  opusenc --bitrate 128 --vbr --quiet "$flac_file" "$opus_file"

  # The Opus encoder provided by opus-tools will propagate tags from the input
  # FLAC file to the output Opus file, except "REPLAYGAIN_*" tags.
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
}

# Ensure the input directory exists.
if [[ ! -d "$FLAC_DIR" ]]; then
  echo "Input directory '$FLAC_DIR' does not exist"
  exit 1
fi

# Ensure the output directory exists.
if [[ ! -d "$OPUS_DIR" ]]; then
  mkdir -p "$OPUS_DIR"
fi

# Export variables and function, allowing child processes to inherit them.
export NC
export YELLOW
export -f doit

# Convert FLAC files to Opus files in parallel child processes.
cd "$FLAC_DIR"
find . -name '*.flac' -type f | sort | parallel --progress 'doit {} {.}.opus'
echo -e "${GREEN}Done!${NC}"
