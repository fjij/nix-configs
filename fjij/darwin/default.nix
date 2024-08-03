inputs: fjij: {
  users = import ./users;

  configurations = let
    nix-darwin = inputs.nix-darwin;
  in {
    "Wills-MacBook-Air" = nix-darwin.lib.darwinSystem {
      specialArgs = {
        inherit inputs;
        inherit fjij;
      };
      modules = [
        ./systems/wills-macbook-air
        ./modules/tailscale
        ./modules/homebrew
        fjij.darwin.users.will
      ];
    };
  };
}
