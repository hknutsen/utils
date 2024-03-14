#! /bin/bash

# Mounts my media disk in read-only mode to prevent accidental write operations.
#
# Usage:
# - mount: ./mount_media_disk.sh
# - unmount: ./mount_media_disk.sh -u

unmount=false
while getopts u opt; do
    case $opt in
      u) unmount=true
        ;;

      *) exit 1
        ;;
    esac
done

label="Media"
filesystem=$(sudo blkid -o list | grep "$label" | cut -d ' ' -f 1)
mount="/run/media/$(whoami)/$label"

if [[ "$unmount" == true ]]; then
  echo "Unmounting $filesystem from $mount"
  sudo umount "$mount"
else
  if [[ ! -d "$mount" ]]; then
    echo "Creating directory $mount"
    sudo mkdir "$mount"
  fi
  echo "Mounting $filesystem to $mount"
  sudo mount -o ro "$filesystem" "$mount"
fi
