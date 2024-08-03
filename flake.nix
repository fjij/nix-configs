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

  outputs = {self, ...} @ inputs: let
    fjij = rec {
      nixos = import ./nixos inputs fjij;
      darwin = import ./darwin inputs fjij;
      home-manager = import ./home-manager inputs fjij;
    };
  in {
    nixosConfigurations = fjij.nixos.configurations;
    darwinConfigurations = fjij.darwin.configurations;
  };
}
