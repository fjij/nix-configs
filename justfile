# Show the list of commands
help:
    just --list

# Setup git hooks
init-hooks:
    #!/usr/bin/env bash
    if [ -d ./.git/hooks/ ]; then
      mv .git/hooks .git/hooks.bak
    fi
    ln -s $PWD/git-hooks .git/hooks

# Code formatting
fmt:
    nix-shell -p alejandra --run 'alejandra .'
    just --unstable --fmt

# Rebuild using the local repo flake
rebuild-local:
    sudo nixos-rebuild switch --flake '.?submodules=1'

# Sops

secrets-file := 'secrets/secrets.yaml'
op-secret := 'op://secrets/age-willh/private-key'
age-key-file := '~/keys.txt'
configure-sops-key := ('
if command -v op; then
    export SOPS_AGE_KEY=$(op read ' + op-secret + ')
fi
if [ -f ' + age-key-file + ' ]; then
    export SOPS_AGE_KEY_FILE=' + age-key-file + '
fi
')

# Edit the secrets file
secrets-edit:
    #!/usr/bin/env bash
    {{ configure-sops-key }}
    sops {{ secrets-file }}

# Rotate the data encryption key and re-encrypt the secrets file
secrets-rotate:
    #!/usr/bin/env bash
    {{ configure-sops-key }}
    sops --rotate --in-place {{ secrets-file }}

# Re-encrypt the secrets file with the current key set (.sops.yaml)
secrets-sync:
    #!/usr/bin/env bash
    {{ configure-sops-key }}
    sops updatekeys {{ secrets-file }}

host-ssh-pubkey := '/etc/ssh/ssh_host_ed25519_key.pub'

# Display the age pubkey of the local machine
get-local-pubkey:
    nix-shell -p ssh-to-age --run 'cat {{ host-ssh-pubkey }} | ssh-to-age'
