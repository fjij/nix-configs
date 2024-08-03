{
  fjij,
  pkgs,
  ...
}: let
  user = "will";
in {
  imports = [
    fjij.home-manager.darwinModule
    (fjij.home-manager.mkHome {
      inherit user;
      profile = fjij.home-manager.profiles.mac;
    })
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

  programs.fish.enable = true;
}
