#!/bin/bash
# Bootstrap an Arch system.
## Scriptification of:
## https://wiki.archlinux.org/index.php/Hyper-V
## https://wiki.archlinux.org/index.php/Installation_guide.

# For Hyper-V:
## Use a Generation 1 machine.
## Dynamic memory is OK, with hv_balloon.
## When setting up the machine in Hyper-V, use a legacy network adapter, per 
## https://superuser.com/questions/689813/setting-up-archlinux-in-hyper-v-no-ethernet

# To run:
# curl -o /tmp/arch-install.sh https://raw.githubusercontent.com/cceckman/Tilde/arch-setup/arch-install.sh
# chmod +x /tmp/arch-install.sh && /tmp/arch-install.sh base-install

# Modes:
## base-install -> assume in live image, set up partitions, etc. on /dev/sda
## setup-chroot -> Assume in live image, within chroot of the new system; set up root password, hostname, networking, etc.
## friendlify -> Assume within chroot or on new, live, machine; set up user, packages & configuration for access, dev tools, my usual aliases, etc.

echo "Hi! This script isn't ready for prime time yet; contact @cceckman if you want to use it." && exit

set -v

# Only allow the above invocation (as a script, not piped into Bash.)
if [[ "$BASH_SOURCE" == "" ]]
then
  echo "Whoop! Execute this script, don't pipe it to a shell!"
  exit
fi

ME=$(realpath "$BASH_SOURCE")
if [[ "$BASH_SOURCE" != "$0" ]]
then
  shift
  if [[ "$BASH_SOURCE" != "$0" ]]
  then
    echo "Assert failed! :-("
    exit 1
  fi
fi

if [[ "$1" == 'base-install' ]]
then
  # Base system install.

  # Turn on some base services: 
  timedatectl set-ntp true # enable NTP-based time.

  # Set up the disk: use GPT (rather than MBR); leave 1MiB for GRUB; and leave 8GB for swap.
  parted --script /dev/sda mklabel gpt || exit
  parted --script --align optimal /dev/sda -- mkpart primary 0% 1M set 1 bios_grub on name 1 grub || exit
  parted --script --align optimal /dev/sda -- mkpart primary ext4 1M -8GiB name 2 root || exit
  parted --script --align optimal /dev/sda -- mkpart primary linux-swap -8GiB 100% name 3 swap || exit

  # Format root partition and swap
  mkfs -t ext4 /dev/sda2 && mount /dev/sda2 /mnt || exit
  mkswap /dev/sda3 && swapon /dev/sda3 || exit

  # Update mirror list and package DB. This isn’t the most optimal assignment, but good enough till we get really started.
  cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup # back up mirror list
  curl -o - 'https://www.archlinux.org/mirrorlist/?country=US&protocol=https&ip_version=4&ip_version=6&use_mirror_status=on' | sed 's/#Server/Server/' > /tmp/mirrorlist
  rankmirrors -n 10 /tmp/mirrorlist > /etc/pacman.d/mirrorlist # only grab top 10 mirrors
  pacman --noconfirm -Syyu # update databases and system packages
  pacman --noconfirm -Scc # clean up space

  # Install...
  pacstrap /mnt base || exit
  # Wait...

  # Generate /etc/fstab, and hop in to the chroot with the second part of the script.
  genfstab -p /mnt >> /mnt/etc/fstab || exit
  cp $(realpath $BASH_SOURCE) /mnt/usr/bin/arch-install.sh || exit
  exit # TODO: Don't break here.
  arch-chroot /mnt /usr/bin/arch-install.sh setup-chroot
  
  # Restart- remove the drive when it's down, then continue.
  echo "Remove the CD image, then run TODO(cceckman) when reboot is done."
  echo "Press enter to continue..."
  read
  shutdown now
elif [[ "$1" == "setup-chroot" ]]
then
  # Second step: run from within the chroot.
  echo "Hostname? "
  echo -n ">"
  read hostname
  echo "$hostname" > /etc/hostname
  # Set root password:
  echo "Set root password: "
  passwd

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

  # Install GRUB
  pacman --noconfirm -S grub
  grub-install --target=i386-pc --recheck /dev/sda
  grub-mkconfig -o /boot/grub/grub.cfg
  
  # And ensure that dhcpcd starts next time around
  systemctl enable dhcpcd@$(ip link | grep -Po 'en[^:]*(?=:)').service
