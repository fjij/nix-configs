# nix-configs

My configs ... but in Nix!

## Nix Installation

### NixOS

See [INSTALL_NIXOS.md](./INSTALL_NIXOS.md) for instructions on how to install
NixOS on a physical device. I also have a Cloud-Init config for DigitalOcean,
but I can't remember how it works, so best of luck.

### Nix Package Manager (non-NixOS systems)

Either use the [Determinate Nix
Installer](https://github.com/DeterminateSystems/nix-installer) or follow the
[official installation guide](https://nixos.org/download/). The former is
recommended in most cases, the latter is recommended if you want to stick to
FOSS or are having issues with the Determinate installer.

## Deploy configurations

### Deploy NixOS locally

```sh
nix run .#deployNixosLocal -- '<config name>'
```

### Deploy Nix-darwin locally

```sh
nix run .#deployDarwinLocal -- '<config name>'
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
in a key group can access secrets. Key groups are declared in `.sops.yaml`.

### Adding a new keypair to a key group

**Note:** these commands currently use the 1password CLI to fetch the sops
encryption key.

**Prerequisites:**

- [Age](https://github.com/FiloSottile/age) keypair

**1. Update `.sops.yaml`**

- Add the keypair's public key to the `keys` section of the file
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
nix run .#distributeServerKey -- '<ip>'
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
