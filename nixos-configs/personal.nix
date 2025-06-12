{
  imports = [
    ../nixos-modules
  ];
  fjij = {
    base-system = {
      enable = true;
      hostName = "personal";
      containerMode = true;
    };
    tailscale.enable = true;
    admin-user.enable = true;
    openssh.enable = true;
  };
}
