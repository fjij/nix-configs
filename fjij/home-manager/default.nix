inputs: fjij: {
  profiles = {
    mac = (import ./profiles/mac.nix).profile;
    terminal = (import ./profiles/terminal.nix).profile;
  };

  nixosModule = inputs.home-manager.nixosModules.home-manager;
  darwinModule = inputs.home-manager.darwinModules.home-manager;

  mkHome = {
    profile,
    user,
    ...
  }: {
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
    home-manager.users."${user}".imports = profile;
  };

  # Standalone (alien) configurations

  mkAlien = {
    username,
    homeDirectory,
    profile,
    system,
  }:
    inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = inputs.nixpkgs.legacyPackages."${system}";
      modules =
        profile
        ++ [
          (import ./modules/alien.nix {
            inherit username;
            inherit homeDirectory;
          })
        ];
    };

  aliens = let
    profiles = fjij.home-manager.profiles;
    mkAlien = fjij.home-manager.mkAlien;
  in {
    # "mac" = mkAlien {
    #   username = "will";
    #   homeDirectory = "/Users/will";
    #   profile = profiles.mac;
    #   system = "aarch64-darwin";
    # };
    "work" = mkAlien {
      username = "wharris";
      homeDirectory = "/home/wharris";
      profile = profiles.terminal;
      system = "x86_64-linux";
    };
  };
}
