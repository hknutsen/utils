#! /bin/bash

set -eu

# Set system hostname
sudo hostname henrik-desktop

# TODO(@hknutsen): mount disks

# TODO(@hknutsen): restore Duplicity backup (`duplicity restore`)

################################################################################
# CONFIGURE GNOME (DESKTOP ENVIRONMENT)
################################################################################

# Tell dconf to synchronize the binary database with a plain text keyfile in
# ${XDG_CONFIG_HOME}/dconf/user.txt.
# Ref: https://wiki.gnome.org/Projects/dconf/SystemAdministrators
echo 'service-db:keyfile/user
user-db:user
system-db:local
system-db:site
system-db:distro' > /etc/dconf/profile/user

