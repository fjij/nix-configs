{
  imports = [
    ../hardware/emoji.nix
    ../modules
  ];
  services.satisfactory.enable = true;
  fjij = {
    base-system = {
      enable = true;
      hostName = "emoji";
    };
    admin-user.enable = true;
    willh-user.enable = true;
    minecraft.enable = true;
    openssh.enable = true;
    tailscale.enable = true;
    ollama.enable = true;
    frpc.enable = true;
  };
}
