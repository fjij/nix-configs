inputs: fjij: {
  base = import ./base;
  hardware = import ./hardware;
  misc = import ./misc;
  modules = import ./modules;
  services = import ./services;
  users = import ./users;

  configurations = let
    nixpkgs = inputs.nixpkgs;
  in {
    emoji = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {
        inherit inputs;
        inherit fjij;
      };
      modules = [
        (fjij.nixos.base {hostName = "emoji";})
        fjij.nixos.hardware.emoji
        fjij.nixos.users.admin
        fjij.nixos.users.willh
        fjij.nixos.services.openssh
        fjij.nixos.services.tailscale
        fjij.nixos.services.minecraft
      ];
    };
    droplet = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {
        inherit inputs;
        inherit fjij;
      };
      modules = [
        fjij.nixos.misc.iso
        (fjij.nixos.base {hostName = "droplet";})
        fjij.nixos.users.admin
        fjij.nixos.services.openssh
        fjij.nixos.services.tailscale
      ];
    };
  };
}
