#! /bin/bash

set -eu

################################################################################
# CONFIGURE DISKS
################################################################################
fstab_file='/etc/fstab'
disk_labels=('Data' 'Backup') # Auto-mount disks with these labels
for label in "${disk_labels[@]}"; do
  mount_point="/mnt/$label"
  if [[ ! -d "$mount_point" ]]; then
    echo "Creating directory $mount_point"
    sudo mkdir -p "$mount_point"
  fi
  line="LABEL=$label $mount_point auto nosuid,nodev,nofail,x-gvfs-show 0 0"
  # Use grep to check if disk is already configured for auto-mount
  grep --quiet --fixed-strings -- "$line" "$fstab_file" ||
  echo "$line" | sudo tee --append "$fstab_file" > /dev/null
done
systemctl daemon-reload # Reload systemctl daemon to read updated fstab file
sudo mount --all # Mount all disks configured in fstab file

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
