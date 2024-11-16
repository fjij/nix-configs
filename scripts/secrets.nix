{ pkgs, ... }:
let
  # This key is one of the keys used to read/edit secrets.yaml
  configureSopsKey = ''
    SOPS_AGE_KEY="$(${pkgs._1password-cli}/bin/op read 'op://secrets/nixos-admin-age/private-key')"
    export SOPS_AGE_KEY
  '';
  # Relative to flake root
  secretsFile = "secrets/secrets.yaml";
in
{
  # Edit the secrets file
  secretsEdit = pkgs.writeShellApplication {
    name = "secetsEdit";
    runtimeInputs = with pkgs; [ sops ];
    text = ''
      ${configureSopsKey}
      sops '${secretsFile}'
    '';
  };

  # Rotate the data encryption key and re-encrypt secrets file
  secretsRotate = pkgs.writeShellApplication {
    name = "secretsRotate";
    runtimeInputs = with pkgs; [ sops ];
    text = ''
      ${configureSopsKey}
      sops --rotate --in-place '${secretsFile}'
    '';
  };

  # Re-encrypt the secrets file with key group in `.sops.yaml`
  secretsSync = pkgs.writeShellApplication {
    name = "secretsRotate";
    runtimeInputs = with pkgs; [ sops ];
    text = ''
      ${configureSopsKey}
      sops updatekeys '${secretsFile}'
    '';
  };
}
