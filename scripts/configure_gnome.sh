#! /bin/bash

set -eu

# Disable mouse acceleration
gsettings set org.gnome.desktop.peripherals.mouse accel-profile 'flat'

# Increase font scaling to 125% (since I think fonts are too small on 27" 1440p displays)
gsettings set org.gnome.desktop.interface text-scaling-factor 1.25
# # Increase cursor size for same reason as above
# gsettings set org.gnome.desktop.interface cursor-size 32
