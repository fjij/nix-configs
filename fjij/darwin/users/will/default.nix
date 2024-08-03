{
  fjij,
  pkgs,
  ...
}: {
  imports = [
    fjij.home-manager.darwinModule
    (fjij.home-manager.mkHome {
      user = "will";
      profile = fjij.home-manager.profiles.mac;
    })
  ];
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
}
