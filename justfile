# Show the list of commands
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
