{
  description = "My NixOS Configs!";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager";
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
    home-manager,
    flake-utils,
    ...
  } @ inputs: let
    specialArgs = {
      inherit inputs;
      outputs = self;
    };
    forAllSystems = nixpkgs.lib.genAttrs ["x86_64-linux" "aarch64-darwin"];
  in {
    nixosConfigurations = {
      "emoji" = nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        system = "x86_64-linux";
        modules = [./nixos-configs/emoji.nix];
      };

      # Digital Ocean Base Image
      # Build Target: '.#nixosConfigurations.digital-ocean-image.config.system.build.digitalOceanImage'
      "digital-ocean-image" = nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        system = "x86_64-linux";
        modules = [./nixos-configs/digital-ocean-image.nix];
      };

      "gateway" = nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        system = "x86_64-linux";
        modules = [./nixos-configs/gateway.nix];
      };
    };

    darwinConfigurations = {
      "Wills-MacBook-Air" = nix-darwin.lib.darwinSystem {
        inherit specialArgs;
        modules = [./darwin-configs/wills-macbook-air.nix];
      };
    };

    homeConfigurations = {
      "work" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages."x86_64-linux";
        modules = [./home-manager-configs/work.nix];
      };
    };

    devShells = forAllSystems (system: {
      default = let
        pkgs = nixpkgs.legacyPackages.${system};
      in
        pkgs.mkShell {
          packages = with pkgs; [alejandra just sops];
        };
    });

    checks = forAllSystems (system: {
      nix-formatter = let
        pkgs = import nixpkgs {inherit system;};
      in
        # runCommandLocal => don't use the cache
        pkgs.runCommandLocal "nix-formatter-check" {src = ./.;} ''
          ${pkgs.alejandra}/bin/alejandra --check "$src"
          touch "$out"
        '';
      just-formatter = let
        pkgs = import nixpkgs {inherit system;};
      in
        # runCommandLocal => don't use the cache
        pkgs.runCommandLocal "just-formatter-check" {src = ./.;} ''
          cd "$src"
          ${pkgs.just}/bin/just --unstable --fmt --check
          touch "$out"
        '';
    });
  };
}
