#! /bin/bash

set -eu

# Set system hostname
hostname henrik-desktop

################################################################################
# CONFIGURE GNOME (DESKTOP ENVIRONMENT)
################################################################################

# Disable mouse acceleration
gsettings set org.gnome.desktop.peripherals.mouse accel-profile 'flat'

# Always show accessibility menu in the top bar
gsettings set org.gnome.desktop.a11y always-show-universal-access-status true
