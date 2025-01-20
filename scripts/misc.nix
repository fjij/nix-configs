{ pkgs, ... }:
{
  # Build the digital ocean base image
  buildDigitalOceanImage =
    let
      builders = "ssh://admin@emoji x86_64-linux - 8 8 kvm";
      configName = "digital-ocean-image";
    in
    pkgs.writeShellApplication {
      name = "buildDigitalOceanImage";
      text = ''
        nix build \
          --builders '${builders}' \
          '.#nixosConfigurations.${configName}.config.system.build.digitalOceanImage'
      '';
    };

  # Change the current user's shell to fish
  # This is only needed in standalone home manager, not for NixOS or Nix-darwin
  homeManagerUseFish = pkgs.writeShellApplication {
    name = "homeManagerUseFish";
    text = ''
      # Add fish to list of allowed shells
      which fish | sudo tee -a /etc/shells
      # Change shell to fish for current user
      sudo chsh -s "$(which fish)" "$(whoami)"
    '';
  };
}
