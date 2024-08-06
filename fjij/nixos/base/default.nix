{
  hostName ? "nixos",
  hostPlatform ? "x86_64-linux",
  useBootLoader ? true,
}: {
  config,
  fjij,
  pkgs,
  lib,
  ...
}: {
  networking.hostName = hostName;
  nixpkgs.hostPlatform = hostPlatform;

  # Bootloader
  boot.loader = lib.mkIf useBootLoader {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  # Enable networking
  networking.networkmanager.enable = true;
  networking.wireless.enable = false;

  time.timeZone = "America/Toronto";
  i18n.defaultLocale = "en_US.UTF-8";

  nixpkgs.config.allowUnfree = true;

  nix.settings.auto-optimise-store = true;

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 1w";
  };

  nix.settings.experimental-features = ["nix-command" "flakes"];
  environment.systemPackages = with pkgs; [
    git # required to use flakes
    vim
    lshw
  ];

  # Add wheel to trusted users so they can build
  # https://github.com/NixOS/nix/issues/2789
  nix.settings.trusted-users = ["root" "@wheel"];

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
}
