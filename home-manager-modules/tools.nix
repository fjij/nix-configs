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
    fjij.tmux.enable = true;

    home.packages = with pkgs; [
      fish
      ripgrep
      neovim
      jq
      rsync
      gnupg
      just
      bat
      gum
      gh
      tldr
      zoxide
      fzf
      nethack
      nodejs_20
    ];

    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
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
    };
  };
}
