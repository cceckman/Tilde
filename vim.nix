{ pkgs, ...} : {
  enable = true;
  plugins = with pkgs.vimPlugins; [
    async-vim
    rainbow_parentheses
    rust-vim
    syntastic
    typescript-vim
    vim-lsp
    vim-pathogen
    vim-colors-solarized
    tmux-navigator
    vim-nix
  ];
  extraConfig = builtins.readFile ./config/vim/vimrc;
}
