#!/bin/sh
#
# Script to clean up all devices mounted under $CHROOT
#
#################################################################
CHROOT="${CHROOT:-/mnt/ec2-root}"

for BLK in $(mount | grep "${CHROOT}" | awk '{ print $3 }' | sort -r)
do
   umount "${BLK}"
done
exit 0
