{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.fjij.frps;
in {
  options.fjij.frps.enable = lib.mkEnableOption "FRP Server";

  config = lib.mkIf cfg.enable {
    services.frp = {
      enable = true;
      role = "server";
      settings.bindPort = 7000;
    };
    networking.firewall.allowedTCPPorts = [7777 25565];
    networking.firewall.allowedUDPPorts = [7777 15000 15777];
  };
}
