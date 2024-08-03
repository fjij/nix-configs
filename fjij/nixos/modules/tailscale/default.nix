{
  config,
  pkgs,
  ...
}: {
  sops.secrets.tailscale-authkey = {};

  # make the tailscale command usable to users
  environment.systemPackages = [pkgs.tailscale];

  # enable the tailscale service
  services.tailscale = {
    enable = true;
    openFirewall = true;
    authKeyFile = config.sops.secrets.tailscale-authkey.path;
    extraUpFlags = ["--ssh"];
  };
}
