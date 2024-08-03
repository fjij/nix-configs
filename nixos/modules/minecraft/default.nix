{
  config,
  pkgs,
  ...
}: {
  # Howto: https://tailscale.com/blog/nixos-minecraft
  services.minecraft-server = {
    enable = true;
    eula = true;
    declarative = true;

    serverProperties = {
      server-port = 25565;
      gamemode = "survival";
      motd = "My cool minecraft server!";
      max-players = 5;
      # enable-rcon = true;
      # "rcon.password" = "hunter2";
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

  # Don't need this if using tailscale
  # networking.firewall.allowedTCPPorts = [ 25565 ];
}
