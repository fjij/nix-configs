inputs: fjij: {
  configurations = let
    nixpkgs = inputs.nixpkgs;
    specialArgs = {
      inherit inputs;
      inherit fjij;
    };
  in {
    emoji = nixpkgs.lib.nixosSystem {
      inherit specialArgs;
      system = "x86_64-linux";
      modules = [./configs/emoji.nix];
    };

    # Digital Ocean Base Image
    # Build Target: '.#nixosConfigurations.digital-ocean-image.config.system.build.digitalOceanImage'
    digital-ocean-image = nixpkgs.lib.nixosSystem {
      inherit specialArgs;
      system = "x86_64-linux";
      modules = [./configs/digital-ocean-image.nix];
    };

    gateway = nixpkgs.lib.nixosSystem {
      inherit specialArgs;
      system = "x86_64-linux";
      modules = [./configs/gateway.nix];
    };
  };
}
