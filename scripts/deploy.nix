{ pkgs, ... }:
{
  # This file is mainly glorified aliases
  deployDarwinLocal = pkgs.writeShellApplication {
    name = "deployDarwinLocal";
    text = ''
      CONFIG="$1"
      if [ -z "$CONFIG" ]; then
          echo "No config name supplied"
          exit 1
      fi
      # Optional: --show-trace
      nix run nix-darwin -- switch --flake ".#$CONFIG"
    '';
  };

  deployNixosLocal = pkgs.writeShellApplication {
    name = "deployNixosLocal";
    text = ''
      CONFIG="$1"
      if [ -z "$CONFIG" ]; then
          echo "No config name supplied"
          exit 1
      fi
      # Optional: --show-trace
      sudo nixos-rebuild switch --flake ".#$CONFIG"
    '';
  };

  deployHomeManagerLocal = pkgs.writeShellApplication {
    name = "deployHomeManagerLocal";
    text = ''
      CONFIG="$1"
      if [ -z "$CONFIG" ]; then
          echo "No config name supplied"
          exit 1
      fi
      # Optional: --show-trace
      nix run home-manager/release-24.05 -- switch --flake ".#$CONFIG"
    '';
  };

  deployNixosRemote = pkgs.writeShellApplication {
    name = "deployNixosRemote";
    runtimeInputs = [ pkgs.nixos-rebuild ];
    text = ''
      CONFIG="$1"
      IP="$2"
      if [ -z "$CONFIG" ]; then
          echo "No config name supplied"
          exit 1
      fi
      if [ -z "$IP" ]; then
          echo "No ip supplied"
          exit 1
      fi
      TARGET="admin@$IP"
      nixos-rebuild switch \
          --fast \
          --flake ".#$CONFIG" \
          --use-remote-sudo \
          --show-trace \
          --target-host "$TARGET" \
          --build-host "$TARGET"
    '';
  };
}
