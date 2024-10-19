{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.fjij.minecraft;
in {
  options.fjij.minecraft = {
    enable = lib.mkEnableOption "Minecraft Server";

    frpcProxy = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to proxy traffic through FRPC.";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 25565;
      description = "TCP port to host game on.";
    };
  };

  config = lib.mkIf cfg.enable {
    # Howto: https://tailscale.com/blog/nixos-minecraft
    services.minecraft-server = {
      enable = true;
      eula = true;
      declarative = true;

      # Don't need this since we are using a reverse proxy
      # openFirewall = true;

      serverProperties = {
        server-port = cfg.port;
        gamemode = "survival";
        force-gamemode = true;
        motd = "My cool minecraft server!";
        max-players = 10;
        enable-rcon = true;
        "rcon.password" = "hunter2";
      };

      # I only have to define this section because the current server is out of date
      # https://discourse.nixos.org/t/howto-setting-up-a-nixos-minecraft-server-using-the-newest-version-of-minecraft/3445
      package = let
        version = "1.21";
        url = "https://piston-data.mojang.com/v1/objects/450698d1863ab5180c25d7c804ef0fe6369dd1ba/server.jar";
        sha256 = "c96394da86f9d9f9ef7ca2d2ee1f2f0980c29b7aa5c94b43c02c50435dbcf53f";
      in (pkgs.minecraft-server.overrideAttrs (old: rec {
        name = "minecraft-server-${version}";
        inherit version;

        src = pkgs.fetchurl {
          inherit url sha256;
        };
      }));
    };

    nixpkgs.config.allowUnfree = true;

    fjij.frpc.enable = lib.mkIf cfg.frpcProxy true;

    services.frp.settings.proxies = lib.mkIf cfg.frpcProxy [
      {
        name = "minecraft";
        type = "tcp";
        localIP = "127.0.0.1";
        localPort = cfg.port;
        remotePort = cfg.port;
      }
    ];
  };
}
