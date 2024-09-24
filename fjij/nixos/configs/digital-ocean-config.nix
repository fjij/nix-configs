{modulesPath, ...}: {
  # I got this config from the machine.
  # See https://justinas.org/nixos-in-the-cloud-step-by-step-part-1
  imports = [
    (modulesPath + "/virtualisation/digital-ocean-config.nix")
  ];
}
