{
  imports = [
    ../nixos-hardware/digital-ocean-image.nix
    ../nixos-modules
  ];

  fjij = {
    base-system = {
      enable = true;
      useBootLoader = false;
    };
    admin-user.enable = true;
    openssh.enable = true;
  };
}
