inputs: fjij: {
  configurations = let
    nix-darwin = inputs.nix-darwin;
  in {
    "Wills-MacBook-Air" = nix-darwin.lib.darwinSystem {
      specialArgs = {
        inherit inputs;
      };
      modules = [./configs/wills-macbook-air.nix];
    };
  };
}
