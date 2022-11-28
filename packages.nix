# Packages that I want in my environment generally.
{ pkgs
, isDev ? false # True for machines I develop on
} : let
  always = [
    pkgs.curl
    pkgs.git
    pkgs.gzip
    pkgs.htop
    pkgs.mtr
    pkgs.tmux
    pkgs.vim
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
  ];
in
  always ++ dev

