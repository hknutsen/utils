#! /bin/bash

# Decodes audio from lossless FLAC files in the source directory and encodes to lossy Opus files in the target directory.
#
# Prereqs:
#   parallel
#   opus-tools
#   rsgain
# Arguments:
#   Source directory, a path.
#   Target directory, a path.
# Usage:
#   ./encode_opus.sh <SOURCE_DIR> <TARGET_DIR>
#   ./encode_opus.sh /mnt/Data/Music ~/Music/opus

set -eu

################################################################################
# Convert FLAC file to Opus.
# Globals:
#   OUTPUT_DIR
# Arguments:
#   FLAC_FILE, a name.
#   OPUS_FILE, a name.
# Outputs:
#   Writes output file path to stdout
################################################################################
function flac2opus {
  output_file="${OUTPUT_DIR}/$2"
  # According to the Xiph.Org Foundation (developers of Opus), "Opus at 128 KB/s (VBR) is pretty much transparent".
  # Ref: https://wiki.xiph.org/Opus_Recommended_Settings#Recommended_Bitrates (2024/04/03)
  opusenc --bitrate 128 --vbr --quiet "$1" "${output_file}"
  realpath "${output_file}"
}

if [[ ! -d "$1" ]]; then
  echo "Directory '$1' does not exist"
  exit 1
fi

if [[ ! -d "$2" ]]; then
  mkdir -p "$2"
fi

readonly SOURCE_DIR=$(realpath "$1")
readonly TARGET_DIR=$(realpath "$2")

# Export constants to environment
export OUTPUT_DIR

# Export functions to environment
export -f flac2opus

# Change to source directory.
cd "${SOURCE_DIR}"

# Find album directories.
readarray -t ALBUM_DIRS < <(find . -maxdepth 1 -type d)
readonly ALBUM_DIRS

for ALBUM_DIR in "${ALBUM_DIRS[@]}"; do
  # Change to album directory.
  cd "${SOURCE_DIR}/${ALBUM_DIR}"

  # Find FLAC files.
  readarray -t flac_files < <(find . -maxdepth 1 -type f -name "*.flac")

  # If no FLAC files found, skip this directory.
  if [[ "${#flac_files[@]}" -eq 0 ]]; then
    continue
  fi

  # Set output directory, and ensure it exists.
  $OUTPUT_DIR="${TARGET_DIR}/${ALBUM_DIR}"
  if [[ ! -d "${OUTPUT_DIR}" ]]; then
    mkdir -p "${OUTPUT_DIR}"
  fi

  # Convert FLAC files to Opus.
  readarray -t opus_files < <(parallel 'flac2opus {} {.}.opus' ::: "${flac_files[@]}")

  # Calculate track and album gain, and write RFC 7845 standard tags.
  # Ref: https://datatracker.ietf.org/doc/html/rfc7845#section-5.2.1 (2024/04/16)
  rsgain custom --album --tagmode=i --opus-mode=s --quiet "${opus_files[@]}"
done
