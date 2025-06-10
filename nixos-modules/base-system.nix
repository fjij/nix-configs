{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.fjij.base-system;
in
{
  options.fjij.base-system = {
    enable = lib.mkEnableOption "Base System";

    hostName = lib.mkOption {
      type = lib.types.str;
      default = "nixos";
      description = "The system hostname.";
    };

    hostPlatform = lib.mkOption {
      type = lib.types.str;
      default = "x86_64-linux";
      description = "The system platform. Only applies to non-container systems.";
    };

    useBootLoader = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to use systemd bootloader. Only applies to non-container systems.";
    };

    containerMode = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to run in container mode. This will disable the bootloader and enable container-specific settings.";
    };
  };

  config = lib.mkIf cfg.enable {
    # Common configuration for all systems
    networking.hostName = cfg.hostName;

    time.timeZone = "America/Toronto";
    i18n.defaultLocale = "en_US.UTF-8";

    nixpkgs.config.allowUnfree = true;

    environment.systemPackages = with pkgs; [
      git # required to use flakes
      vim
      lshw
    ];

    # Add wheel to trusted users so they can build
    # https://github.com/NixOS/nix/issues/2789
    nix.settings.trusted-users = [
      "root"
      "@wheel"
    ];

    # Use vim as default editor
    environment.variables.EDITOR = "vim";

    # Command not found is broken with flakes: https://github.com/NixOS/nixpkgs/issues/171054
    programs.command-not-found.enable = false;

    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It‘s perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = "24.05"; # Did you read the comment?

    # Non-container specific configuration
    nixpkgs.hostPlatform = lib.mkIf (!cfg.containerMode) cfg.hostPlatform;
    # Bootloader
    boot.loader = lib.mkIf (cfg.useBootLoader && !cfg.containerMode) {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    # Enable networking
    networking.networkmanager.enable = lib.mkIf (!cfg.containerMode) true;
    # Disables wpa_supplicant, however NetworkManager can still manage wireless connections
    networking.wireless.enable = lib.mkIf (!cfg.containerMode) false;

    nix.settings.auto-optimise-store = lib.mkIf (!cfg.containerMode) true;

    nix.gc = lib.mkIf (!cfg.containerMode) {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 1w";
    };

    nix.settings.experimental-features = lib.mkIf (!cfg.containerMode) [
      "nix-command"
      "flakes"
    ];
    # Container specific configuration
    # Specifically used in private networking
    networking.nameservers = lib.mkIf cfg.containerMode [ "8.8.8.8" ]; # Cloudflare DNS
    networking.defaultGateway = lib.mkIf cfg.containerMode "192.168.100.10";
    networking.useHostResolvConf = lib.mkIf cfg.containerMode false;
  };
}
