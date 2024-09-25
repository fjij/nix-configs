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
    # Note to self - don't use programs.tmux, since it adds stupid un-removable
    # options to conf file
    home.packages = with pkgs; [
      tmux
    ];

    xdg.configFile.tmux = {
      source = ../dotfiles/tmux;
      recursive = true;
    };
  };
}
