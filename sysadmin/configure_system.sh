#! /bin/bash

set -eu

# Set system hostname
sudo hostname henrik-desktop

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
