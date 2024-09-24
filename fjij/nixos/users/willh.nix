{
  inputs,
  pkgs,
  ...
}: {
  imports = [inputs.home-manager.nixosModules.home-manager];

  users.users.willh = {
    isNormalUser = true;
    description = "Will Harris";
    extraGroups = ["networkmanager" "wheel"];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEuZghgOTkdblxNA+cg8JQnQumgyxGiOoTouB7vT5XIW"
    ];
    # packages = with pkgs; [];
    shell = pkgs.fish;
    home = "/home/willh";
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.willh = {
      imports = [../../home-manager/configs/terminal.nix];
    };
  };

  # Need to enable this here to allow it as a shell
  programs.fish.enable = true;
}
