{
  config,
  pkgs,
  lib,
  ...
}: let
  cfgName = "tmux";
  cfg = config.fjij.${cfgName};
in {
  options.fjij.${cfgName}.enable = lib.mkEnableOption cfgName;

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      tmux
    ];

    xdg.configFile.tmux = {
      source = ../dotfiles/tmux;
      recursive = true;
    };
  };
}
