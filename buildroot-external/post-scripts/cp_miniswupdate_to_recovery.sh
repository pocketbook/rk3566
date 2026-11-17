#!/bin/bash -e

# Define log functions as plain echo if not already defined
declare -f INFO  >/dev/null || {
        TITLE() { echo "$@"; }
        INFO()  { echo "$@"; }
        WARN()  { echo "$@"; }
        ERROR() { echo "$@"; }
}

#BASE_DIR=/srv/Jenkins/workspace/BSP-rockchip.dev/buildroot/output/rockchip_635k3_recovery
RECOVERY_BASE_DIR=$(realpath $BASE_DIR)
ROOTFS_BASE_DIR=$(dirname $RECOVERY_BASE_DIR)/$(basename $RECOVERY_BASE_DIR | sed -e "s/_recovery$//")
cp -v ${ROOTFS_BASE_DIR}/images/updatefs/swupdate_mini $TARGET_DIR/usr/bin/swupdate
cp -v ${ROOTFS_BASE_DIR}/images/updatefs/libioc.so $TARGET_DIR/usr/lib/
cp -v ${ROOTFS_BASE_DIR}/images/updatefs/libhwconfig.so $TARGET_DIR/usr/lib/
cp -v ${ROOTFS_BASE_DIR}/images/updatefs/hwconfig.app $TARGET_DIR/usr/bin/
