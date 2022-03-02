#!/bin/sh

mkdir -p /dev/pts
mount -t devpts devpts /dev/pts

insmod /modules/arcotg_udc.ko
insmod /modules/g_ether.ko

ifconfig usb0 up
ifconfig usb0 192.168.2.2
busybox-initrd telnetd -F &
