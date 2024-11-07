# nix-configs

My configs ... but in Nix!

## Repo Usage

All the commands are in the `justfile`! Use the
[just](https://github.com/casey/just) command to list them and read
documentation:

`$ just`

```
Available recipes:
    alien-set-shell                               # Change the current user's shell (alien)
    build-digital-ocean builders=default-builders # Build a DigitalOcean image
    deploy config='' ip=''                        # Deploy a configuration, optionally to a remote machine
    deploy-alien name                             # Deploy a standalone (alien) home-manager config locally
    deploy-darwin                                 # Deploy a Darwin configuration locally
    distribute-keys ip                            # Distribute keys to a remote machine
    fmt                                           # Formatter
    help                                          # Display this list
    install-nix                                   # Install Nix on a non-Nix OS
    save-admin-keys                               # Save admin keys from 1password to filesystem
    secrets-edit                                  # Edit the secrets file
    secrets-rotate                                # Rotate data encryption key and re-encrypt secrets file
    secrets-sync                                  # Re-encrypt the secrets file with keys group in `.sops.yaml`
```

## How to setup a new machine

1. Install the OS with an image generated from `just build-iso` or `just build-vdi`
2. Distribute keys using `just distribute-keys <ip>`
3. Deploy a configuration using `just deploy <config> <ip>`

## Development

To automatically activate the development environment in this directory, use
direnv:

```sh
direnv allow .
```
