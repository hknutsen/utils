#! /bin/bash

# Decodes audio from lossless FLAC files in the source directory and
# encodes to lossy Opus files in the target directory.
# Prerequisites:
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

function doit {
  opusenc --bitrate 128 --vbr --quiet "$INPUT_DIR/$1" "$OUTPUT_DIR/$2"
}

if [[ ! -d "$1" ]]; then
  echo "Directory '$1' does not exist"
  exit 1
fi
SOURCE_DIR=$(realpath "$1")
readonly SOURCE_DIR

# TODO: check that TARGET_DIR is empty to prevent overriding existing files
if [[ ! -d "$2" ]]; then
  mkdir -p "$2"
fi
TARGET_DIR=$(realpath "$2")
readonly TARGET_DIR

# Export variables and functions to environment
export INPUT_DIR
export OUTPUT_DIR
export -f doit

# Find album directories.
cd "${SOURCE_DIR}"
readarray -t ALBUM_DIRS < <(find . -maxdepth 1 -type d | sort)
readonly ALBUM_DIRS

for ALBUM_DIR in "${ALBUM_DIRS[@]}"; do
  # Set input directory and find FLAC files.
  # If input directory doesn't contain any FLAC files, skip.
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

  # According to the Xiph.Org Foundation (developers of Opus), "Opus at 128 KB/s (VBR) is pretty much transparent".
  # Ref: https://wiki.xiph.org/Opus_Recommended_Settings#Recommended_Bitrates (2024/04/03)
  echo "Converting FLAC files in '$INPUT_DIR' to Opus in '$OUTPUT_DIR'..."
  parallel "doit {} {.}.opus" ::: "${flac_files[@]}"
done

echo "Calculating gain in '$TARGET_DIR'..."
rsgain easy -m MAX "$TARGET_DIR"
