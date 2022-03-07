#!/bin/sh

# Splash screen
/opt/recovery/scripts/restore-splash &

mount /dev/mmcblk0p4 /mnt

cd /mnt
rm onboard
sync

# Restoring standard onboard storage backing file
busybox-initrd tar -xf /opt/recovery/restore/onboard/onboard-512M.tar.gz
sync

cd /opt/recovery

umount /mnt

# Set some flags
echo "true" > /boot/flags/FIRST_BOOT
echo "false" > /boot/flags/WILL_UPDATE
echo "false" > /boot/flags/KERNEL_FLASH
echo "false" > /boot/flags/USBNET_ENABLE
echo "false" > /boot/flags/DIAGS_BOOT
echo "false" > /boot/flags/DO_FACTORY_RESET
echo "false" > /boot/flags/DO_SOFT_RESET

# Reset the configuration files
# Mounting user storage device
mount /dev/mmcblk0p4 /mnt

# Deleting old config and making space for the stock one
rm -rf /mnt/config
mkdir -p /mnt/config

# Extracting the default config
cd /mnt/config && busybox-initrd tar -xf /opt/recovery/restore/config.tar.xz
cd /opt/recovery

# Wiping X11 overlay data
rm -rf /mnt/X11/rootfs/write
rm -rf /mnt/X11/rootfs/work
mkdir -p /mnt/X11/rootfs/work
mkdir -p /mnt/X11/rootfs/write

# Unmounting user storage device
umount /dev/mmcblk0p4

# Wiping rootfs overlay data
mount /dev/mmcblk0p3 /mnt
rm -rf /mnt/rootfs/write
rm -rf /mnt/rootfs/work
mkdir -p /mnt/rootfs/work
mkdir -p /mnt/rootfs/write

# Syncing disks
sync

# Displaying welcome image and powering off
busybox-initrd killall restore-splash
/opt/recovery/scripts/inkbox-welcome
poweroff
