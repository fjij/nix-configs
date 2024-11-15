{ pkgs, ... }:
let
  adminSshDir = "/var/lib/secrets/";
  adminSshFile = adminSshDir + "nixos_admin_id_ed25519";
  serverKeyDir = "/var/lib/sops-nix/";
  serverKeyFile = serverKeyDir + "server-key.txt";
  remoteTempKey = "~/server-key.txt";
in
{
  distributeKeys = pkgs.writeShellApplication {
    name = "just-help";
    runtimeInputs = with pkgs; [ just ];
    text = ''
      IP="$1"
      if [ -z "$IP" ]; then
          echo "No ip supplied"
          exit 1
      fi
      TARGET="admin@$IP"
      ssh -i '${adminSshFile}' "$TARGET" 'sudo mkdir -p ${serverKeyDir}'
      sudo scp -i '${adminSshFile}' '${serverKeyFile}' "$TARGET:${remoteTempKey}"
      ssh -i '${adminSshFile}' "$TARGET" 'sudo mv ${remoteTempKey} ${serverKeyFile}'
      echo 'Copied the key successfully :)'
    '';
  };
}
