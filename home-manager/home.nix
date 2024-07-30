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

  home.file.".tmux.conf".source = ./configs/tmux/tmux.conf;

  xdg.configFile = {
    nvim = {
      source = ./configs/nvim;
      recursive = true;
    };
    fish = {
      source = ./configs/fish;
      recursive = true;
    };
  };

  programs.home-manager.enable = true;
}
