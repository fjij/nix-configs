{
  modulesPath,
  lib,
  ...
}: {
  imports = [
    (modulesPath + "/virtualisation/digital-ocean-config.nix")
  ];
}
