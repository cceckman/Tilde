# Home Manager module
{ pkgs, lib, ... }: {
  home.username = "cceckman";
  home.homeDirectory = "/home/cceckman";

  home.stateVersion = "22.05";

  programs.home-manager.enable = true;

  home.packages = (import ./packages.nix) {
    inherit pkgs;
    isDev = true;
  };

  home.file = {
    allSecrets = {
      source = ./secrets;
      recursive = true;
      target = ".local/allSecrets";
    };
    tmux = {
      source = ./config/tmux/tmux.conf;
      target = ".tmux.conf";
    };
    selenized = {
      source = ./config/vim/selenized.vim;
      target = ".vim/colors/selenized.vim";
    };
    theme = {
      source = ./themes;
      target = "themes";
      recursive = true;
    };
    gitConfig = {
      source = ./config/git-extra;
      target = ".config/git-extra";
      recursive = true;
    };
  };

  home.activation = {
  # decryptSecrets = lib.hm.dag.entryAfter ["onFilesChange"] (builtins.readFile ./secrets/activation);
  };

  programs.vim = (import ./vim.nix) { inherit pkgs; };

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    enableVteIntegration = true;

    # Incluse all ./shellfiles as extra init values in ZSH config
    initExtra = let
      configDir = ./shellfiles;
      rcFiles = builtins.attrNames (builtins.readDir "${configDir}");
      rcPaths = builtins.map (name: "${configDir}/${name}") rcFiles;
      rcContents = builtins.map builtins.readFile rcPaths;
    in builtins.concatStringsSep "\n" rcContents;
  };

  programs.git = {
    enable = true;
    includes = let
      configDir = ./config/git;
      configFiles = builtins.attrNames (builtins.readDir "${configDir}");
    in builtins.map (file: {
      path = "${configDir}/${file}";
    }) configFiles;
  };
}
