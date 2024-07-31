{
  config,
  pkgs,
  ...
}: {
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = [
    pkgs.vim
  ];

  nixpkgs.hostPlatform = "aarch64-darwin";
  # for 1password CLI
  nixpkgs.config.allowUnfree = true;

  # List of users managed by nix-darwin
  # https://github.com/LnL7/nix-darwin/issues/811
  users.knownUsers = ["will"];
  users.users.will = {
    home = "/Users/will";
    shell = pkgs.fish;
    # dscl . -read /Users/will UniqueID
    uid = 501;
  };

  programs.fish.enable = true;

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
      loginwindow.LoginwindowText = "woah this is my cool logginwindow.LoginwindowText";

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
}
