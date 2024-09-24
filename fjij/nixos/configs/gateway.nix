{
  imports = [
    ../users/admin.nix
    ../hardware/digital-ocean-config.nix
    ../modules
  ];

  fjij = {
    base-system = {
      enable = true;
      hostName = "gateway";
      useBootLoader = false;
    };
    openssh.enable = true;
    tailscale.enable = true;
    frps.enable = true;
  };
}
