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
    jq
    rsync
    gnupg
    just
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

  # Classic dotfiles
  home.file = {
    ".tmux.conf".source = ./configs/tmux/tmux.conf;
    ".gitconfig".source = ./configs/git/gitconfig;
    ".gitignore".source = ./configs/git/gitignore;
    ".ssh/rc".source = ./configs/ssh/rc;
    "scripts" = {
      source = ./configs/scripts;
      recursive = true;
    };
  };

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

  home.stateVersion = "24.05";

  programs.home-manager.enable = true;
}
