inputs: fjij: {
  configurations = let
    nix-darwin = inputs.nix-darwin;
  in {
    "Wills-MacBook-Air" = nix-darwin.lib.darwinSystem {
      specialArgs = {inherit inputs;};
      modules = [
        ./systems/wills-macbook-air
        ./modules/tailscale
        ./modules/homebrew
        ./users/will
        fjij.home-manager.darwinModule
        (fjij.home-manager.mkHome {
          user = "will";
          profile = fjij.home-manager.profiles.mac;
        })
      ];
    };
  };
}
