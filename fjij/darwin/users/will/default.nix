{
  inputs,
  fjij,
  pkgs,
  ...
}: let
  user = "will";
in {
  imports = [
    inputs.home-manager.darwinModules.home-manager
    (fjij.darwin.modules.homebrew {inherit user;})
  ];

  # List of users managed by nix-darwin
  # https://github.com/LnL7/nix-darwin/issues/811
  users.knownUsers = [user];
  users.users."${user}" = {
    home = "/Users/${user}";
    shell = pkgs.fish;
    # dscl . -read /Users/will UniqueID
    uid = 501;
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.will = {
      imports = [../../../home-manager/configs/mac.nix];
    };
  };

  programs.fish.enable = true;
  # environment.loginShellInit = ''for p in (string split " " $NIX_PROFILES); fish_add_path --prepend --move $p/bin; end'';
}
