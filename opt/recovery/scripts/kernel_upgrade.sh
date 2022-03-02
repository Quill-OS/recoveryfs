#!/bin/sh

/opt/recovery/scripts/update-splash &

rmmod g_mass_storage.ko
busybox-initrd losetup -P -f /tmp/update_storage/update_storage

mount /dev/loop1 /tmp/update_mount

# Flashing new kernel
dd if=/tmp/update_mount/uImage of=/dev/mmcblk0 bs=512 seek=81920
sync

reboot
