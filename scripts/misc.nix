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

  # Build Graphical Installer
  buildGraphicalInstaller =
    let
      builders = "ssh://admin@emoji x86_64-linux - 8 8 kvm";
      configName = "graphical-installer";
    in
    pkgs.writeShellApplication {
      name = "buildGraphicalInstaller";
      text = ''
        nix build \
          --builders '${builders}' \
          '.#nixosConfigurations.${configName}.config.system.build.isoImage'
      '';
    };

  # Change the current user's shell to fish
  # This is only needed in standalone home manager, not for NixOS or Nix-darwin
  # NOTE: this can be dangerous if the user uninstalls fish
  # TODO: just use exec to run fish instead of changing the shell
  homeManagerUseFish = pkgs.writeShellApplication {
    name = "homeManagerUseFish";
    text = ''
      # Add fish to list of allowed shells
      which fish | sudo tee -a /etc/shells
      # Change shell to fish for current user
      sudo chsh -s "$(which fish)" "$(whoami)"
    '';
  };

  # Remote install with nixos-anywhere. We assume the target is running the
  # graphical installer flake, and is connected to the network.

  remoteInstall =
    let
      opSecretPath = "op://secrets/nixos-server-key/private-key";
      secretPath = "/var/lib/sops-nix/server-key.txt";
    in
    pkgs.writeShellApplication {
      name = "remoteInstall";
      runtimeInputs = with pkgs; [
        nixos-anywhere
        _1password-cli
      ];
      text = ''
        usage() {
            echo "Usage: $0 <ip-address> <nixos-config-name> <generate-hardware-config-path>"
        }
        # Count number of arguments
        if [ "$#" -ne 3 ]; then
            usage
            exit 1
        fi
        IP="$1"
        CONFIG_NAME="$2"
        GENERATE_HARDWARE_CONFIG_PATH="$3"

        # Copy secret from 1Password to a temporary file
        TEMP=$(mktemp -d)
        cleanup() {
            rm -rf "$TEMP"
        }
        trap cleanup EXIT
        mkdir -p "$(dirname "$TEMP"${secretPath})"
        (umask 077; op read '${opSecretPath}' > "$TEMP${secretPath}")

        nixos-anywhere \
          --flake ".#$CONFIG_NAME" \
          --target-host "admin@$IP" \
          --generate-hardware-config nixos-generate-config "$GENERATE_HARDWARE_CONFIG_PATH" \
          --build-on-remote \
          --extra-files "$TEMP"
      '';
    };
}
