{
  config,
  lib,
  ...
}:
let
  cfg = config.fjij.base;
in
{
  options.fjij.base.enable = lib.mkEnableOption "Base Home Manager Options";

  config = lib.mkIf cfg.enable {
    home.stateVersion = "24.05";
    programs.home-manager.enable = true;
  };
}
