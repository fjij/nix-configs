{
  imports = [
    ../nixos-modules
  ];
  fjij = {
    base-system = {
      enable = true;
      hostName = "minibee";
      containerMode = true;
    };
    tailscale.enable = true;
    admin-user.enable = true;
    openssh.enable = true;
  };
}
