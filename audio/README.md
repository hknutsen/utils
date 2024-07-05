# Audio utility scripts

## Prerequisites

Set environment variables `FLAC_DIR` and `OPUS_DIR`. For example:

```bash
export FLAC_DIR="/mnt/Data/$(whoami)/Music/FLAC"
export OPUS_DIR="/mnt/Data/$(whoami)/Music/Opus"
```

If you're on Windows Subsystem for Linux (WSL), disks are usually mounted by the Windows drive letter. For example, the Windows drive `D:\` would be mounted at `/mnt/d` in WSL:

```bash
export FLAC_DIR="/mnt/d/Music/FLAC"
export OPUS_DIR="/mnt/d/Music/Opus"
```

Append to `~/.bashrc` to set permanently.
