# Packages that I want in my environment generally.
{ pkgs
, isDev ? false # True for machines I develop on
} : let
  always = [
    pkgs.age
    pkgs.curl
    pkgs.ripgrep
    pkgs.file
    pkgs.git
    pkgs.gitAndTools.gh
    pkgs.gzip
    pkgs.htop
    pkgs.mtr
    pkgs.tmux
    pkgs.wget
    pkgs.zip
    pkgs.jq
    pkgs.restic
    pkgs.ffmpeg
  ];
  dev = if ! isDev then [] else [
    pkgs.ansible
    pkgs.clang
    pkgs.cmatrix # TODO: Make an "interactive" set- not quite the same...
    pkgs.gdb
    pkgs.go
    pkgs.google-cloud-sdk
    pkgs.graphviz
    pkgs.lld
    pkgs.llvm
    pkgs.parted
    pkgs.pv
    pkgs.python311
    pkgs.python311Packages.pip
    pkgs.redo-apenwarr
    pkgs.sqlite
    # TODO: Make this part of a hermetic build for image-building
    pkgs.libguestfs-with-appliance
    pkgs.guestfs-tools
    pkgs.qemu
    # TODO: Make this part of a hermetic build of Pidp11
    pkgs.gnumake
    pkgs.amsterdam-compiler-kit
  ];
in
  always ++ dev

