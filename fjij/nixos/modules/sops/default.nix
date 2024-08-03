{
  inputs,
  config,
  pkgs,
  ...
}: {
  imports = [inputs.sops-nix.nixosModules.sops];
  # This will add secrets.yml to the nix store
  # You can avoid this by adding a string to the full path instead, i.e.
  # sops.defaultSopsFile = "/root/.sops/secrets/example.yaml";
  sops.defaultSopsFile = ./secrets/secrets.yaml;
  # This will automatically import SSH keys as age keys
  sops.age.sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
}
