{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.fjij.tools;
in {
  options.fjij.tools.enable = lib.mkEnableOption "Terminal Tools";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      fish
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
      ".ssh/rc".source = ../dotfiles/ssh/rc;
      "scripts" = {
        source = ../dotfiles/scripts;
        recursive = true;
      };
    };

    xdg.configFile = {
      nvim = {
        source = ../dotfiles/nvim;
        recursive = true;
      };
      fish = {
        source = ../dotfiles/fish;
        recursive = true;
      };
      git = {
        source = ../dotfiles/git;
        recursive = true;
      };
      tmux = {
        source = ../dotfiles/tmux;
        recursive = true;
      };
    };
  };
}
