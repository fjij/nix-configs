{
  config,
  pkgs,
  ...
}: {
  # enable the tailscale service
  services.tailscale.enable = true;
}
