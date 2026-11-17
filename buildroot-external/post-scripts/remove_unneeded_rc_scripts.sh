#!/bin/bash -e
set -x

cd ${TARGET_DIR}/etc/init.d
rm -f *syslogd* *klogd* *sysctl* *async-commit* *bluetoothd* *dhcpcd* *chrony* *dropbear* *rkebc* fuse3

