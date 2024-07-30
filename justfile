# Rebuild using the local repo flake
rebuild-local:
    sudo nixos-rebuild switch --flake '.?submodules=1'
