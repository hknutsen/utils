#! /bin/bash

set -eu

# Set system hostname
hostname henrik-desktop

# Disable mouse acceleration
gsettings set org.gnome.desktop.peripherals.mouse accel-profile 'flat'

# # Increase font scaling to 125% (since I think fonts are too small on 27" 1440p displays)
# gsettings set org.gnome.desktop.interface text-scaling-factor 1.25

# Always show accessibility menu in the top bar
gsettings set org.gnome.desktop.a11y always-show-universal-access-status true
