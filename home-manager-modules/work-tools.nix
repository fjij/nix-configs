{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.fjij.work-tools;
in
{
  options.fjij.work-tools.enable = lib.mkEnableOption "Work Tools";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      postgresql_16 # psql
      graphite-cli # graphite
      yq # jq for YAML
    ];
  };
}
