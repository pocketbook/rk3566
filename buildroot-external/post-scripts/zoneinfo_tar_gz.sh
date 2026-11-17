#!/bin/bash -e

function INFO()  { echo -e ">>>     $@" ; }

if [ ${BR2_POSTBUILD_ZONEINFO_TAR_GZ} = y ]; then
        mkdir -p zoneinfo.dir
        rm -rf zoneinfo.dir/*
        cat ${TARGET_DIR}/ebrmain/share/zoneinfo.lst | strings | sed -e "s/.[0-9][0-9]:[0-9][0-9] //" | \
        while read zone_name
        do
                find ${TARGET_DIR}/usr/share/zoneinfo/ -name ${zone_name// /_} | xargs -i% cp -v "%" "zoneinfo.dir/${zone_name}"
        done
        (cd zoneinfo.dir && tar cz *) > ${TARGET_DIR}/ebrmain/share/zoneinfo.tar.gz
fi
