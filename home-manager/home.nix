{ config, pkgs, ... }:

{
  home.username = "willh";
  home.homeDirectory = "/home/willh";
  
  home.packages = with pkgs; [
    # tools
    ripgrep
    neovim
    git
    git-lfs
    tmux
    fish
    jq
    rsync
    gnupg
    # glitter
    bat
    gum
    gh
    tldr
    zoxide
    fzf
    stylua
    # gamer
    nethack
  ];

  programs.git = {
    enable = true;
    userName = "fjij";
    userEmail = "30779570+fjij@users.noreply.github.com";
  };

  home.stateVersion = "24.05";

  xdg.configFile.nvim = {
    source = ./configs/nvim;
    recursive = true;
  };

  programs.home-manager.enable = true;
}
