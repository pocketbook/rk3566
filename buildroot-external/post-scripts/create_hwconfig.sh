#!/bin/bash -e

# Define log functions as plain echo if not already defined
declare -f INFO  >/dev/null || {
        TITLE() { echo "$@"; }
        INFO()  { echo "$@"; }
        WARN()  { echo "$@"; }
        ERROR() { echo "$@"; }
}

if [ -z "${RK_OUTDIR}" ] ; then
	INFO "Skip $0"
	exit 0
fi

if [ -z $TARGET_DIR ]; then
        TARGET_DIR=$RK_SDK_DIR/buildroot/output/$RK_BUILDROOT_CFG/target
fi

if [ "$BR2_HWCONFIG_VALUE" -gt 0 ] ; then
        INFO "HWCONFIG value: $BR2_HWCONFIG_VALUE"
        rm -f "$TARGET_DIR/etc/hwconfig"
        echo -en "`printf '%cx%02x%cx%02x' '\\' $(((BR2_HWCONFIG_VALUE%16)*16+10)) '\\' $((BR2_HWCONFIG_VALUE/16))`\0\0\0\0\0\0" >"$TARGET_DIR/etc/hwconfig"
elif [ -L "$TARGET_DIR/etc/hwconfig" ] ; then
	INFO "HWCONFIG is a link to $(readlink $TARGET_DIR/etc/hwconfig)"
        if [ -n "$BR2_HWCONFIG_PBENV_VALUE" ]; then
                INFO "Gen $RK_FIRMWARE_DIR/pbenv.img from $BR2_HWCONFIG_PBENV_VALUE"
                dd if=/dev/zero of="$RK_FIRMWARE_DIR/pbenv.img" bs=64K count=1
                # Use 'xxd -r -p' to convert hex to binary
                echo "$BR2_HWCONFIG_PBENV_VALUE" | xxd -r -p | dd conv=notrunc of="$RK_FIRMWARE_DIR"/pbenv.img
        fi
else
        ERROR "HWCONFIG value is not defined, and no hwconfig written to rootfs!"
fi

