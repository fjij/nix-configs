# Show the list of commands
export SOPS_AGE_KEY_FILE := '/home/willh/keys.txt'

help:
  just --list

secrets-file := 'secrets/secrets.yaml'

# Rebuild using the local repo flake
rebuild-local:
    sudo nixos-rebuild switch --flake '.?submodules=1'

# Edit the secrets file
secrets-edit:
    sops {{secrets-file}}

# Rotate the data encryption key and re-encrypt the secrets file
secrets-rotate:
  sops --rotate --in-place {{secrets-file}}

# Re-encrypt the secrets file with the current key set (.sops.yaml)
secrets-sync:
  sops updatekeys {{secrets-file}}

# Display the age pubkey of the local machine
get-local-pubkey:
  nix-shell -p ssh-to-age --run 'cat /etc/ssh/ssh_host_ed25519_key.pub | ssh-to-age'
