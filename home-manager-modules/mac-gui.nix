{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.fjij.mac-gui;
in
{
  options.fjij.mac-gui.enable = lib.mkEnableOption "Mac GUI Tools";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      _1password-cli
    ];

    fjij.alacritty.enable = true;
    fjij.alacritty.macApp = true;

    xdg.configFile.yabai = {
      source = ../dotfiles/yabai;
      recursive = true;
    };
  };
}
