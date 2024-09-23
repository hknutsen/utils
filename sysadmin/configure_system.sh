#! /bin/bash

set -eu

readonly FILESYSTEM_LABELS=('Data' 'Backup') # Filesystems to auto-mount

################################################################################
# CONFIGURE FILESYSTEMS (DISKS)
################################################################################
for label in "${FILESYSTEM_LABELS[@]}"; do
  mount_point="/mnt/$label"
  # Set read, write and execute permissions for owner, group and others at
  # mount point. Permissions are defined in numerical format.
  sudo chmod 0777 "$mount_point"
done
sudo systemctl daemon-reload # Reload daemon to read updated fstab file
sudo mount --all # Mount all disks configured in fstab file
