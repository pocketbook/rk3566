#!/bin/sh

if [ "$1" = connect ]; then
echo "$0 $1"
else
echo "$0 $1 - skip"
exit
fi

/ebrmain/bin/ota-config-update

