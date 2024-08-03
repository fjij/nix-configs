inputs: fjij: {
  profiles = {
    mac = (import ./profiles/mac).profile;
    terminal = (import ./profiles/terminal).profile;
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
}
