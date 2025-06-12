{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:
let
  cfgNamespace = config.fjij;
in
{
  # Containers
  # Each container
  options.fjij.containers = lib.mkOption {
    type = lib.types.attrsOf (
      lib.types.submodule {
        options = {
          config = lib.mkOption {
            type = lib.types.attrsOf lib.types.anything;
            default = { };
            description = "Configuration for the container.";
          };
        };
      }
    );
    default = { };
    description = "NixOS containers configuration.";
  };

  config = lib.mkIf (lib.hasAttr "containers" cfgNamespace) {
    # Set the containers configuration
    containers = lib.mapAttrs (name: container: {
      specialArgs = { inherit inputs; };
      config = container.config;
      autoStart = true;
      nixpkgs = pkgs.path;
      privateNetwork = true;
      hostAddress = "192.168.100.10";
      localAddress = "192.168.100.11";
      privateUsers = "pick";
      # Mount secret key
      bindMounts.sops = {
        # TODO: upstream a config for mount options (rather than addig to the end of the mountPoint path)
        # https://www.freedesktop.org/software/systemd/man/latest/systemd-nspawn.html#Mount%20Options
        mountPoint = "/var/lib/sops-nix/server-key.txt:rootidmap";
        hostPath = "/var/lib/sops-nix/server-key.txt";
        isReadOnly = true;
      };
      # Allow tailscale to use TUN for networking
      allowedDevices = [
        {
          node = "/dev/net/tun";
          modifier = "rwm";
        }
      ];
      # https://man7.org/linux/man-pages/man7/capabilities.7.html
      additionalCapabilities = [
        # Needed for tailscale
        "CAP_NET_ADMIN"
        "CAP_NET_RAW"
        # Not specifically needed for anything, but useful in a container setting
        "CAP_MKNOD"
      ];
    }) cfgNamespace.containers;

    # Enable NAT for the containers
    networking.nat.enable = true;
    networking.nat.internalInterfaces = [ "ve-+" ];
    networking.nat.externalInterface = "wlo1";
    networking.networkmanager.unmanaged = [ "interface-name:ve-*" ];
  };
}
