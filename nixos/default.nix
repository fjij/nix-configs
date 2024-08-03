{
  # Returns an attrset of nixosConfigurations
  getConfigurations = {
    inputs,
    extraModules ? [],
  }: let
    nixpkgs = inputs.nixpkgs;
  in {
    emoji = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {inherit inputs;};
      modules =
        [
          ./systems/emoji
          ./users/willh
          ./users/admin
          ./modules/openssh
          ./modules/nvidia
          ./modules/sops
          ./modules/tailscale
          ./modules/minecraft
        ]
        ++ extraModules;
    };
  };
}
