#!/bin/bash -i
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
## friendlify -> Assume within chroot or on new, live, machine; set up user, packages & configuration for access, dev tools, etc.
## user-setup -> Started as the new user; set up keys, password, Tilde repository, etc.
## prompt -> Prompt for, and write to file, configuration parameters.

echo "Hi! This script isn't necessarily ready for prime time."
echo "If you know what you're doing, hit enter to start."
read

set -e
for sig in INT TERM EXIT; do
  trap "echo 'Encountered an error! Dropping into bash.' && bash; [[ $sig == EXIT ]] || (trap - $sig EXIT; kill -$sig $$)" $sig 
done


PROMPTFILE='/etc/newhostconfig'

getkey() {
  grep -Pho "(?<=^$1:).*$" $PROMPTFILE
}

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

if [[ "$1" == 'prompt' ]]
then
  prompt() {
    echo "$1"
    echo -n '>'
  }

  prompt 'Skip all these prompts (re-use answers?)'
  read reuse
  if [[ "$reuse" == y* ]] || [[ "$reuse" == Y* ]]
  then
    trap - EXIT && exit
  fi
  
  # Input info:
  prompt 'Hostname'
  read hostname
  
  # TODO(cceckman) Root password?
  prompt 'Username'
  read newuser

  prompt 'URL of an SSH pubkey (authorized_key) for that user'
  read authkey_url

  prompt 'Generate moduli [y/N]'
  read moduli
  
  prompt 'GitHub username'
  read githubuser

  prompt 'GitHub API access token (with write:public_key scope)'
  read githubtoken

  prompt 'E-mail for Git commits'
  read gitemail

  prompt 'Name for Git commits'
  read gitname

  # Write out; copy to chroot later.
  cat - << HRD > $PROMPTFILE
hostname:$hostname
newuser:$newuser
authkey_url:$authkey_url
moduli:$moduli
githubuser:$githubuser
githubtoken:$githubtoken
gitemail:$gitemail
gitname:$gitname
HRD

  trap - EXIT && exit
elif [[ "$1" == 'base-install' ]]
then
  $0 prompt 

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

  # Install...
  pacstrap /mnt base || exit
  # Wait...

  # Generate /etc/fstab, and hop in to the chroot with the second part of the script.
  genfstab -p /mnt >> /mnt/etc/fstab || exit
  cp $(realpath $BASH_SOURCE) /mnt/usr/bin/arch-install.sh || exit
  mv $PROMPTFILE /mnt${PROMPTFILE}
  arch-chroot /mnt /usr/bin/arch-install.sh setup-chroot
  
  # Restart- remove the drive when it's down, then continue.
  echo 'Press "enter", remove the Arch CD, and restart the machine.'
  read
  trap - EXIT && shutdown now
elif [[ "$1" == "setup-chroot" ]]
then
  # Second step: run from within the chroot.
  getkey hostname > /etc/hostname

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
  # Use higher resolution by default: https://askubuntu.com/questions/384602/ubuntu-hyper-v-guest-display-resolution
  echo 'GRUB_CMDLINE_LINUX_DEFAULT="$GRUB_CMDLINE_LINUX_DEFAULT splash video=hyperv_fb:1920x1080"' >> /etc/default/grub
  grub-mkconfig -o /boot/grub/grub.cfg
  
  # And ensure that dhcpcd starts next time around
  systemctl enable dhcpcd@$(ip link | grep -Po '(en|eth)[^: ]*(?=:)').service
  
  # Auto-start the `friendlify` step upon reboot, by logging in as root and immediately running it.
  # Is this super insecure? Totally! That's why the first thing we do on the other side is disable root logins,
  # and disable auto-login.
  # Auto-login as root:
  mkdir -p /etc/systemd/system/getty@tty1.service.d/
  cat - <<HRD >> /etc/systemd/system/getty@tty1.service.d/override.conf
