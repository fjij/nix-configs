# Original source:
# https://github.com/matejc/helper_scripts/blob/fc6e92183135c21054314c4c65065e84daa25055/nixes/satisfactory.nix
# License:
# https://github.com/matejc/helper_scripts/blob/fc6e92183135c21054314c4c65065e84daa25055/LICENSE
{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.services.satisfactory;
in
{
  options.services.satisfactory = {
    enable = lib.mkEnableOption "Satisfactory Server";

    beta = lib.mkOption {
      type = lib.types.enum [
        "public"
        "experimental"
      ];
      default = "public";
      description = "Beta channel to follow";
    };

    address = lib.mkOption {
      type = lib.types.str;
      default = "0.0.0.0";
      description = "Bind address";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 7777;
      description = "Game port the server uses. It uses both TCP and UDP.";
    };

    secondaryPort = lib.mkOption {
      type = lib.types.port;
      default = 8888;
      description = ''
        Secondary port the server uses. It uses TCP only. Note, changing this
        option does not actually change the port. This default value is just
        provided for reference.
      '';
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to open ports in firewall (TCP and UDP).";
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
    users.groups.satisfactory = { };

    nixpkgs.config.allowUnfree = true;

    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedUDPPorts = [ cfg.port ];
      allowedTCPPorts = [
        cfg.port
        cfg.secondaryPort
      ];
    };

    systemd.services.satisfactory =
      let
        satisfactoryAppId = 1690800;
        dataDir = "/var/lib/satisfactory";
        installDir = "${dataDir}/SatisfactoryDedicatedServer";
        binary = "${installDir}/Engine/Binaries/Linux/FactoryServer-Linux-Shipping";
        configDir = "${installDir}/FactoryGame/Saved/Config/LinuxServer";
        setConfigValue =
          iniFile: section: key: value:
          "${pkgs.crudini}/bin/crudini --set '${configDir}/${iniFile}' '${section}' '${key}' '${value}'";
      in
      {
        wantedBy = [ "multi-user.target" ];
        preStart = ''
          ${pkgs.steamcmd}/bin/steamcmd \
            +force_install_dir ${installDir} \
            +login anonymous \
            +app_update ${toString satisfactoryAppId} \
            -beta ${cfg.beta} \
            ${cfg.extraSteamCmdArgs} \
            validate \
            +quit
          ${pkgs.patchelf}/bin/patchelf --set-interpreter ${pkgs.glibc}/lib/ld-linux-x86-64.so.2 ${binary}
          ln -sfv ${dataDir}/.steam/steam/linux64 /var/lib/satisfactory/.steam/sdk64
          mkdir -p ${configDir}
          ${setConfigValue "Game.ini" "/Script/Engine.GameSession" "MaxPlayers" (toString cfg.maxPlayers)}
          ${setConfigValue "ServerSettings.ini" "/Script/FactoryGame.FGServerSubsystem" "mAutoPause" (
            if cfg.autoPause then "True" else "False"
          )}
          ${setConfigValue "ServerSettings.ini" "/Script/FactoryGame.FGServerSubsystem"
            "mAutoSaveOnDisconnect"
            (if cfg.autoSaveOnDisconnect then "True" else "False")
          }
        '';
        script = ''
          ${binary} FactoryGame -Port=${toString cfg.port} \
            -multihome=${cfg.address}
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
