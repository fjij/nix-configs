{
  config,
  lib,
  ...
}:
let
  cfg = config.fjij.openssh;
in
{
  options.fjij.openssh.enable = lib.mkEnableOption "OpenSSH";

  config = lib.mkIf cfg.enable {
    # Enable the OpenSSH daemon.
    services.openssh = {
      enable = true;
      settings = {
        PermitRootLogin = lib.mkForce "no";
        PasswordAuthentication = false;
      };
      openFirewall = true; # Should theoretically auto-open port 22
    };
  };
}
