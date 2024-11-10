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

    treefmt-nix.url = "github:numtide/treefmt-nix";
    treefmt-nix.inputs.nixpkgs.follows = "nixpkgs";

    nixvim.url = "github:nix-community/nixvim";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";

    homebrew-bundle.url = "github:homebrew/homebrew-bundle";
    homebrew-bundle.flake = false;

    homebrew-core.url = "github:homebrew/homebrew-core";
    homebrew-core.flake = false;

    homebrew-cask.url = "github:homebrew/homebrew-cask";
    homebrew-cask.flake = false;

    koekeishiya-formulae.url = "github:koekeishiya/homebrew-formulae";
    koekeishiya-formulae.flake = false;
  };

  outputs =
    {
      self,
      systems,
      nixpkgs,
      nix-darwin,
      home-manager,
      treefmt-nix,
      ...
    }@inputs:
    let
      extraSpecialArgs = {
        inherit inputs;
        outputs = self;
      };
      specialArgs = {
        inherit inputs;
        inherit extraSpecialArgs;
        outputs = self;
      };
      eachSystem = f: nixpkgs.lib.genAttrs (import systems) (system: f nixpkgs.legacyPackages.${system});
      treefmtEval = eachSystem (pkgs: treefmt-nix.lib.evalModule pkgs ./treefmt.nix);
    in
    {
      nixosConfigurations = {
        "emoji" = nixpkgs.lib.nixosSystem {
          inherit specialArgs;
          system = "x86_64-linux";
          modules = [ ./nixos-configs/emoji.nix ];
        };

        # Digital Ocean Base Image
        # Build Target: '.#nixosConfigurations.digital-ocean-image.config.system.build.digitalOceanImage'
        "digital-ocean-image" = nixpkgs.lib.nixosSystem {
          inherit specialArgs;
          system = "x86_64-linux";
          modules = [ ./nixos-configs/digital-ocean-image.nix ];
        };

        "gateway" = nixpkgs.lib.nixosSystem {
          inherit specialArgs;
          system = "x86_64-linux";
          modules = [ ./nixos-configs/gateway.nix ];
        };
      };

      darwinConfigurations = {
        "Wills-MacBook-Air" = nix-darwin.lib.darwinSystem {
          inherit specialArgs;
          modules = [ ./darwin-configs/wills-macbook-air.nix ];
        };
      };

      homeConfigurations = {
        "work" = home-manager.lib.homeManagerConfiguration {
          inherit extraSpecialArgs;
          pkgs = nixpkgs.legacyPackages."x86_64-linux";
          modules = [ ./home-manager-configs/work.nix ];
        };
      };

      devShells = eachSystem (pkgs: {
        default = pkgs.mkShell {
          packages = with pkgs; [
            just
            sops
          ];
        };
      });

      # for `nix fmt`
      formatter = eachSystem (pkgs: treefmtEval.${pkgs.system}.config.build.wrapper);

      # for `nix flake check`
      checks = eachSystem (pkgs: {
        formatting = treefmtEval.${pkgs.system}.config.build.check self;
      });

      # scripts
      packages = eachSystem (pkgs: {
        # https://ryantm.github.io/nixpkgs/builders/trivial-builders/#trivial-builder-writeShellApplication
        default = pkgs.writeShellApplication {
          name = "just-help";
          runtimeInputs = with pkgs; [ just ];
          text = ''
            just help
          '';
        };
      });

      # Templates
      templates = import ./templates;
    };
}
