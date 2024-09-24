{
  config,
  lib,
  ...
}: let
  cfg = config.fjij.frpc;
in {
  options.fjij.frpc.enable = lib.mkEnableOption "FRP Client";

  config = lib.mkIf cfg.enable {
    services.frp = {
      enable = true;
      role = "client";
      settings.serverAddr = "gateway";
      settings.serverPort = 7000;
    };
    services.frp.settings.proxies = [
      {
        name = "minecraft";
        type = "tcp";
        localIP = "127.0.0.1";
        localPort = 25565;
        remotePort = 25565;
      }
      {
        name = "satisfactory-tcp";
        type = "tcp";
        localIP = "127.0.0.1";
        localPort = 7777;
        remotePort = 7777;
      }
      {
        name = "satisfactory-udp";
        type = "udp";
        localIP = "127.0.0.1";
        localPort = 7777;
        remotePort = 7777;
      }
      {
        name = "satisfactory-udp-beacon";
        type = "udp";
        localIP = "127.0.0.1";
        localPort = 15000;
        remotePort = 15000;
      }
      {
        name = "satisfactory-udp-query";
        type = "udp";
        localIP = "127.0.0.1";
        localPort = 15777;
        remotePort = 15777;
      }
    ];
  };
}
