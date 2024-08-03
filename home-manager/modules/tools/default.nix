{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
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
    bat
    gum
    gh
    tldr
    zoxide
    fzf
    stylua
    nethack
  ];

  programs.git = {
    enable = true;
    userName = "fjij";
    userEmail = "30779570+fjij@users.noreply.github.com";
  };

  home.file = {
    ".tmux.conf".source = ../../dotfiles/tmux/tmux.conf;
    ".gitconfig".source = ../../dotfiles/git/gitconfig;
    ".gitignore".source = ../../dotfiles/git/gitignore;
    ".ssh/rc".source = ../../dotfiles/ssh/rc;
    "scripts" = {
      source = ../../dotfiles/scripts;
      recursive = true;
    };
  };

  xdg.configFile = {
    nvim = {
      source = ../../dotfiles/nvim;
      recursive = true;
    };
    fish = {
      source = ../../dotfiles/fish;
      recursive = true;
    };
  };
}
