inputs: fjij: {
  # Returns an attrset of nixosConfigurations
  configurations = let
    nixpkgs = inputs.nixpkgs;
  in {
    emoji = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {inherit inputs;};
      modules = [
        ./systems/emoji
        ./users/willh
        ./users/admin
        ./modules/openssh
        ./modules/nvidia
        ./modules/sops
        ./modules/tailscale
        ./modules/minecraft
        fjij.home-manager.nixosModule
        (fjij.home-manager.mkHome {
          user = "willh";
          profile = fjij.home-manager.profiles.terminal;
        })
      ];
    };
  };
}
