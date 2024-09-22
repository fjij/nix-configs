# Display this list
help:
    just --list

# Setup git hooks for linting
init-hooks:
    #!/usr/bin/env bash
    if [ -d ./.git/hooks/ ]; then
      mv .git/hooks .git/hooks.bak
    fi
    ln -s $PWD/git-hooks .git/hooks

# Format nix files and the justfile
fmt:
    nix run 'nixpkgs#alejandra' -- .
    just --unstable --fmt

admin-ssh-dir := '/var/lib/secrets/'
admin-ssh-file := admin-ssh-dir + 'nixos_admin_id_ed25519'
server-key-dir := '/var/lib/sops-nix/'
server-key-file := server-key-dir + 'server-key.txt'

# Save admin keys from 1password to filesystem
save-admin-keys:
    #!/usr/bin/env bash
    umask 066
    sudo mkdir -p {{ admin-ssh-dir }}
    op read 'op://secrets/nixos-admin-ssh/private key' \
      | sudo tee {{ admin-ssh-file }} > /dev/null
    sudo mkdir -p {{ server-key-dir }}
    op read 'op://secrets/nixos-server-key/private-key' \
      | sudo tee {{ server-key-file }} > /dev/null

remote-temp-key := '~/server-key.txt'

# Distribute keys to a remote machine
distribute-keys ip:
    #!/usr/bin/env bash
    ssh -i '{{ admin-ssh-file }}' 'admin@{{ ip }}' 'sudo mkdir -p {{ server-key-dir }}'
    sudo scp -i '{{ admin-ssh-file }}' '{{ server-key-file }}' 'admin@{{ ip }}:{{ remote-temp-key }}'
    ssh -i '{{ admin-ssh-file }}' 'admin@{{ ip }}' 'sudo mv {{ remote-temp-key }} {{ server-key-file }}'

# Deploy a Darwin configuration locally
deploy-darwin:
    #!/usr/bin/env bash
    nix run \
      --extra-experimental-features nix-command \
      --extra-experimental-features flakes \
      nix-darwin -- switch --show-trace --flake .

# Deploy a configuration, optionally to a remote machine
deploy config='' ip='':
    #!/usr/bin/env bash
    if [ -z "{{ config }}" ]; then
      sudo nixos-rebuild switch --flake .
    else
      if [ -z "{{ ip }}" ]; then
        sudo nixos-rebuild switch --flake '.#{{ config }}'
      else
        nix run 'nixpkgs#nixos-rebuild' -- \
          switch --fast --flake '.#{{ config }}' --use-remote-sudo --show-trace --target-host 'admin@{{ ip }}' --build-host 'admin@{{ ip }}'
      fi
    fi

# Sops

secrets-file := 'fjij/nixos/modules/sops/secrets/secrets.yaml'
configure-sops-key := ('
if command -v op; then
    export SOPS_AGE_KEY="$(op read op://secrets/nixos-admin-age/private-key)"
fi
')

# Edit the secrets file
secrets-edit:
    #!/usr/bin/env bash
    {{ configure-sops-key }}
    nix run 'nixpkgs#sops' -- '{{ secrets-file }}'

# Rotate data encryption key and re-encrypt secrets file
secrets-rotate:
    #!/usr/bin/env bash
    {{ configure-sops-key }}
    nix run 'nixpkgs#sops' -- --rotate --in-place '{{ secrets-file }}'

# Re-encrypt the secrets file with keys group in `.sops.yaml`
secrets-sync:
    #!/usr/bin/env bash
    {{ configure-sops-key }}
    nix run 'nixpkgs#sops' -- updatekeys '{{ secrets-file }}'

default-builders := 'ssh://admin@emoji x86_64-linux - 8 8 kvm'
digital-ocean-config := 'digital-ocean-image'

# Build a DigitalOcean image
build-digital-ocean builders=default-builders:
    nix build \
      --builders '{{ builders }}' \
      '.#nixosConfigurations.{{ digital-ocean-config }}.config.system.build.digitalOceanImage'

# Install Nix on a non-Nix OS
install-nix:
    curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install

# Deploy a standalone (alien) home-manager config locally
deploy-alien name:
    nix run home-manager/release-24.05 -- switch --flake '.#{{ name }}'

# Change the current user's shell (alien)
alien-set-shell:
    echo $(which fish) | sudo tee -a /etc/shells
    sudo chsh -s $(which fish) $(whoami)
