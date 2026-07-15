{
  config,
  lib,
  inputs,
  ...
}:
let
  cfg = config.fjij.darwin.homebrew;
in
{
  imports = [
    inputs.nix-homebrew.darwinModules.nix-homebrew
  ];

  options.fjij.darwin.homebrew = {
    enable = lib.mkEnableOption "Homebrew";

    user = lib.mkOption {
      type = lib.types.str;
      description = "User to install homebrew for";
    };
  };

  config = lib.mkIf cfg.enable {
    nix-homebrew = {
      enable = true;
      enableRosetta = true;
      user = cfg.user;
      mutableTaps = false;
      taps = {
        "homebrew/homebrew-bundle" = inputs.homebrew-bundle;
        "homebrew/homebrew-cask" = inputs.homebrew-cask;
        "homebrew/homebrew-core" = inputs.homebrew-core;
        "keith/homebrew-formulae" = inputs.keith-formulae;
        # this is broken rn, idk why
        # "koekeishiya/formulae" = inputs.koekeishiya-formulae;
      };

      # autoMigrate = true;
    };

    homebrew = {
      enable = true;
      global = {
        autoUpdate = true;
      };
      onActivation = {
        autoUpdate = false;
        upgrade = false;
        cleanup = "zap";
      };
      brews = [
        "trash"
        "yabai"
        "sox"
        "keith/homebrew-formulae/reminders-cli"
      ];
      taps = builtins.attrNames config.nix-homebrew.taps;
      casks = [
        "unnaturalscrollwheels"
        "meetingbar"
        # "1password/tap/1password-cli"
        # "koekeishiya/formulae"
        # "koekeishiya/formulae/yabai"
        "1password-cli"
        # "yabai"
      ];
      /*
        masApps = {
          "1Password for Safari" = 1569813296;
          "GarageBand" = 682658836;
          "Infuse" = 1136220934;
          "Messenger" = 1480068668;
          "Microsoft Excel" = 462058435;
          "Microsoft PowerPoint" = 462062816;
          "Microsoft Remote Desktop" = 1295203466;
          "Microsoft Word" = 462054704;
          "OneDrive" = 823766827;
          "Tailscale" = 1475387142;
        };
      */
    };
  };
}
