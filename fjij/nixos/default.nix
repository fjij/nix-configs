inputs: fjij: {
  hardware = import ./hardware;
  users = import ./users;

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
      modules = [
        fjij.nixos.users.admin
        fjij.nixos.users.willh
        {
          imports = [
            ./hardware/emoji.nix
            ./modules
          ];
          services.satisfactory.enable = true;
          fjij = {
            base-system = {
              enable = true;
              hostName = "emoji";
            };
            minecraft.enable = true;
            openssh.enable = true;
            tailscale.enable = true;
            ollama.enable = true;
            frpc.enable = true;
          };
        }
      ];
    };

    # Digital Ocean Base Image
    # Build Target: '.#nixosConfigurations.digital-ocean-image.config.system.build.digitalOceanImage'
    digital-ocean-image = nixpkgs.lib.nixosSystem {
      inherit specialArgs;
      system = "x86_64-linux";
      modules = [
        {
          imports = [
            ./hardware/digital-ocean-image.nix
            ./modules
          ];
          fjij.openssh.enable = true;
          fjij.base-system = {
            enable = true;
            useBootLoader = false;
          };
        }
        fjij.nixos.users.admin
      ];
    };

    gateway = nixpkgs.lib.nixosSystem {
      inherit specialArgs;
      system = "x86_64-linux";
      modules = [
        {
          imports = [
            ./hardware/digital-ocean-config.nix
            ./modules
          ];
          fjij = {
            base-system = {
              enable = true;
              hostName = "gateway";
              useBootLoader = false;
            };
            openssh.enable = true;
            tailscale.enable = true;
            frps.enable = true;
          };
        }
        fjij.nixos.users.admin
      ];
    };
  };
}
