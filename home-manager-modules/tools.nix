{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.fjij.tools;
in
{
  options.fjij.tools.enable = lib.mkEnableOption "Terminal Tools";

  config = lib.mkIf cfg.enable {
    fjij.git.enable = true;
    fjij.tmux.enable = true;

    home.packages = with pkgs; [
      fish
      ripgrep
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
      curl
      fd # better find
      eza # better ls
      xh # http client
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
      fish = {
        source = ../dotfiles/fish;
        recursive = true;
      };
    };
  };
}