[Service]
ExecStart=
ExecStart=-/usr/bin/agetty --autologin root --noclear %I $TERM
HRD
  # Start this script upon root login:
  echo "/usr/bin/arch-setup.sh friendlify" >> /root/.bash_profile
  trap - EXIT && exit
elif [[ "$1" == 'friendlify' ]]
then
  # Don't start this script again when root logs in again;
  # Don't automatically log in as root;
  # In fact, don't let root log in at all.
  rm /root/.bashrc && \
  rm /etc/systemd/system/getty@tty1.service.d/override.conf && \
  passwd -l root
  # Yep, we're kind of screwed if we break here. Keep going!
  
  # Make the system actually usable. Run from within chroot, or from the newly-booted system.
  pacman --noconfirm -Syyu
  
  # SYSTEM
  SYS_PKGS="sudo openssh intel-ucode mlocate tcpdump"
  pacman --noconfirm -S $SYS_PKGS
  grub-mkconfig -o /boot/grub/grub.cfg # Update intel microcode
  updatedb # Update 'locate' database
  # TODO consider Mosh
  # TODO consider two-factor with U2F: https://developers.yubico.com/yubico-pam/Yubikey_and_SSH_via_PAM.html
  ## (libu2f-host)
  
  # Set up groups and new user
  # Add wheel to sudoers by uncommenting the line starting with # %wheel.
  # We don't actually uncomment- just append, becase in-place edits are hard.
  echo '%wheel ALL=(ALL) ALL' >> /etc/sudoers
  groupadd ssh-users
  newuser=$(getkey newuser)
  useradd --create-home --groups wheel,ssh-users $newuser
  passwd --expire 1 $newuser
  
  # Configure sshd per https://stribika.github.io/2015/01/04/secure-secure-shell.html
  sed -i 's/^PermitRootLogin .*$//g' /etc/ssh/sshd_config
  sed -i 's/^PasswordAuthentication .*$//g' /etc/ssh/sshd_config
  sed -i 's/^ChallengeResponseAuthentication .*$//g' /etc/ssh/sshd_config
  sed -i 's/^PubkeyAuthentication .*$//g' /etc/ssh/sshd_config
  sed -i 's/^Protocol .*$//g' /etc/ssh/sshd_config
  cat - << HRD >>/etc/ssh/sshd_config
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

  cat - << HRD >>/etc/ssh/ssh_config
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
  genmoduli=$(getkey genmoduli)
  if [[ "$genmoduli" == y* ]] || [[ "$genmoduli" == Y* ]]
  then
    awk '$5 > 2000' /etc/ssh/moduli > "${HOME}/moduli"
    mv "${HOME}/moduli" /etc/ssh/moduli
    if [ ! -e /tmp/foo ] || (( $(wc -l /tmp/foo | cut -f1 -d' ' ) == 0 ))
    then
      ssh-keygen -G /etc/ssh/moduli.all -b 4096
      ssh-keygen -T /etc/ssh/moduli.safe -f /etc/ssh/moduli.all
      mv /etc/ssh/moduli.safe /etc/ssh/moduli
      rm /etc/ssh/moduli.all
    fi
  fi
  # Make new host keys
  pushd /etc/ssh/
  rm ssh_host_*key*
  ssh-keygen -t ed25519 -f ssh_host_ed25519_key < /dev/null
  ssh-keygen -t rsa -b 4096 -f ssh_host_rsa_key < /dev/null
  popd
  
  systemctl --now enable sshd.service
  echo "System packages installed!"
  
  # USABILITY
  ## TODO learn tmux too...
  FONT_PKGS="ttf-dejavu ttf-anonymous-pro"
  UTIL_PKGS="zip unzip tar gzip less bash-completion"
  STD_PKGS="vim screen gpm chromium"
  # TODO add Vimium to Chromium automatically.
  # TODO configure gpm for mouse support: https://wiki.archlinux.org/index.php/Console_mouse_support
  pacman --noconfirm -S $STD_PKGS $FONT_PKGS $UTIL_PKGS
 
  # TODO turn on numlock by default.
  echo "Useful packages installed!"
  
  # DEVELOPMENT
  DEV_PKGS="base-devel rsync git go protobuf python2"
  HS_PKGS="ghc cabal-install haddock happy alex"
  JAVA_PKGS="jre8-openjdk jdk8-openjdk openjdk8-doc"
  BUILD_PKGS="clang llvm-libs" # TODO add Bazel- it's slightly more complicated...
  pacman --noconfirm -S $DEV_PKGS $HS_PKGS $JAVA_PKGS $BUILD_PKGS
  # TODO add private repositories
  echo "Developer packages installed!"
  
  # GUI
  # Set up X, display manager, and window manager.
  # Starting out with xmonad is probably a bad idea, but sure!
  X_PKGS="xorg-server xorg-server-utils xorg-drivers xterm xscreensaver cmatrix"
  XMONAD_PKGS="lxdm xmonad xmonad-contrib xmobar dmenu"
  pacman --noconfirm -S  $X_PKGS $XMONAD_PKGS
  sed -i 's/^.*numlock=.*$/numlock=0/' /etc/lxdm/lxdm.conf
  sed -i "s:^.*[^a-z]session=.*\$:session=$(which xmonad):" /etc/lxdm/lxdm.conf
  systemctl enable lxdm.service
  # TODO Make the login prompt prettier.
  # TODO configure clipboard shortcuts.
  
  # Now we're ready to set up the user account.
  # Do this setup before GUI because it includes adding AUR.
  sudo -u $newuser -- $0 user-setup
  
  echo "All done! Restarting one last time; press 'enter' to continue."
  read
  trap - EXIT && shutdown -r now
