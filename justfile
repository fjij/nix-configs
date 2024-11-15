# Display this list
help:
    just --list

# Sops

secrets-file := 'secrets/secrets.yaml'
configure-sops-key := ('
if command -v op; then
    export SOPS_AGE_KEY="$(op read op://secrets/nixos-admin-age/private-key)"
fi
')

# Edit the secrets file
secrets-edit:
    #!/usr/bin/env bash
    {{ configure-sops-key }}
    sops '{{ secrets-file }}'

# Rotate data encryption key and re-encrypt secrets file
secrets-rotate:
    #!/usr/bin/env bash
    {{ configure-sops-key }}
    sops --rotate --in-place '{{ secrets-file }}'

# Re-encrypt the secrets file with keys group in `.sops.yaml`
secrets-sync:
    #!/usr/bin/env bash
    {{ configure-sops-key }}
    sops updatekeys '{{ secrets-file }}'

default-builders := 'ssh://admin@emoji x86_64-linux - 8 8 kvm'
digital-ocean-config := 'digital-ocean-image'

# Build a DigitalOcean image
build-digital-ocean builders=default-builders:
    nix build \
      --builders '{{ builders }}' \
      '.#nixosConfigurations.{{ digital-ocean-config }}.config.system.build.digitalOceanImage'

# Change the current user's shell (alien)
alien-set-shell:
    echo $(which fish) | sudo tee -a /etc/shells
    sudo chsh -s $(which fish) $(whoami)
