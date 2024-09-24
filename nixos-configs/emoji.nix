{
  imports = [
    ../nixos-hardware/emoji.nix
    ../nixos-modules
  ];
  fjij = {
    base-system = {
      enable = true;
      hostName = "emoji";
    };
    admin-user.enable = true;
    willh-user.enable = true;
    minecraft = {
      enable = true;
      frpcProxy = true;
    };
    satisfactory = {
      enable = true;
      frpcProxy = true;
    };
    openssh.enable = true;
    tailscale.enable = true;
    ollama.enable = true;
    frpc.enable = true;
  };
}
