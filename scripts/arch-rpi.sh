#!/bin/bash
# Per https://archlinuxarm.org/platforms/armv8/broadcom/raspberry-pi-3,
# install a 

if (( $# != 1 ))
then
  echo "Please provide the SD card /dev/ device as argument 1."
  exit 1
fi

dev="$1"

if df -h | grep $dev
then
  echo "$dev appears to be in use; aborting."
  exit 2
fi

set -x

# Set up filesystem

parted --script $dev mklabel msdos &&
  parted --script --align optimal $dev -- mkpart primary fat32 0% 100M set 1 lba &&
  parted --script --align optimal $dev -- mkpart primary ext4 100M 100%

mkdir -p /tmp/rpi && cd /tmp/rpi

mkfs.vfat ${dev}1
mkdir boot
mount ${dev}1 boot

mkfs.ext4 ${dev}2
mkdir -p root
mount ${dev}2 root

# Get base image
wget http://archlinuxarm.org/os/ArchLinuxARM-rpi-2-latest.tar.gz
bsdtar -xpf ArchLinuxARM-rpi-2-latest.tar.gz -C root
sync

mv root/boot/* boot

# TODO: Copy over arch-install.sh, invoke on first boot.

umount boot root

set +x
