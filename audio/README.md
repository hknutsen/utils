# Audio scripts

This directory contains scripts for conversion of audio files.

## Prerequisites

Set environment variables `FLAC_DIR` and `OPUS_DIR`, for example:

```bash
export FLAC_DIR="/mnt/Data/$(whoami)/Music/FLAC"
export OPUS_DIR="/mnt/Data/$(whoami)/Music/Opus"
```

Append to `~/.bashrc` to set permanently.

## Usage

### Convert cover files for embedding

Convert all `cover.jpg` files in `FLAC_DIR` to `cover_600px.jpg` files, which will be used by MusicBrainz Picard for embedding in FLAC files:

```bash
./convert_cover.sh
```

Will be irreleveant if MusicBrainz Picard implements cover art image processing options (see [relevant ticket](https://tickets.metabrainz.org/browse/PICARD-2121)).

### Re-encode FLAC files

Re-encode all FLAC files in `FLAC_DIR` using the latest version of the FLAC encoder:

```bash
./encode_flac.sh
```

### Convert FLAC files to Opus

Convert all FLAC files in `FLAC_DIR` to Opus files in `OPUS_DIR`:

```bash
./encode_opus.sh
```
