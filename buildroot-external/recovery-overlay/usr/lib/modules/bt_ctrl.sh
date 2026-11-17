#!/bin/sh
[ -z $1 ] && exit 1

CMD=$1
PRM=$2
case $CMD in
on )
        echo -n "Load BT modules ... "
        if [ -n "$PRM" ]; then
            insmod "/lib/modules/skwbt.ko" $PRM || { echo "fail" ; exit 2 ; }
        else
            insmod "/lib/modules/skwbt.ko" || { echo "fail" ; exit 2 ; }
        fi
        echo -e -n "OK\nEnable BT power ... "
        echo 1 > "$(find /sys/class/bluetooth/hci0/ -maxdepth 1 -type d -name 'rfkill*')/state" || { echo "fail" ; exit 3 ; }
        echo -e -n "OK\nLoad BT firmware ... "
        #second parameter with command "on" can be MAC address
#        [ -n "$2" ] && echo "$2" > "/var/run/btmac"
#        echo 1 >/proc/bluetooth/sleep/lpm || { echo "fail" ; exit 4 ; }
#        aic_hciattach -s 1500000 ttyS1 aic || { echo "fail" ; exit 5 ; }
        echo -e "OK"
        ;;
off )
        fail=
        echo -n "Disable BT power ... "
#        killall aic_hciattach ||  { echo "fail" ; fail=1 ; }
#        echo 0 >/proc/bluetooth/sleep/lpm || { echo "fail" ; fail=2 ; }
        echo 0 > "$(find /sys/class/bluetooth/hci0/ -maxdepth 1 -type d -name 'rfkill*')/state" || { echo "fail" ; exit 3 ; }
        rmmod "/lib/modules/skwbt.ko" || { echo "fail" ; fail=4 ; }
        [ -n "$fail" ] && exit $fail
        echo "OK"
        ;;

start )
        [ -d /mnt/secure/bluetooth ] || mkdir -p /mnt/secure/bluetooth
        [ -L /var/lib/bluetooth ] || ln -s /mnt/secure/bluetooth /var/lib/bluetooth
        echo "Start BT services:"
        echo -e -n "\tbluetoothd ... "
        /usr/libexec/bluetooth/bluetoothd -E -d -n &
        sleep 2
        echo -e -n "OK\n\tbluealsa ... "
        /usr/bin/bluealsa -p a2dp-source &
        sleep 1
        echo -e -n "OK\n\tbluetooth agent ... "
        /usr/bin/bluetooth_agent_app &
        echo -e -n "OK\n\tavrcp manager ... "
        /usr/bin/avrcp_dbus_manager &
        echo "OK"
        ;;
stop )
        echo -n -e "Stop BT services ... "
        killall bluealsa
        killall bluetooth_agent_app
        killall avrcp_dbus_manager
        killall bluetoothd
        sleep 1
        echo "OK"
        ;;
* )
        echo "Unknown command"
        exit 1
        ;;
esac
