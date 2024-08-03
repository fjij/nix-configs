{
  description = "My NixOS Configs!";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";

    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    nix-homebrew.inputs.nixpkgs.follows = "nixpkgs";

    homebrew-bundle.url = "github:homebrew/homebrew-bundle";
    homebrew-bundle.flake = false;

    homebrew-core.url = "github:homebrew/homebrew-core";
    homebrew-core.flake = false;

    homebrew-cask.url = "github:homebrew/homebrew-cask";
    homebrew-cask.flake = false;

    koekeishiya-formulae.url = "github:koekeishiya/homebrew-formulae";
    koekeishiya-formulae.flake = false;
  };

  outputs = {
    self,
    nixpkgs,
    nix-darwin,
    ...
  } @ inputs: let
    fjij = {
      nixos = import ./nixos;
      home-manager = import ./home-manager inputs;
    };
  in {
    # Here, "emoji" is the system's hostname
    nixosConfigurations = fjij.nixos.getConfigurations {
      inputs = inputs;
      extraModules = [
        fjij.home-manager.nixosModule
        (fjij.home-manager.mkHome {
          user = "willh";
          profile = fjij.home-manager.profiles.terminal;
        })
      ];
    };

    darwinConfigurations."Wills-MacBook-Air" = nix-darwin.lib.darwinSystem {
      specialArgs = {inherit inputs;};
      modules = [
        ./darwin/systems/wills-macbook-air
        ./darwin/modules/tailscale
        ./darwin/modules/homebrew
        ./darwin/users/will
        fjij.home-manager.darwinModule
        (fjij.home-manager.mkHome {
          user = "will";
          profile = fjij.home-manager.profiles.mac;
        })
      ];
    };
  };
}
