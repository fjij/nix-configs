{ lib, modulesPath, pkgs, ... }:
{
  imports = [
    ../nixos-modules

    # Make sure to use the 'calamares' version so it includes the graphical installer
    (modulesPath + "/installer/cd-dvd/installation-cd-graphical-calamares-gnome.nix")
  ];

  fjij = {
    base-system = {
      enable = true;
      useBootLoader = false;
    };
    admin-user.enable = true;
    openssh.enable = true;
  };


  # Use the latest kernel so we have up-to-date wifi drivers
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # ZFS is broken on the latest kernel, so let's disable it
  boot.supportedFilesystems.zfs = lib.mkForce false;
}
