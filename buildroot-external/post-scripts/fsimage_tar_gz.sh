#!/bin/bash -e


if [ ${BR2_POSTBUILD_FSIMAGE_TAR_GZ} = y ]; then
        # move /ebrmain/content to /ebrmain/fsimage.tar.gz
        mkdir -p ${TARGET_DIR}/ebrmain/content
        ( cd ${TARGET_DIR}/ebrmain/content && tar cz  --group=0 --owner=0 . ) > ${TARGET_DIR}/ebrmain/fsimage.tar.gz
        rm -rf ${TARGET_DIR}/ebrmain/content
fi

