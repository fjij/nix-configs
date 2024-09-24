{
  config,
  lib,
  inputs,
  pkgs,
  ...
}: let
  user = "willh";
  cfg = config.fjij."${user}-user";
in {
  imports = [inputs.home-manager.nixosModules.home-manager];

  options.fjij."${user}-user".enable = lib.mkEnableOption "${user} user account";

  config = lib.mkIf cfg.enable {
    users.users."${user}" = {
      isNormalUser = true;
      description = "User account for ${user}";
      extraGroups = ["networkmanager" "wheel"];
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEuZghgOTkdblxNA+cg8JQnQumgyxGiOoTouB7vT5XIW"
      ];
      # packages = with pkgs; [];
      shell = pkgs.fish;
      home = "/home/${user}";
    };

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      users."${user}" = {
        imports = [../../home-manager/configs/terminal.nix];
      };
    };

    # Need to enable this here to allow it as a shell
    programs.fish.enable = true;
  };
}
