#! /bin/bash

set -eu

readonly HOSTNAME='henrik-desktop'
readonly FILESYSTEM_LABELS=('Data' 'Backup') # Filesystems to auto-mount

readonly NC='\033[0;37m'
readonly YELLOW='\033[0;33m'
readonly GREEN='\033[0;32m'

################################################################################
# CONFIGURE HOSTNAME
################################################################################
echo -e "${YELLOW}Configuring hostname...${NC}"
hostnamectl set-hostname "$HOSTNAME"

################################################################################
# CONFIGURE FILESYSTEMS (DISKS)
################################################################################
echo -e "${YELLOW}Configuring filesystems...${NC}"
fstab_file='/etc/fstab' # Filesystem Table file
for label in "${FILESYSTEM_LABELS[@]}"; do
  mount_point="/mnt/$label"
  if [[ ! -d "$mount_point" ]]; then
    echo "Creating directory $mount_point"
    sudo mkdir -p "$mount_point"
  fi
  line="LABEL=$label $mount_point auto nosuid,nodev,nofail,x-gvfs-show 0 0"
  # Check if disk is already configured for auto-mount
  grep --quiet --fixed-strings -- "$line" "$fstab_file" ||
  echo "$line" | sudo tee --append "$fstab_file" > /dev/null
done
sudo systemctl daemon-reload # Reload daemon to read updated fstab file
sudo mount --all # Mount all disks configured in fstab file

################################################################################
# CONFIGURE GNOME (DESKTOP ENVIRONMENT)
################################################################################
echo -e "${YELLOW}Configuring GNOME (desktop environment)...${NC}"
# Tell dconf to synchronize the binary database with a plain text keyfile in
# ~/.config/dconf/user.txt. This allows us to backup and restore our GNOME
# settings using deja-dup.
# Ref: https://wiki.gnome.org/Projects/dconf/SystemAdministrators
echo 'service-db:keyfile/user
user-db:user
system-db:local
system-db:site
system-db:distro' | sudo tee /etc/dconf/profile/user > /dev/null

echo -e "${GREEN}Done!${NC}"
