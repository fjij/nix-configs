{ pkgs, ... }:
let
  adminSshDir = "/var/lib/secrets/";
  adminSshFile = adminSshDir + "nixos_admin_id_ed25519";
  serverKeyDir = "/var/lib/sops-nix/";
  serverKeyFile = serverKeyDir + "server-key.txt";
  remoteTempKey = "~/server-key.txt";
in
{
  # Saves the admin ssh key and the server key to the local system
  saveAdminKeys = pkgs.writeShellApplication {
    name = "saveAdminKeys";
    runtimeInputs = with pkgs; [ _1password-cli ];
    text = ''
      # Umask 066 => written files will have permissions:
      # * User Owner = RW
      # * Group Owner = 0
      # * Others = 0
      umask 066

      # Admin key: used to SSH into the admin@host account
      # Only deployers get this key
      sudo mkdir -p '${adminSshDir}'
      op read 'op://secrets/nixos-admin-ssh/private key' \
        | sudo tee '${adminSshFile}' > /dev/null
      # ^ Sudo tee => file will be owned by root

      echo 'Saved admin SSH key to ${adminSshFile}'

      # Server key: used to read secrets from the sops.yaml file
      # All servers need this
      sudo mkdir -p '${serverKeyDir}'
      op read 'op://secrets/nixos-server-key/private-key' \
        | sudo tee '${serverKeyFile}' > /dev/null

      echo 'Saved server secrets key to ${serverKeyFile}'
    '';
  };

  # Use the local admin SSH key to distribute the local server key to another
  # system
  distributeServerKey = pkgs.writeShellApplication {
    name = "distributeServerKey";
    text = ''
      IP="$1"
      if [ -z "$IP" ]; then
          echo "No ip supplied"
          exit 1
      fi
      TARGET="admin@$IP"

      # Make the server key directory on the remote
      ssh -i '${adminSshFile}' "$TARGET" 'sudo mkdir -p ${serverKeyDir}'

      # Copy the key to a temporary location on the remote
      sudo scp -i '${adminSshFile}' '${serverKeyFile}' "$TARGET:${remoteTempKey}"
      # ^ Need sudo to copy protected file

      # Move the key to the correct location on the remote
      ssh -i '${adminSshFile}' "$TARGET" 'sudo mv ${remoteTempKey} ${serverKeyFile}'

      echo 'Copied the key successfully :)'
    '';
  };
}
