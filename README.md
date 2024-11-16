# nix-configs

My configs ... but in Nix!

## Deploy configurations

### Deploy NixOS locally

```sh
nix run .#deployNixosLocal -- '<config name>'
```

### Deploy Nix-darwin locally

```sh
nix run .#deployNixDarwin -- '<config name>'
```

### Deploy Home Manager (standalone) locally

```sh
nix run .#deployHomeManagerLocal -- '<config name>'
```

On first deploy, you may need to update your shell

```sh
nix run .#homeManagerUseFish
```

### Deploy NixOS to a remote

Requires access to the admin ssh key

```sh
nix run .#deployNixosRemote -- '<config name>' '<ip>'
```

## Secrets management

[Sops-nix](https://github.com/Mic92/sops-nix) is used for managing secrets.

Secrets are encrypted and stored in `secrets/secrets.yaml`. Only users with keys
in a key group can access secrets. Key group are declared in `.sops.yaml`.

### Adding a new keypair to a key group

**Note:** these commands currently use the 1password CLI to fetch the sops
encryption key.

**Prerequisites:**

- [Age](https://github.com/FiloSottile/age) keypair

**1. Update `.sops.yaml`**

- Add the keypair's public key to the `keys` section of file
- Add a reference to the key in the `age` key group

**2. Re-encrypt `secrets/secrets.yaml` with the new key groups**

```sh
nix run .#secretsSync
```

### Editing the secrets file

```sh
nix run .#secretsEdit
```

### Rotate the shared data encryption key

```sh
nix run .#secretsRotate
```

## Key management

### Copy keys from 1password

```sh
nix run .#saveAdminKeys
```

This will save a local copy of:

- admin SSH key: needed to deploy to remotes
- server (age) key: needed on all systems to access sops secrets

### Distribute server key to a remote

This requires a local copy of the admin SSH key and the server key.

```sh
nix run .#distributeAdminKeys -- '<ip>'
```

## Development

### Format code

```sh
nix fmt
```

### List scripts

```sh
nix eval .#packages.aarch64-darwin --apply builtins.attrNames
```
