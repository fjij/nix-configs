{ pkgs, lib, ... }:
{
  imports = [
    ../disk-config.nix
    ../nixos-modules
    ../nixos-hardware/ceelink.nix
  ];

  fjij = {
    base-system = {
      enable = true;
      useBootLoader = true;
      hostName = "ceelink";
    };
    wifi.enable = true;
    wifi.netfixUser.enable = true;
    tailscale.enable = true;
    admin-user.enable = true;
    openssh.enable = true;
  };
  # Use the latest kernel so we have up-to-date wifi drivers
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # ZFS is broken on the latest kernel, so let's disable it
  boot.supportedFilesystems.zfs = lib.mkForce false;

  fjij.containers.minicee.config = import ./minicee.nix;
}
