{
  imports = [
    ../users/willh.nix
    ../users/admin.nix
    ../hardware/emoji.nix
    ../modules
  ];
  services.satisfactory.enable = true;
  fjij = {
    base-system = {
      enable = true;
      hostName = "emoji";
    };
    minecraft.enable = true;
    openssh.enable = true;
    tailscale.enable = true;
    ollama.enable = true;
    frpc.enable = true;
  };
}
