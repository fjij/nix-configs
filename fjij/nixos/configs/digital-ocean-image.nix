{
  imports = [
    ../users/admin.nix
    ../hardware/digital-ocean-image.nix
    ../modules
  ];

  fjij.openssh.enable = true;
  fjij.base-system = {
    enable = true;
    useBootLoader = false;
  };
}
