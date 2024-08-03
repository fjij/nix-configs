inputs: fjij: {
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
        ./systems/emoji
        fjij.nixos.users.admin
        fjij.nixos.users.willh
        ./modules/openssh
        ./modules/nvidia
        ./modules/sops
        ./modules/tailscale
        ./modules/minecraft
      ];
    };
  };
}
