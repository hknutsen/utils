# Firmware

This document contains useful commands for managing firmware (UEFI or legacy BIOS) settings.

## Show firmware setup menu

Tell the firmware to show the setup menu on next boot, then shut down and reboot the system:

```bash
systemctl reboot --firmware-setup
```
