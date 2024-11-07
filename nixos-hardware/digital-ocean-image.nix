{ modulesPath, ... }:
{
  imports = [
    (modulesPath + "/virtualisation/digital-ocean-image.nix")
  ];
}
