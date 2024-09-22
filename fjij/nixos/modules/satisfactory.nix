# Source: https://github.com/matejc/helper_scripts/blob/master/nixes/satisfactory.nix
{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.services.satisfactory;
in {
  options.services.satisfactory = {
    enable = lib.mkEnableOption "Enable Satisfactory Dedicated Server";

    beta = lib.mkOption {
      type = lib.types.enum ["public" "experimental"];
      default = "public";
      description = "Beta channel to follow";
    };

    address = lib.mkOption {
      type = lib.types.str;
      default = "0.0.0.0";
      description = "Bind address";
    };

    maxPlayers = lib.mkOption {
      type = lib.types.number;
      default = 4;
      description = "Number of players";
    };

    autoPause = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Auto pause when no players are online";
    };

    autoSaveOnDisconnect = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Auto save on player disconnect";
    };

    extraSteamCmdArgs = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "Extra arguments passed to steamcmd command";
    };
  };
  config = lib.mkIf cfg.enable {
    users.users.satisfactory = {
      home = "/var/lib/satisfactory";
      createHome = true;
      isSystemUser = true;
      group = "satisfactory";
    };
    users.groups.satisfactory = {};

    nixpkgs.config.allowUnfree = true;

    networking = {
      firewall = {
        allowedUDPPorts = [7777];
        allowedTCPPorts = [7777];
      };
    };

    systemd.services.satisfactory = let
      dataDir = "/var/lib/satisfactory";
      installDir = "${dataDir}/SatisfactoryDedicatedServer";
      binary = "${installDir}/Engine/Binaries/Linux/FactoryServer-Linux-Shipping";
    in {
      wantedBy = ["multi-user.target"];
      preStart = ''
        ${pkgs.steamcmd}/bin/steamcmd \
          +force_install_dir ${installDir} \
          +login anonymous \
          +app_update 1690800 \
          -beta ${cfg.beta} \
          ${cfg.extraSteamCmdArgs} \
          validate \
          +quit
        ${pkgs.patchelf}/bin/patchelf --set-interpreter ${pkgs.glibc}/lib/ld-linux-x86-64.so.2 ${binary}
        ln -sfv ${dataDir}/.steam/steam/linux64 /var/lib/satisfactory/.steam/sdk64
        mkdir -p ${installDir}/FactoryGame/Saved/Config/LinuxServer
        ${pkgs.crudini}/bin/crudini --set ${installDir}/FactoryGame/Saved/Config/LinuxServer/Game.ini '/Script/Engine.GameSession' MaxPlayers ${toString cfg.maxPlayers}
        ${pkgs.crudini}/bin/crudini --set ${installDir}/FactoryGame/Saved/Config/LinuxServer/ServerSettings.ini '/Script/FactoryGame.FGServerSubsystem' mAutoPause ${
          if cfg.autoPause
          then "True"
          else "False"
        }
        ${pkgs.crudini}/bin/crudini --set ${installDir}/FactoryGame/Saved/Config/LinuxServer/ServerSettings.ini '/Script/FactoryGame.FGServerSubsystem' mAutoSaveOnDisconnect ${
          if cfg.autoSaveOnDisconnect
          then "True"
          else "False"
        }
      '';
      script = ''
        ${binary} FactoryGame -multihome=${cfg.address}
      '';
      serviceConfig = {
        Restart = "always";
        User = "satisfactory";
        Group = "satisfactory";
        WorkingDirectory = "${dataDir}";
      };
      environment = {
        LD_LIBRARY_PATH = "SatisfactoryDedicatedServer/linux64:SatisfactoryDedicatedServer/Engine/Binaries/Linux:SatisfactoryDedicatedServer/Engine/Binaries/ThirdParty/PhysX3/Linux/x86_64-unknown-linux-gnu";
      };
    };
  };
}
