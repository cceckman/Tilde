# magic.sh : Shell command lines to remember.
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

