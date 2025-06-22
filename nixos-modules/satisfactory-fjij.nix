{
  config,
  lib,
  ...
}:
let
  serviceCfg = config.services.satisfactory;
  cfg = config.fjij.satisfactory;
in
{
  options.fjij.satisfactory = {
    enable = lib.mkEnableOption "Satisfactory Server";

    frpcProxy = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to proxy traffic through FRPC.";
    };
  };

  config = lib.mkIf cfg.enable {
    services.satisfactory.enable = true;

    fjij.frpc.enable = lib.mkIf cfg.frpcProxy true;

    services.frp.settings.proxies = lib.mkIf cfg.frpcProxy [
      {
        name = "satisfactory-tcp";
        type = "tcp";
        localIP = "127.0.0.1";
        localPort = serviceCfg.port;
        remotePort = serviceCfg.port;
      }
      {
        name = "satisfactory-udp";
        type = "udp";
        localIP = "127.0.0.1";
        localPort = serviceCfg.port;
        remotePort = serviceCfg.port;
      }
      {
        name = "satisfactory-tcp-secondary";
        type = "tcp";
        localIP = "127.0.0.1";
        localPort = serviceCfg.secondaryPort;
        remotePort = serviceCfg.secondaryPort;
      }
    ];
  };
}
