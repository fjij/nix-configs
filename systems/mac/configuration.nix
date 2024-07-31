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
  nix.package = pkgs.nix;
}
