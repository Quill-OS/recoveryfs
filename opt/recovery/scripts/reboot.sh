#!/bin/sh

export LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:/opt/bin/fbink"

sleep 2
/opt/bin/fbink/fbink -k -f -h -w
/opt/bin/fbink/fbink -k -f -w
/opt/bin/fbink/fbink -t regular=/opt/fonts/inter-b.ttf,size=20 "Rebooting" -m -M -w
sync
reboot -f
