#!/bin/sh

DO_FACTORY_RESET=`cat /boot/flags/DO_FACTORY_RESET 2>/dev/null`
DO_SOFT_RESET=`cat /boot/flags/DO_SOFT_RESET 2>/dev/null`
DEVICE=`cat /opt/device`

if [ "$DEVICE" == "n705" ] || [ "$DEVICE" == "n905b" ] || [ "$DEVICE" == "n905c" ]; then
	DPI=187
elif [ "$DEVICE" == "n613" ]; then
	DPI=215
else
	DPI=187
fi


if [ "$DO_FACTORY_RESET" == "true" ]; then
	# Restoring standard size, 512 MiB onboard storage
	/opt/recovery/scripts/restore.sh 512
elif [ "$DO_SOFT_RESET" == "true" ]; then
	# Wipe onboard storage, but keep current firmware version
	/opt/recovery/scripts/soft-reset.sh
else
	echo 0 > /sys/class/leds/pmic_ledsb/brightness
	cd /opt/recovery
	QT_FONT_DPI=$DPI QTPATH=/opt/qt-linux-5.15.2-kobo/  LD_LIBRARY_PATH=${QTPATH}lib:lib: QT_QPA_PLATFORM=kobo:touchscreen_rotate=90:touchscreen_invert_x=auto:touchscreen_invert_y=auto:logicaldpitarget=0 ./inkbox-recovery
fi
