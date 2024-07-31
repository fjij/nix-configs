{
  config,
  pkgs,
  ...
}: {
  # home.username = "will";
  # home.homeDirectory = "/Users/will";

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
    age
    sops
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
    ".tmux.conf".source = ./tmux/tmux.conf;
    ".gitconfig".source = ./git/gitconfig;
    ".gitignore".source = ./git/gitignore;
    ".ssh/rc".source = ./ssh/rc;
    "scripts" = {
      source = ./scripts;
      recursive = true;
    };
  };

  xdg.configFile = {
    nvim = {
      source = ./nvim;
      recursive = true;
    };
    fish = {
      source = ./fish;
      recursive = true;
    };
  };

  home.stateVersion = "24.05";

  programs.home-manager.enable = true;
}
