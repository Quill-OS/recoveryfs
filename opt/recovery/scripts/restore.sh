#!/bin/sh

DEVICE=$(cat /opt/device)

/opt/recovery/scripts/restore-splash &

yes | /opt/e2fsprogs/sbin/mkfs.ext4 /dev/mmcblk0p3 -O "^metadata_csum" -F
e2label "/dev/mmcblk0p3" "rootfs"
yes | /opt/e2fsprogs/sbin/mkfs.ext4 /dev/mmcblk0p4 -O "^metadata_csum" -F
e2label "/dev/mmcblk0p4" "user"

mount -t ext4 /dev/mmcblk0p3 /mnt

cd /mnt
busybox-initrd tar -xf /opt/recovery/restore/rootfs-part.tar.xz
sync
cd /opt/recovery
umount -l -f /mnt
mount -t ext4 /dev/mmcblk0p4 /mnt
cd /mnt
busybox-initrd tar -xf /opt/recovery/restore/userstore.tar.xz
sync

# According to the user's choice, we extract the desired backing file for the onboard storage
if [ "${1}" == "64" ]; then
        busybox-initrd tar -xf /opt/recovery/restore/onboard/onboard-64M.tar.gz
fi
if [ "${1}" == "256" ]; then
        busybox-initrd tar -xf /opt/recovery/restore/onboard/onboard-256M.tar.gz
fi
if [ "${1}" == "512" ]; then
        busybox-initrd tar -xf /opt/recovery/restore/onboard/onboard-512M.tar.gz
fi
if [ "${1}" == "1024" ]; then
        busybox-initrd tar -xf /opt/recovery/restore/onboard/onboard-1024M.tar.gz
fi
if [ "${1}" == "2048" ]; then
        busybox-initrd tar -xf /opt/recovery/restore/onboard/onboard-2048M.tar.gz
fi
sync
sync

cd /opt/recovery
sync
umount -l -f /mnt
sync

# We reset the boot partition and we have to set the FIRST_BOOT flag
umount /dev/mmcblk0p1
yes | /opt/e2fsprogs/sbin/mkfs.ext4 /dev/mmcblk0p1 -O "^metadata_csum" -F
e2label "/dev/mmcblk0p1" "boot"
mount -t ext4 /dev/mmcblk0p1 /boot
mkdir -p /boot/flags
mkdir -p /boot/boot
sync

# Factory reset; lock down the device and disable root access
echo "noroot" > /tmp/root_flag
sync
dd if=/tmp/root_flag of=/dev/mmcblk0 bs=512 seek=79872
sync
rm -f /tmp/root_flag

# Flashing U-Boot bootloader
if [ "${DEVICE}" != "n306" ]; then
	dd if=/opt/recovery/restore/u-boot_inkbox.bin of=/dev/mmcblk0 bs=1K seek=1 skip=1
else
	dd if=/opt/recovery/restore/u-boot_inkbox.bin of=/dev/mmcblk0 bs=1K seek=1
fi

# Flashing kernel and copying it to the boot partition for utility purposes
cp /opt/recovery/restore/uImage-std /boot/boot
dd if=/opt/recovery/restore/uImage-std of=/dev/mmcblk0 bs=512 seek=81920
sync

# Setting some flags
echo "true" > /boot/flags/FIRST_BOOT
echo "true" > /boot/flags/X11_START
echo "false" > /boot/flags/WILL_UPDATE
echo "false" > /boot/flags/KERNEL_FLASH
echo "false" > /boot/flags/USBNET_ENABLE
echo "false" > /boot/flags/DIAGS_BOOT

sync

# Displaying welcome image and powering off
busybox-initrd killall restore-splash
/opt/recovery/scripts/inkbox-welcome
poweroff
