#! /bin/bash

set -eu

# Set system hostname
sudo hostname henrik-desktop

# TODO(@hknutsen): mount disks

# TODO(@hknutsen): restore Duplicity backup (`duplicity restore`)

################################################################################
# CONFIGURE GNOME (DESKTOP ENVIRONMENT)
################################################################################

# Ref: https://wiki.gnome.org/Projects/dconf/SystemAdministrators
sudo echo 'service-db:keyfile/user
user-db:user
system-db:local
system-db:site
system-db:distro' > /etc/dconf/profile/user

echo 'Restart your computer to finish configuration of GNOME.'