elif [[ "$1" == 'user-setup' ]]
then
  cd $HOME
  
  # Generate a new key and add it to the GitHub account.
  username=$(getkey githubuser)
  token=$(getkey githubtoken)

  gitemail=$(getkey gitemail)
  gitname=$(getkey gitname)

  git config --global user.email "$gitemail"
  git config --global user.name "$gitname"
  git config --global push.default simple # Squash that message!

  echo "Generating keys for $USER"
  cd $HOME
  edkey="$HOME/.ssh/id_ed25519"
  ssh-keygen -t ed25519 -f $edkey  -C $(hostname) -o -a 100
  ssh-keygen -t rsa -b 4096 -f $HOME/.ssh/id_rsa -C $(hostname) -o -a 100
 
  keyreq='/tmp/keyreq'
  cat - << HRD > $keyreq
{
  "title": "$USER@$(hostname)",
  "key": "$(cat $HOME/.ssh/id_rsa.pub)"
}
HRD

  curl -X POST -d @$keyreq -u ${username}:${token} https://api.github.com/user/keys \
    || (echo "Didn't upload Github key! That's a problem." && bash)
  
  git clone git@github.com:cceckman/Tilde.git && cp -r $HOME/Tilde/* . && cp -r $HOME/Tilde/.* . 
  rm -rf Tilde
  
  # Make Yaourt, but not as root.
  for repo in package-query yaourt
  do
  	pushd /tmp/
  	git clone https://aur.archlinux.org/${repo}.git && cd ${repo}
  	echo "Check PKGBUILD and any .install files..."
  	bash
  	makepkg -sri
  	popd
  done

  # Make Bazel (from the official repo.)
  # TODO(cceckman) Enable hermeticity:
  # http://bazel.io/docs/bazel-user-manual.html#sandboxing
  pushd /tmp
    git clone https://github.com/bazelbuild/bazel.git && cd bazel
    # ./compile.sh all # 'all' is a little strong here; we fail hermeticity checks, and it takes forever.
    ./compile
  popd
  
  trap - EXIT && exit
else
  echo "Unrecognized command $1! Whoops!"
fi
