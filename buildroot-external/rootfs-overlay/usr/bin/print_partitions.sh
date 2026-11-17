#!/bin/sh

parted /dev/mmcblk0 unit b print | awk '/^ *[0-9]/ {printf("%08x %08x %s\n",$2/512,$4/512,$(NF))}'

