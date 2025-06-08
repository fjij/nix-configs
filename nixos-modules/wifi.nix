{
  config,
  lib,
  ...
}:
let
  cfg = config.fjij.wifi;
in
{
  options.fjij.wifi.enable = lib.mkEnableOption "Wifi";

  config = lib.mkIf cfg.enable {
    fjij.sops.enable = true;
    sops.secrets.wifi-env = { };

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
  };
}
