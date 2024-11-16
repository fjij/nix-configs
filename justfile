# Display this list
help:
    just --list

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
