{
  config,
  lib,
  ...
}:
let
  cfg = config.fjij.openssh;
in
{
  options.fjij.openssh = {
    enable = lib.mkEnableOption "OpenSSH";
    permitRootLogin = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to allow root login via SSH.";
    };
  };

  config = lib.mkIf cfg.enable {
    # Enable the OpenSSH daemon.
    services.openssh = {
      enable = true;
      settings = {
        PermitRootLogin = if cfg.permitRootLogin then lib.mkForce "prohibit-password" else lib.mkForce "no";
        PasswordAuthentication = false;
      };
      openFirewall = true; # Should theoretically auto-open port 22
    };
  };
}
