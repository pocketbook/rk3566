#!/bin/sh
[ -z $1 ] && exit 1


echo -n "Set Playback Path = $1"
 
amixer -c 0 sset "Playback Path" $1
