{
  imports = [
    ../nixos-modules
  ];
  fjij = {
    base-system = {
      enable = true;
      hostName = "minicee";
      containerMode = true;
    };
    tailscale.enable = true;
    admin-user.enable = true;
    openssh.enable = true;
  };
}
