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
  };
}
