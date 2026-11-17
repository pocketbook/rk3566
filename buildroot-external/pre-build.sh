#!/bin/bash -e

THIS_SCRIPT="$(realpath $0)"

function TITLE() { echo -e ">>>   \033[32m$@\033[0m" ; }
function INFO()  { echo -e ">>>     $@" ; }
function WARN()  { echo -e ">>>     \033[33m$@\033[0m" ; }
function ERROR() { echo -e ">>>     \033[31m$@\033[0m" ; }

export -f INFO WARN ERROR

eval export $(grep "^BR2_[A-Za-z0-9_]*=" "$BR2_CONFIG")

SCRIPTLIST=$(grep ^BR2_PREBUILD_ "$BR2_CONFIG" | sed 's/^BR2_PREBUILD_//g;s/=.*//g')

for SCRIPT in $SCRIPTLIST ; do
        SCRIPTPATH="${THIS_SCRIPT%/*}/pre-scripts/${SCRIPT,,}.sh"
        if [ -f "$SCRIPTPATH" ] ; then
                TITLE "running pre-build script: ${SCRIPT,,}"
                $SCRIPTPATH
                if [ $? != 0 ] ; then
                        ERROR "script $SCRIPT failed!!!"
                        exit 1
                fi
        else
                ERROR "pre-build script ${SCRIPT,,} not found!"
                exit 1
        fi
done

