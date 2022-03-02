#!/bin/sh

mkdir /tmp/update_storage
mount -t tmpfs tmpfs -o size=140M /tmp/update_storage
cd /tmp/update_storage && busybox-initrd tar -xf /opt/recovery/update/update_storage.tar.gz
mkdir /tmp/update_mount

rmmod g_ether.ko

insmod /modules/arcotg_udc.ko
insmod /modules/g_mass_storage.ko file=/tmp/update_storage/update_storage removable=y stall=0
