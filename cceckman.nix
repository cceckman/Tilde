# Home Manager module
{ pkgs, lib, ... }:
{
  home.username = "cceckman";
  home.homeDirectory = "/home/cceckman";

  home.stateVersion = "22.05";

  programs.home-manager.enable = true;

  home.packages = (import ./packages.nix) {
    inherit pkgs;
    isDev = true;
  };

# programs.zsh = lib.mkMerge {
#   enable = true;
#   enableAutosuggestions = true;
#   enableCompletion = true;
#   enableVteIntegration = true;

#   # Incluse all ./shellfiles as extra init values in ZSH config
#   initExtra = let
#     rcFiles = builtins.attrNames (builtins.readDir ./shellfiles);
#     rcContents = builtins.map builtins.readFile rcFiles;
#   in builtins.concatStringsSep "\n" rcContents;
# };
}
