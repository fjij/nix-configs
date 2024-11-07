{
  config,
  lib,
  outputs,
  ...
}:
let
  cfg = config.fjij.frps;
  nameFilter =
    name:
    let
      frp = outputs.nixosConfigurations."${name}".config.services.frp;
    in
    (frp.enable == true && frp.role == "client" && frp.settings.serverAddr == cfg.serverAddr);
  systemNames = builtins.filter nameFilter (builtins.attrNames outputs.nixosConfigurations);
  systems = builtins.map (name: outputs.nixosConfigurations."${name}") systemNames;
  tcpRules = system: builtins.filter (p: p.type == "tcp") system.config.services.frp.settings.proxies;
  udpRules = system: builtins.filter (p: p.type == "udp") system.config.services.frp.settings.proxies;
  allTcpRules = builtins.concatLists (builtins.map tcpRules systems);
  allUdpRules = builtins.concatLists (builtins.map udpRules systems);
  allTcpPorts = builtins.map (p: p.remotePort) allTcpRules;
  allUdpPorts = builtins.map (p: p.remotePort) allUdpRules;
in
{
  options.fjij.frps.enable = lib.mkEnableOption "FRP Server";

  options.fjij.frps.serverAddr = lib.mkOption {
    type = lib.types.str;
    default = config.networking.hostName;
    description = "The address of this server. Used to determine which configs are clients.";
  };

  options.fjij.frps.openFirewall = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Whether to open ports in firewall for all client proxies.";
  };

  config = lib.mkIf cfg.enable {
    services.frp = {
      enable = true;
      role = "server";
      settings.bindPort = 7000;
    };
    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall allTcpPorts;
    networking.firewall.allowedUDPPorts = lib.mkIf cfg.openFirewall allUdpPorts;
  };
}
