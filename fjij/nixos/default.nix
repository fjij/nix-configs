inputs: fjij: {
  base = import ./base;
  hardware = import ./hardware;
  misc = import ./misc;
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
        {
          imports = [./modules];
          services.satisfactory.enable = true;
          fjij = {
            minecraft.enable = true;
            openssh.enable = true;
            tailscale.enable = true;
            ollama.enable = true;
          };
        }
        {
          services.frp = {
            enable = true;
            role = "client";
            settings.serverAddr = "gateway";
            settings.serverPort = 7000;
          };
          services.frp.settings.proxies = [
            {
              name = "minecraft";
              type = "tcp";
              localIP = "127.0.0.1";
              localPort = 25565;
              remotePort = 25565;
            }
            {
              name = "satisfactory-tcp";
              type = "tcp";
              localIP = "127.0.0.1";
              localPort = 7777;
              remotePort = 7777;
            }
            {
              name = "satisfactory-udp";
              type = "udp";
              localIP = "127.0.0.1";
              localPort = 7777;
              remotePort = 7777;
            }
            {
              name = "satisfactory-udp-beacon";
              type = "udp";
              localIP = "127.0.0.1";
              localPort = 15000;
              remotePort = 15000;
            }
            {
              name = "satisfactory-udp-query";
              type = "udp";
              localIP = "127.0.0.1";
              localPort = 15777;
              remotePort = 15777;
            }
          ];
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
          imports = [./modules];
          fjij.openssh.enable = true;
        }
        fjij.nixos.misc.digital-ocean-image
        (fjij.nixos.base {useBootLoader = false;})
        fjij.nixos.users.admin
      ];
    };

    gateway = nixpkgs.lib.nixosSystem {
      inherit specialArgs;
      system = "x86_64-linux";
      modules = [
        {
          imports = [./modules];
          fjij.openssh.enable = true;
          fjij.tailscale.enable = true;
        }
        fjij.nixos.misc.digital-ocean-config
        (fjij.nixos.base {
          hostName = "gateway";
          useBootLoader = false;
        })
        fjij.nixos.users.admin
        {
          services.frp = {
            enable = true;
            role = "server";
            settings.bindPort = 7000;
          };
          networking.firewall.allowedTCPPorts = [7777 25565];
          networking.firewall.allowedUDPPorts = [7777 15000 15777];
        }
      ];
    };
  };
}
