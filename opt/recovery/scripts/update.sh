#!/bin/sh

mkdir /tmp/update_storage
mount -t tmpfs tmpfs -o size=140M /tmp/update_storage
cd /tmp/update_storage && busybox-initrd tar -xf /opt/recovery/update/update_storage.tar.gz
mkdir /tmp/update_mount

rmmod g_ether.ko

if [ "${DEVICE}" != "n873" ] && [ "${DEVICE}" != "n236" ] && [ "${DEVICE}" != "n437" ] && [ "${DEVICE}" != "n306" ] && [ "${DEVICE}" != "emu" ] && [ "${DEVICE}" != "bpi" ]; then
	insmod /modules/arcotg_udc.ko
fi
if [ "${DEVICE}" == "n306" ] || [ "${DEVICE}" == "n873" ]; then
	insmod /modules/fs/configfs/configfs.ko
	insmod /modules/drivers/usb/gadget/libcomposite.ko
	insmod /modules/drivers/usb/gadget/function/usb_f_mass_storage.ko
fi
insmod /modules/g_mass_storage.ko file=/tmp/update_storage/update_storage removable=y stall=0
