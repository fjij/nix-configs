{
  description = "My basic NixOS flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      # Make home manager use the same version of nixpkgs as the current flake
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    sops-nix,
    nix-darwin,
    ...
  } @ inputs: {
    # Here, "emoji" is the system's hostname
    nixosConfigurations.emoji = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {inherit inputs;};
      modules = [
        ./systems/emoji/configuration.nix
        ./modules/nvidia.nix
        ./modules/sops.nix
        ./modules/tailscale.nix
        ./modules/minecraft.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.willh = import ./home/home.nix;
        }
      ];
    };

    darwinConfigurations."Wills-MacBook-Air" = nix-darwin.lib.darwinSystem {
      specialArgs = {inherit inputs;};
      modules = [
        ./systems/mac/configuration.nix
        home-manager.darwinModules.home-manager
        {
          home-manager.backupFileExtension = ".bak";
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.will = import ./home/home.nix;
        }
      ];
    };
  };
}
