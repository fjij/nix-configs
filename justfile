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
deploy host='':
    #!/usr/bin/env bash
    if [ -z "{{ host }}" ]; then
      if uname -s | grep Darwin > /dev/null; then
        nix run \
          --extra-experimental-features nix-command \
          --extra-experimental-features flakes \
          nix-darwin -- switch --flake '.?submodules=1' --show-trace
      else
        sudo nixos-rebuild switch --flake '.?submodules=1'
      fi
    else
      nix-shell -p nixos-rebuild --run \
        'nixos-rebuild switch --fast --flake ".#{{ host }}" --use-remote-sudo --target-host "admin@{{ host }}" --build-host "admin@{{ host }}"'
    fi

# Sops

secrets-file := 'fjij/nixos/modules/sops/secrets/secrets.yaml'
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
    nix-shell -p sops --run 'sops {{ secrets-file }}'

# Rotate the data encryption key and re-encrypt the secrets file
secrets-rotate:
    #!/usr/bin/env bash
    {{ configure-sops-key }}
    nix-shell -p sops --run 'sops --rotate --in-place {{ secrets-file }}'

# Re-encrypt the secrets file with the current key set (.sops.yaml)
secrets-sync:
    #!/usr/bin/env bash
    {{ configure-sops-key }}
    nix-shell -p sops --run 'sops updatekeys {{ secrets-file }}'

host-ssh-pubkey := '/etc/ssh/ssh_host_ed25519_key.pub'

# Display the age pubkey of the local machine
get-local-pubkey:
    nix-shell -p ssh-to-age --run 'cat {{ host-ssh-pubkey }} | ssh-to-age'

# Build an ISO for the given configuration, optionally using a builder
build-iso configuration='' builder='':
    #!/usr/bin/env bash
    if [ -z "{{ builder }}" ]; then
      # todo the builder config is a little hardcoded
      nix build '.#nixosConfigurations.{{ configuration }}.config.system.build.isoImage' \
        --builders 'ssh://admin@{{ builder }} x86_64-linux - 8 8 kvm' \
        --max-jobs 0
    else
      nix build '.#nixosConfigurations.{{ configuration }}.config.system.build.isoImage'
    fi

# Convert an produced ISO to a VDI file
convert-iso iso='' vdi='':
    nix-shell -p virtualbox --run "VBoxManage convertfromraw {{ iso }} {{ vdi }}"
