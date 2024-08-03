{
  fjij,
  config,
  lib,
  pkgs,
  ...
}: let
  # Get the ISO image from the existing NixOS configuration
  isoImage = config.system.build.isoImage;
in {
  imports = [
    fjij.nixos.misc.iso
  ];
  # Define a new build output
  system.build.vdiImage = pkgs.stdenv.mkDerivation {
    name = "nixos-vdi-${config.system.nixos.label}-${pkgs.stdenv.hostPlatform.system}.vdi";

    # We need the ISO image and VirtualBox
    nativeBuildInputs = [pkgs.virtualbox];

    # Use the ISO as our source
    src = isoImage;

    buildPhase = ''
      # Convert the ISO to VDI
      VBoxManage convertfromraw ${isoImage}/iso/*.iso $out.vdi --format VDI
    '';

    # Just move our VDI to the output
    installPhase = ''
      mv $out.vdi $out
    '';
  };
}
