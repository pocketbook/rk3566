#!/bin/bash -e

if [[ "$RK_WIFIBT_MODULES" =~ "skw" ]] ; then
	INFO "Copy SKW firmware files to rootfs"
	mkdir -p "$TARGET_DIR/lib/firmware"
	cp $RK_SDK_DIR/external/seekwave_wifibt/EA6621QF/firmware/* $TARGET_DIR/lib/firmware/
fi

