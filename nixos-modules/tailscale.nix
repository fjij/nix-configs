{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.fjij.tailscale;
in
{
  options.fjij.tailscale.enable = lib.mkEnableOption "Tailscale";

  config = lib.mkIf cfg.enable {
    fjij.sops.enable = true;
    sops.secrets.tailscale-authkey = { };

    # make the tailscale command usable to users
    environment.systemPackages = [ pkgs.tailscale ];

    # enable the tailscale service
    services.tailscale = {
      enable = true;
      openFirewall = true;
      authKeyFile = config.sops.secrets.tailscale-authkey.path;
      extraUpFlags = [ "--ssh" ];
    };

    # container-specific configuration
    systemd.services.tailscaled-autoconnect.serviceConfig.ExecCondition =
      lib.mkIf config.boot.isContainer "/bin/sh -c 'ip link show eth0 >/dev/null 2>&1 && ip link show eth0 | grep -q UP'";
  };
}
