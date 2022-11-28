# Home Manager module
{ config, pkgs, ... }:
{
  home.username = "cceckman";
  home.homeDirectory = "/home/cceckman";

  home.stateVersion = "22.05";

  programs.home-manager.enable = true;
}
