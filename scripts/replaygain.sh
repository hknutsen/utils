#! /bin/bash

# Add Replay Gain tags to FLAC files in the source directory.
# Adds both title and album gains.
# All FLAC files in the source directory will be treated as an album.

set -eu

source_dir=$1

cd "$source_dir" || exit

readarray -t flac_files < <(find -- *.flac)

metaflac --add-replay-gain "${flac_files[@]}"
