{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.fjij.darwin.base;
  loginWindowText = "Back to, back to, back to, back to you";
in
{
  options.fjij.darwin.base.enable = lib.mkEnableOption "Base Darwin";

  config = lib.mkIf cfg.enable {
    system.stateVersion = 4;
    # List packages installed in system profile. To search by name, run:
    # $ nix-env -qaP | grep wget
    environment.systemPackages = [
      pkgs.vim
    ];

    nixpkgs.hostPlatform = "aarch64-darwin";
    # for 1password CLI
    nixpkgs.config.allowUnfree = true;

    # Let determinate manage nix
    nix.enable = false;
    security.pam.services.sudo_local.touchIdAuth = true;

    system = {
      startup.chime = false;

      defaults = {
        loginwindow.LoginwindowText = loginWindowText;

        finder = {
          AppleShowAllExtensions = true;
          # List view
          FXPreferredViewStyle = "Nlsv";
        };

        NSGlobalDomain = {
          KeyRepeat = 2;
          InitialKeyRepeat = 25;
        };
      };
    };
  };
}
