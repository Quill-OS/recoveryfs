#!/bin/sh

/opt/recovery/scripts/update-splash &

rmmod g_mass_storage.ko
busybox-initrd losetup -P -f /tmp/update_storage/update_storage

mkdir -p /tmp/inkbox_userstore

mount /dev/mmcblk0p4 /tmp/inkbox_userstore
mount /dev/loop1 /tmp/update_mount

rm /tmp/inkbox_userstore/update/update.isa
mkdir -p /tmp/inkbox_userstore/update
cp /tmp/update_mount/update.isa /tmp/inkbox_userstore/update/
sync

echo "true" > /tmp/inkbox_userstore/opt/update/inkbox_updated
sync
sync

reboot -f
