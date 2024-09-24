{
  imports = [
    ../nixos-hardware/digital-ocean-config.nix
    ../nixos-modules
  ];

  fjij = {
    base-system = {
      enable = true;
      hostName = "gateway";
      useBootLoader = false;
    };
    admin-user.enable = true;
    openssh.enable = true;
    tailscale.enable = true;
    frps.enable = true;
  };
}
