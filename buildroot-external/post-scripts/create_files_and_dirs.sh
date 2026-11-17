#!/bin/bash -e
mkdir -p "$TARGET_DIR/mnt/ext1"
mkdir -p "$TARGET_DIR/mnt/ext2"
mkdir -p "$TARGET_DIR/mnt/secure"

rm -f "$TARGET_DIR/ebrmain" && ln -s usr "$TARGET_DIR/ebrmain"

echo "PocketBook${BR2_PB_DEVICE//\"/}" > $TARGET_DIR/etc/devicename 
date +%Y%m%d_%H%M%S  > $TARGET_DIR/etc/create_time
