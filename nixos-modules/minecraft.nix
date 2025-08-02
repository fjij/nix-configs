{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.fjij.minecraft;
in
{
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

      # Default:
      # dataDir = "/var/lib/minecraft";
      # dataDir = "/var/lib/minecraft/oct2024-world-2";
      dataDir = "/var/lib/minecraft/aug2025-world-3";

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
      package =
        let
          version = "1.21.8";
          url = "https://piston-data.mojang.com/v1/objects/6bce4ef400e4efaa63a13d5e6f6b500be969ef81/server.jar";
          sha256 = "1rxvgyz969yhc1a0fnwmwwap1c548vpr0a39wx02rgnly2ldjj93";
        in
        (pkgs.minecraft-server.overrideAttrs (_: rec {
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
