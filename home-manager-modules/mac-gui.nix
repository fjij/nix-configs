{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.fjij.mac-gui;
in {
  options.fjij.mac-gui.enable = lib.mkEnableOption "Mac GUI Tools";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      _1password
    ];
    xdg.configFile = {
      alacritty = {
        source = ../dotfiles/alacritty;
        recursive = true;
      };
      yabai = {
        source = ../dotfiles/yabai;
        recursive = true;
      };
    };
  };
}
