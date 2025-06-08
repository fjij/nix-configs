{
  config,
  lib,
  ...
}:
let
  cfg = config.fjij.wifi;
in
{
  options.fjij.wifi = {
    enable = lib.mkEnableOption "Wifi";
    netfixUser.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Create a special user account for fixing network issues. Not accessible via SSH.";
    };
    netfixUser.name = lib.mkOption {
      type = lib.types.str;
      default = "netfix";
      description = "The username for the network debugging user.";
    };
    netfixUser.password = lib.mkOption {
      type = lib.types.str;
      default = "password";
      description = "Password for the netfix user.";
    };
  };

  config = lib.mkIf cfg.enable {
    fjij.sops.enable = true;
    sops.secrets.wifi-env = { };

    networking.networkmanager.enable = true;
    networking.networkmanager.ensureProfiles = {
      environmentFiles = [
        config.sops.secrets.wifi-env.path
      ];

      profiles.home = {
        connection = {
          id = "home";
          type = "wifi";
          autoconnect = true;
        };
        wifi = {
          mode = "infrastructure";
          ssid = "$WIFI_SSID";
        };
        wifi-security = {
          key-mgmt = "wpa-psk";
          psk = "$WIFI_PASSWORD";
        };
        ipv4.method = "auto";
        ipv6.method = "auto";
        ipv6.addr-gen-mode = "stable-privacy";
      };
    };

    # Netfix user
    users.users = lib.mkIf cfg.netfixUser.enable {
      "${cfg.netfixUser.name}" = {
        isNormalUser = true;
        description = "User account for network debugging";
        extraGroups = [ "networkmanager" ];
        home = "/home/${cfg.netfixUser.name}";
        password = cfg.netfixUser.password;
      };
    };
    services.openssh.settings.DenyUsers = lib.mkIf cfg.netfixUser.enable [
      cfg.netfixUser.name
    ];
  };
}
