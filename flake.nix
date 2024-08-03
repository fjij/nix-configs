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
    nix-homebrew = {
      url = "github:zhaofengli-wip/nix-homebrew";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    koekeishiya-formulae = {
      url = "github:koekeishiya/homebrew-formulae";
      flake = false;
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
        ./nixos/systems/emoji
        ./nixos/users/willh.nix
        ./nixos/users/admin.nix
        ./nixos/modules/openssh.nix
        ./nixos/modules/nvidia.nix
        ./nixos/modules/sops.nix
        ./nixos/modules/tailscale.nix
        ./nixos/modules/minecraft.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.willh.imports = [
            ./home-manager
            ./home-manager/modules/tools
          ];
        }
      ];
    };

    darwinConfigurations."Wills-MacBook-Air" = nix-darwin.lib.darwinSystem {
      specialArgs = {inherit inputs;};
      modules = [
        ./darwin/systems/wills-macbook-air
        ./darwin/modules/tailscale.nix
        ./darwin/modules/homebrew.nix
        ./darwin/users/will.nix
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.will.imports = [
            ./home-manager
            ./home-manager/modules/ui
            ./home-manager/modules/tools
          ];
        }
      ];
    };
  };
}
