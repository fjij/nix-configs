inputs: fjij: {
  base = import ./base;
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
        (fjij.darwin.base {})
        fjij.darwin.services.tailscale
        fjij.darwin.users.will
      ];
    };
  };
}