elif [[ "$1" == 'friendlify' ]]
then
  # Make the system actually usable. Run from within chroot, or from the newly-booted system.
  pacman --noconfirm -Syyu
  
  # SYSTEM
  SYS_PKGS="sudo openssh intel-ucode mlocate"
  pacman --noconfirm -S $SYS_PKGS
  grub-mkconfig -o /boot/grub/grub.cfg # Update intel microcode
  updatedb # Update 'locate' database
  # TODO consider Mosh
  # TODO consider two-factor with U2F: https://developers.yubico.com/yubico-pam/Yubikey_and_SSH_via_PAM.html
  ## (libu2f-host)
  
  echo "Add wheel to sudoers by uncommenting the line starting with # %wheel"
  visudo
  
  groupadd ssh-users
  
  # Set up user before starting sshd
  echo "Pick a username for login:"
  echo -n ">"
  read newuser
  useradd -m -G wheel,ssh-users $newuser
  echo "Set password for $newuser:"
  passwd $newuser
  
  # Configure sshd per https://stribika.github.io/2015/01/04/secure-secure-shell.html
  sed -i 's/^PermitRootLogin .*$//g' /etc/ssh/sshd_config
  sed -i 's/^PasswordAuthentication .*$//g' /etc/ssh/sshd_config
  sed -i 's/^ChallengeResponseAuthentication .*$//g' /etc/ssh/sshd_config
  sed -i 's/^PubkeyAuthentication .*$//g' /etc/ssh/sshd_config
  sed -i 's/^Protocol .*$//g' /etc/ssh/sshd_config
  cat << HRD >>/etc/ssh/sshd_config
AllowGroups ssh-users
PermitRootLogin no
PasswordAuthentication no
ChallengeResponseAuthentication no
PubkeyAuthentication yes
Protocol 2
HostKey /etc/ssh/ssh_host_ed25519_key
HostKey /etc/ssh/ssh_host_rsa_key
Ciphers chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr
MACs hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com,hmac-ripemd160-etm@openssh.com,umac-128-etm@openssh.com,hmac-sha2-512,hmac-sha2-256,hmac-ripemd160,umac-128@openssh.com
HRD

  cat << HRD >>/etc/ssh/ssh_config
# Github needs diffie-hellman-group-exchange-sha1 some of the time but not always.
Host github.com
  KexAlgorithms curve25519-sha256@libssh.org,diffie-hellman-group-exchange-sha256,diffie-hellman-group-exchange-sha1,diffie-hellman-group14-sha1
Host *
  PasswordAuthentication no
  ChallengeResponseAuthentication no
  PubkeyAuthentication yes
  KexAlgorithms curve25519-sha256@libssh.org,diffie-hellman-group-exchange-sha256
  HostKeyAlgorithms ssh-ed25519-cert-v01@openssh.com,ssh-rsa-cert-v01@openssh.com,ssh-ed25519,ssh-rsa
  Ciphers chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr
  MACs hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com,hmac-ripemd160-etm@openssh.com,umac-128-etm@openssh.com,hmac-sha2-512,hmac-sha2-256,hmac-ripemd160,umac-128@openssh.com
HRD

  # Make good, new, moduli...
  awk '$5 > 2000' /etc/ssh/moduli > "${HOME}/moduli"
  mv "${HOME}/moduli" /etc/ssh/moduli
  if [ ! -e /tmp/foo ] || (( $(wc -l /tmp/foo | cut -f1 -d' ' ) == 0 ))
  then
    ssh-keygen -G /etc/ssh/moduli.all -b 4096
    ssh-keygen -T /etc/ssh/moduli.safe -f /etc/ssh/moduli.all
    mv /etc/ssh/moduli.safe /etc/ssh/moduli
    rm /etc/ssh/moduli.all
  fi
  # Make new keys
  pushd /etc/ssh
  rm ssh_host_*key*
  ssh-keygen -t ed25519 -f ssh_host_ed25519_key < /dev/null
  ssh-keygen -t rsa -b 4096 -f ssh_host_rsa_key < /dev/null
  popd
  
  echo "Generating keys for $newuser"
  sudo -u $newuser /bin/bash <<'HRD'
cd $HOME
ssh-keygen -t ed25519 -o -a 100
ssh-keygen -t rsa -b 4096 -o -a 100
HRD
  
  systemctl --now enable sshd.socket sshd@.service
  echo "System packages installed! Press enter to continue."
  read
  
  # USABILITY
  ## TODO learn tmux too...
  STD_PKGS="vim screen ttf-dejavu gpm"
  # TODO add display drivers, X, & GUI.
  # TODO configure gpm for mouse support: https://wiki.archlinux.org/index.php/Console_mouse_support
  pacman --noconfirm -S $STD_PKGS
  # TODO turn on numlock by default.
  # TODO grab Tilde, do key-setup stuff.
  echo "Useful packages installed! Press enter to continue."
  read
  
  # DEVELOPMENT
  DEV_PKGS="base-devel git llvm-libs clang go protobuf python2 jre8-openjdk jdk8-openjdk openjdk8-doc"
  pacman --noconfirm -S $DEV_PKGS
  # TODO add Bazel
  # TODO add private repositories
  echo "Developer packages installed! Press enter to complete."
  read
  
else
  echo "Unrecognized command $1! Whoops!"
fi
  
set +v
