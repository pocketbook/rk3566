#!/bin/bash

if [ ${BR2_POSTBUILD_GEN_FONTCONFIG_CACHE} = y ]; then
# base at buildroot!
br_ext=../buildroot-external

#dir_=$(dirname $0)/..
path_=$br_ext/docker/fc-cache

set -ex

env
IMAGE=pocketbook_build:fc-cache-rk
docker load -i $path_/alpine_3.16.tgz 
docker build -t ${IMAGE}  --build-arg uid=$(id -u) $path_

ebrmain=$(realpath ${TARGET_DIR}/ebrmain)
fonts=$(realpath ${TARGET_DIR}/etc/fonts/)
mnt=$(realpath ${TARGET_DIR}/mnt/)
sysroot=${TARGET_DIR}


docker run  --rm -v "$ebrmain:/ebrmain/:ro" -v "$fonts:/etc/fonts/:ro" -v "$mnt:/mnt/:rw" -v "$sysroot:/sysroot:ro" -u jenkins  $IMAGE /fc-cache.sh

#${dir_}/docker/fc-cache/run.sh || exit 1
fi
