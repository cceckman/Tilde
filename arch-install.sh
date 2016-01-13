#!/bin/bash
## Bootstrap an Arch system.

# Scriptification of:
# https://wiki.archlinux.org/index.php/Hyper-V
# https://wiki.archlinux.org/index.php/Installation_guide.

set -x

# Turn on some base services: 
timedatectl set-ntp true # enable NTP-based time.

# Set up the disk: use GPT (rather than MBR); leave 1MiB for GRUB; and leave 8GB for swap.
parted --script /dev/sda mklabel gpt
parted --script --align optimal /dev/sda -- mkpart primary 0% 1M set 1 bios_grub on name 1 grub
parted --script --align optimal /dev/sda -- mkpart primary ext4 1M -8GiB name 2 root
parted --script --align optimal /dev/sda -- mkpart primary linux-swap -8GiB 100% name 3 swap

# Format root partition and swap
mkfs -t ext4 /dev/sda2 && mount /dev/sda2 /mnt
mkswap /dev/sda3 && swapon /dev/sda3


# Update mirror list and package DB. This isn’t the most optimal assignment, but good enough till we get really started.
cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup # back up mirror list
curl -o - ‘https://www.archlinux.org/mirrorlist/?country=US&protocol=https&ip_version=4&ip_version=6&use_mirror_status=on’ | sed ‘s/#Server/Server/’ > /tmp/mirrorlist
rankmirrors -n 10 /tmp/mirrorlist > /etc/pacman.d/mirrorlist # only grab top 10 mirrors
pacman --noconfirm -Syyu # update databases and system packages
pacman --noconfirm -Scc # clean up space

# Install...
pacstrap /mnt base
# Wait...

# Generate /etc/fstab, and hop in.
genfstab -p /mnt >> /mnt/etc/fstab
arch-chroot /mnt # BREAK; this should call "iteration two" of this script, i.e. the stuff below.

exit ## BREAK; TODO(cceckman) Run the below as part of arch-chroot /mnt $script, then shutdown

echo "Hostname? "
echo -n ">"
read hostname
echo "$hostname" > /etc/hostname

# Set locale settings
# Ignore time zone; we run in UTC
ln -s /usr/share/zoneinfo/UTC /etc/localtime
sed -i 's/^#en_US/en_US/' /etc/locale.gen && locale-gen
echo LANG=en_US > /etc/locale.conf
# OK with default elsewhere

# Make init RAM disk.
# Make sure startup modules includes Hyper-V modules... which is OK even if we aren't under Hyper-V.
hv_modules="hv_vmbus hv_storvsc hv_netvsc hv_utils hv_balloon"
sed -i "s/^MODULES=\"/MODULES=\"$hv_modules /" /etc/mkinitcpio.conf

mkinitcpio -p linux

# Set root password:
echo "Set root password: "
passwd

# Install GRUB
pacman --noconfirm -S grub
grub-install --target=i386-pc --recheck /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg

# Restart- remove the drive when it's down, then continue.
echo "Remove the CD image, then run startup.sh when reboot is done."

set +x
