#!/bin/bash

if [ $# -ne 1 ] && [ $# -ne 2 ]; then
  echo "Usage: $0 VolumeName [MountPoint]"
  echo "MountPoint will be created if it does not exist, defaults to ~/Desktop/Drive"
  exit 1
fi

if [ $# -eq 1 ]; then
  MNT="${HOME}/Desktop/Drive"
else
  MNT=$2
fi

DEV=`mount | grep "^/dev/[[:alnum:]]* on /Volumes/$1" | sed 's:\(/dev/[[:alnum:]]*\).*:\1:'`
if [ "$DEV" = "" ]; then
  echo "Volume not found $1"
  exit 1
fi

echo "Will remount $DEV. Y/N? [N]"
read -n1 yn
if [ "$yn" != "Y" ] && [ "$yn" != "y" ]; then
  echo -e "\nAborting"
  exit 1
fi
echo -e "\n"

sudo umount $DEV
if [ ! -d $MNT ]; then
  echo "Creating $MNT"
  mkdir $MNT
fi

sudo mount -t ntfs -o rw,auto,nobrowse $DEV $MNT && echo "Sucess! Don't forget to eject the drive through finder"
