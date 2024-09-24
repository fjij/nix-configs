inputs: fjij: let
  homeManagerConfiguration = inputs.home-manager.lib.homeManagerConfiguration;
  nixpkgs = inputs.nixpkgs;
in {
  aliens = {
    "work" = homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages."x86_64-linux";
      modules = [./configs/work.nix];
    };
  };
}
