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
    fjij.git.enable = true;

    home.packages = with pkgs; [
      fish
      ripgrep
      neovim
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
      tmux = {
        source = ../dotfiles/tmux;
        recursive = true;
      };
    };
  };
}
