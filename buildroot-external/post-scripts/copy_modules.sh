#!/bin/bash -e

KERNEL_DIR="$(realpath "$(dirname "$0")/../../kernel")"

find $KERNEL_DIR -name '*.ko' | while read M ; do
	INFO "* ${M##*/}"
	[ -d $TARGET_DIR/lib/modules/ ] || mkdir -p $TARGET_DIR/lib/modules 
	cp "$M" $TARGET_DIR/lib/modules/
done

