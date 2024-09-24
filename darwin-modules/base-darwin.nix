{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.fjij.darwin.base;
  loginWindowText = "Back to, back to, back to, back to you";
in {
  options.fjij.darwin.base.enable = lib.mkEnableOption "Base Darwin";

  config = lib.mkIf cfg.enable {
    # List packages installed in system profile. To search by name, run:
    # $ nix-env -qaP | grep wget
    environment.systemPackages = [
      pkgs.vim
    ];

    nixpkgs.hostPlatform = "aarch64-darwin";
    # for 1password CLI
    nixpkgs.config.allowUnfree = true;

    # Auto upgrade nix package and the daemon service.
    services.nix-daemon.enable = true;
    nix = {
      package = pkgs.nix;
      gc = {
        automatic = true;
        interval.Weekday = 0;
        options = "--delete-older-than 1w";
      };
      settings = {
        experimental-features = "nix-command flakes";
        auto-optimise-store = true;
        trusted-users = [
          "root"
          "@admin"
        ];
      };
    };

    security.pam.enableSudoTouchIdAuth = true;

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
