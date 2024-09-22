inputs: fjij: {
  base = import ./base;
  hardware = import ./hardware;
  misc = import ./misc;
  modules = import ./modules;
  services = import ./services;
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
        (fjij.nixos.base {hostName = "emoji";})
        fjij.nixos.hardware.emoji
        fjij.nixos.users.admin
        fjij.nixos.users.willh
        fjij.nixos.services.openssh
        fjij.nixos.services.tailscale
        fjij.nixos.services.minecraft
        fjij.nixos.modules.satisfactory
        {
          services.satisfactory.enable = true;
        }
        fjij.nixos.services.ollama
        {
          services.frp = {
            enable = true;
            role = "client";
            settings.serverAddr = "gateway";
            settings.serverPort = 7000;
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
        fjij.nixos.misc.digital-ocean-image
        (fjij.nixos.base {useBootLoader = false;})
        fjij.nixos.users.admin
        fjij.nixos.services.openssh
      ];
    };

    gateway = nixpkgs.lib.nixosSystem {
      inherit specialArgs;
      system = "x86_64-linux";
      modules = [
        fjij.nixos.misc.digital-ocean-config
        (fjij.nixos.base {
          hostName = "gateway";
          useBootLoader = false;
        })
        fjij.nixos.users.admin
        fjij.nixos.services.openssh
        fjij.nixos.services.tailscale
        {
          services.frp = {
            enable = true;
            role = "server";
            settings.bindPort = 7000;
          };
          networking.firewall.allowedTCPPorts = [25565];
        }
      ];
    };
  };
}
