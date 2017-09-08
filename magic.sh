#!/bin/sh
# magic.sh : Shell command lines to remember.
vim ~/magic.sh
exit

# Per
# https://www.raspberrypi.org/documentation/linux/kernel/building.md
git clone https://github.com/raspberrypi/tools $HOME/r/raspberrypi/tools
PATH="$PATH:$HOME/r/raspberrypi/tools/arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian-x64/bin"

# Download and write Raspbian image.
curl -Lo ~/Downloads/raspbian.zip https://downloads.raspberrypi.org/raspbian_latest
unzip raspbian.zip
lsblk; df -h
# Unmount if necessary
umount /dev/sdc1
read img
dd bs=4M if=$img of=/dev/sdc

# Install Buildifier.
# TODO to make this part of update-repos or somesuch.
go get -d -u github.com/bazelbuild/buildifier/buildifier \
  && go generate github.com/bazelbuild/buildifier/core \
  && go install github.com/bazelbuild/buildifier/buildifier

# Scan for wireless networks
nmcli dev wifi list
# radio off / on
nmcli radio wifi off
# Connect to PSK network; creates persisted connection to an insecure network.
nmcli device wifi connect Networkname
# -a to ask for a password. Use this instead of a trailing password arg.
nmcli -a device wifi connect NetworkName

# Get DPI
MY_DPI=$(xdpyinfo \
  | grep dots \
  | grep -Po '([0-9]{2,3})x\1' \
  | grep -Po '^[^x]*' )


# The coolest thing I've done in a while:
# resize encrypted logical volumes, online.
# Hop out of X (i3 etc. keep some files open in /home) and to a TTY, then:
sudo lvresize -r -L-10G /dev/matildai-vg/home
sudo lvresize -r -L+10G /dev/matildai-vg/root
# -r indicates "resize the filesystem, too."

# Install a more modern kernel, along with some more modern drivers.
sudo apt-get install -t jessie-backports \
  linux-image-amd64 \
  linux-headers-amd64 \
  linux-image-extra \
  dkms \
  virtualbox-guest-dkms \
  virtualbox-guest-x11 \
  broadcom-sta-dkms # WiFi driver

# Set BBR as the default congestion control
export BBR="/etc/sysctl.d/50-bbr.conf"
sudo bash -c "echo 'net.core.default_qdisc=fq' >> $BBR"
sudo bash -c "echo 'net.ipv4.tcp_congestion_control=bbr' >> $BBR"

# Use 'overlay' module for Docker.
sudo tee /etc/docker/daemon.json <<HRD
{
  "storage-driver": "overlay"
}
HRD

# Run a command, started in the background, that runs on the X display
export DISPLAY=:0 && (cmd)
# Alternative?
env DISPLAY=:0 cmd
