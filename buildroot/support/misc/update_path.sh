#!/bin/bash
SDK_PATH_PREFIX=$(realpath $(dirname $0)/../usr)
SDK_PATH_PREFIX_M=${SDK_PATH_PREFIX//\//\\\/}
find ${SDK_PATH_PREFIX}/lib/pkgconfig/ -name \*.pc | while read f
do 
	        sed -e "s/prefix=\/.*/prefix=${SDK_PATH_PREFIX_M}/" -i $f
	done

	SDK_PATH_PREFIX=$(realpath $(dirname $0)/../usr/local)
	SDK_PATH_PREFIX_M=${SDK_PATH_PREFIX//\//\\\/}
	find ${SDK_PATH_PREFIX}/lib/pkgconfig/ -name \*.pc | while read f
do 
	        sed -e "s/prefix=\/.*/prefix=${SDK_PATH_PREFIX_M}/" -i $f
	done
true
