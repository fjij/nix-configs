{
  iso = {
    pkgs,
    modulesPath,
    ...
  }: {
    # https://nixos.wiki/wiki/Creating_a_NixOS_live_CD
    imports = [
      (modulesPath + "/installer/cd-dvd/installation-cd-minimal.nix")
      # (modulesPath + "/virtualisation/digital-ocean-image.nix")
    ];

    # Builds the image faster, but less compressed
    isoImage.squashfsCompression = "gzip -Xcompression-level 1";
  };
}
