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
  ];
  dev = if ! isDev then [] else [
    pkgs.clang
    pkgs.go
    pkgs.python311
    pkgs.python311Packages.pip
    pkgs.redo-apenwarr
    pkgs.gdb
    pkgs.graphviz
    pkgs.lld
    pkgs.llvm
    pkgs.parted
    # TODO: Make this part of a hermetic build for image-building
    pkgs.libguestfs-with-appliance
    pkgs.guestfs-tools
    pkgs.qemu
    # TODO: Make this part of a hermetic build of Pidp11
    pkgs.gnumake
  ];
in
  always ++ dev

