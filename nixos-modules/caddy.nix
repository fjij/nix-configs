{
  config,
  lib,
  ...
}:
let
  cfg = config.fjij.caddy;
in
{
  # Caddy
  # https://nixos.wiki/wiki/Caddy
  options.fjij.caddy = {
    enable = lib.mkEnableOption "Caddy";

    tailscaleCerts = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to allow caddy to automatically configure Tailscale certs";
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to open the firewll ports";
    };
  };

  config = lib.mkIf cfg.enable {
    services.caddy.enable = true;

    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [
      80
      443
    ];

    # https://caddyserver.com/docs/automatic-https#activation
    # Caddy automatically attempts to get certificates from the locally running
    # tailscale instance. It requires HTTPS to be enabled in Tailscale account
    # and the caddy user has permission to fetch certificates:
    services.tailscale.permitCertUid = lib.mkIf cfg.tailscaleCerts "caddy";
  };
}
