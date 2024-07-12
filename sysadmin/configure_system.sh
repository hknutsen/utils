#! /bin/bash

set -eu

################################################################################
# CONFIGURE DISKS
################################################################################
disk_config='/etc/fstab'
disk_labels=('Data' 'Backup') # Auto-mount disks with these labels
for label in "${disk_labels[@]}"; do
  line="LABEL=$label /mnt/$label auto nosuid,nodev,nofail,x-gvfs-show 0 0"
  # Use grep to check if disk is already configured for auto-mount
  grep -qF -- "$line" "$disk_config" ||
  echo "$line" | sudo tee -a "$disk_config" > /dev/null
done
sudo mount -a # Mount all disks configured for auto-mount

################################################################################
# CONFIGURE GNOME (DESKTOP ENVIRONMENT)
################################################################################

# Tell dconf to synchronize the binary database with a plain text keyfile in
# ~/.config/dconf/user.txt. This allows us to backup and restore our GNOME
# settings using deja-dup.
# Ref: https://wiki.gnome.org/Projects/dconf/SystemAdministrators
echo 'service-db:keyfile/user
user-db:user
system-db:local
system-db:site
system-db:distro' |
sudo tee /etc/dconf/profile/user > /dev/null
