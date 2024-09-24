{
  imports = [
    ../hardware/digital-ocean-image.nix
    ../modules
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
