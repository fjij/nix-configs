# nix-configs

My configs ... but in Nix!

## Architecture

Each scope (`nixos`, `darwin`, `home-manager`) follows the same `configs / modules` split:

- `<scope>-configs/<name>.nix` — thin entry points referenced from `flake.nix`. They `imports = [ ../<scope>-modules ]` and set `fjij.<name>.enable = true;` to turn modules on.
- `<scope>-modules/<name>.nix` — reusable modules. Pattern: define `options.fjij.<name>` (typically `mkEnableOption`) and gate config with `lib.mkIf cfg.enable`. See `nixos-modules/base-system.nix` for the canonical example.
- `nixos-hardware/<name>.nix` — per-machine hardware files (NixOS only).

Shell wrappers in `scripts/` are folded into `packages.<system>` and run via `nix run .#<name>`.

## Deploying

Local:

```sh
nix run .#deployNixosLocal -- '<config>'
nix run .#deployNixDarwin -- '<config>'
nix run .#deployHomeManagerLocal -- '<config>'
```

Remote (needs admin SSH key locally):

```sh
nix run .#deployNixosRemote -- '<config>' '<ip>'
```

Fresh bare-metal install via `nixos-anywhere`: see `INSTALL_NIXOS.md`.

## Secrets

Uses [sops-nix](https://github.com/Mic92/sops-nix). Encrypted secrets live in `secrets/secrets.yaml`; access is gated by the key groups in `.sops.yaml`. Wrapper scripts fetch the SOPS age key from 1Password, so sign in to `op` first.

```sh
nix run .#secretsEdit     # Edit secrets/secrets.yaml
nix run .#secretsSync     # Re-encrypt after changing .sops.yaml key groups
nix run .#secretsRotate   # Rotate the data encryption key
```

To add a new keypair: add its public key to `.sops.yaml`'s `keys` and the relevant key group, then `secretsSync`.

## Keys

```sh
nix run .#saveAdminKeys                  # Pull admin SSH + server age keys from 1Password
nix run .#distributeServerKey -- '<ip>'  # Push local server key to a remote
```

## Development

```sh
nix fmt                           # Format (treefmt-nix)
nix flake check . --all-systems   # CI check
```
