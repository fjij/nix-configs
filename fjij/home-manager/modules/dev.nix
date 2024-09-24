{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.fjij.dev;
in {
  options.fjij.dev.enable = lib.mkEnableOption "Developer Tools";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      elixir
    ];
  };
}
