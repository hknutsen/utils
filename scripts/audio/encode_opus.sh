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
# Convert input file to Opus.
# Globals:
#   OUTPUT_DIR
# Arguments:
#   Input file, a name.
#   Output file, a name.
# Outputs:
#   Writes output file path to stdout
################################################################################
function convert_to_opus {
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
SOURCE_DIR=$(realpath "$1")
readonly SOURCE_DIR

if [[ ! -d "$2" ]]; then
  mkdir -p "$2"
fi
TARGET_DIR=$(realpath "$2")
readonly TARGET_DIR

# Export constants and functions to environment
export INPUT_DIR
export OUTPUT_DIR
export -f convert_to_opus

# Find album directories.
cd "${SOURCE_DIR}"
readarray -t ALBUM_DIRS < <(find . -maxdepth 1 -type d | sort)
readonly ALBUM_DIRS

for ALBUM_DIR in "${ALBUM_DIRS[@]}"; do
  # Find FLAC files in album directory.
  # If album directory doesn't contain any FLAC files, skip and continue loop.
  INPUT_DIR=$(realpath "${SOURCE_DIR}/${ALBUM_DIR}")
  cd "$INPUT_DIR"
  readarray -t flac_files < <(find . -maxdepth 1 -type f -name "*.flac" | sort)
  if [[ "${#flac_files[@]}" -eq 0 ]]; then
    continue
  fi

  # Set output directory, and ensure it exists.
  OUTPUT_DIR=$(realpath "${TARGET_DIR}/${ALBUM_DIR}")
  if [[ ! -d "${OUTPUT_DIR}" ]]; then
    mkdir -p "${OUTPUT_DIR}"
  fi

  # Convert FLAC files to Opus.
  echo "Converting FLAC files in '$INPUT_DIR' to Opus in '$OUTPUT_DIR'"
  readarray -t opus_files < <(parallel 'convert_to_opus {} {.}.opus' ::: "${flac_files[@]}")

  # Calculate track and album gain, and write RFC 7845 standard tags.
  # Ref: https://datatracker.ietf.org/doc/html/rfc7845#section-5.2.1 (2024/04/16)
  echo "Calculating track and album gain in '$OUTPUT_DIR'"
  rsgain custom --album --tagmode=i --opus-mode=s --quiet "${opus_files[@]}"
done
