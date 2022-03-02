#!/bin/sh

cat /sys/devices/platform/fsl-usb2-udc/gadget/suspended > /tmp/usbevent sleep 1
