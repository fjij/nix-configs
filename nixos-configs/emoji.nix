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
    frpc.enable = true;

    mediawiki = {
      enable = true;
      hostName = "emoji.neon-atlas.ts.net";
      caddyReverseProxy = true;
    };

    caddy = {
      enable = true;
      openFirewall = true;
      tailscaleCerts = true;
    };

    # Disabled
    ollama.enable = false; # Takes a long time to build from source
  };
}
