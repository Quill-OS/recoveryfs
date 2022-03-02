#!/bin/sh

# Mounting user storage device
mount /dev/mmcblk0p4 /mnt

# Deleting old config and making space for the stock values
rm -rf /mnt/config
mkdir -p /mnt/config

# Extracting the default config
cd /mnt/config && busybox-initrd tar -xf /opt/recovery/restore/config.tar.xz
cd /opt/recovery

# Unmounting user storage device
umount -l -f /mnt

# Syncing disks
sync

# Rebooting
reboot
