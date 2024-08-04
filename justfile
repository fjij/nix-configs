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
    nix-shell -p alejandra --run 'alejandra .'
    just --unstable --fmt

server-key-dir := '/var/lib/sops-nix/'
server-key-file := server-key-dir + 'server-key.txt'

# Copy the server key to a remote `ip`
distribute-server-key ip:
    #!/usr/bin/env bash
    ssh 'admin@{{ ip }}' 'sudo mkdir -p {{ server-key-dir }}'
    sudo rsync --rsync-path="sudo rsync" {{ server-key-file }} 'admin@{{ ip }}:{{ server-key-file }}'

# Deploy a Darwin configuration locally
deploy-darwin:
    #!/usr/bin/env bash
    nix run \
      --extra-experimental-features nix-command \
      --extra-experimental-features flakes \
      nix-darwin -- switch --show-trace --flake . 

# Deploy the configuration for `hostName`, optionally at a remote `ip`
deploy hostName='' ip='':
    #!/usr/bin/env bash
    if [ -z "{{ hostName }}" ]; then
      sudo nixos-rebuild switch --flake .
    else
      if [ -z "{{ ip }}" ]; then
        sudo nixos-rebuild switch --flake '.#{{ hostName }}'
      else
        nix-shell -p nixos-rebuild --run \
          'nixos-rebuild switch --fast --flake ".#{{ hostName }}" --use-remote-sudo --target-host "admin@{{ ip }}" --build-host "admin@{{ ip }}"'
      fi
    fi

# Sops

secrets-file := 'fjij/nixos/modules/sops/secrets/secrets.yaml'
configure-sops-key := ('
if command -v op; then
    export SOPS_AGE_KEY="$(op read op://secrets/age-admin/private-key)"
fi
')

# Edit the secrets file
secrets-edit:
    #!/usr/bin/env bash
    {{ configure-sops-key }}
    nix-shell -p sops --run 'sops {{ secrets-file }}'

# Rotate data encryption key and re-encrypt secrets file
secrets-rotate:
    #!/usr/bin/env bash
    {{ configure-sops-key }}
    nix-shell -p sops --run 'sops --rotate --in-place {{ secrets-file }}'

# Re-encrypt the secrets file with keys group in `.sops.yaml`
secrets-sync:
    #!/usr/bin/env bash
    {{ configure-sops-key }}
    nix-shell -p sops --run 'sops updatekeys {{ secrets-file }}'

image-config := 'base-system'
builder-opts := 'x86_64-linux - 8 8'

# Build an ISO file
build-iso builderIp='':
    #!/usr/bin/env bash
    if [ -z "{{ builderIp }}" ]; then
      nix build '.#nixosConfigurations.{{ image-config }}.config.system.build.isoImage'
    else
      nix build '.#nixosConfigurations.{{ image-config }}.config.system.build.isoImage' \
        --builders 'ssh://admin@{{ builderIp }} {{ builder-opts }}' \
        --max-jobs 0
    fi

# Build a VDI file
build-vdi builderIp='':
    #!/usr/bin/env bash
    # Upload to DigitalOcean: https://cloud.digitalocean.com/images/custom_images
    if [ -z "{{ builderIp }}" ]; then
      nix build '.#nixosConfigurations.{{ image-config }}.config.system.build.vdiImage'
    else
      nix build '.#nixosConfigurations.{{ image-config }}.config.system.build.vdiImage' \
        --builders 'ssh://admin@{{ builderIp }} {{ builder-opts }}' \
        --max-jobs 0
    fi
