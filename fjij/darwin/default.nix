inputs: fjij: {
  modules = import ./modules;
  services = import ./services;
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
        fjij.darwin.services.tailscale
        fjij.darwin.users.will
      ];
    };
  };
}
