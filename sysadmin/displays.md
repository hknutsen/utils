# Displays

This document contains useful commands for managing display settings.

## Set system monitors configuration

Copy the monitors configuration of the current user to the GNOME Display Manager (GDM) system monitors configuration:

```bash
sudo cp ~/.config/monitors.xml /var/lib/gdm/.config/monitors.xml
```

This ensures that the login screen uses the same primary display as the current user.
